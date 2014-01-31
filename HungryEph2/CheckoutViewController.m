//
//  CheckoutViewController.m
//  Display when user checks out. Shows cart and total price and allows user to remove items 
//
//  Created by Diogenes Nunez on 1/20/10.
//  Copyright 2010 __Williams College__. All rights reserved.
//

#import "CheckoutViewController.h"

@implementation CheckoutViewController

- (id)initWithTotalPrice: (double)cost cart:(NSMutableArray *)stuff parent:(ToOrderMenuViewController *)root{
    if (self = [super initWithNibName:@"CheckoutView" bundle:[NSBundle mainBundle]]){
		self.title = @"Checkout";
		totalPrice = cost;
		cart = stuff;
		parent = root;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelOrder)];
	self.navigationItem.leftBarButtonItem = cancelButton;

}

- (void) cancelOrder{
	[parent updateTotalPrice: totalPrice cart:cart];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return @"Cart";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
	return [NSString stringWithFormat:@"Total Price: %.2f", totalPrice];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cart count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
	NSDictionary *item = [cart objectAtIndex:indexPath.row];
	cell.textLabel.text = [item objectForKey:@"name"];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", [[item objectForKey:@"price"] doubleValue]];
	//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove the name from our array.
	//NSDictionary *item = [cart objectAtIndex:indexPath.row];
	[cart removeObjectAtIndex:indexPath.row];
	totalPrice = 0; 
	for(int i = 0; i < [cart count]; i++){
		totalPrice += [[[cart objectAtIndex:i] objectForKey:@"price"] doubleValue];
	}
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	[tableView reloadData];

}



-(IBAction) checkout: (id) sender{
	while([cart count] > 0) {
		[cart removeLastObject];
	}
	[parent updateTotalPrice: 0 cart:cart];
}




@end

