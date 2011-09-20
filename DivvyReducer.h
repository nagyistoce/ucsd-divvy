//
//  DivvyReducer.h
//  Divvy
//
//  Created by Joshua Lewis on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DivvyDataset;

@protocol DivvyReducer

- (NSString *) reducerID;
- (NSString *) name;

- (NSNumber *) d;

- (void) calculateD:(DivvyDataset *)dataset;

- (void) reduceDataset:(DivvyDataset *)dataset
             reducedData:(NSData *)reducedData;

@end
