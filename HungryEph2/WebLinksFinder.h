//
//  WebLinksFinder.h
//  HungryEph2
//
//  Created by Aaron Taylor on 6/10/13.
//  Copyright (c) 2013 Williams College. All rights reserved.
//
//this class serves to find all the links to menus on the dining services web page 

#import <Foundation/Foundation.h>

@interface WebLinksFinder : NSObject 

//root URL specified at initialization
@property (strong) NSURL * rootURL;
//Dictionary of associations between titles and their associated URL links
@property (atomic, copy) NSMutableDictionary * links;
//indicates whether the parsing process is completed
@property (nonatomic) BOOL isDone;
//holds that raw HTML data for the specified URL
@property (strong) NSData * pageData;

//factory method to initialize the class
+(id) webLinksFinderWithRootURL:(NSURL *)rootURL;
//this method initializes the class
-(id) initWithRootURL:(NSURL *) rootURL;
//this method downloads the HTML from the root page so that it doesn't have to be done by findLinksWithBaseURL later
-(void) downloadRoot;
//this method fills up the links Dictionary with all links on the rootURL page that are within the directory of BaseURL
-(void) findLinksWithBaseURL:(NSURL *) baseURL;
//this method calls findLinkswithBaseURL with the rootURL as a parameter
-(void) findLinksWithinRootURL;

@end
