//
//  WebMenuScanner.h
//  HungryEph1
//
//  Created by Aaron Taylor on 5/24/13.
//
//  This class extends the abstract NSOperation class, which encapsulates the code and data required
//  to scan the website for menus information.
//  By initializing the class asynchronously, it does the parsing in the background without locking up the UI
//
//  This class was abandoned in favor of the WebLinksFinder class and 

#import <Foundation/Foundation.h>

@interface WebMenuScanOperation : NSOperation

-(id) initWithURL:(NSURL *) url;
// accessor method to retreive menus
-(NSArray *) getMenu;

@end
