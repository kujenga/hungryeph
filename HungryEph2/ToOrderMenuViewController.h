//
//  AbstractMenuViewController.h
//  DiningApp
//  Interface that RootViewController (late night), EcoMenuViewController, GoodrichMenuViewController will extend
//
//  Created by Emily Yu on 4/12/11.
//  Modified by Aaron Taylor on 4/10/13
//  Copyright 2011 __Williams College__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ToOrderMenuViewController : UITableViewController 

-(id) initWithName:(NSString *) name andPoints: (BOOL)limit;
- (NSComparisonResult) sortWith: (NSDictionary *)dict1 and: (NSDictionary *)dict2;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

-(void) addToCartWithDictionary:(NSDictionary*) newItem;
-(void) presentCheckout;
-(void) updateTotalPrice:(double)cost cart:(NSMutableArray *)stuff;

@end

