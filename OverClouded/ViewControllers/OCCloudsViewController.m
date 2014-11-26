//
//  OCCloudsViewController.m
//  OverClouded
//
//  Created by Parag Dulam on 26/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCCloudsViewController.h"
#import "OCWebViewController.h"

#define DROPBOX_APP_KEY @"y1hmeaarl6da494"
#define DROPBOX_APP_SECRET_KEY @"4mjdch4itbrvcyh"
#define DROPBOX_ROOT @"auto"
#define REDIRECT_URI @"http://localhost"


@interface OCCloudsViewController ()<OCAuthorizationCodeDelegate>

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
    NSString *urlString = nil;
    switch (indexPath.row) {
        case DROPBOX:
        {
            NSDictionary *params = @{@"client_id":DROPBOX_APP_KEY,@"response_type":@"code",@"redirect_uri":REDIRECT_URI};
            NSMutableString *baseURLString = [NSMutableString stringWithString:@"https://www.dropbox.com/1/oauth2/authorize"];
            [baseURLString appendFormat:@"?"];
            NSArray *keys = [params allKeys];
            for (NSString *key in keys) {
                [baseURLString appendFormat:@"%@=%@",key,[params objectForKey:key]];
                if (![[keys lastObject] isEqualToString:key]) {
                    [baseURLString appendString:@"&"];
                }
            }
            urlString = baseURLString;
        }
            break;
            
        default:
            break;
    }
    NSURL *url = [NSURL URLWithString:urlString];
    OCWebViewController *webViewController = [[OCWebViewController alloc] initWithURL:url ForCloudType:indexPath.row andRedirectURI:REDIRECT_URI];
    [webViewController setDelegate:self];
    [self.navigationController pushViewController:webViewController animated:YES];
}


#pragma mark - OCAuthorizationCodeDelegate

-(void) webViewController:(OCWebViewController *) vc didRecieveAuthorizationCode:(NSString *) code
{
    //Phase 1 of oauth 2.0 is done here
    switch (vc.type) {
        case DROPBOX:
        {
            NSString *paramString = [NSString stringWithFormat:@"code=%@&grant_type=authorization_code&client_id=%@&client_secret=%@&redirect_uri=%@",code,DROPBOX_APP_KEY,DROPBOX_APP_SECRET_KEY,REDIRECT_URI];
            NSURL *authURL = [NSURL URLWithString:@"https://api.dropbox.com/1/oauth2/token"];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:authURL];
            [request setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
            [request setHTTPMethod:@"POST"];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"res %@",responseString);
            }];
        }
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
