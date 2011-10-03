//
//  DivvyDataset.m
//
//  Written in 2011 by Joshua Lewis at the UC San Diego Natural Computation Lab,
//  PI Virginia de Sa, supported by NSF Award SES #0963071.
//  Copyright 2011, UC San Diego Natural Computation Lab. All rights reserved.
//  Licensed under the New BSD License.
//
//  Find the Divvy project on the web at http://divvy.ucsd.edu
//  
//  DivvyDataset manages the data and metadata associated with a single dataset.
//  It maintains a set of DivvyDatasetViews that represent alternative
//  visualizations, clusterings and embeddings of the dataset.

#import "DivvyDataset.h"

@implementation DivvyDataset 

@dynamic d;
@dynamic data;
@dynamic n;
@dynamic title;
@dynamic zoomValue;

@dynamic datasetViews;
@dynamic selectedDatasetViews;

+ (id) datasetInDefaultContextWithFile:(NSString *)path {
  NSManagedObjectContext *context = [[NSApp delegate] managedObjectContext];
  
  DivvyDataset *newItem;
  newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Dataset"
                                          inManagedObjectContext:context];
  
  newItem.title = [[path lastPathComponent] stringByDeletingPathExtension];
  
  newItem.data = [NSData dataWithContentsOfFile:path];
  
  newItem.selectedDatasetViews = [NSIndexSet indexSet];
  
  unsigned int n;
  unsigned int d;
  
  [newItem.data getBytes:&n range:NSMakeRange(0, 4)];
  [newItem.data getBytes:&d range:NSMakeRange(4, 4)];
  
  newItem.n = [NSNumber numberWithUnsignedInt:n];
  newItem.d = [NSNumber numberWithUnsignedInt:d];

  return newItem;
}

- (float *) floatData {
  return (float *)(self.data.bytes + 8); // Offset by 8 bytes to avoid header info
}

@end
