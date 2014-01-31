//
//  AbstractMenuViewController.m
//  DiningApp
//  This is abstract and should not be instantiated top 3 initializer/methods must be overwritten
//
//  Created by Emily Yu on 4/12/11.
//  Modified by Aaron Taylor on 4/10/13
//  Copyright 2011 __Williams College__. All rights reserved.
//
//  need support for combo meals in this all-inclusive class
//  difficulty in the specificity of combo meals to each dining hall location

#import "ToOrderMenuViewController.h"
#import "CheckoutViewController.h"
#import "MealDealOptionsViewController.h"

@interface ToOrderMenuViewController(){
	double totalPrice;
	double limitPrice;
	NSArray *menu;
	NSMutableArray *cart;
	NSMutableArray *flexibleMenu;
	NSArray *list;
    NSArray *names;
   }

@property (strong) NSString *location;

-(void) recursiveSort: (int)lastIndex;

@end

@implementation ToOrderMenuViewController

-(id) initWithName:(NSString *)name andPoints: (BOOL)limit{
    self.location = [[name copy] substringToIndex:([name length]-5)];
    NSLog(@"%@",self.location);
    if (!(self = [super initWithNibName:@"toOrder" bundle:nil])) return nil;
    if(self = [super initWithStyle:UITableViewStylePlain]){
        
        NSString *arrayPath = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
        NSArray *data = [[NSArray alloc] initWithContentsOfFile:arrayPath];
        names = [[NSArray alloc] initWithArray:[data objectAtIndex:0]];
        if ([names count] != ([data count]-1)) {
            NSLog(@"the menu plist is improperly formatted. the number of sections does not match the number of section names");
        }
        
        flexibleMenu = [data mutableCopy];
        //removes the array of names from the menu array of arrays
        [flexibleMenu removeObjectAtIndex:0];
        menu = [flexibleMenu copy];
        cart = [NSMutableArray array];
        //Imposes a limit if the user is using points
		if(limit){
            limitPrice = 7;
		}
		else{
			limitPrice = 64000;
		}
        //NSLog(@"%@",flexibleMenu);
        //[flexibleMenu writeToFile:[[NSBundle mainBundle] pathForResource:@"WhitArrayOut" ofType:@"plist"] atomically:true];
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	UIBarButtonItem *checkoutButton = [[UIBarButtonItem alloc] initWithTitle:@"View Cart" style:UIBarButtonItemStyleDone target:self action:@selector(presentCheckout)];
	self.navigationItem.rightBarButtonItem = checkoutButton;
	totalPrice = 0;
	self.title = [NSString stringWithFormat:@"Total: $%.2F", totalPrice];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSArray *section = [flexibleMenu objectAtIndex:indexPath.section];
	NSDictionary *item = [section objectAtIndex:indexPath.row];

    //deal with combos for individual locations here, or simply adds the item to the cart
    if ([self.location isEqualToString:@"EcoCafe"]) {
        //eco cafe combo code
        
        if(![[item objectForKey:@"name"] isEqualToString:@"Breakfast Combo"]) {
            [self addToCartWithDictionary:item];
        } else {
            // else go through menu and find items for combos-- food section
            NSArray *newSection = [flexibleMenu objectAtIndex:2];
            for(int i = 0; i < [newSection count]; i++) {
                NSDictionary *newItem = [newSection objectAtIndex:i];
                NSString *itemName = [newItem objectForKey:@"name"];
                if([itemName isEqualToString:@"Bagel w/ Cream Cheese"]) {
                    [self addToCartWithDictionary:newItem];
                }
            }
            newSection = [flexibleMenu objectAtIndex:0];
            for(int i = 0; i < [newSection count]; i++) {
                NSDictionary *newItem = [newSection objectAtIndex:i];
                NSString *itemName = [newItem objectForKey:@"name"];
                if([itemName isEqualToString:@"Naked Juice"]) {
                    [self addToCartWithDictionary:newItem];
                }
            }
        }
    }
    else if ([self.location isEqualToString:@"Goodrich"]) {
        if(![[item objectForKey:@"combo"] boolValue]) {
            [self addToCartWithDictionary:item];
        } else {
            // go through menu and find items for combos-- food section
            NSString *comboName = [item objectForKey:@"name"];
            NSArray *newSection = [flexibleMenu objectAtIndex:2];
            for(int i = 0; i < [newSection count]; i++) {
                NSDictionary *newItem = [newSection objectAtIndex:i];
                NSString *itemName = [newItem objectForKey:@"name"];
                if([itemName isEqualToString: @"Bagel"]){
                    if(![comboName isEqualToString:@"On-the-Go"]) {
                        [self addToCartWithDictionary:newItem];
                    }
                }
                
                else if ([itemName isEqualToString:@"Cream Cheese"]) {
                    if([comboName isEqualToString:@"The Goodrich (w/ Latte)"] ||
                       [comboName isEqualToString:@"The Goodrich (w/ Chai)"] ||
                       [comboName isEqualToString:@"Quick & Easy"] ||
                       [comboName isEqualToString:@"CofFree"] ||
                       [comboName isEqualToString:@"The Usual"]) {
                        [self addToCartWithDictionary:newItem];
                    }
                }
                
                else if ([itemName isEqualToString:@"Peanut Butter"]){
                    if([comboName isEqualToString:@"Nutty Nantucket"]) {
                        [self addToCartWithDictionary:newItem];
                    }
                }
                
                else if( [itemName isEqualToString:@"Granola Bar"] ||
                        [itemName isEqualToString:@"Cereal w/ Milk"]) {
                    if([comboName isEqualToString:@"On-the-Go"]) {
                        [self addToCartWithDictionary:newItem];
                    }
                }
                
            }
            
            //find items for combos-- cold drinks section
            NSArray *nextSection = [flexibleMenu objectAtIndex:1];
            for(int j = 0; j < [nextSection count]; j++) {
                NSDictionary *coldDrinkItem = [nextSection objectAtIndex:j];
                NSString *drinkName = [coldDrinkItem objectForKey:@"name"];
                //[self addToCartWithDictionary:coldDrinkItem];
                if([drinkName isEqualToString:@"Odwalla Juice"]) {
                    if([comboName isEqualToString:@"Quick & Easy"] ||
                       [comboName isEqualToString:@"On-the-Go"]) {
                        [self addToCartWithDictionary:coldDrinkItem];
                    }
                }
                
                else if([drinkName isEqualToString:@"Nantucket Nectar"]) {
                    if([comboName isEqualToString:@"CofFree"] ||
                       [comboName isEqualToString:@"The Usual"] ||
                       [comboName isEqualToString:@"Nutty Nantucket"]) {
                        [self addToCartWithDictionary:coldDrinkItem];
                        if([comboName isEqualToString:@"Nutty Nantucket"]) {
                            [self addToCartWithDictionary:coldDrinkItem];
                        }
                    }
                }
            }
            
            //find items for combos-- hot drinks section
            NSArray *hotSection = [flexibleMenu objectAtIndex:0];
            for(int k = 0; k < [hotSection count]; k++) {
                NSMutableDictionary *hotDrinkItem = [hotSection objectAtIndex:k];
                NSString *hotDrinkName = [hotDrinkItem objectForKey:@"name"];
                if([hotDrinkName isEqualToString:@"Lg. Latte"]) {
                    if([comboName isEqualToString:@"The Goodrich (w/ Latte)"]) {
                        [self addToCartWithDictionary:hotDrinkItem];
                    }
                } 
                
                else if ([hotDrinkName isEqualToString:@"Sm. Coffee"]) {
                    if([comboName isEqualToString:@"The Usual"] ) {
                        [self addToCartWithDictionary:hotDrinkItem];
                    }
                }
                
                else if([hotDrinkName isEqualToString:@"Sm. Chai"]) {
                    if([comboName isEqualToString:@"The Goodrich (w/ Chai)"]) {
                        [self addToCartWithDictionary:hotDrinkItem];
                    }
                }
                
                else if([hotDrinkName isEqualToString:@"Sm. Tea"]) {
                    if([comboName isEqualToString:@"CofFree"]) {
                        [self addToCartWithDictionary:hotDrinkItem];
                    }
                }
                
            }
            
            
        }
    }
    else if ([self.location isEqualToString:@"LeeAfterDark"]) {
        NSDictionary *options = [item objectForKey:@"options"];
        NSString *notes = [item objectForKey:@"notes"];
        [self addToCartWithDictionary:item];
        if( options != nil ) {
            //creates and pushes a meal deal view controller
            MealDealOptionsViewController* mealDealController = [[MealDealOptionsViewController alloc] initWithItems:options andNotes:notes andSender:self];
            mealDealController.view.frame = [UIScreen mainScreen].applicationFrame;
            [self.navigationController pushViewController:mealDealController animated:YES];
        }
    } else {
        [self addToCartWithDictionary:item];
    }
    
    //this code separates the remaining menu items into two groups:
    //those still available and those that cannot be purchased and must be deleted from the menu
    NSArray *temp = [flexibleMenu copy];
	[flexibleMenu removeAllObjects];
	NSMutableArray *indices = [NSMutableArray array];
	int sectionNum = 0;
	for(NSArray *section in temp){
		int row = 0;
		NSMutableArray *newSection = [NSMutableArray array];
		for(NSDictionary *item in section){
			double cash = [[item objectForKey:@"price"] doubleValue];
			cash += totalPrice;
			if(cash <= limitPrice){
				[newSection addObject:item];
			}
			else{
				[indices addObject: [NSIndexPath indexPathForRow:row inSection:sectionNum]];
			}
			row++;
		}
		[flexibleMenu addObject:newSection];
		sectionNum++;
	}
	[self.tableView deleteRowsAtIndexPaths:indices withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark TableView data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [flexibleMenu count];
}


// Returns the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[flexibleMenu objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //uses the names array created in initWithPoints to return the name for the section
    return [names objectAtIndex:section];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //data that the cell will access
    NSArray *section = [flexibleMenu objectAtIndex:indexPath.section];
	
    NSDictionary *item = [section objectAtIndex:indexPath.row];
    
    //creates a different type of cell for regular menu items and combos or meal deals
    UITableViewCell *cell;
    if ( [item objectForKey:@"options"] != nil ) {
        //creates or reuses a cell for combos or meal deals
        static NSString *CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //NSLog(@"%@",[item objectForKey:@"notes"]);
        cell.detailTextLabel.text = [item objectForKey:@"notes"];
    } else {
        //creates a cell for a normal menu item
        static NSString *CellIdentifier = @"normalCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.detailTextLabel.text = [NSString stringWithFormat: @"%.2f",[[item objectForKey:@"price"] doubleValue]];
    }
	
	cell.textLabel.text = [item objectForKey:@"name"];
	cell.textLabel.minimumScaleFactor = 8;
	cell.textLabel.adjustsFontSizeToFitWidth = YES;
	
	// Configure the cell.
    
    return cell;
}


#pragma mark Cart and Checkout Methods

-(void) addToCartWithDictionary:(NSDictionary*) newItem {
    
    [cart addObject:newItem];
    
    totalPrice += [[newItem objectForKey:@"price"] doubleValue];
	[self recursiveSort:[cart count] - 1];
    
	self.title = [NSString stringWithFormat:@"Total: $%.2f", totalPrice];
}

-(void) presentCheckout{
    /*if ( self.navigationController.topViewController != self ) {
        [self.navigationController dismissViewControllerAnimated:NO completion:NULL];
        //[self presentViewController:self animated:NO completion:NULL];
    }*/
	CheckoutViewController *checkoutController = [[CheckoutViewController alloc]initWithTotalPrice:totalPrice cart:cart parent:self];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:checkoutController];
	[self presentViewController:navController animated:YES completion:NULL];
}

