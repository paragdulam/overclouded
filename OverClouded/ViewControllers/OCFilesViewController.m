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
#import "OCAccount.h"
#import "AppDelegate.h"

@interface OCFilesViewController ()<DBRestClientDelegate,UIGestureRecognizerDelegate>
{
    UILabel *headerLabelView;
    UIView *draggingView;
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
    
    
    draggingView = [[UIView alloc] initWithFrame:CGRectZero];
    [draggingView setBackgroundColor:[UIColor redColor]];
    [dataTableView addSubview:draggingView];
    
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    [longPressGesture setDelegate:self];
    longPressGesture.minimumPressDuration = 1.f;
    [dataTableView addGestureRecognizer:longPressGesture];
    
    if (self.currentFile) {
        OCFileController *fileController = [[OCFileController alloc] initWithFile:self.currentFile];
        [fileController getFileMetadataAtPath:currentFile.path
                                withAccountID:currentFile.accountId
                              completionBlock:^(OCFile *afile) {
                                  [self stopAnimating:nil];
                                  [self updateView:afile];
                              }];
        self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        [self.restClient setDelegate:self];
        [self.restClient loadMetadata:currentFile.path withHash:currentFile.hash];
        [self startAnimating];
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



#pragma mark - UIGestureRecognizerDelegate


-(void) longPressGesture:(UILongPressGestureRecognizer *) gestureRecognizer
{
    UITableView *tableView = (UITableView *)gestureRecognizer.view;
    CGPoint startPoint = [gestureRecognizer locationInView:tableView];
    NSIndexPath *indPath = [tableView indexPathForRowAtPoint:startPoint];
    if (indPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint p = [gestureRecognizer locationInView:tableView];
        NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:p];
        NSLog(@"long press on table view at row %d", indexPath.row);
        
        tableView.scrollEnabled = NO;
        tableView.alpha = 0.6;
        
        CGRect dragViewFrame = draggingView.frame;
        
        dragViewFrame.size.width = 200;
        dragViewFrame.size.height = 30;
        dragViewFrame.origin.y = p.y - (dragViewFrame.size.height/2);
        dragViewFrame.origin.x = p.x;
        if (p.x + dragViewFrame.size.width + 30 > self.view.frame.size.width) {
            dragViewFrame.origin.x = p.x - dragViewFrame.size.width;
        }
        draggingView.frame = dragViewFrame;
        
        
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint p = [gestureRecognizer locationInView:tableView];
        NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:p];
        NSLog(@"Ended long press on table view at row %d", indexPath.row);
        
        tableView.scrollEnabled = YES;
        tableView.alpha = 1.0;
        draggingView.frame = CGRectZero;
        
        
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged){
        CGPoint p = [gestureRecognizer locationInView:tableView];
        NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:p];
        
        CGRect dragViewFrame = draggingView.frame;
        dragViewFrame.origin.y = p.y - (dragViewFrame.size.height/2);
        dragViewFrame.origin.x = p.x;
        if (p.x + dragViewFrame.size.width + 30 > self.view.frame.size.width) {
            dragViewFrame.origin.x = p.x - dragViewFrame.size.width;
        }
        draggingView.frame = dragViewFrame;
        
        NSArray *visibleIndexPaths = [tableView indexPathsForVisibleRows];
        NSInteger firstIndex = [[visibleIndexPaths firstObject] row] + 2;
        NSInteger lastIndex = [[visibleIndexPaths lastObject] row] - 2;
        
        NSIndexPath *firstVisibleIndexPath = [NSIndexPath indexPathForRow:firstIndex inSection:0];
        NSIndexPath *lastVisibleIndexPath = [NSIndexPath indexPathForRow:lastIndex inSection:0];
        
        CGRect firstCellRect = [tableView rectForRowAtIndexPath:firstVisibleIndexPath];
        CGRect lastCellRect = [tableView rectForRowAtIndexPath:lastVisibleIndexPath];
        
        draggingView.hidden = NO;
        if (draggingView.frame.origin.y < firstCellRect.origin.y) {
            CGRect targetRect = CGRectZero;
            targetRect.size = firstCellRect.size;
            targetRect.origin.x = firstCellRect.origin.x;
            targetRect.origin.y = firstCellRect.origin.y - (firstCellRect.size.height * 2);
            draggingView.hidden = YES;
            [tableView scrollRectToVisible:targetRect animated:YES];
        }
        
        if (draggingView.frame.origin.y > lastCellRect.origin.y) {
            CGRect targetRect = CGRectZero;
            targetRect.size = lastCellRect.size;
            targetRect.origin.x = lastCellRect.origin.x;
            targetRect.origin.y = lastCellRect.origin.y + (lastCellRect.size.height * 3);
            
            draggingView.hidden = YES;
            [tableView scrollRectToVisible:targetRect animated:YES];
        }
        
        if (tableView.contentOffset.y <= 0 || tableView.contentOffset.y >= tableView.contentSize.height - tableView.frame.size.height) {
            draggingView.hidden = NO;
        }
    }
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL retVal = YES;
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        retVal = NO;
    }
    return retVal;
}



#pragma mark - DBRestClientDelegate

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata
{
    OCFile *aFile = [[OCFile alloc] initWithFile:metadata ofAccountType:DROPBOX andAccountID:currentFile.accountId];
    OCFileController *fileController = [[OCFileController alloc] initWithFile:aFile];
    [fileController saveWithCompletionBlock:^(OCFile *afile) {
        [self stopAnimating:nil];
        [self updateView:aFile];
    }];
}

- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path
{
    
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
    [cell.textLabel setText:file.filename];
    [cell.detailTextLabel setText:file.humanReadableSize];
    
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
