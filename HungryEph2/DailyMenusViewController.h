//
//  DailyMenusViewController.h
//  HungryEph2
//
//  Created by Aaron Taylor on 5/25/13.
//  Copyright (c) 2013 Williams College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyMenusViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    
    IBOutlet UIButton *showMenu;
    IBOutlet UIButton *updateMenus;
    IBOutlet UIPickerView *mealPicker;
}

-(IBAction)go:(id)sender;

@end
