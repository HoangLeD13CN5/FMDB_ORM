//
//  ViewController.m
//  DbLibrary
//
//  Created by LEMINHO on 4/19/18.
//  Copyright © 2018 LEMINHO. All rights reserved.
//

#import "ViewController.h"
#import "MovieEntity.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MovieEntity *movie = [[MovieEntity alloc] initWithCreateDb:true];
    movie.movieName = @"King Of Subb";
    [movie save];
    MovieEntity *moviess = (MovieEntity *)[MovieEntity modelByPrimaryKey:@(1)];
    NSLog(@"Hello %@", moviess.movieName);
    NSArray *arr = [MovieEntity getAllModel];
    if(arr.count > 0){
        MovieEntity *mov = [arr objectAtIndex:0];
        NSLog(@"Hello %@", mov.movieName);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
