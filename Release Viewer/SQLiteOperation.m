//
//  SQLiteOperation.m
//  Release Viewer
//
//  Created by Wang, Aaron on 24/04/2017.
//  Copyright © 2017 BHP Billiton. All rights reserved.
//

#import "SQLiteOperation.h"

@implementation SQLiteOperation

#pragma mark Get Database Ready
- (void)readyDatabase{
//    BOOL success;
 //   NSFileManager *fileManager = [NSFileManager defaultManager];
 //   NSError *error;
    

/*    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"releasedb"];

    
    success = [fileManager fileExistsAtPath:writableDBPath];
 */
    [self getPath];
/*
    if (success) return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"releasedb"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
*/    
}

- (void)getPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    path = [documentsDirectory stringByAppendingPathComponent:@"releasedbtest2"];
}

#pragma mark 查询数据库
/************
 sql：sql语句
 col：sql语句需要操作的表的所有字段数
 ***********/
- (NSMutableArray *)selectData:(NSString *)sql resultColumns:(int)col {
    [self readyDatabase];
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];//所有记录
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *statement = nil;
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableArray *row = [[NSMutableArray alloc] init];//一条记录
//                NSLog(@"=====%@",statement);
                for(int i=0; i<col; i++){
                    [row addObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]];
                }
                [returnArray addObject:row];;
            }//end while
        }else {
            NSLog(@"Error: failed to prepare [selectData]");
//            return NO;
        }//end if
        NSLog(@"returnArray：%@",returnArray);
        return returnArray;

//        sqlite3_finalize(statement);
    } else {
        sqlite3_close(database);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
    }//end if
    sqlite3_close(database);
    NSLog(@"%@", returnArray);
    return returnArray;
}

#pragma mark 增，删，改数据库
/************
 sql：sql语句
 param：sql语句中?对应的值组成的数组
 ***********/
- (BOOL)dealData:(NSString *)sql paramArray:(NSArray *)param {
    [self readyDatabase];
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        sqlite3_stmt *statement = nil;
        int success = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
        if (success != SQLITE_OK) {
            NSLog(@"Error: failed to prepare [dealData]");
            return NO;
        }
        //绑定参数
        /*
        NSInteger max = [param count];
        for (int i=0; i<max; i++) {
            NSString *temp = [param objectAtIndex:i];
            sqlite3_bind_text(statement, i+1, [temp UTF8String], -1, SQLITE_TRANSIENT);
        }
        success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if (success == SQLITE_ERROR) {
            NSLog(@"Error: failed to insert into the database");
            return NO;
        }
        */
        
        NSInteger numberOfSubArrays = [param count];
        
        for(int i=0; i<numberOfSubArrays; i++){
            NSArray *currentEntry = [param objectAtIndex:i];
            NSInteger numberOfColumns = [currentEntry count];
//            NSLog(@"Array:%ld", (long)i);
            
            for (int j=0; j<numberOfColumns; j++) {
                NSString *temp = [currentEntry objectAtIndex:j];
//                NSLog(@"element%d:%@", j,temp);
                sqlite3_bind_text(statement, j+1, [temp UTF8String], -1, SQLITE_TRANSIENT);
            }

            success = sqlite3_step(statement);
            int resetResult=sqlite3_reset(statement);
            NSLog(@"reset result: %d", resetResult);
            if (success == SQLITE_ERROR) {
                NSLog(@"Error: failed to insert into the database");
                return NO;
            }
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    NSLog(@"dealData success");
    return TRUE;
}

- (BOOL)createTable:(NSString *)sql{
    [self readyDatabase];
    char *error;
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        int success = sqlite3_exec(database, [sql UTF8String], NULL, NULL, &error);
        if ( success != SQLITE_OK) {
            NSLog(@"error: %s", error);
            sqlite3_free(error);
            return NO;
        }
    }
    sqlite3_close(database);
    NSLog(@"create table is ok.");
    return TRUE;
}


@end

