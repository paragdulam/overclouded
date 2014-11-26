//
//  OCCloudsViewController.m
//  OverClouded
//
//  Created by Parag Dulam on 26/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCCloudsViewController.h"

#define DROPBOX_APP_KEY @"y1hmeaarl6da494"
#define DROPBOX_APP_SECRET_KEY @"4mjdch4itbrvcyh"
#define DROPBOX_ROOT @"auto"


@interface OCCloudsViewController ()

@end

@implementation OCCloudsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [dataTableView registerClass:[UITableViewCell class]
          forCellReuseIdentifier:@"UITableViewCell"];
    
    [tableDataArray addObject:@"Dropbox"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    [cell.textLabel setText:[tableDataArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case DROPBOX:
            <#statements#>
            break;
            
        default:
            break;
    }
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
