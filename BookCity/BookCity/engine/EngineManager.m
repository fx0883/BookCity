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
    NSMutableDictionary *_dicEngine;
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
    if (_dicEngine == nil) {
        _dicEngine = [[NSMutableDictionary alloc]initWithCapacity:2];
        [self registerEngine:[XiaoShuo7788Engine new] key:@"7788"];
    }
    
//    if (_aryEngine == nil) {
//        _aryEngine = [[NSMutableArray alloc]initWithCapacity:5];
//        
//        [self registerEngine: [XiaoShuo7788Engine new]];
//    }
}

-(void)registerEngine:(BookEngine*)bookEngine
                  key:(NSString*)strKey
{
    
//    if (_aryEngine != nil && ![_aryEngine containsObject:bookEngine])
//    {
//        [_aryEngine addObject:bookEngine];
//    }
    if (_dicEngine == nil) {
        return;
    }
    if(_dicEngine[strKey] == nil)
    {
        [_dicEngine setObject:bookEngine forKey:strKey];
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
    if (_dicEngine == nil) {
        return;
    }
//    for (BookEngine* bookengine in _aryEngine)
//    {
//        [bookengine getSearchBookResult:baseParam];
//    }
    for (NSString *strKey in [_dicEngine allKeys]) {
        [_dicEngine[strKey] getSearchBookResult:baseParam];
    }
    
}

-(void)getCategoryBooksResult:(BMBaseParam*)baseParam
{
    //利用正则判断是哪个网站，
    NSString* strResult = [self getStr:baseParam.paramString pattern:@"^http://www.7788xiaoshuo.com/"];
    if (strResult.length > 0) {
        [_dicEngine[@"7788"] getCategoryBooksResult:baseParam];
    }
}

-(NSString*)getStr:(NSString*)strSource
           pattern:(NSString*)strPattern
{
    NSString* strResult = @"";
    NSRegularExpression *regularexpression1 = [[NSRegularExpression alloc]initWithPattern:strPattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    
    NSTextCheckingResult *match1 = [regularexpression1 firstMatchInString:strSource
                                                                  options:0
                                                                    range:NSMakeRange(0, [strSource length])];
    if (match1) {
        strResult = [strSource substringWithRange:match1.range];
    }
    return strResult;
}

@end
