//
//  DivvyDatasetViewPanel.m
//  Divvy
//
//  Created by Joshua Lewis on 6/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DivvyDatasetViewPanel.h"
#import "DivvyAppDelegate.h"
#import "DivvyDatasetView.h"
#import "DivvyClusterer.h"


@implementation DivvyDatasetViewPanel

@synthesize datasetVisualizerView;
@synthesize pointVisualizerView;
@synthesize clustererView;
@synthesize reducerView;

@synthesize datasetVisualizerPopUp;
@synthesize pointVisualizerPopUp;
@synthesize clustererPopUp;
@synthesize reducerPopUp;

@synthesize datasetVisualizerDisclosureButton;
@synthesize pointVisualizerDisclosureButton;
@synthesize clustererDisclosureButton;
@synthesize reducerDisclosureButton;

@synthesize datasetVisualizerArrayController;
@synthesize pointVisualizerArrayController;
@synthesize clustererArrayController;
@synthesize reducerArrayController;

@synthesize datasetVisualizerController;
@synthesize pointVisualizerController;
@synthesize clustererController;
@synthesize reducerController;

@synthesize selectViewTextField;

@synthesize datasetVisualizerViewControllers;
@synthesize pointVisualizerViewControllers;
@synthesize clustererViewControllers;
@synthesize reducerViewControllers;

- (void) windowWillLoad {
  DivvyAppDelegate *delegate = [NSApp delegate];
  NSArray *pluginTypes = delegate.pluginTypes;

  for(NSString *pluginType in pluginTypes) {
    NSMutableArray *pluginViewControllers = [[NSMutableArray alloc] init];
    [self setValue:pluginViewControllers forKey:[NSString stringWithFormat:@"%@ViewControllers", pluginType]];
    [pluginViewControllers release];
    
    for(NSEntityDescription *anEntityDescription in [[[NSApp delegate] managedObjectModel] entities])
      if([anEntityDescription.propertiesByName objectForKey:[NSString stringWithFormat:@"%@ID", pluginType]]) {        
        Class controller = NSClassFromString([NSString stringWithFormat:@"%@%@%@", @"Divvy", anEntityDescription.name, @"Controller"]);
        NSMutableArray *controllers = [self valueForKey:[NSString stringWithFormat:@"%@ViewControllers", pluginType]];
        
        id controllerInstance = [[controller alloc] init];
        [controllers addObject:controllerInstance];
        [controllerInstance release];
        
        [NSBundle loadNibNamed:[NSString stringWithFormat:@"%@%@", @"Divvy", anEntityDescription.name] owner:controllerInstance];
      }
  }
}

- (IBAction) clustererSelect:(id)sender {
  [self reflow];
  
  DivvyAppDelegate *delegate = [NSApp delegate];
  
  delegate.selectedDatasetView.selectedClusterer = clustererController.content;
  
  [delegate datasetVisualizerChanged]; // If the clustering changes, the dataset visualizer result needs to be updated
  [delegate reloadSelectedDatasetViewImage];
}

- (IBAction) reducerSelect:(id)sender {
  [self reflow];
  
  DivvyAppDelegate *delegate = [NSApp delegate];
  
  delegate.selectedDatasetView.selectedReducer = reducerController.content;
  
  [delegate datasetVisualizerChanged]; // If the reduction changes, the dataset visualizer result needs to be updated
  [delegate pointVisualizerChanged]; // Same for the point visualizer
  [delegate reloadSelectedDatasetViewImage];
}

