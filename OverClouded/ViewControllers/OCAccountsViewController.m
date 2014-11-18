//
//  OCAccountsViewController.m
//  OverClouded
//
//  Created by Parag Dulam on 17/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCAccountsViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "OCAccount.h"
#import "OCAccountController.h"


@interface OCAccountsViewController ()<DBRestClientDelegate>

@property (nonatomic,strong) DBRestClient *restClient;

@end

@implementation OCAccountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"Accounts"];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped:)];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonTapped:)];
    [self.navigationItem setLeftBarButtonItem:editButton];
    
    [OCAccountController getAllAccounts:^(NSArray *accounts, NSError *error) {
        if (accounts) {
            [self updateTableView:accounts];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - UITableViewDelegate



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    OCAccount *account = [tableDataArray objectAtIndex:indexPath.row];
    [account.accountController removeAccountWithCompletionBlock:^(NSError *error) {
        
    }];
    [tableDataArray removeObject:account];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
}

#pragma mark - UITableViewDataSource



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        [cell.detailTextLabel setFont:[UIFont italicSystemFontOfSize:11.f]];
        [cell.detailTextLabel setTextColor:[UIColor darkGrayColor]];
    }
    
    OCAccount *account = [tableDataArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:account.displayName];
    NSString *detailText = [NSString stringWithFormat:@"%.2f GB used out of %.2f GB",account.normalConsumedBytes * pow(10, -9),account.totalBytes * pow(10, -9)];
    [cell.detailTextLabel setText:detailText];
    
    return cell;
}



#pragma mark - DBRestClientDelegate

- (void)restClient:(DBRestClient*)client loadedAccountInfo:(DBAccountInfo*)info
{
    OCAccount *account = [[OCAccount alloc] initWithAccount:info ofType:DROPBOX];
    OCAccountController *accountController = [[OCAccountController alloc] initWithAccount:account];
    [accountController saveWithCompletionBlock:^(OCAccount *account) {
        if (account) {
            [tableDataArray addObject:account];
            [self updateTable];
        }
    }];
}


- (void)restClient:(DBRestClient*)client loadAccountInfoFailedWithError:(NSError*)error
{
    NSLog(@"errro %@",error);
}


#pragma mark - Dropbox Login Callback

-(void)dropboxDidLink
{
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    [self.restClient setDelegate:self];
    [self.restClient loadAccountInfo];
}

#pragma mark - IBActions

-(void)addButtonTapped:(id) sender
{
    [[DBSession sharedSession] linkFromController:self];
}


-(void)editButtonTapped:(id) sender
{
    BOOL editing = dataTableView.editing;
    [dataTableView setEditing:!editing animated:YES];
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
