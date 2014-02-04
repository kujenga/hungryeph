//
//  MenuItemOptionsViewController.m
//  HungryEph2
//
//  Created by Aaron Taylor on 9/27/13.
//  Copyright (c) 2013 Williams College. All rights reserved.
//

#import "MenuItemOptionsViewController.h"

@interface MenuItemOptionsViewController () {
    NSDictionary * options;
    NSString * notes;
    //array of keys in the order that the options dictionary stores them, created for frequent use
    NSArray * orderedKeys;
    
    ToOrderMenuViewController*parent;
    
    NSMutableArray *removedItems;
}

@end

@implementation MenuItemOptionsViewController

- (id) initWithItems:(NSDictionary *)optionsIn andNotes:(NSString *)notesIn andSender:(id)sender
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        NSLog(@"in MenuItemOptionsViewController");
        options = optionsIn;
        orderedKeys = [options allKeys];
        notes = notesIn;
        parent = sender;
        
        removedItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *checkoutButton = [[UIBarButtonItem alloc] initWithTitle:@"View Cart" style:UIBarButtonItemStyleDone target:self action:@selector(goCheckout)];
	self.navigationItem.rightBarButtonItem = checkoutButton;
	self.title = @"Meal Deal";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) goCheckout {
    if (parent) {
        
        //[self.navigationController popViewControllerAnimated:YES];
        [parent presentCheckout];
        //[self.navigationController pushViewController:parent animated:YES];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* itemName = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    NSDictionary*item = [NSDictionary dictionaryWithObjects:@[itemName,@0] forKeys:@[@"name",@"price"]];
    //NSLog([item description]);
    
    [parent addToCartWithDictionary:item];
    
    [removedItems addObject:indexPath];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [orderedKeys count];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [orderedKeys objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.

    int less = 0;  // accounts for rows removed by user to maintain consistency
    for ( NSIndexPath * path in removedItems ) {
        if (path.section == section) less++;
    }
    return ([[options objectForKey:[orderedKeys objectAtIndex:section]] count] - less);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
	
	NSArray *section = [options objectForKey:[orderedKeys objectAtIndex:indexPath.section]];
	NSString *item = [section objectAtIndex:indexPath.row];
	cell.textLabel.text = item;
	cell.textLabel.minimumScaleFactor = 8;
	cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

#pragma mark - Navigation

- (void) popAfterCheckout {
    [self.navigationController popToViewController:parent animated:NO];
}

/*
// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
