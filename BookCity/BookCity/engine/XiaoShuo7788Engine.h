//
//  XiaoShuo7788Engine.h
//  BookCity
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookEngine.h"

@interface XiaoShuo7788Engine : BookEngine

-(void)getSearchBookResult:(BMBaseParam*)baseParam;

-(void)getCategoryBooksResult:(BMBaseParam*)baseParam;

-(void)getBookChapterList:(BMBaseParam*)baseParam;
@end
