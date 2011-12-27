//
//  MainWindowController.h
//  SqliteGenerator
//
//  Created by  on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FMDatabase.h"

@interface MainWindowController : NSWindowController

@property (nonatomic, retain) NSMutableArray *tablesArray;
@property (nonatomic, retain) NSMutableArray *columnsArray;
@property (assign) IBOutlet NSArrayController *tablesArrayController;
@property (assign) IBOutlet NSArrayController *columnsArrayController;
@property (assign) IBOutlet NSTextField *filePathField;
@property (retain) FMDatabase *db;

- (IBAction)chooseFileClicked:(id)sender;
- (IBAction)dumpClicked:(id)sender;
- (IBAction)generateClicked:(id)sender;

@end
