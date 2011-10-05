//
//  DivvyAppDelegate.m
//  Divvy
//
//  Created by Joshua Lewis on 4/5/10.
//  Copyright 2010 UCSD. All rights reserved.
//

#import "DivvyAppDelegate.h"

#import "DivvyDataset.h"
#import "DivvyDatasetView.h"

#import "DivvyDatasetVisualizer.h"
#import "DivvyPointVisualizer.h"
#import "DivvyClusterer.h"
#import "DivvyReducer.h"

#import "DivvyPluginManager.h"
#import "DivvyDelegateSettings.h"

#import "DivvyDatasetViewPanel.h"
#import "DivvyDatasetsPanel.h"
#import "DivvyDatasetWindow.h"

@implementation DivvyAppDelegate

@synthesize datasetViewPanelController;
@synthesize datasetsPanelController;
@synthesize datasetWindowController;

@synthesize selectedDataset;
@synthesize selectedDatasetView;

@synthesize selectedDatasets;

@synthesize pluginTypes;
@synthesize pluginDefaults;

@synthesize pluginManager;
@synthesize delegateSettings;

@synthesize persistentStoreCoordinator;
@synthesize managedObjectModel;
@synthesize managedObjectContext;

@synthesize processingImage;

- (void) reloadSelectedDatasetViewImage {
  [self.selectedDatasetView setProcessingImage];
  [self.datasetWindowController.datasetViewsBrowser reloadData];  
  
  NSInvocationOperation *invocationOperation = [[[NSInvocationOperation alloc] initWithTarget:self.selectedDatasetView
                                                                                     selector:@selector(checkForNullPluginResults)
                                                                                       object:nil] autorelease];
  
  // Reload the DatasetView image in main thread once processing is complete.
  [invocationOperation setCompletionBlock:^{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.datasetWindowController.datasetViewsBrowser reloadData];
    });
  }];
  
  
  [self.selectedDatasetView.operationQueue addOperation:invocationOperation];
}

