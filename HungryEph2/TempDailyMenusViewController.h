//
//  TempDailyMenusViewController.h
//  HungryEph2
//
//  Created by Aaron Taylor on 1/1/14.
//  Copyright (c) 2014 Williams College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TempDailyMenusViewController : UIViewController <UIWebViewDelegate> {

}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic) BOOL *atStart;
@property (nonatomic) BOOL *isInitialized;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

//-(void) initializeWebView;

@end
