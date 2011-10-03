//
//  DivvyDatasetWindow.m
//  Divvy
//
//  Created by Joshua Lewis on 5/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DivvyDatasetWindow.h"

#import "DivvyAppDelegate.h"

#import "DivvyDataset.h"
#import "DivvyDatasetView.h"

#import "DivvyDatasetViewPanel.h"

#import "DivvyDatasetVisualizer.h"
#import "DivvyPointVisualizer.h"
#import "DivvyClusterer.h"

#import "DivvyAppDelegate.h"

@implementation DivvyDatasetWindow

@synthesize datasetViewsBrowser;
@synthesize datasetViewsArrayController;

- (void) loadWindow {
  [super loadWindow];
  
  NSSortDescriptor *dateCreatedDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:YES] autorelease];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:dateCreatedDescriptor, nil];
  
  [datasetViewsArrayController setSortDescriptors:sortDescriptors];
}

- (IBAction)editDatasetViews:(id)sender {
  DivvyAppDelegate *delegate = [NSApp delegate];
  
  NSInteger selectedSegment = [sender selectedSegment];
  NSInteger clickedSegmentTag = [[sender cell] tagForSegment:selectedSegment];

  if (clickedSegmentTag == 0) // Add button
    [DivvyDatasetView datasetViewInDefaultContextWithDataset:delegate.selectedDataset];
  else { // Remove button
    for (id datasetView in [self.datasetViewsArrayController selectedObjects])
      [delegate.managedObjectContext deleteObject:datasetView];
  }
}

- (void) dealloc {
  [self.datasetViewsBrowser release];
  [self.datasetViewsArrayController release];
  
  [super dealloc];
}

@end
