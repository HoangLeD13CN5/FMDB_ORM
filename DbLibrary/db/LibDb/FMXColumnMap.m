//
//  FMXColumnMap.m
//  FMDBx
//
//  Copyright (c) 2014 KohkiMakimoto. All rights reserved.
//

#import "FMXColumnMap.h"
#import "FMXHelpers.h"

@implementation FMXColumnMap

- (id)initWithName:(NSString *)name type:(FMXColumnMapType)type
{
    self = [super init];
    if (self) {
        self.name = name;
        self.type = type;
        self.increments = NO;
        self.foreign_key = NO;
        self.nameTableLink = @"";
        self.nameForeignKey = @"";
    }
    return self;
}

- (id)initWithName:(NSString *)name type:(FMXColumnMapType)type nameTableLink:(NSString*) nameTable nameForeignKey:(NSString*) nameForeignKey{
    self = [super init];
    if (self) {
        self.name = name;
        self.type = type;
        self.increments = NO;
        self.foreign_key = YES;
        self.nameTableLink = nameTable;
        self.nameForeignKey = nameForeignKey;
    }
    return self;
}
-(NSString *)propertyName
{
    return FMXLowerCamelCaseFromSnakeCase(self.name);
}

@end
