//
//  HungryEphFirstViewController.h
//  HungryEph2
//
//  Created by Aaron Taylor on 5/25/13.
//  Copyright (c) 2013 Williams College. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToOrderMenuViewController;

@interface ToOrderViewController : UIViewController {
    
    IBOutlet UINavigationItem *nav;
    
    IBOutlet UIButton *whitmans;
    IBOutlet UIButton *eco;
    IBOutlet UIButton *goodrich;
    IBOutlet UIButton *lee;
    IBOutlet UIButton *etgrill;
    //IBOutlet UIButton *leeMealDeal;
    
    //heights of the buttons
    
    IBOutlet NSLayoutConstraint *whitmanHeight;
    IBOutlet NSLayoutConstraint *ecoHeight;
    IBOutlet NSLayoutConstraint *goodrichHeight;
    IBOutlet NSLayoutConstraint *etHeight;
    IBOutlet NSLayoutConstraint *leeHeight;
    
    IBOutlet UISegmentedControl *equivalencyControl;
}



-(IBAction)go:(id)sender;

@end
