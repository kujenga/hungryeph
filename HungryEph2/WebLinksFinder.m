//
//  WebLinksFinder.m
//  HungryEph2
//
//  Created by Aaron Taylor on 6/10/13.
//  Copyright (c) 2013 Williams College. All rights reserved.
//

#import "WebLinksFinder.h"
#import "TFHpple.h"

@interface WebLinksFinder()

@end

@implementation WebLinksFinder

+(id) webLinksFinderWithRootURL:(NSURL *)rootURL {
    return [[WebLinksFinder alloc] initWithRootURL:rootURL];
}

-(id) initWithRootURL:(NSURL *)rootURL {
    self = [super init];
    
    self.rootURL = rootURL;
    
    return self;
}

@synthesize links = _links;
@synthesize isDone = _isDone;

- (void) downloadRoot {
    self.pageData = [NSData dataWithContentsOfURL:self.rootURL];
}

- (void) findLinksWithinRootURL {
    [self findLinksWithBaseURL:self.rootURL];
}

//this method looks at all the links on the page and pulls out the ones that have the correct prefix, adding those to the dictionary.
- (void) findLinksWithBaseURL:(NSURL *)baseURL {
    if (!self.pageData) [self downloadRoot];
    
    //instantiates the hpple parser for HTML parsing
    TFHpple *parser = [TFHpple hppleWithHTMLData:self.pageData];
    
    //XPath query string indicating the position in the "tree" of the web page that the useful information will be found
    NSString *menuLinksXPathQueryString = @"//h3/a";
    NSArray *menuLinksNodes= [parser searchWithXPathQuery:menuLinksXPathQueryString];
    
    if (!_links) _links = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    for (TFHppleElement *element in menuLinksNodes) {
        //NSLog(@"Next Element in XPath: %@",element.attributes);
        
        if ([element.attributes objectForKey:@"href"] != nil){
            //NSLog(@"Next Element in XPath: %@\nwith link: %@",[[element firstChild] content], [element.attributes objectForKey:@"href"]);
            NSURL *url = [NSURL URLWithString:[element.attributes objectForKey:@"href"]];
            if (stringPrefixesString([baseURL absoluteString],[_rootURL absoluteString])) {
                [self.links setObject:url forKey:[[element firstChild] content]];
            }
        }
    }

    NSLog(@"links: %@",self.links);
}

//block syntax for determining if a string is the prefix of another string
//here intended to see if a url is a subdirectory of another
BOOL (^stringPrefixesString)(NSString*,NSString*) = ^(NSString* new, NSString* original){
    if ([new length] < [original length]) {
        return NO;
    }
    NSRange range = [original rangeOfString:new];
    if (range.location == NSNotFound || range.location != 0) {
        return NO;
    } else {
        return YES;
    }
};

@end
