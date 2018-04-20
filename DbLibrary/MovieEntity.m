//
//  MovieEntity.m
//  FMDBxDemo
//
//  Created by LEMINHO on 4/19/18.
//  Copyright © 2018 LEMINHO. All rights reserved.
//

#import "MovieEntity.h"

@implementation MovieEntity

+ (void)overrideTableMap:(FMXTableMap *)table {
    [table hasIntIncrementsColumn:@"id"];   // defines as a primary key.
    [table hasStringColumn:@"movieName"];
    [table setTableName:@"movieEntity"];
}
-(id) initWithCreateDb:(BOOL) isCreate{
    if(!(self = [super init]))
        return nil;
    if(isCreate)
        [self createTable];
    return self;
}
@end
