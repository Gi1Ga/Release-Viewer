//
//  SQLiteOperation.h
//  Release Viewer
//
//  Created by Wang, Aaron on 24/04/2017.
//  Copyright © 2017 BHP Billiton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SQLiteOperation : NSObject{
    sqlite3 *database;
    NSString *path;
}


-(void)readyDatabase;
-(void)getPath;
-(NSMutableArray *)selectData:(NSString *)sql resultColumns:(int)col;
-(BOOL)dealData:(NSString *)sql paramArray:(NSArray *)param;
-(BOOL)createTable:(NSString *)sql;

@end
