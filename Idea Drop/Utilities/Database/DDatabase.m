//
//  DDatabase.m
//  DDecor
//
//  Created by webwerks on 23/12/15.
//  Copyright © 2015 webwerks. All rights reserved.
//

#import "DDatabase.h"

@implementation DDatabase

static DDatabase* _sharedMySingleton = nil;

+(DDatabase *)sharedObject
{
    @synchronized([DDatabase class])
    {
        if (!_sharedMySingleton){
            _sharedMySingleton = [[self alloc] init];
        }
        return _sharedMySingleton;
    }
    
    return nil;
}

-(FMDatabase *)database{
    
    FMDatabase *db = [FMDatabase databaseWithPath:DatabasePath];
    db.shouldCacheStatements = YES;
    
    [db open];
    
    return db;
}

-(void)datebaseInit
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL success = [fileManager fileExistsAtPath:DatabasePath];
    NSLog(@"path :%@",DatabasePath);
    if(!success)
    {
        NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"IdeaDrop" ofType:@"sqlite"];
        NSLog(@"%@",dbPath);
        success = [fileManager copyItemAtPath:dbPath toPath:DatabasePath error:&error];
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    
}

+(NSString *)dbPathAddress
{
    return [self dbPath:[NSString stringWithFormat:@"%@.sqlite",@"IdeaDrop"]];
}

+(NSString *)dbPath:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *dbDocumentsPath =@"";
    dbDocumentsPath = [documentsDir stringByAppendingPathComponent:fileName];
    return dbDocumentsPath;
}

-(FMDatabaseQueue *)getDBQueue
{
    
    if(APP_DELEGATE.DBQueue == nil)
    {
        APP_DELEGATE.DBQueue = [FMDatabaseQueue databaseQueueWithPath:[DDatabase dbPathAddress]];
    }
    return  APP_DELEGATE.DBQueue;
}

#pragma mark - Select Operation


-(NSMutableArray *)fetchAllList:(NSString *)ismatrix isUncatReq:(BOOL)value{
    
    FMDatabaseQueue *queueObj = [Database getDBQueue];
    NSMutableArray *array = [NSMutableArray new];
    
    [queueObj inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *fmResultSetObj = [db executeQuery:@"select * from LIST_MASTER where IS_MATRIX = ?", ismatrix,nil];
        while ([fmResultSetObj next])        {
            NSMutableDictionary *dic = [NSMutableDictionary new];

            if ([ismatrix isEqualToString:@"0"] && ([fmResultSetObj intForColumn:LIST_ID] == UNCATEGORIZED_LIST_ID)) {
                
                if (value) {
                    NSString *query = [NSString stringWithFormat:@"select count(IDEA_ID) from idea_master where list_id=%d",UNCATEGORIZED_LIST_ID];
                    FMResultSet *fmResultSetObj1 = [db executeQuery:query];
                    int foundItem = 0;
                    while ([fmResultSetObj1 next])        {
                        foundItem = [fmResultSetObj1 intForColumnIndex:0];
                    }
                    [fmResultSetObj1 close];
                    if (foundItem>0) {
                        [dic setObject:[fmResultSetObj stringForColumn:LIST_ID] forKey:LIST_ID];
                        [dic setObject:[fmResultSetObj stringForColumn:LIST_NAME] forKey:LIST_NAME];
                        [dic setObject:[fmResultSetObj stringForColumn:IS_MATRIX] forKey:IS_MATRIX];
                        [array addObject:dic];
                    }
                }

            }else{
                [dic setObject:[fmResultSetObj stringForColumn:LIST_ID] forKey:LIST_ID];
                [dic setObject:[fmResultSetObj stringForColumn:LIST_NAME] forKey:LIST_NAME];
                [dic setObject:[fmResultSetObj stringForColumn:IS_MATRIX] forKey:IS_MATRIX];
                [array addObject:dic];
            }
            
        }
        [fmResultSetObj close];
    }];
    return array;
}

