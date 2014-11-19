//
//  OCBaseViewController.m
//  OverClouded
//
//  Created by Parag Dulam on 17/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCBaseViewController.h"

@interface OCBaseViewController ()
{
    UIActivityIndicatorView *activityIndicator;
    UIBarButtonItem *activityIndicatorButtonItem;
}
@end

@implementation OCBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:59.f/255.f
                                                                             green:162.f/255.f
                                                                              blue:235.f/255.f
                                                                             alpha:1.f]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator setHidesWhenStopped:YES];
    activityIndicatorButtonItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Activity Indicators

-(void) startAnimating
{
    [activityIndicator startAnimating];
    [self.navigationItem setRightBarButtonItem:activityIndicatorButtonItem];
}

-(void) stopAnimating:(UIBarButtonItem *) barbuttonItem
{
    [activityIndicator stopAnimating];
    [self.navigationItem setRightBarButtonItem:barbuttonItem];
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
