//
//  OCWebViewController.m
//  OverClouded
//
//  Created by Parag Dulam on 26/11/14.
//  Copyright (c) 2014 Parag Dulam. All rights reserved.
//

#import "OCWebViewController.h"

@interface OCWebViewController ()<UIWebViewDelegate>
{
    UIWebView *webView;
}
@end

@implementation OCWebViewController
@synthesize url;
@synthesize type;
@synthesize delegate;
@synthesize redirect_uri;

-(id) initWithURL:(NSURL *) anURL ForCloudType:(OCCLOUD_TYPE) cloudType andRedirectURI:(NSString *) rURI
{
    if (self = [super init]) {
        self.url = anURL;
        self.type = cloudType;
        self.redirect_uri = rURI;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView setDelegate:self];
    [self.view addSubview:webView];
    [webView setScalesPageToFit:YES];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"requet %@",request);
    NSString *urlString = [request.URL absoluteString];
    if ([urlString hasPrefix:self.redirect_uri]) {
        NSString *trimmedString = [urlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/?",self.redirect_uri] withString:@""];
        NSLog(@"trimmed %@",trimmedString);
        NSArray *components = [trimmedString componentsSeparatedByString:@"="];
        if ([self.delegate respondsToSelector:@selector(webViewController:didRecieveAuthorizationCode:)]) {
            if ([components count]) {
                [self.delegate webViewController:self didRecieveAuthorizationCode:[components lastObject]];
            }
        }
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self stopAnimating:nil];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
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