- (NSArray *)defaultSortDescriptors {
  return [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
}

- (IBAction) openDatasets:(id)sender {
  int result;
  NSArray *fileTypes = [NSArray arrayWithObject:@"bin"];
  NSOpenPanel *oPanel = [NSOpenPanel openPanel];
  
  [oPanel setAllowsMultipleSelection:YES];
  [oPanel setAllowedFileTypes:fileTypes];
  result = [oPanel runModal];
  if (result == NSOKButton) {
    NSArray *filesToOpen = [oPanel URLs];
    int i, count = [filesToOpen count];
    for (i=0; i<count; i++) {
      NSString *aFile = [[filesToOpen objectAtIndex:i] path];
      [DivvyDataset datasetInDefaultContextWithFile:aFile];
    }
  }
}

- (IBAction) closeDatasets:(id)sender {
  NSArray *datasets = [self.datasetsPanelController.datasetsArrayController arrangedObjects];
  
  for (id dataset in [datasets objectsAtIndexes:self.selectedDatasets]) {
    for (id datasetView in [[dataset datasetViews] allObjects])
      [managedObjectContext deleteObject:datasetView];
    [managedObjectContext deleteObject:dataset];
  }
}

- (id)init
{
  if (!(self = [super init])) return nil;
  
  pluginTypes = [[NSArray alloc] initWithObjects:@"datasetVisualizer", @"pointVisualizer", @"clusterer", @"reducer", nil];
  pluginDefaults = [[NSArray alloc] initWithObjects:@"ScatterPlot", @"NilPointVisualizer", @"KMeans", @"NilReducer", nil];
  
  pluginManager = [DivvyPluginManager shared];
  
  return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  
  DivvyDatasetsPanel *datasetsPanel;
  datasetsPanel = [[DivvyDatasetsPanel alloc] initWithWindowNibName:@"DatasetsPanel"];
  [datasetsPanel showWindow:nil];  
  self.datasetsPanelController = datasetsPanel;
  [datasetsPanel release];

  DivvyDatasetWindow *datasetWindow;
  datasetWindow = [[DivvyDatasetWindow alloc] initWithWindowNibName:@"DatasetWindow"];
  [datasetWindow showWindow:nil];  
  self.datasetWindowController = datasetWindow;
  [datasetWindow release];  
  
  DivvyDatasetViewPanel *datasetViewPanel;
  datasetViewPanel = [[DivvyDatasetViewPanel alloc] initWithWindowNibName:@"DatasetViewPanel"];
  [datasetViewPanel showWindow:nil];  
  self.datasetViewPanelController = datasetViewPanel;
  [datasetViewPanel release];
  
  self.processingImage = [[[NSImage alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"waiting" withExtension:@"png"]] autorelease];
  
  // Connect to delegateSettings
  NSError *error = nil;
  NSEntityDescription *delegateSettingsEntityDescription = [self.managedObjectModel.entitiesByName objectForKey:@"DelegateSettings"];
  NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
  [request setEntity:delegateSettingsEntityDescription];
  NSArray *delegateSettingsArray = [self.managedObjectContext executeFetchRequest:request error:&error];
  
  if(delegateSettingsArray.count == 0)
    self.delegateSettings = [NSEntityDescription insertNewObjectForEntityForName:delegateSettingsEntityDescription.name inManagedObjectContext:self.managedObjectContext];
  else {
    self.delegateSettings = [delegateSettingsArray objectAtIndex:0];
  }
  
  [self addObserver:self forKeyPath:@"selectedDatasets" options:0 context:nil];
  [self addObserver:self forKeyPath:@"selectedDataset.selectedDatasetViews" options:0 context:nil];
  
  if(self.delegateSettings.selectedDatasets)
    self.selectedDatasets = self.delegateSettings.selectedDatasets;
}

// This stuff needs to be cleaned up, but it's an improvement over catching UI events
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if([keyPath isEqual:@"selectedDatasets"]) {
    DivvyDataset *newDataset;

    if(self.selectedDatasets.count == 0)
      self.selectedDataset = nil;
    else {
      NSArray *datasets = [self.datasetsPanelController.datasetsArrayController arrangedObjects];
      newDataset = [datasets objectAtIndex:[self.selectedDatasets lastIndex]];

      NSIndexSet *cachedIndexes = newDataset.selectedDatasetViews;
      
      // Don't update the selectedDatasetViews until after the ImageBrowser has nuked them and they've been restored
      [self removeObserver:self forKeyPath:@"selectedDataset.selectedDatasetViews"];
      self.selectedDataset = newDataset;
      [self addObserver:self forKeyPath:@"selectedDataset.selectedDatasetViews" options:0 context:nil];
      
      self.selectedDataset.selectedDatasetViews = cachedIndexes;
    }
  }
  
  if([keyPath isEqual:@"selectedDataset.selectedDatasetViews"]) {
    if(!self.selectedDataset || self.selectedDataset.selectedDatasetViews.count == 0)
        self.selectedDatasetView = nil;
    else {
      NSArray *datasetViews = [self.datasetWindowController.datasetViewsArrayController arrangedObjects];
      DivvyDatasetView *newDatasetView = [datasetViews objectAtIndex:[self.selectedDataset.selectedDatasetViews lastIndex]];

      // Fixes potential errors from uninitialized views when the bindings fire
      [newDatasetView willAccessValueForKey:nil];

      self.selectedDatasetView = newDatasetView;
    }
    [self.datasetViewPanelController reflow];
  }
}

/**
 Returns the support directory for the application, used to store the Core Data
 store file.  This code uses a directory named "Divvy" for
 the content, either in the NSApplicationSupportDirectory location or (if the
 former cannot be found), the system's temporary directory.
 */

- (NSString *)applicationSupportDirectory {
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
  NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
  return [basePath stringByAppendingPathComponent:@"Divvy"];
}


/**
 Creates, retains, and returns the managed object model for the application 
 by merging all of the models found in the application bundle.
 */

- (NSManagedObjectModel *)managedObjectModel {
  
  if (managedObjectModel) return managedObjectModel;
  
  NSMutableArray *models = [NSMutableArray array];
  [models addObject:[NSManagedObjectModel mergedModelFromBundles:nil]];
  [models addObjectsFromArray:[pluginManager pluginModels]];
  
  managedObjectModel = [[NSManagedObjectModel modelByMergingModels:models] retain];
  
  return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.  This 
 implementation will create and return a coordinator, having added the 
 store for the application to it.  (The directory for the store is created, 
 if necessary.)
 */

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
  
  if (persistentStoreCoordinator) return persistentStoreCoordinator;
  
  NSManagedObjectModel *mom = [self managedObjectModel];
  if (!mom) {
    NSAssert(NO, @"Managed object model is nil");
    NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
    return nil;
  }
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString *applicationSupportDirectory = [self applicationSupportDirectory];
  NSError *error = nil;
  
  if ( ![fileManager fileExistsAtPath:applicationSupportDirectory isDirectory:NULL] ) {
		if (![fileManager createDirectoryAtPath:applicationSupportDirectory withIntermediateDirectories:NO attributes:nil error:&error]) {
      NSAssert(NO, @"Failed to create App Support directory");
      NSLog(@"Error creating application support directory at %@ : %@",applicationSupportDirectory,error);
      return nil;
		}
  }
  
  NSMutableArray *configArray = [NSMutableArray array];
  [configArray addObject:@"DivvyCore"];
  
  for(Class aClass in [pluginManager pluginClasses])
    [configArray addObject:NSStringFromClass(aClass)];
  
  persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: mom];
  
  NSString *filePath;
  for (NSString *configName in configArray) {
    filePath = [configName stringByAppendingPathExtension:@"storedata"];
    filePath = [applicationSupportDirectory stringByAppendingPathComponent:filePath];

    NSURL *url = [NSURL fileURLWithPath:filePath];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSXMLStoreType 
                                                  configuration:configName 
                                                            URL:url 
                                                        options:nil 
                                                          error:&error]){
      [[NSApplication sharedApplication] presentError:error];
      [persistentStoreCoordinator release], persistentStoreCoordinator = nil;
      return nil;
    }
  }
  
  return persistentStoreCoordinator;
}

