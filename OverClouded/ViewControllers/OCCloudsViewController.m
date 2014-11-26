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
@synthesize delegate;

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
    NSURL *authURL = nil;
    NSMutableURLRequest *request = nil;
    switch (vc.type) {
        case DROPBOX:
        {
            NSString *paramString = [NSString stringWithFormat:@"code=%@&grant_type=authorization_code&client_id=%@&client_secret=%@&redirect_uri=%@",code,DROPBOX_APP_KEY,DROPBOX_APP_SECRET_KEY,REDIRECT_URI];
            authURL = [NSURL URLWithString:@"https://api.dropbox.com/1/oauth2/token"];
            request = [NSMutableURLRequest requestWithURL:authURL];
            [request setHTTPBody:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
            [request setHTTPMethod:@"POST"];
        }
            break;
        default:
            break;
    }
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *authDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([self.delegate respondsToSelector:@selector(cloudViewController:didRecieveAuthenticationDataDictionary:)]) {
            NSMutableDictionary *retDict = [NSMutableDictionary dictionary];
            [retDict addEntriesFromDictionary:authDictionary];
            [retDict setObject:[NSNumber numberWithInt:vc.type]
                        forKey:OC_CLOUD_TYPE];
            [self.delegate cloudViewController:self didRecieveAuthenticationDataDictionary:retDict];
            [self dismissViewControllerAnimated:YES completion:^{
            }];
        }
    }];
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
