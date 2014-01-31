//
//  TempDailyMenusViewController.m
//  HungryEph2
//
//  Created by Aaron Taylor on 1/1/14.
//  Copyright (c) 2014 Williams College. All rights reserved.
//

#import "TempDailyMenusViewController.h"

@interface TempDailyMenusViewController () {
    
    NSString * webAddressStr;
}

@end

@implementation TempDailyMenusViewController

@synthesize isInitialized,atStart;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        webAddressStr = @"http://nutrition.williams.edu/NetNutrition/Mobile.aspx/Mobile";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _webView.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *fullURL = @"http://nutrition.williams.edu/NetNutrition/Mobile.aspx/Mobile";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:requestObj];
}

-(void) viewWillDisappear:(BOOL)animated {
    //clears the webview
    //[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_activityIndicator startAnimating];
    _activityIndicator.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_activityIndicator stopAnimating];
    _activityIndicator.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
