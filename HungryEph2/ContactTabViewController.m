//
//  ContactTabViewController.m
//  HungryEph2
//
//  Created by Aaron Taylor on 9/27/13.
//  Copyright (c) 2013 Williams College. All rights reserved.
//

#import <MessageUI/MessageUI.h>

#import "ContactTabViewController.h"

@interface ContactTabViewController ()

@end

@implementation ContactTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendMessage:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController * mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setToRecipients:@[@"hungryephcontact@gmail.com"]];
        [mailer setSubject:@"Hungry Eph App ideas"];
        [self presentViewController:mailer animated:YES completion:NULL];
    } else {
        NSLog(@"Error: cannot send mail on this device");
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Result: Mail sending canceled");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Result: Mail saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Result: Mail sent");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Result: Mail sending failed");
			break;
		default:
			NSLog(@"Result: Mail not sent");
			break;
	}
    
	[self dismissViewControllerAnimated:YES completion:NULL];
}

@end
