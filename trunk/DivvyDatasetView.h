//
//  DivvyDatasetView.h
//  Divvy
//
//  Created by Joshua Lewis on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@class DivvyDataset;
@class DivvyDatasetVisualizer;
@class DivvyPointVisualizer;
@class DivvyClusterer;

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>


@interface DivvyDatasetView : NSManagedObject

@property (retain) NSString *uniqueID;
@property (retain) NSNumber *version;

@property (retain) DivvyDataset *dataset;
@property (retain) DivvyDatasetVisualizer *datasetVisualizer;
@property (retain) DivvyPointVisualizer *pointVisualizer;
@property (retain) DivvyClusterer *clusterer;
@property (retain) NSData *assignment;
@property (retain) NSData *reducedData;
@property (retain) NSData *exemplarList;

@property (readonly) NSImage *image;

+ (id) datasetViewInDefaultContextWithDataset:(DivvyDataset *)dataset 
                            datasetVisualizer:(DivvyDatasetVisualizer *)datasetVisualizer;

- (void) clustererChanged;

@end