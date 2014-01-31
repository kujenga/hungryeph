//
//  InfoTabViewController.m
//  HungryEph2
//
//  Created by Aaron Taylor on 9/27/13.
//  Copyright (c) 2013 Williams College. All rights reserved.
//

#import "InfoTabsViewController.h"

@interface InfoTabsViewController ()

@property (strong, nonatomic) InfoChildViewController* infoChildController;
@property (strong, nonatomic) ContactChildViewController* contactChildController;

@end

@implementation InfoTabsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@synthesize infoChildController;
@synthesize contactChildController;

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

# pragma mark UIPageViewControllerDataSource protocol methods

-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [(InfoChildViewController *)viewController index];
    
    if (index == 0) {
        if (contactChildController) {
            return contactChildController;
        }
        return nil;
    } else if (index == 1) {
        index--;
        if ( infoChildController ) {
            return infoChildController;
        }
        return nil;
    } else {
        return nil;
    }
}

-(UIViewController*)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [(InfoChildViewController *)viewController index];
    
    if (index == 0) {
        index++;
        if (contactChildController) {
            return contactChildController;
        }
        return nil;
    } else if (index == 1) {
        if ( infoChildController ) {
            return infoChildController;
        }
        return nil;
    } else {
        return nil;
    }
}

-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return 2;
}

-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return 1;
}
@end
