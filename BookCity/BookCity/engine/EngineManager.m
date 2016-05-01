//
//  SearchEngineManage.m
//  BookCity
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "EngineManager.h"
#import "XiaoShuo7788Engine.h"
#import "DuanTianEngine.h"
#import "SiKushuEngine.h"
#import "H23wxEngine.h"


#define E7788 @"7788"
#define EDUANTIAN @"DuanTian"
#define ESIKUSHU @"SiKuShu"
#define H23WX @"H23Wx"

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

-(void)loadData {
    if (_dicEngine == nil) {
        _dicEngine = [[NSMutableDictionary alloc]initWithCapacity:3];
        
        [self registerEngine:[XiaoShuo7788Engine new] key:E7788];
        [self registerEngine:[SiKushuEngine new] key:ESIKUSHU];
        [self registerEngine:[H23wxEngine new] key:H23WX];
    }
}

-(void)registerEngine:(id<BCIBookEngine>)bookEngine key:(NSString*)strKey {

    [_dicEngine setObject:bookEngine forKey:strKey];
}

-(void)registerEngine:(id<BCIBookEngine>)bookEngine {
    
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
         usleep(100);
    }
    
}

-(void)getCategoryBooksResult:(BMBaseParam*)baseParam
{
    
    for (NSString *strUrl in baseParam.paramArray) {
        //利用正则判断是哪个网站，
//        NSString* strResult = [self getStr:baseParam.paramString pattern:@"^http://www.7788xiaoshuo.com/"];
//        if (strResult.length > 0) {
//            [_dicEngine[@"7788"] getCategoryBooksResult:baseParam];
//        }
        baseParam.paramString = strUrl;
        
    
        if ([self getStr:baseParam.paramString pattern:@"^http://www.7788xiaoshuo.com/"].length > 0) {
            if ([_dicEngine objectForKey:E7788]) {
                [_dicEngine[E7788] getCategoryBooksResult:baseParam];
            }
            
        }
        else if([self getStr:baseParam.paramString pattern:@"^http://www.duantian.com/"].length>0)
        {
            if ([_dicEngine objectForKey:EDUANTIAN]) {
                [_dicEngine[EDUANTIAN] getCategoryBooksResult:baseParam];
            }

        }
        else if([self getStr:baseParam.paramString pattern:@"^http://www.sikushu.com/"].length>0)
        {
            if ([_dicEngine objectForKey:ESIKUSHU]) {
                [_dicEngine[ESIKUSHU] getCategoryBooksResult:baseParam];
            }
        }
        else if([self getStr:baseParam.paramString pattern:@"^http://www.23wx.com/"].length>0)
        {
            if ([_dicEngine objectForKey:H23WX]) {
                [_dicEngine[H23WX] getCategoryBooksResult:baseParam];
            }
        }
        usleep(100);
    }
    
//    //利用正则判断是哪个网站，
//    NSString* strResult = [self getStr:baseParam.paramString pattern:@"^http://www.7788xiaoshuo.com/"];
//    if (strResult.length > 0) {
//        [_dicEngine[@"7788"] getCategoryBooksResult:baseParam];
//    }
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

-(void)getBookChapterList:(BMBaseParam*)baseParam
{
    //利用正则判断是哪个网站，
    NSString* strResult = [self getStr:baseParam.paramString pattern:@"^http://www.7788xiaoshuo.com/"];
    if (strResult.length > 0) {
        [_dicEngine[E7788] getBookChapterList:baseParam];
    }
    else if([self getStr:baseParam.paramString pattern:@"^http://www.duantian.com/"].length>0)
    {
        [_dicEngine[EDUANTIAN] getBookChapterList:baseParam];
    }
    else if([self getStr:baseParam.paramString pattern:@"^http://www.sikushu.com/"].length>0)
    {
        [_dicEngine[ESIKUSHU] getBookChapterList:baseParam];
    }
    else if([self getStr:baseParam.paramString pattern:@"^http://www.23wx.com/"].length>0)
    {
        [_dicEngine[H23WX] getBookChapterList:baseParam];
    }
    
    //http://www.23wx.com/
    
}

-(void)getBookChapterDetail:(BMBaseParam*)baseParam
{
    //利用正则判断是哪个网站，
    NSString* strResult = [self getStr:baseParam.paramString pattern:@"^http://www.7788xiaoshuo.com/"];
    if (strResult.length > 0) {
        [_dicEngine[E7788] getBookChapterDetail:baseParam];
    }
    else if([self getStr:baseParam.paramString pattern:@"^http://www.duantian.com/"].length>0)
    {
        [_dicEngine[EDUANTIAN] getBookChapterDetail:baseParam];
    }
    else if([self getStr:baseParam.paramString pattern:@"^http://www.sikushu.com/"].length>0)
    {
        [_dicEngine[ESIKUSHU] getBookChapterDetail:baseParam];
    }
    
    else if([self getStr:baseParam.paramString pattern:@"^http://www.23wx.com/"].length>0)
    {
        [_dicEngine[H23WX] getBookChapterDetail:baseParam];
    }
}


-(void)downloadplist:(BMBaseParam*)baseParam
{
    //利用正则判断是哪个网站，
    NSString* strResult = [self getStr:baseParam.paramString pattern:@"^http://www.7788xiaoshuo.com/"];
    if (strResult.length > 0) {
        [_dicEngine[E7788] downloadplist:baseParam];
    }
    else if([self getStr:baseParam.paramString pattern:@"^http://www.duantian.com/"].length>0)
    {
        [_dicEngine[EDUANTIAN] downloadplist:baseParam];
    }
    else if([self getStr:baseParam.paramString pattern:@"^http://www.sikushu.com/"].length>0)
    {
        [_dicEngine[ESIKUSHU] downloadplist:baseParam];
    }
    else if([self getStr:baseParam.paramString pattern:@"^http://www.23wx.com/"].length>0)
    {
        [_dicEngine[H23WX] downloadplist:baseParam];
    }
}


@end
