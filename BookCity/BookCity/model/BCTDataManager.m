//
//  DataManager.m
//  BookCity
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "BCTDataManager.h"
#import "BCTBookCityConfig.h"
#import "BCTBookCategoryModel.h"

@implementation BCTDataManager
DEF_SINGLETON(BCTDataManager)


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
    _dicBooksCategoryAry = [NSMutableDictionary new];
    _bookCategory = [NSMutableArray new];

    
    BCTBookCityConfig *bookCityConfig = [BCTBookCityConfig sharedInstance];
    
    NSUInteger count = [bookCityConfig.bookCategory count];
    for (NSInteger i = 0; i < count; i++)
    {

//        NSLog (@"Key: %@ for value: %@", key, value);
        NSDictionary *dicItem = [bookCityConfig.bookCategory objectAtIndex:i];
        
        BCTBookCategoryModel *bookcategorymodel = [BCTBookCategoryModel new];
        bookcategorymodel.curIndex = 1;
        bookcategorymodel.name = dicItem[CATEGORYNAME];
        bookcategorymodel.strUrl = dicItem[URL];
        bookcategorymodel.categoryDescription = dicItem[DESCRIPTION];
        
        bookcategorymodel.aryUrl = [[NSMutableArray alloc]initWithArray:dicItem[URLARY]];
        
        [_bookCategory addObject:bookcategorymodel];

    }
    
    
}


-(NSMutableArray*)getBookArybyCategoryname:(NSString*)strCategoryname
{
    NSMutableArray* retArray = _dicBooksCategoryAry[strCategoryname];
    if (retArray == nil) {
        retArray = [NSMutableArray new];
        [_dicBooksCategoryAry setObject:retArray forKey:strCategoryname];
    }
    return retArray;
}

@end
