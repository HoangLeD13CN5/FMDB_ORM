//
//  FMXDatabaseManager.m
//  FMDBx
//
//  Copyright (c) 2014 KohkiMakimoto. All rights reserved.
//

#import "FMXDatabaseManager.h"
#import <objc/runtime.h>

static FMXDatabaseManager *sharedInstance = nil;

@interface FMXDatabaseManager()

@property (strong, nonatomic) NSMutableDictionary *tables;

@end

@implementation FMXDatabaseManager

/**
 *  Get a shared instance.
 *
 *  @return shared instance
 */
+ (FMXDatabaseManager *)sharedManager {
    @synchronized(self) {
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

/**
 *  Init.
 *
 *  @return initialized instance
 */
- (id)init {
    self = [super init];
    if (self) {
        self.tables = [[NSMutableDictionary alloc] init];
    }
    return self;
}

/**
 *  Register a database.
 *
 *  @param database     database name
 */
-(void)registerDatabaseWithName:(NSString *)database{
    // Register the configuration.
    self->databaseFileName = database;
    // get file path from databaseFileName
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    self->databasePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",
                                                                             self->databaseFileName]];
    [self createDatabase];
}

-(Boolean) createDatabase{
    Boolean isCreated = false;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:self->databasePath]){
        self->database = [FMDatabase databaseWithPath:self->databasePath];
        isCreated = true;
    }
    return isCreated;
}

-(Boolean) openDatabase{
    if(database == nil){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSLog(@"Path: %@",self->databasePath);
        if([fileManager fileExistsAtPath:self->databasePath]){
            self->database = [FMDatabase databaseWithPath:self->databasePath];
        }
    }
    if (database != nil) {
        if ([database open]) {
            return true;
        }
    }
    return false;
}

-(void) closeDataBase{
    if([database open]){
        [database close];
    }
}

/**
 *  Destroy database.
 */
- (void)destroyDatabase {
    NSFileManager *fm = [NSFileManager defaultManager];
    if (databasePath && [fm fileExistsAtPath:databasePath]) {
        [fm removeItemAtPath:databasePath error:nil];
    }
}

/**
 *  Get a database.
 *  @return FMDatabase object
 */
- (FMDatabase *)getDatabase {
    return database;
}

- (FMDatabase *)databaseForModel:(Class)modelClass {
    return [self getDatabase];
}

/**
 *  Get a table map
 *
 *  @param modelClass model class
 *
 *  @return table map object
 */

- (FMXTableMap *)tableForModel:(Class)modelClass {
    FMXTableMap *table = [self.tables objectForKey:NSStringFromClass(modelClass)];
    if (!table) {
        table = [[FMXTableMap alloc] init];
        table.database = databaseFileName;
        table.tableName = FMXDefaultTableNameFromModelName(NSStringFromClass(modelClass));
    
        /*
        TODO: Initializing table map at runtime.
         
        // initializing tablemap automatically from the properties.
        objc_property_t *properties;
        unsigned int count;
        int i;
        properties = class_copyPropertyList(modelClass, &count);
        for (i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
            NSString *columnName = FMXSnakeCaseFromCamelCase(propertyName);
            NSString *propertyType = nil;
        }
        */
        
        // Override by model.
        [modelClass performSelector:@selector(overrideTableMap:) withObject:table];
        
        // Cache the definition in the manager.
        [self.tables setObject:table forKey:NSStringFromClass(modelClass)];
    }
    return table;
}

/**
 *  Get a query
 *
 *  @param modelClass model class
 *
 *  @return query object
 */
- (FMXQuery *)queryForModel:(Class)modelClass {
    return [[FMXQuery alloc] initWithModelClass:modelClass];
}


-(void) createTable:(FMXTableMap*)table{
    NSDictionary *columns = table.columns;
    NSMutableString *query = [[NSMutableString alloc] init];
    [query appendFormat:@"create table %@ (", table.tableName];
    for (id key in [columns keyEnumerator]) {
        FMXColumnMap *column = [columns objectForKey:key];
        if([column.name isEqualToString:table.primaryKeyName]){
            if(!column.increments)
                [query appendFormat:@"%@ %@ primary key not null",column.name,[self convetFMXColumnType:column.type]];
            else
                [query appendFormat:@"%@ %@ primary key autoincrement not null",column.name,[self convetFMXColumnType:column.type]];
        }else {
            if(!column.increments)
                [query appendFormat:@"%@ %@ not null",column.name,[self convetFMXColumnType:column.type]];
            else
                [query appendFormat:@"%@ %@ autoincrement not null",column.name,[self convetFMXColumnType:column.type]];
        }
        [query appendFormat:@","];
    }
    NSRange range = NSMakeRange([query length]-1,1);
    [query replaceCharactersInRange:range withString:@""];
    [query appendFormat:@")"];
    NSLog(@"Query: %@",query);
    // create table
    if([self openDatabase]){
        [database executeUpdate:query];
        [self closeDataBase];
    }
}

- (NSString*) convetFMXColumnType:(int) type{
    switch (type) {
        case FMXColumnMapTypeInt:
            return @"integer";
        case FMXColumnMapTypeLong:
            return @"integer";
        case FMXColumnMapTypeLongLongInt:
            return @"integer";
        case FMXColumnMapTypeBool:
            return @"blob";
        case FMXColumnMapTypeDouble:
            return @"real";
        case FMXColumnMapTypeString:
           return @"text";
        default:
            return @"";
    }
}
@end
