//
//  MenuItemOptionsViewController.h
//  HungryEph2
//
//  Created by Aaron Taylor on 9/27/13.
//  Copyright (c) 2013 Williams College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToOrderMenuViewController.h"

@interface MenuItemOptionsViewController : UITableViewController

- (id) initWithItems:(NSDictionary *)optionsIn andNotes:(NSString *)notesIn andSender:(id)sender;

@end
