//
//  SearchEngineManage.m
//  BookCity
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "EngineManager.h"
#import "XiaoShuo7788Engine.h"

@interface EngineManager()
{
    NSMutableArray *_aryEngine;
}
@end


@implementation EngineManager

DEF_SINGLETON(EngineManager)

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
    if (_aryEngine == nil) {
        _aryEngine = [[NSMutableArray alloc]initWithCapacity:5];
        
        [self registerEngine: [XiaoShuo7788Engine new]];
    }
}

-(void)registerEngine:(BookEngine*)bookEngine
{
    
    if (_aryEngine != nil && ![_aryEngine containsObject:bookEngine])
    {
        [_aryEngine addObject:bookEngine];
    }
    
    
}

-(void)getSearchBookResult:(BMBaseParam*)baseParam
{
    if (_aryEngine == nil) {
        return;
    }
    for (BookEngine* bookengine in _aryEngine)
    {
        [bookengine getSearchBookResult:baseParam];
    }
}

@end
