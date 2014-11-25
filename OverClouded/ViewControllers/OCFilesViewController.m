//
//  OCFIlesViewController.m
//  OverClouded
//
//  Created by Parag Dulam on 17/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCFilesViewController.h"
#import "OCConstants.h"
#import "OCFile.h"
#import "OCFileController.h"
#import "OCAccountController.h"
#import "OCAccount.h"
#import "AppDelegate.h"
#import "OCDragView.h"
#import "OCUtilities.h"

@interface OCFilesViewController ()<DBRestClientDelegate,OCTableViewDelegate>
{
    UILabel *headerLabelView;
}

-(BOOL) isRootPath;

@end

@implementation OCFilesViewController
@synthesize currentFile;


-(id) initWithFile:(OCFile *) aFile
{
    if (self = [super initWithTableStyle:UITableViewStylePlain]) {
        self.currentFile = aFile;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"OverClouded"];
    headerLabelView = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                dataTableView.frame.size.width,
                                                                50)];
    [headerLabelView setTextAlignment:NSTextAlignmentCenter];
    [headerLabelView setText:@"Swipe Right to add Accounts"];
    [dataTableView setTableHeaderView:headerLabelView];
    [dataTableView setRowHeight:44.f];
    [dataTableView setDragTableViewDelegate:self];
    
    if (self.currentFile) {
        OCFileController *fileController = [[OCFileController alloc] initWithFile:self.currentFile];
        [fileController getFileMetadataAtPath:currentFile.path
                                withAccountID:currentFile.accountId
                              completionBlock:^(OCFile *afile) {
                                  [self stopAnimating:nil];
                                  [self updateView:afile];
                              }];
        
        [OCAccountController getAllAccounts:^(NSArray *accounts, NSError *error) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"accountId == %@",currentFile.accountId];
            NSArray *results = [accounts filteredArrayUsingPredicate:predicate];
            if ([results count]) {
                OCAccount *account = [results objectAtIndex:0];
                self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession] userId:account.userId];
                [self.restClient setDelegate:self];
                [self.restClient loadMetadata:currentFile.path withHash:currentFile.hash];
                [self startAnimating];
            }
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:OC_ALL_ACCOUNTS_READ_NOTIFICATION
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      NSArray *accounts = (NSArray *)[note object];
                                                      for (OCAccount *account in accounts) {
                                                          OCFileController *fileController = [[OCFileController alloc] init];
                                                          [fileController getFileMetadataAtPath:@"/"
                                                                                  withAccountID:account.accountId
                                                                                completionBlock:^(OCFile *afile) {
                                                                                    [self stopAnimating:nil];
                                                                                    [self updateView:afile];
                                                                                }];
                                                      }
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:OC_FILES_METADATA_LOAD_START_NOTIFICATION
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
//                                                      [self startAnimating];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:OC_FILES_METADATA_LOAD_END_NOTIFICATION
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [self stopAnimating:nil];
                                                      [self updateView:[note object]];
                                                  }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:OC_ACCOUNT_ADDED_NOTIFICATION
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [self startAnimating];
                                                      OCAccount *account = (OCAccount *)[note object];
                                                      [headerLabelView setText:[NSString stringWithFormat:@"Loading Files for %@",account.displayName]];
                                                      self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession] userId:account.userId];
                                                      [self.restClient setDelegate:self];
                                                      [self.appDelegate.drawerViewController setCenterViewController:self.appDelegate.filesNavController withCloseAnimation:YES completion:^(BOOL finished) {
                                                          
                                                      }];
                                                  }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:OC_ACCOUNT_SELECTED_NOTIFICATION
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [self.appDelegate.drawerViewController setCenterViewController:self.appDelegate.filesNavController withCloseAnimation:YES completion:^(BOOL finished) {
                                                          [self.appDelegate.filesNavController popToRootViewControllerAnimated:YES];
                                                      }];

                                                      
                                                      OCAccount *account = (OCAccount *)[note object];
                                                      self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession] userId:account.userId];
                                                      [self.restClient setDelegate:self];
                                                      [self.restClient loadMetadata:@"/" withHash:nil];
                                                      OCFileController *fileController = [[OCFileController alloc] init];
                                                      [fileController getFileMetadataAtPath:@"/"
                                                                              withAccountID:account.accountId
                                                                            completionBlock:^(OCFile *afile) {
                                                                                [self updateView:afile];
                                                                            }];
                                                  }];

    
    [[NSNotificationCenter defaultCenter] addObserverForName:OC_ACCOUNT_REMOVED_NOTIFICATION
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      OCAccount *account = (OCAccount *)[note object];
                                                      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"accountId == %@",account.accountId];
                                                      NSArray *filteredFiles = [tableDataArray filteredArrayUsingPredicate:predicate];
                                                      [tableDataArray removeObjectsInArray:filteredFiles];
                                                      [self updateTable];
                                                      if (![tableDataArray count]) {
                                                          [self.navigationItem setTitle:@"OverClouded"];
                                                          [headerLabelView setTextAlignment:NSTextAlignmentCenter];
                                                          [headerLabelView setText:@"Swipe Right to add Accounts"];
                                                          [dataTableView setTableHeaderView:headerLabelView];
                                                      }
                                                  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OC_FILES_METADATA_LOAD_START_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OC_FILES_METADATA_LOAD_END_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OC_ACCOUNT_ADDED_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OC_ACCOUNT_REMOVED_NOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OC_ALL_ACCOUNTS_READ_NOTIFICATION object:nil];
}



