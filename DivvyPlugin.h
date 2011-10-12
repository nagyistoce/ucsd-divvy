//
//  DivvyPlugin.h
//  Divvy
//
//  Created by Joshua Lewis on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol DivvyPlugin

- (NSString *) name;

@optional
- (NSString *) helpURL;

@end
