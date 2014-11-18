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
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:nil action:nil];
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


#pragma mark - UITableViewDataSource



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    
    OCAccount *account = [tableDataArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:account.displayName];
    NSString *detailText = [NSString stringWithFormat:@"%2.2f of %2.2f Used",account.normalConsumedBytes/(1024 ^ 6),account.totalBytes/(1024 ^ 6)];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