/**
 Returns the managed object context for the application (which is already
 bound to the persistent store coordinator for the application.) 
 */

- (NSManagedObjectContext *) managedObjectContext {
  
  if (managedObjectContext) return managedObjectContext;
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (!coordinator) {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
    [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
    NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    [[NSApplication sharedApplication] presentError:error];
    return nil;
  }
  managedObjectContext = [[NSManagedObjectContext alloc] init];
  [managedObjectContext setPersistentStoreCoordinator: coordinator];
  
  return managedObjectContext;
}

/**
 Returns the NSUndoManager for the application.  In this case, the manager
 returned is that of the managed object context for the application.
 */

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
  return [[self managedObjectContext] undoManager];
}


/**
 Performs the save action for the application, which is to send the save:
 message to the application's managed object context.  Any encountered errors
 are presented to the user.
 */

- (IBAction) saveAction:(id)sender {
  
  NSError *error = nil;
  
  if (![[self managedObjectContext] commitEditing]) {
    NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
  }
  
  if (![[self managedObjectContext] save:&error]) {
    [[NSApplication sharedApplication] presentError:error];
  }
}


/**
 Implementation of the applicationShouldTerminate: method, used here to
 handle the saving of changes in the application managed object context
 before the application terminates.
 */

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {    
  // Save the selected datasets.
  self.delegateSettings.selectedDatasets = self.selectedDatasets;
  
  // Stops a bunch of CoreGraphics errors from the binding between the dataset window
  // title and the selected dataset title. There's probably a better way to fix them though.  
  self.selectedDataset = nil;
  
  if (!managedObjectContext) return NSTerminateNow;
  
  if (![managedObjectContext commitEditing]) {
    NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
    return NSTerminateCancel;
  }
  
  if (![managedObjectContext hasChanges]) return NSTerminateNow;
  
  NSError *error = nil;
  if (![managedObjectContext save:&error]) {
    
    // This error handling simply presents error information in a panel with an 
    // "Ok" button, which does not include any attempt at error recovery (meaning, 
    // attempting to fix the error.)  As a result, this implementation will 
    // present the information to the user and then follow up with a panel asking 
    // if the user wishes to "Quit Anyway", without saving the changes.
    
    // Typically, this process should be altered to include application-specific 
    // recovery steps.  
    
    BOOL result = [sender presentError:error];
    if (result) return NSTerminateCancel;
    
    NSString *question = NSLocalizedString(@"Could not save changes while quitting.  Quit anyway?", @"Quit without saves error question message");
    NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
    NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
    NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:question];
    [alert setInformativeText:info];
    [alert addButtonWithTitle:quitButton];
    [alert addButtonWithTitle:cancelButton];
    
    NSInteger answer = [alert runModal];
    [alert release];
    alert = nil;
    
    if (answer == NSAlertAlternateReturn) return NSTerminateCancel;
    
  }
  
  return NSTerminateNow;
}


/**
 Implementation of dealloc, to release the retained variables.
 */

- (void)dealloc {
  [datasetsPanelController release];
  [datasetViewPanelController release];
  [datasetWindowController release];
  
  [pluginTypes release];
  [pluginDefaults release];

  [pluginManager release];
  [delegateSettings release];
  
  [selectedDatasets release];
  
  [managedObjectContext release];
  [persistentStoreCoordinator release];
  [managedObjectModel release];
  
  [processingImage release];
  
  [super dealloc];
}

@end
