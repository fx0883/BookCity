//
//  DataManager.m
//  BookCity
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "DataManager.h"
#import "BookCityConfig.h"
#import "BookCategoryModel.h"

@implementation DataManager
DEF_SINGLETON(DataManager)


-(id)init
{
    self=[super init];
    if (self) {
        [self loadData];
    }
    return self;
}

-(void)loadData
{
    
    _bookCategory = [NSMutableArray new];
    
    BookCityConfig *bookCityConfig = [BookCityConfig sharedInstance];
    
    NSUInteger count = [bookCityConfig.bookCategory count];
    for (NSInteger i = 0; i < count; i++)
    {

//        NSLog (@"Key: %@ for value: %@", key, value);
        NSDictionary *dicItem = [bookCityConfig.bookCategory objectAtIndex:i];
        
        BookCategoryModel *bookcategorymodel = [BookCategoryModel new];
        bookcategorymodel.curIndex = 1;
        bookcategorymodel.name = dicItem[CATEGORYNAME];
        bookcategorymodel.strUrl = dicItem[URL];
        bookcategorymodel.categoryDescription = dicItem[DESCRIPTION];
//        bookcategorymodel.strUrl = ;
        
        
//#define DESCRIPTION @"description"
//#define ORDER @"order"
//#define CATEGORYNAME @"categoryname"
//#define URL @"url"
        
        [_bookCategory addObject:bookcategorymodel];

    }
    
    
}

@end
