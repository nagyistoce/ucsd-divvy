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

#import "DivvyDatasetsPanel.h"
#import "DivvyDatasetViewPanel.h"

#import "DivvyDatasetVisualizer.h"
#import "DivvyPointVisualizer.h"
#import "DivvyClusterer.h"

#import "DivvyAppDelegate.h"

@implementation DivvyDatasetWindow

@synthesize datasetViewsBrowser;
@synthesize datasetViewsArrayController;

@synthesize datasetsPanel;
@synthesize datasetViewPanel;

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

// Don't let our views completely obscure each other
- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(NSInteger)dividerIndex {
  CGFloat min = 150.f;
  
  return min;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(NSInteger)dividerIndex {
  CGFloat max = splitView.frame.size.height - 150.f;
  
  return max;
}

- (void) dealloc {
  [self.datasetViewsBrowser release];
  [self.datasetViewsArrayController release];
  
  [self.datasetsPanel release];
  [self.datasetViewPanel release];
  
  [super dealloc];
}

@end
