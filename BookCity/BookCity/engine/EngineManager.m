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
#import "BCTBookAnalyzer.h"


typedef NS_ENUM(NSInteger, BCTBookEngineType) {
    kBCTBookEngine7788 = 100
    , kBCTBookEngineDuantian
    , kBCTBookEngineSiKuShu
    , kBCTBookEngineH23Wx
};

@interface EngineManager() {
    NSMutableDictionary *_dicEngine;
}
@property (nonatomic, strong) NSMutableDictionary *dicEnginePatterns;
@end


@implementation EngineManager

DEF_SINGLETON(EngineManager)

-(id)init {
    self=[super init];
    
    if (self) {
        [self loadData];
    }
    return self;
}

-(void)loadData {
    
    _dicEngine = [[NSMutableDictionary alloc]initWithCapacity:3];
    [_dicEngine setObject:[XiaoShuo7788Engine new] forKey:@(kBCTBookEngine7788).stringValue];
    [_dicEngine setObject:[SiKushuEngine new] forKey:@(kBCTBookEngineSiKuShu).stringValue];
    [_dicEngine setObject:[H23wxEngine new] forKey:@(kBCTBookEngineH23Wx).stringValue];
    
    _dicEnginePatterns = [NSMutableDictionary dictionary];
    [_dicEnginePatterns setObject:@"^http://www.7788xiaoshuo.com/" forKey:@(kBCTBookEngine7788).stringValue];
    [_dicEnginePatterns setObject:@"^http://www.duantian.com/" forKey:@(kBCTBookEngineDuantian).stringValue];
    [_dicEnginePatterns setObject:@"^http://www.sikushu.com/" forKey:@(kBCTBookEngineSiKuShu).stringValue];
    [_dicEnginePatterns setObject:@"^http://www.23wx.com/" forKey:@(kBCTBookEngineH23Wx).stringValue];
}


-(void)getSearchBookResult:(BMBaseParam*)baseParam {
    for (NSString *strKey in [_dicEngine allKeys]) {
        [_dicEngine[strKey] getSearchBookResult:baseParam];
         usleep(100);
    }
    
}

- (void)getCategoryBooksResult:(BMBaseParam*)baseParam {
    for (NSString *strUrl in baseParam.paramArray) {
        
        baseParam.paramString = strUrl;
        
        [self executeSelector:_cmd param:baseParam];
        
        usleep(100);
    }
}

- (void)getBookChapterList:(BMBaseParam*)baseParam {
    [self executeSelector:_cmd param:baseParam];
}

- (void)getBookChapterDetail:(BMBaseParam*)baseParam {
    [self executeSelector:_cmd param:baseParam];
}

- (void)downloadplist:(BMBaseParam*)baseParam {
    [self executeSelector:_cmd param:baseParam];
}

-(void)executeSelector:(SEL)selector param:(BMBaseParam *)param {
    [_dicEnginePatterns enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([BCTBookAnalyzer getStr:param.paramString pattern:obj].length > 0) {
            
            id<BCIBookEngine> engine = _dicEngine[key];
            if ([engine respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [engine performSelector:selector withObject:param];
#pragma clang diagnostic pop
                
            }
        }
    }];
}


@end
