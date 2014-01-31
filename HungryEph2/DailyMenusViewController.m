//
//  DailyMenusViewController.m
//  HungryEph2
//
//  Created by Aaron Taylor on 5/25/13.
//  Copyright (c) 2013 Williams College. All rights reserved.
//

#import "DailyMenusViewController.h"
#import "WebMenuScanOperation.h"
#import "MenuForDayViewController.h"
#import "WebLinksFinder.h"

@interface DailyMenusViewController (){
    
    NSDictionary *urls;
    NSDictionary *urls2;
    
    NSMutableArray *menusOps;
}

@property (nonatomic,strong) NSArray *keys;

@end

@implementation DailyMenusViewController

-(IBAction)go:(id)sender{
    if (sender == showMenu) {
        int selection = [mealPicker selectedRowInComponent:0];
        NSString *key = [[self.keys objectAtIndex:selection] copy];
        int index = [self.keys indexOfObject:key];
        WebMenuScanOperation *theMenuOp = [menusOps objectAtIndex:index];
        if ([theMenuOp isFinished]) {
            NSArray *menus = [theMenuOp getMenu];
            MenuForDayViewController *viewController = [[MenuForDayViewController alloc] initWithTitle:key AndMenuArray:menus];
            viewController.view.frame = [UIScreen mainScreen].applicationFrame;
            NSLog(@"Navigation Controller:%@/nViewController:%@",self.navigationController,viewController);
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            NSLog(@"Attempeted to go to Daily Menu:%@ while search was still running", key);
            //this should be modified to have an activity indicator view that spins while the operation is finishing.
            //it could also cancel other, non relevant operations on the NSOperationQueues in viewDidLoad
        }
        
    } else if (sender == updateMenus) {
        WebLinksFinder *linksFinder = [WebLinksFinder webLinksFinderWithRootURL:[NSURL URLWithString:@"http://dining.williams.edu/menus/"]];
        [linksFinder findLinksWithinRootURL];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Daily Menus";
    /*
    urls = @{@"Whitman's Wednesday 1":[NSURL URLWithString:@"http://dining.williams.edu/menus/whitmans-wednesday-1/"],
                @"Whitman's Monday 2":[NSURL URLWithString:@"http://dining.williams.edu/menus/whitmans-monday-2/"],
             @"Whitman's Wednesday 2":[NSURL URLWithString:@"http://dining.williams.edu/menus/whitmans-wednesday-2/"],
                          @"Eco Cafe":[NSURL URLWithString:@"http://dining.williams.edu/menus/eco-cafe/"],
                       @"Grab and Go":[NSURL URLWithString:@"http://dining.williams.edu/menus/eco-cafe/"]
             };
    */
    
    urls = @{@"Whitman's Wednesday 1":[NSURL URLWithString:@"http://dining.williams.edu/menus/whitmans-wednesday-1/"],
             @"Whitman's Monday 2":[NSURL URLWithString:@"http://dining.williams.edu/menus/whitmans-monday-2/"],
             @"Whitman's Wednesday 2":[NSURL URLWithString:@"http://dining.williams.edu/menus/whitmans-wednesday-2/"],
             @"Eco Cafe":[NSURL URLWithString:@"http://dining.williams.edu/menus/eco-cafe/"],
             @"Grab and Go":[NSURL URLWithString:@"http://dining.williams.edu/menus/eco-cafe/"]
             };

    
    //this code utilizes concurrency to allow the WebLinksFinder to run in a background thread using GCD
    NSOperationQueue *linksOpQueue = [[NSOperationQueue alloc] init];
    WebLinksFinder *linksFinder = [WebLinksFinder webLinksFinderWithRootURL:[NSURL URLWithString:@"http://dining.williams.edu/menus/"]];
    NSInvocationOperation *findLinksOp = [[NSInvocationOperation alloc] initWithTarget:linksFinder
                                                                        selector:@selector(findLinksWithinRootURL) object:nil];
    [linksOpQueue addOperation:findLinksOp];
    
    menusOps = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *key in [urls allKeys]) {
        NSOperation *newMenuOp = [[WebMenuScanOperation alloc] initWithURL:[urls objectForKey:key]];
        [menusOps addObject:newMenuOp];
    }
    NSOperationQueue *menusOpQueue = [[NSOperationQueue alloc] init];
    [menusOpQueue addOperations:menusOps waitUntilFinished:NO];
    
    self.keys = [urls allKeys];
    mealPicker.dataSource = self;
    mealPicker.delegate = self;
    
    
    //NSLog(@"keysIn: %@\nself.keys: %@",keysIn,self.keys);
}


void (^loadMenusWithURLDictionary)(NSDictionary*) =  ^(NSDictionary *dic){
    
};




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIPickerView dataSource methods

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.keys count];
}

#pragma mark UIPickerView delegate methods

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.keys objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}


@end
