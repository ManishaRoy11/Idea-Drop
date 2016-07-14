//
//  DDatabase.h
//  DDecor
//
//  Created by webwerks on 23/12/15.
//  Copyright © 2015 webwerks. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"

#define DatabasePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"IdeaDrop.sqlite"]
#define ImagePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


@interface DDatabase : NSObject

+(DDatabase *)sharedObject;
-(FMDatabase *)database;
-(FMDatabaseQueue *)getDBQueue;
-(void)datebaseInit;

-(NSMutableArray *)fetchAllList:(NSString *)ismatrix isUncatReq:(BOOL)value;

-(NSMutableArray *)fetchIdea:(NSInteger)ideaId withListId:(NSInteger)listId isCompletedNeeded:(BOOL)completedNeeded;

-(NSMutableArray *)fetchNotification;

-(BOOL)checkAlreadyEsistingRec:(NSString *)query;

-(BOOL)dbOperation:(NSString *)query;

@end
