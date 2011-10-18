//
//  Object.m
//  iNuxeo
//
//  Created by Stefane Fermigier on 12/8/09.
//  Copyright 2009 Nuxeo. All rights reserved.
//

#import "NXObject.h"

@implementation NXObject
@synthesize title, uid, url, properties;

- (id)initWithTitle:(NSString*)_title {
    self = [super init];
    if (self != nil) {
        self.title = _title;
        [_title release];
    }
    return self;
}

- (id)initWithEntry:(DDXMLElement *)entry {
    self = [super init];
    
    self.properties = [[NSMutableDictionary alloc] init];
    [self parse:entry];

    NSString *dcTitle = (NSString*)[self getProperty:@"dc:title"];
    if (dcTitle != nil) {
        self.title = dcTitle;
    } else {
        self.title = (NSString*)[self getProperty:@"cmis:name"];
    }
    return self;
}

- (NSObject *)getProperty:(NSString *)name {
    return [self.properties objectForKey:name];
}

- (void)parse:(DDXMLElement *)entry {
    NSLog(@"entry: %@", [entry XMLString]);
    DDXMLElement *object = [[entry elementsForName:@"object"] objectAtIndex:0] ;
    DDXMLElement *props = [[object elementsForName:@"properties"] objectAtIndex:0];

    for (DDXMLElement *prop in [props elementsForName:@"propertyId"]) {
        NSString *propName = [[prop attributeForName:@"propertyDefinitionId"] stringValue];
        NSArray *values = [prop elementsForName:@"value"];
        NSString *propValue = @"";
        if ([values count] > 0) {
            propValue = [[values objectAtIndex:0] stringValue];
        }
        NSLog(@"%@ = %@", propName, propValue);
        [self.properties setObject:propValue forKey:propName];        
    }
    for (DDXMLElement *prop in [props elementsForName:@"propertyString"]) {
        NSString *propName = [[prop attributeForName:@"propertyDefinitionId"] stringValue];
        NSArray *values = [prop elementsForName:@"value"];
        NSString *propValue = @"";
        if ([values count] > 0) {
            propValue = [[values objectAtIndex:0] stringValue];
        }
        NSLog(@"%@ = %@", propName, propValue);
        [self.properties setObject:propValue forKey:propName];        
    }
    for (DDXMLElement *prop in [props elementsForName:@"propertyDateTime"]) {
        NSString *propName = [[prop attributeForName:@"propertyDefinitionId"] stringValue];
        NSLog(@"propname: %@, value: %@", propName, [prop elementsForName:@"value"]);
        NSArray *values = [prop elementsForName:@"value"];
        if ([values count] == 0) {
            continue;
        }        
        NSString *dateString = [[values objectAtIndex:0] stringValue];
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *propValue = [dateFormatter dateFromString:dateString];
        NSLog(@"%@ = %@", propName, propValue);
        if (propValue != NULL) {
            [self.properties setObject:propValue forKey:propName];        
        }
    }
    for (DDXMLElement *prop in [props elementsForName:@"propertyInteger"]) {
        NSString *propName = [[prop attributeForName:@"propertyDefinitionId"] stringValue];
        NSLog(@"propname: %@, value: %@", propName, [prop elementsForName:@"value"]);

        if ([[prop elementsForName:@"value"] count] == 0) {
            [self.properties setObject:[NSNumber numberWithInt:0] forKey:propName];            
        } else {
            NSString *propValue = [[[prop elementsForName:@"value"] objectAtIndex:0] stringValue];
            NSLog(@"%@ = %@", propName, propValue);
            [self.properties setObject:[NSNumber numberWithInt:atoi([propValue UTF8String])] forKey:propName];
        }
    }
    NSLog(@"--------------------------------------------------------------------------------------");
}

- (BOOL)isFolder {
    return NO;
}

@end
