//
//  DivvyScatterPlotController.m
//  Divvy
//
//  Created by Joshua Lewis on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DivvyScatterPlotController.h"
#import "DivvyAppDelegate.h"
#import "DivvyDatasetView.h"


@implementation DivvyScatterPlotController

-(IBAction) changeScatterPlot:(id)sender{
  DivvyAppDelegate *delegate = [NSApp delegate];
  [delegate.selectedDatasetView  datasetVisualizerChanged];
  [delegate reloadSelectedDatasetViewImage];}

@end
