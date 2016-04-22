//
//  BookAction.m
//  BookCity
//
//  Created by 冯璇 on 16/1/2.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "BookAction.h"
#import "EngineManager.h"

@implementation BookAction

-(void)getSearchBookResult:(BMBaseParam*)baseParam {
    [self executeSelector:_cmd param:baseParam];
}

-(void)getCategoryBooksResult:(BMBaseParam*)baseParam {
    [self executeSelector:_cmd param:baseParam];
}

-(void)getBookChapterList:(BMBaseParam*)baseParam {
    [self executeSelector:_cmd param:baseParam];
}

-(void)getBookChapterDetail:(BMBaseParam*)baseParam {
    [self executeSelector:_cmd param:baseParam];
}

-(void)downloadplist:(BMBaseParam*)baseParam {
    [self executeSelector:_cmd param:baseParam];
}

-(void)executeSelector:(SEL)selector param:(BMBaseParam *)param {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [[EngineManager sharedInstance] performSelector:selector withObject:param];
#pragma clang diagnostic pop
}

@end