-(NSMutableArray *)fetchIdea:(NSInteger)ideaId withListId:(NSInteger)listId isCompletedNeeded:(BOOL)completedNeeded{
    
    FMDatabaseQueue *queueObj = [Database getDBQueue];
    NSMutableArray *array = [NSMutableArray new];
    
    [queueObj inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSString *query = @"";
        
        if (ideaId!=0) {
            query = [NSString stringWithFormat:@"select * from IDEA_MASTER where IDEA_ID = %ld",(long)ideaId];
            
        }else if (listId != 0){
            if (!completedNeeded || listId == CAPTURE_LIST_ID) {
                query = [NSString stringWithFormat:@"select * from IDEA_MASTER where list_id = %ld and IS_COMPLETED = 0",(long)listId];
            }else
                query = [NSString stringWithFormat:@"select * from IDEA_MASTER where list_id = %ld",(long)listId];
        }
        
        FMResultSet *fmResultSetObj = [db executeQuery:query];
        while ([fmResultSetObj next])        {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            [dic setObject:[COMMON_METHODS isStringNull:[fmResultSetObj stringForColumn:IDEA_ID]] forKey:IDEA_ID];
            [dic setObject:[COMMON_METHODS isStringNull:[fmResultSetObj stringForColumn:LIST_ID] ]forKey:LIST_ID];
            [dic setObject:[COMMON_METHODS isStringNull:[fmResultSetObj stringForColumn:IDEA_NAME] ]forKey:IDEA_NAME];
            [dic setObject:[fmResultSetObj dateForColumn:DUE_DATE] forKey:DUE_DATE];
            [dic setObject:[COMMON_METHODS isStringNull:[fmResultSetObj stringForColumn:DUE_TIME] ]forKey:DUE_TIME];
            [dic setObject:[COMMON_METHODS isStringNull:[fmResultSetObj stringForColumn:REMINDER] ]forKey:REMINDER];
            [dic setObject:[COMMON_METHODS isStringNull:[fmResultSetObj stringForColumn:REPEAT]] forKey:REPEAT];
            [dic setObject:[COMMON_METHODS isStringNull:[fmResultSetObj stringForColumn:IS_COMPLETED]] forKey:IS_COMPLETED];
            [array addObject:dic];
        }
        [fmResultSetObj close];
    }];
    return array;
}

-(NSMutableArray *)fetchNotification{
    
    FMDatabaseQueue *queueObj = [Database getDBQueue];
    NSMutableArray *array = [NSMutableArray new];
    
    [queueObj inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *fmResultSetObj = [db executeQuery:@"select * from FAVORITE_COLLECTION"];
        while ([fmResultSetObj next])        {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            [dic setObject:[fmResultSetObj stringForColumn:@"ID"] forKey:@"ID"];
            [dic setObject:[fmResultSetObj stringForColumn:@"NAME"] forKey:@"NAME"];
            [array addObject:dic];
        }
        [fmResultSetObj close];
    }];
    return array;
}

-(BOOL)checkAlreadyEsistingRec:(NSString *)query{
    FMDatabaseQueue *queueObj=[Database getDBQueue];
    __block BOOL response;
    [queueObj inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        FMResultSet *fmResultSetObj1 = [db executeQuery:query];
        int foundItem = 0;
        while ([fmResultSetObj1 next])        {
            foundItem = [fmResultSetObj1 intForColumnIndex:0];
        }
        [fmResultSetObj1 close];
        
        if (foundItem>0) {
            response = YES;
        }else
            response = false;
    }];
    return response;
}


-(BOOL)dbOperation:(NSString *)query{
    FMDatabaseQueue *queueObj=[Database getDBQueue];
    __block BOOL response;
    [queueObj inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        response =[db executeUpdate:query];
        if(!response)
        {
            NSLog(@"Record %@",[db lastError].localizedDescription);
        }
    }];
    return response;
}

//+(int)insertCollectionList:(NSInteger )listId andCollectionId:(NSString *)collectionId{
//    FMDatabaseQueue *queueObj=[[DDatabase sharedObject] getDBQueue];
//    __block int response ;
//    [queueObj inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        
//        NSString *str = [NSString stringWithFormat:@"select * from COLLECTION_LIST where COLLECTION_ID=%ld and LIST_ID=%ld", (long)[collectionId integerValue], (long)listId];
//        
//        FMResultSet *fmResultSetObj = [db executeQuery:str];
//        int foundItem = false;
//        while ([fmResultSetObj next])        {
//            foundItem = true;
//        }
//        [fmResultSetObj close];
//        
//        if (!foundItem) {
//            str = [NSString stringWithFormat:@"INSERT INTO COLLECTION_LIST (COLLECTION_ID, LIST_ID) values (%ld, %ld) ", (long)[collectionId integerValue], (long)listId];
//            response =[db executeUpdate:str];
//            if(!response)
//            {
//                NSLog(@"Record %@",[db lastError].localizedDescription);
//            }
//        }
//        else
//            response = 2;
//
//    }];
//    return response;
//}

@end