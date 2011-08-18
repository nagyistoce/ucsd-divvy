//
//  DivvyAppDelegate.h
//  Divvy
//
//  Created by Joshua Lewis on 4/5/10.
//  Copyright 2010 UCSD. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DivvyDataset;
@class DivvyDatasetView;

@class DivvyDatasetViewPanel;
@class DivvyDatasetsPanel;
@class DivvyDatasetWindow;

@class DivvyPluginManager;

@protocol DivvyClusterer;
@protocol DivvyDatasetVisualizer;
@protocol DivvyPointVisualizer;

@interface DivvyAppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, retain) DivvyDatasetViewPanel *datasetViewPanelController;
@property (nonatomic, retain) DivvyDatasetsPanel *datasetsPanelController;
@property (nonatomic, retain) DivvyDatasetWindow *datasetWindowController;

@property (nonatomic, assign) DivvyDataset *selectedDataset;
@property (nonatomic, assign) DivvyDatasetView *selectedDatasetView;

@property (nonatomic, retain) NSArray *pluginTypes;
@property (nonatomic, retain) NSArray *pluginDefaults;

@property (nonatomic, retain) DivvyPluginManager *pluginManager;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:sender;
- (IBAction)openDatasets:sender;
- (IBAction)closeDatasets:sender;

- (NSArray *)defaultSortDescriptors;

- (void) reloadSelectedDatasetViewImage;

- (void) datasetVisualizerChanged;
- (void) pointVisualizerChanged;
- (void) clustererChanged;
- (void) reducerChanged;

@end