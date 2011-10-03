//
//  DivvyClusterer.h
//  Divvy
//
//  Created by Joshua Lewis on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DivvyDataset;

@protocol DivvyClusterer <NSObject>

- (NSString *) clustererID;
- (NSString *) name;

- (void) clusterDataset:(DivvyDataset *)dataset
             assignment:(NSData *)assignment;

@end