#pragma mark - OCTableViewDelegate

-(NSArray *) dataForTableView:(OCTableView *) tableView
{
    return tableDataArray;
}

-(BOOL) shouldIndexPath:(NSIndexPath *)indexPath AnimateFor:(OCTableView *) tableView
{
    BOOL retVal = NO;
    if (indexPath) {
        OCFile *file = [tableDataArray objectAtIndex:indexPath.row];
        retVal = [file isDirectory];
    }
    return retVal;
}



-(UIView *) dragViewForTableView:(OCTableView *) tableView
{
    return [[OCDragView alloc] init];
}

-(void) tableView:(OCTableView *)tableView didSelectFile:(id)file AtIndexPath:(NSIndexPath *)indexPath withDraggingView:(UIView *)aView
{
    OCDragView *draggingView = (OCDragView *)aView;
    [draggingView setFile:file];
}

-(void) tableView:(OCTableView *)tableView isDraggingNowOnIndexPath:(NSIndexPath *) dragIndexPath withStartingIndexPath:(NSIndexPath *)startIndexPath WithHoldCounter:(NSInteger) counter
{
    OCFile *file = [tableDataArray objectAtIndex:dragIndexPath.row];
    if ([file isDirectory]) {
        [tableView reloadRowsAtIndexPaths:@[dragIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


-(void) tableView:(OCTableView *)tableView isDraggingNowOnIndexPath:(NSIndexPath *) dragIndexPath withStartingIndexPath:(NSIndexPath *)startIndexPath
{
    [tableView reloadRowsAtIndexPaths:@[dragIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

-(void) tableView:(OCTableView *)tableView didDropFile:(id)file withStartingIndexPath:(NSIndexPath *)anIndexPath toEndingIndexPath:(NSIndexPath *)otherIndexPath
{
    OCFile *fromFile = [tableDataArray objectAtIndex:anIndexPath.row];
    OCFile *toFile = [tableDataArray objectAtIndex:otherIndexPath.row];
    [self.restClient moveFrom:fromFile.path toPath:[NSString stringWithFormat:@"%@/%@",toFile.path,fromFile.filename]];
}


#pragma mark - DBRestClientDelegate


-(void) restClient:(DBRestClient *)client loadedThumbnail:(NSString *)destPath metadata:(DBMetadata *)metadata
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"path == %@",metadata.path];
    NSArray *results = [tableDataArray filteredArrayUsingPredicate:predicate];
    if ([results count]) {
        OCFile *file = [results objectAtIndex:0];
        file.thumbnailData = [UIImage imageWithContentsOfFile:destPath];
        OCFileController *fileController = [[OCFileController alloc] initWithFile:currentFile];
        [fileController saveWithCompletionBlock:^(OCFile *afile) {
            NSInteger index = [tableDataArray indexOfObject:file];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [dataTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }
}

-(void) restClient:(DBRestClient *)client loadThumbnailFailedWithError:(NSError *)error
{
    
}


-(void) restClient:(DBRestClient *)client movedPath:(NSString *)from_path to:(DBMetadata *)result
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"path == %@",from_path];
    NSArray *results = [tableDataArray filteredArrayUsingPredicate:predicate];
    if ([results count]) {
        OCFile *file = [results objectAtIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[tableDataArray indexOfObject:file] inSection:0];
        [tableDataArray removeObject:file];
        [dataTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}


-(void) restClient:(DBRestClient *)client movePathFailedWithError:(NSError *)error
{
    
}

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata
{
    OCFile *aFile = [[OCFile alloc] initWithFile:metadata WithFileID:currentFile.fileId ofAccountType:DROPBOX inAccountID:currentFile.accountId];
    OCFileController *fileController = [[OCFileController alloc] initWithFile:aFile];
    [fileController saveWithCompletionBlock:^(OCFile *afile) {
        [self stopAnimating:nil];
        [self updateView:aFile];
    }];
}

- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path
{
    [self stopAnimating:nil];
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error
{
    [self stopAnimating:nil];
}


#pragma mark - Helpers



-(BOOL) isRootPath
{
    return currentFile ? NO : YES;
}

-(void)updateView:(OCFile *) file
{
    NSString *title = file.filename;
    if ([self isRootPath]) { //current folder is root
        title = OC_ROOT_FOLDER_NAME;
    }
    [self.navigationItem setTitle:title];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"thumbnailExists	== %@",[NSNumber numberWithBool:YES]];
    NSArray *thumbnailFiles = [file.contents filteredArrayUsingPredicate:predicate];
    
    for (OCFile *file in thumbnailFiles) {
        NSString *thumbnailPath = [NSString stringWithFormat:@"%@/%@/%@",[OCUtilities getAccountsPath],file.accountId,file.fileId];
        [self.restClient loadThumbnail:file.path ofSize:@"small" intoPath:thumbnailPath];
    }
    
    [self updateTableView:file.contents];
}

#pragma mark - Animating

-(void) startAnimating {
    [super startAnimating];
    [headerLabelView setText:@"Loading...."];
    [dataTableView setTableHeaderView:headerLabelView];
}


-(void) stopAnimating:(UIBarButtonItem *)barbuttonItem
{
    [super stopAnimating:barbuttonItem];
    [dataTableView setTableHeaderView:nil];
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OCFile *file = [tableDataArray objectAtIndex:indexPath.row];
    if (file.isDirectory) {
        OCFilesViewController *filesViewController = [[OCFilesViewController alloc] initWithFile:file];
        [self.navigationController pushViewController:filesViewController animated:YES];
    }
}


#pragma mark - UITableViewDataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    OCFile *file = [tableDataArray objectAtIndex:indexPath.row];
    NSString *fileName = file.filename;
    [cell.textLabel setText:fileName];
    [cell.detailTextLabel setText:file.humanReadableSize];
    UIImage *image = nil;
    if ([file isDirectory]) {
        image = [UIImage imageNamed:@"folder"];
    } else {
        NSArray *components = [fileName componentsSeparatedByString:@"."];
        NSString *extension = [components lastObject];
        image = file.thumbnailData;
        if (!image) {
            if ([extension length]) {
                image = [UIImage imageNamed:[extension lowercaseString]];
                if (!image) {
                    image = [UIImage imageNamed:@"_blank"];
                }
            } else {
                image = [UIImage imageNamed:@"_blank"];
            }
        }
    }
    [cell.imageView setImage:image];
    return cell;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
