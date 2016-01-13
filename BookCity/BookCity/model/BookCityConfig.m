//
//  BookCityConfig.m
//  BookCity
//
//  Created by apple on 16/1/11.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "BookCityConfig.h"

@implementation BookCityConfig
DEF_SINGLETON(BookCityConfig)

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
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"bookCityConfig" ofType:@"plist"];
    _dicConfig = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    // colors
    _bookCategory = _dicConfig[@"BookCategory"];

}

@end
