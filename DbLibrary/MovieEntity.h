//
//  MovieEntity.h
//  FMDBxDemo
//
//  Created by LEMINHO on 4/19/18.
//  Copyright © 2018 LEMINHO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDBx.h"
@interface MovieEntity : FMXModel
@property FMXTableMap *tableMap;
@property NSNumber *id;
@property NSString *movieName;
-(id) initWithCreateDb:(BOOL) isCreate;
@end
