//
//  FMXDatabaseManager.h
//  FMDBx
//
//  Copyright (c) 2014 KohkiMakimoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMXTableMap.h"
#import "FMXModel.h"
#import "FMXHelpers.h"
#import "FMXQuery.h"
#import "FMDB.h"
@class FMXDatabaseMigration;
@class FMXDatabaseConfiguration;
@class FMXQuery;

@interface FMXDatabaseManager : NSObject{
    NSString *databaseFileName;
    NSString *databasePath;
    FMDatabase *database;
}

+ (FMXDatabaseManager *)sharedManager;

- (void)registerDatabaseWithName:(NSString *)database;

- (void)destroyDatabase;

- (FMDatabase *)getDatabase;

- (FMDatabase *)databaseForModel:(Class)modelClass;

- (FMXTableMap *)tableForModel:(Class)modelClass;

- (FMXQuery *)queryForModel:(Class)modelClass;

-(void) createTable:(FMXTableMap*)table;

-(Boolean) openDatabase;

-(void) closeDataBase;
@end
