//
//  OCAccountsViewController.m
//  OverClouded
//
//  Created by Parag Dulam on 17/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCAccountsViewController.h"
#import "OCAccount.h"
#import "OCFile.h"
#import "OCAccountController.h"
#import "OCFileController.h"
#import "AppDelegate.h"
#import "OCUtilities.h"
#import "OCCloudsViewController.h"
#import "OCAppController.h"


@interface OCAccountsViewController ()<OCCloudsViewControllerDelegate>
{
    UIBarButtonItem *addButton;
}


@end

@implementation OCAccountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"Accounts"];
    
    addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped:)];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonTapped:)];
    [self.navigationItem setLeftBarButtonItem:editButton];
    
    [OCAppController getAllAccountsWithCompletionBlock:^(id response, NSError *error) {
        NSArray *accounts = (NSArray *)response;
        if (accounts) {
            [self updateTableView:accounts];
            [[NSNotificationCenter defaultCenter] postNotificationName:OC_ALL_ACCOUNTS_READ_NOTIFICATION object:accounts];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:OC_ACCOUNT_SELECTED_NOTIFICATION object:[tableDataArray objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    OCAccount *account = [tableDataArray objectAtIndex:indexPath.row];
    [OCAppController removeAccount:account
               WithCompletionBlock:^(NSError *error) {
    }];
    
    [tableDataArray removeObject:account];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OC_ACCOUNT_REMOVED_NOTIFICATION object:account];
}

#pragma mark - UITableViewDataSource



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    OCAccount *account = [tableDataArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:account.displayName];
    NSString *detailText = [NSString stringWithFormat:@"%.2f GB used out of %.2f GB",[account.normalConsumedBytes longLongValue] * pow(10, -9),[account.totalBytes longLongValue] * pow(10, -9)];
    [cell.detailTextLabel setText:detailText];
    
    return cell;
}


#pragma mark - Helpers

-(void) stopAnimating:(UIBarButtonItem *)barbuttonItem
{
    [super stopAnimating:barbuttonItem];
    [dataTableView setEditing:NO animated:YES];
}


#pragma mark - OCCloudsViewControllerDelegate

-(void) cloudViewController:(OCCloudsViewController *) vc didRecieveAuthenticationDataDictionary:(NSDictionary *) authDict
{
    [OCAppController saveAccountForCredentials:authDict
                               completionBlock:^(id response, NSError *error) {
                                   OCAccount *account = (OCAccount *)response;
                                   [tableDataArray addObject:account];
                                   [self updateTable];
                                   [[NSNotificationCenter defaultCenter] postNotificationName:OC_ACCOUNT_ADDED_NOTIFICATION object:account];
                               }];
}



#pragma mark - IBActions

-(void)addButtonTapped:(id) sender
{
    [OCAppController linkFromController:self];
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
