//
//  CheckoutViewController.h
//  Display when user checks out. Shows cart and total price and allows user to remove items 
//
//  Created by Diogenes Nunez on 1/20/10.
//  Copyright 2010 __Williams College__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToOrderMenuViewController.h"


@interface CheckoutViewController : UITableViewController {
	double totalPrice;
	IBOutlet UIButton *clearButton;
	NSString *emailAddress;
	NSMutableArray *cart;
	ToOrderMenuViewController *parent;
}

- (id) initWithTotalPrice: (double) cost cart:(NSMutableArray *)stuff parent:(ToOrderMenuViewController *)root;
- (IBAction) checkout: (id) sender;

@end
