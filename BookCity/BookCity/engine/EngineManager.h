//
//  SearchEngineManage.h
//  BookCity
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMFramework.h"
#import "BookEngine.h"

@interface EngineManager : NSObject
AS_SINGLETON(EngineManager)


-(void)getSearchBookResult:(BMBaseParam*)baseParam;

-(void)getCategoryBooksResult:(BMBaseParam*)baseParam;

-(void)getBookChapterList:(BMBaseParam*)baseParam;

-(void)registerEngine:(BookEngine*)bookEngine;
@end
