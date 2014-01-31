//
//  MenuForDayViewController.h
//  HungryEph2
//
//  Created by Aaron Taylor on 5/26/13.
//  Copyright (c) 2013 Williams College. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuForDayViewController : UITableViewController

//title parameter is the title of the entire menu. menus NSArray parameter is an array of arrays
//each sub-array of menus begings with the section title (lunch, dinner, etc.) and then lists menu items
-(id)initWithTitle:(NSString *) title AndMenuArray:(NSArray *)menus;

@end
