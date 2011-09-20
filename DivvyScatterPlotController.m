//
//  DivvyScatterPlotController.m
//  Divvy
//
//  Created by Joshua Lewis on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DivvyScatterPlotController.h"
#import "DivvyAppDelegate.h"


@implementation DivvyScatterPlotController

-(IBAction) changeScatterPlot:(id)sender{
  DivvyAppDelegate *delegate = [NSApp delegate];
  [delegate datasetVisualizerChanged];
  [delegate reloadSelectedDatasetViewImage];}

@end
