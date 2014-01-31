//
//  WebMenuScanner.m
//  HungryEph1
//
//  Created by Aaron Taylor on 5/24/13.
//
//

#import "WebMenuScanOperation.h"
#import "TFHpple.h"


@interface WebMenuScanOperation(){
    BOOL executing;
    BOOL finished;
}

@property (strong) NSURL * url;
@property (nonatomic) NSMutableArray *menu;

-(void)completeOperation;

@end

@implementation WebMenuScanOperation

@synthesize url = _url;

-(id) initWithURL:(NSURL *)url{
    if (self = [super init]) {
        _url = url;
        executing = NO;
        finished = NO;
    }
    return self;
}

-(void) start {
    // Checks for cancellation before launching the task.
    if ([self isCancelled])
    {
        // Must move the operation to the finished state if it is canceled.
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    // If the operation is not canceled, begin executing the task.
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

-(void) main {
    NSLog(@"In main Method");
    @try {
        [self loadMenu];
        
        [self completeOperation];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@  Thrown in WebMenuScanner %@ ",exception, self);
    }
}

//these methods allow acess to information about this NSOPeration, per the NSOperation guidelines
-(BOOL) isConcurrent { return YES; }

-(BOOL) isExecuting { return executing; }

-(BOOL) isFinished { return finished; }


//returns an array of the menu objects, parsed by 
-(void) loadMenu{
    executing = YES;
    
    NSData *htmlData = [NSData dataWithContentsOfURL:_url];
    
    TFHpple *parser = [TFHpple hppleWithHTMLData:htmlData encoding:@"NSUTF16StringEncoding"];
    
    NSString *menusXPathQuery = @"//div[@class='entry-content']/ul";
    //NSString *menusXPathQuery = @"//ul";
    NSArray *menuNodes= [parser searchWithXPathQuery:menusXPathQuery];
    
    //NSLog(@"menuNodes: %@",menuNodes);
    
    if (!_menu) _menu = [[NSMutableArray alloc] initWithCapacity:0];
    
    int index = 0;
    //this outer loop should only need run once
    for (TFHppleElement *element in menuNodes) {
        //NSLog(@"element: %@",element);
        for (TFHppleElement *child in element.children) {
            //NSLog(@"child: %@",child);
            if ([child.tagName isEqualToString:@"li"]){
                NSString *header = [[child firstChild] content];
                [_menu addObject:[[NSMutableArray alloc] initWithObjects:header, nil]];
                index++;
            } else if ([child.tagName isEqualToString:@"ul"]) {
                for (TFHppleElement *item in child.children) {
                    [[_menu objectAtIndex:index] addObject:[[item firstChild] content]];
                }
            }
        }
    }
    NSLog(@"final menu for %@:\n%@",self.url, _menu);
}

-(NSDictionary *)getMenu {
    if (!executing && finished && _menu)
        return [_menu copy];
    return nil;
}

- (void)completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

////returns just the XML data that contains the menu information. Tested on Whitman's wednesday websites
//-(NSString *) getMenuXMLforURL:(NSURL *) url{
//    //alternate encoding: NSUTF8StringEncoding
//    NSString *all = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
//    
//    NSScanner *scanner = [NSScanner scannerWithString:all];
//    [scanner setScanLocation:15000];
//    NSString *allMenu = @"";
//    bool isInMenu = false;
//    bool done = false;
//    while (!done && [scanner isAtEnd] == NO) {
//        if (!isInMenu) {
//            [scanner scanUpToString:@"<div class=\"entry-content\">" intoString:NULL];
//            isInMenu = true;
//        } else {
//            [scanner scanUpToString:@"</div>" intoString:&allMenu];
//            done = true;
//        }
//    }
//    NSString *result = [allMenu stringByAppendingString:@"  \n</div>"];
//    //NSLog(@"RESULT STRING:\n%@\n",result);
//    return result;
//}
//
//-(void) parseHTMLData:(NSData *) htmlData {
//    NSData *goodData = [self cleanHTMLText:htmlData];
//    
//    //NSLog(@"goodData: %@",[[NSString alloc] initWithData:goodData encoding:NSUTF8StringEncoding]);
//    //creates a new parser
//    parser = [[NSXMLParser alloc] initWithData:goodData];
//    [parser setDelegate:self];
//    [parser shouldResolveExternalEntities];
//    bool success = [parser parse];
//    if (success){
//        NSLog(@"Parsing was sucessful");
//    } else {
//        NSLog(@"Parsing UNSUCESSFUL!!!!!!!");
//    }
//}
//
////this method serves to clean up the HTML language to amke it suitable for input into the NSXMLParser
//-(NSData *)cleanHTMLText:(NSData *)data {
//    
//    NSString *htmlCode = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
//    NSMutableString *temp = [NSMutableString stringWithString:htmlCode];
//    
//    [temp replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
//    [temp replaceOccurrencesOfString:@"\n        " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
//    [temp replaceOccurrencesOfString:@"Ê" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
//    [temp replaceOccurrencesOfString:@"å" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
//    
//    NSData *finalData = [temp dataUsingEncoding:NSISOLatin1StringEncoding];
//    //[htmlCode release];
//    //[temp release];
//    return finalData;
//}
//
//
//#pragma mark Methods for the NSXMLParserDelegate
//
////this method is called when the XMLParser finds a starting object within the XML text
//-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
//
//    //NSLog(@"element name: %@\nattributeDict: %@",elementName,attributeDict);
//
//    //this pair of if statements uniquely identifies the section of the web page where the menus are located
//    if ([elementName isEqualToString:@"div"]){
//        NSString *obj = [attributeDict objectForKey:@"class"];
//        if (obj != nil && [obj isEqualToString:@"entry-content"]){
//            self.inMenu = true;
//            //creates the sections mutable array if it does not already exist
//            if (!sections){
//                sections = [[NSMutableArray alloc] initWithObjects:[NSMutableArray new], nil];
//            }
//        }
//    }
//    if (self.inMenu) {
//        if ([elementName isEqualToString:@"h4"]){
//            //is about to look at the header, i.e. "Lunch" or "Dinner"
//        }
//        if ([elementName isEqualToString:@"ul"]){
//            if (!section){
//                section = [NSMutableArray new];
//            }
//        }
//        if ([elementName isEqualToString:@"li"]){
//            //is about to look at an individual menu item
//        }
//    }
//}
//
////this method is called within two objects in the XML text
//-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
//    if (self.inMenu){
//        if (currentStringValue == nil) {
//            // currentStringValue is an NSMutableString instance variable
//            currentStringValue = [[NSMutableString alloc] initWithCapacity:50];
//        }
//        currentStringValue = [currentStringValue stringByAppendingString:string];
//    }
//}
//
////this method is called when the XMLParser sees an end object in the XML test
////it is here that the foundCharacters that have been collected since the start of the last element
////are put into the section array within sections if necessary, and the sections and sections arrays
////are handled properly
//-(void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
//    if (self.inMenu){
//        
//        if ([elementName isEqualToString:@"div"]) {
//            self.inMenu = false;
//        }
//        if ([elementName isEqualToString:@"h4"]) {
//            [[sections objectAtIndex:0] addObject:currentStringValue];
//        }
//        if ([elementName isEqualToString:@"li"]) {
//            [section addObject:currentStringValue];
//        }
//        if ([elementName isEqualToString:@"ul"]) {
//            [sections addObject:section];
//            //[section release];
//            section = nil;
//        }
//        //[currentStringValue release];
//        currentStringValue = nil;
//    }
//}
//
//-(void) parserDidEndDocument:(NSXMLParser *)parser{
//    //[self dealloc];
//}
//
//-(void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString{
//    return;
//}
//
//-(void) parser:(NSXMLParser *)theParser parseErrorOccurred:(NSError *)parseError {
//    NSLog(@"ERROR:%@  at line:%ld  and column: %ld",parseError,(long)theParser.lineNumber,(long)theParser.columnNumber);
//}

@end