- (void) reflow {
  DivvyAppDelegate *delegate = [NSApp delegate];
  NSArray *pluginTypes = delegate.pluginTypes;
  
  //DivvyDatasetView *selectedDatasetView = delegate.selectedDatasetView;
  //id <DivvyClusterer> selectedClusterer = selectedDatasetView.selectedClusterer;
  
  NSRect topFrame = [[self window] frame];
  
  float y = 0.f; // Go from the bottom up
  float popUpOffset = 13.f; // View borders from IB are 20px, we want 7px separation
  float disclosureButtonOffset = 7.f; // Centered disclosure buttons are 7px above their corresponding popups
  
  if(delegate.selectedDatasetView) {
  
    // Need to set topFrame height before positioning the subviews
    for(NSString *pluginType in pluginTypes) {
      NSArray *viewControllers = [self valueForKey:[NSString stringWithFormat:@"%@ViewControllers", pluginType]];
      NSArrayController *arrayController = [self valueForKey:[NSString stringWithFormat:@"%@ArrayController", pluginType]];
      NSObjectController *objectController = [self valueForKey:[NSString stringWithFormat:@"%@Controller", pluginType]];
      NSView *view = [self valueForKey:[NSString stringWithFormat:@"%@View", pluginType]];
      NSView *popup = [self valueForKey:[NSString stringWithFormat:@"%@PopUp", pluginType]];
      
      NSViewController *aController;
      
      aController = [viewControllers objectAtIndex:[arrayController.arrangedObjects indexOfObject:[objectController content]]];
      
      for(NSView *aView in view.subviews)
        if(aView != aController.view) // Pointer comparison should work, since there's only one instance of each ViewController
          [aView removeFromSuperview];
      
      NSRect subFrame = [[aController view] frame];
      NSRect popUpFrame = [popup frame];
      
      y += subFrame.size.height;
      y += popUpFrame.size.height - popUpOffset;
      
    }
   
    //y += 30.f; // Top border
  }
//  else {
//    y += 57.f; // Room for select view label
//  }

  y += 30.f; // Top border

  topFrame.origin.y += topFrame.size.height - y;
  topFrame.size.height = y;
  [self.window setFrame:topFrame display:YES animate:NO];
  
  y = 0.f; // Reset to position subviews
  
  if(delegate.selectedDatasetView) {
  
    for(NSString *pluginType in pluginTypes) {
      NSArray *viewControllers = [self valueForKey:[NSString stringWithFormat:@"%@ViewControllers", pluginType]];
      NSArrayController *arrayController = [self valueForKey:[NSString stringWithFormat:@"%@ArrayController", pluginType]];
      NSObjectController *objectController = [self valueForKey:[NSString stringWithFormat:@"%@Controller", pluginType]];
      NSView *view = [self valueForKey:[NSString stringWithFormat:@"%@View", pluginType]];
      NSView *popUp = [self valueForKey:[NSString stringWithFormat:@"%@PopUp", pluginType]];
      NSView *disclosureButton = [self valueForKey:[NSString stringWithFormat:@"%@DisclosureButton", pluginType]];
      
      NSViewController *aController;
      
      aController = [viewControllers objectAtIndex:[arrayController.arrangedObjects indexOfObject:[objectController content]]];
      
      NSRect frame = [view frame];
      NSRect subFrame = [[aController view] frame];
      NSRect popUpFrame = [popUp frame];
      NSRect disclosureButtonFrame = [disclosureButton frame];
      
      frame.origin.y = y;
      frame.size.height = subFrame.size.height;
      y += subFrame.size.height;
      
      popUpFrame.origin.y = y - popUpOffset;
      disclosureButtonFrame.origin.y = y - popUpOffset + disclosureButtonOffset;
      y += popUpFrame.size.height - popUpOffset;
      
      [view setFrame:frame];
      [popUp setFrame:popUpFrame];
      [disclosureButton setFrame:disclosureButtonFrame];
      
      if([view.subviews count] == 0) // Will happen only if we've changed views
        [view addSubview:[aController view]];
    }

    NSRect selectViewFrame = [selectViewTextField frame];
    selectViewFrame.origin.y = -50.f;
    [selectViewTextField setFrame:selectViewFrame];
  }
//  else {
//    NSRect selectViewFrame = [selectViewTextField frame];
//    selectViewFrame.origin.y = 20.f;
//    [selectViewTextField setFrame:selectViewFrame];    
//  }

}

- (void) dealloc {
  // Need to add a million releases here for the retained IBOutlets
  
  [self.datasetVisualizerViewControllers release];
  [self.pointVisualizerViewControllers release];
  [self.clustererViewControllers release];
  [self.reducerViewControllers release];
  
  [super dealloc];
}

@end
