//
//  DivvyPointVisualizer.h
//  Divvy
//
//  Created by Joshua Lewis on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DivvyDataset;

@protocol DivvyPointVisualizer <NSObject>

- (NSString *) pointVisualizerID;
- (NSString *) name;

- (void) drawImage:(NSImage *) image
       reducedData:(NSData *)reducedData
           dataset:(DivvyDataset *)dataset;

@end
