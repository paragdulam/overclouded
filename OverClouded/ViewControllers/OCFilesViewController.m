//
//  OCFIlesViewController.m
//  OverClouded
//
//  Created by Parag Dulam on 17/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCFilesViewController.h"
#import "OCConstants.h"

@interface OCFilesViewController ()
{
    UILabel *headerLabelView;
}

@end

@implementation OCFilesViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserverForName:OC_FILES_METADATA_LOAD_START_NOTIFICATION
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [self startAnimating];
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:OC_FILES_METADATA_LOAD_END_NOTIFICATION
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [self stopAnimating:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
