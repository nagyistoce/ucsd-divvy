//
//  DivvyKMeans.m
//  Divvy
//
//  Created by Joshua Lewis on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DivvyKMeans.h"

#import "DivvyAppDelegate.h"
#import "DivvyDataset.h"
#import "DivvyDatasetView.h"

#include "kmeans.h"


@implementation DivvyKMeans

@dynamic clustererID;
@dynamic name;

@dynamic k;
@dynamic numRestarts;
@dynamic initCentroidsFromPointsInDataset;

- (void) awakeFromInsert {
  [super awakeFromInsert];  
  
  self.clustererID = [[NSProcessInfo processInfo] globallyUniqueString];
}

- (void) awakeFromFetch {
  [super awakeFromFetch];
  
  [self addObserver:self forKeyPath:@"k" options:0 context:nil];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  DivvyAppDelegate *delegate = [NSApp delegate];
  
  [delegate.selectedDatasetView clustererChanged];
  [delegate reloadSelectedDatasetViewImage];
}

- (void) clusterDataset:(DivvyDataset *)dataset
             assignment:(NSData *)assignment {
  
  kmeans([dataset floatData], 
         [[dataset n] unsignedIntValue], 
         [[dataset d] unsignedIntValue], 
         [[self k] unsignedIntValue],
         (int *)[assignment bytes]);
}

@end