-(void) updateTotalPrice:(double)cost cart:(NSMutableArray *)stuff{
	totalPrice = cost;
	cart = stuff;
	[self dismissViewControllerAnimated:YES completion:NULL];
	self.title = [NSString stringWithFormat:@"Total: $%.2f", totalPrice];
	
	[flexibleMenu removeAllObjects];
	int sectionNum = 0;
	for(NSArray *section in menu){
		int row = 0;
		NSMutableArray *newSection = [NSMutableArray array];
		for(NSDictionary *item in section){
			double cash = [[item objectForKey:@"price"] doubleValue];
			cash += totalPrice;
			if(cash <= limitPrice)
				[newSection addObject:item];
			row++;
		}
		[flexibleMenu addObject:newSection];
		sectionNum++;
	}
	[self.tableView reloadData];
}

//this method sorts the cart by price of the items
-(void) recursiveSort: (int)lastIndex{
	if(lastIndex <= 0)
		return;
	int max = 0;
	for(int i = 1; i <lastIndex + 1; i++){
		NSDictionary *dict = [cart objectAtIndex:i];
		NSDictionary *maxDict = [cart objectAtIndex:max];
		if([self sortWith:maxDict and:dict] == NSOrderedAscending){
			max = i;
		}
	}
	NSDictionary *dict = [cart objectAtIndex:lastIndex];
	[cart replaceObjectAtIndex:lastIndex withObject:[cart objectAtIndex:max]];
	[cart replaceObjectAtIndex:max withObject:dict];
	[self recursiveSort:lastIndex - 1];
}
//helper method for the recursive sort, basically a comparator
- (NSComparisonResult) sortWith: (NSDictionary *)dict1 and:(NSDictionary *)dict2{
	NSString *name1 = [dict1 objectForKey:@"name"];
	NSString *name2 = [dict2 objectForKey:@"name"];
	return [name1 caseInsensitiveCompare:name2];
}





@end
