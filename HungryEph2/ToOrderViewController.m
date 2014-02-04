//
//  HungryEphFirstViewController.m
//  HungryEph2
//
//  Created by Aaron Taylor on 5/25/13.
//  Copyright (c) 2013 Williams College. All rights reserved.
//

#import "ToOrderViewController.h"
#import "ToOrderMenuViewController.h"

@interface ToOrderViewController () {
    
    __weak IBOutlet UIImageView *background;
    NSArray* buttonSizes;
}

@end

@implementation ToOrderViewController

-(IBAction)go:(id)sender{
    //determines equivalency amount
    double equivalency = 0;
    if ( (equivalencyControl.selectedSegmentIndex == 0) ) {
        //NSLog(@"is Equivalency");
        if (sender == etgrill) {
            equivalency = 8;
        } else {
            equivalency = 7;
        }
    }
    //determines sender
    NSString *name = @"";
    if (sender == whitmans) {
        name = @"WhitmansArray";
    } else if (sender == eco) {
        name = @"EcoCafeArray";
    } else if (sender == goodrich) {
        name = @"GoodrichArray";
    } else if (sender == lee) {
        name = @"LeeAfterDarkArray";
    } else if (sender == etgrill) {
        name = @"82GrillArray";
    }
    
    //pushes to the menu controller
    if (![name isEqualToString:@""]) {
        ToOrderMenuViewController *viewController = [[ToOrderMenuViewController alloc] initWithName:name andPoints:equivalency];
		viewController.view.frame = [UIScreen mainScreen].applicationFrame;
		[self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
    
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    nav.title = @"To Order";
    
    // Appropriately set button positions
    buttonSizes = @[whitmanHeight,ecoHeight,goodrichHeight,etHeight,leeHeight];
    CGFloat buttonHeight = ([[UIScreen mainScreen] bounds].size.height - 59 - 64 - 75)/5;
    for ( NSLayoutConstraint * height in buttonSizes ) {
        height.constant = buttonHeight;
    }
    
    // the array for the uiimageview background
    NSArray* backgroundImages = @[[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"82Grill2" ofType:@"jpg"]],
                                  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Driscoll2" ofType:@"jpg"]],
                                  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"EcoCafe2" ofType:@"jpg"]],
                                  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Goodrich2" ofType:@"jpg"]],
                                  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LeeSnackBar2" ofType:@"jpg"]],
                                  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Whitmans2" ofType:@"jpg"]]];
    
    background.animationImages = backgroundImages;
    //background.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Whitmans2" ofType:@"jpg"]];
    background.animationDuration = 20.0;
    //background.tintColor = [UIColor darkGrayColor];
    [background startAnimating];
    NSLog([background isAnimating] ? @"YES" : @"NO" );
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
