# FMDB_ORM

An extension of FMDB to provide ORM and migration functionality for your iOS application.

Usage

Database Manager
ORM

Database Manager
Database Manager:FMXDatabaseManager class is a singleton instance that manages sqlite database files and FMDatabase instances connecting them. You can get it the following code.

FMXDatabaseManager *manager = [FMXDatabaseManager sharedManager];

Register a database
At first, you need to register a database that is used in your app to Database Manager.

[[FMXDatabaseManager sharedManager] registerDatabaseWithName:@"movieDatabase.sqlite"];

At the above example, you don't need to place database.sqlite file by hand. FMXDatabaseManager class automatically create initial empty movieDatabase.sqlite file in the NSDocumentDirectory if it doesn't exist.

Get a FMDatabase instance from a registered database

FMDatabase *db = [[FMXDatabaseManager sharedManager] getDatabase];
[db open];

// your code for databse operations

[db close];

ORM
Define a model class
You need to define model classes for each tables.Create Db in model.
For example ABCUser model have table as "user" when using function overrideTableMap. 
@interface ABCUser : FMXModel

@property (strong, nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *age;
@property (assign, nonatomic) BOOL isMale;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;
-(id) initWithCreateDb:(BOOL) isCreate;
@end

@implementation ABCUser

+ (void)overrideTableMap:(FMXTableMap *)table {

    [table hasIntIncrementsColumn:@"id"];   // defines as a primary key.
    [table hasStringColumn:@"name"];
    [table hasIntColumn:@"age"];
    [table hasBoolColumn:@"is_male"];
    [table hasDateColumn:@"created_at"];
    [table hasDateColumn:@"updated_at"];
    [table setTableName:@"user"];
}

-(id) initWithCreateDb:(BOOL) isCreate{
    if(!(self = [super init]))
        return nil;
    if(isCreate)
        [self createTable];
    return self;
}
@end
The model class needs primary key. So you need to define primary key configuration. Please see below example.

[table hasIntIncrementsColumn:@"id"];

// or

[table hasIntColumn:@"id" withPrimaryKey:YES];

If you want to change a mapped table name from a default, you can specify table name like the following.

@implementation ABCUser

- (void)defaultTableMap:(FMXTableMap *)table
{
    [table setTableName:@"custom_users"];
}

@end
Insert, update and delete
You can use a model class to insert, update and delete data.

ABCUser *user = [[ABCUser alloc] init];
user.name = @"Kohki Makimoto";
user.age = @(34);

// insert
[user save];

// update
user.age = @(44);
[user save];

// delete
[user delete];
Find by primary key
ABCUser *user = (ABCUser *)[ABCUser modelByPrimaryKey:@(1)];
NSLog(@"Hello %@", user.name);
Find by where conditions
You can get a model.

ABCUser *user = (ABCUser *)[ABCUser modelWhere:@"name = :name" parameters:@{@"name": @"Kohki Makimoto"}];
You can get multiple models.

NSArray *users = [ABCUser modelsWhere:@"age = :age" parameters:@{@"age": @34}];
for (ABCUser *user in users) {
    NSLog(@"Hello %@!", user.name);
}
Count records by where conditions
# Count all users.
NSInteger count = [ABCUser count];

# Count users whose name is 'Kohki Makimoto'.
NSInteger count = [ABCUser countWhere:@"name = :name" parameters:@{@"name": @"Kohki Makimoto"}];
