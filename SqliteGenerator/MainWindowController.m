//
//  MainWindowController.m
//  SqliteGenerator
//
//  Created by  on 11-12-27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "MainWindowController.h"

@interface MainWindowController()

- (void)dumpDatabase:(NSString *)dbFile;

@end

@implementation MainWindowController

@synthesize tablesArray = _tablesArray;
@synthesize columnsArray = _columnsArray;
@synthesize tablesArrayController = _tablesArrayController;
@synthesize columnsArrayController = _columnsArrayController;
@synthesize filePathField = _filePathField;
@synthesize db = _db;

- (void)setDb:(FMDatabase *)db
{
    if (_db != db) {
        [_db close];
        [_db release];
        _db = [db retain];
    }
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        _tablesArray = [[NSMutableArray alloc] init];
        _columnsArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)awakeFromNib
{
	[self.tablesArrayController addObserver:self forKeyPath:@"selectionIndexes" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)chooseFileClicked:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setPrompt: @"OK"];
    [panel beginSheetForDirectory:nil file:nil
                            types:nil
                   modalForWindow:self.window
                    modalDelegate:self
                   didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:)
                      contextInfo:nil];
}

- (void)openPanelDidEnd:(NSOpenPanel *)sheet returnCode:(int)returnCode contextInfo:(void *)context
{
    if (returnCode == NSOKButton) {
        NSArray *fileNames = [sheet filenames];
        NSLog (@"db file: %@", [fileNames objectAtIndex: 0]);
        
        [self dumpDatabase:[fileNames objectAtIndex: 0]];
    }
    
} // openPanelDidEnd

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	NSLog(@"Table section changed: keyPath = %@, %@", keyPath, [object selectionIndexes]);
    if ([[object selectionIndexes] count] > 0) {
        NSUInteger index = [[object selectionIndexes] firstIndex];
        NSString *sql = [NSString stringWithFormat:@"pragma table_info(%@)", [self.tablesArray objectAtIndex:index]];
        FMResultSet *rs = [self.db executeQuery:sql];
        [self.columnsArray removeAllObjects];
        while ([rs next]) {
            NSString *name = [rs stringForColumn:@"name"];
            NSString *type = [rs stringForColumn:@"type"];
            [self.columnsArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:name, @"name", type, @"type", nil]];
        }
        [rs close];
        [self.columnsArrayController rearrangeObjects];
    }
}

- (void)dumpDatabase:(NSString *)dbFile
{
    FMDatabase *db = [FMDatabase databaseWithPath:dbFile];
    if (![db open]) {
        NSLog(@"Could not open db.");
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        NSAlert* alert = [NSAlert alertWithMessageText:@"非法的数据库文件！" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
        [alert runModal];
        [db close];
        return;
    }
    NSString *sql = @"select * from sqlite_master where type='table' and name!='sqlite_sequence'";
    FMResultSet *rs = [db executeQuery:sql];
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        NSAlert* alert = [NSAlert alertWithMessageText:@"非法的数据库文件！" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@""];
        [alert runModal];
        [db close];
        return;
    }
    self.db = db;
    [self.tablesArray removeAllObjects];
    while ([rs next]) {
        NSString *table = [rs stringForColumn:@"name"];
        [self.tablesArray addObject:table];
    }
    [rs close];
    [self.tablesArrayController rearrangeObjects];
}

- (IBAction)dumpClicked:(id)sender {
    [self dumpDatabase:self.filePathField.stringValue];
}

- (IBAction)generateClicked:(id)sender {
    
}

- (void)dealloc
{
    [_tablesArray release];
    [_columnsArray release];
    [_db close];
    [_db release];
    [super dealloc];
}

@end
