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

-(void)getSearchBookResult:(BMBaseParam*)baseParam
{
    [[EngineManager sharedInstance]getSearchBookResult:baseParam];
}


-(void)getCategoryBooksResult:(BMBaseParam*)baseParam
{
    [[EngineManager sharedInstance]getCategoryBooksResult:baseParam];
}

-(void)getBookChapterList:(BMBaseParam*)baseParam
{
    [[EngineManager sharedInstance]getBookChapterList:baseParam];
}

-(void)getBookChapterDetail:(BMBaseParam*)baseParam
{
    [[EngineManager sharedInstance] getBookChapterDetail:baseParam];
}


-(void)downloadplist:(BMBaseParam*)baseParam
{
    [[EngineManager sharedInstance] downloadplist:baseParam];
}

@end
