//
//  SearchEngine.h
//  BookCity
//
//  Created by apple on 16/1/4.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMFramework.h"

@interface BookEngine : NSObject


-(void)getSearchBookResult:(BMBaseParam*)baseParam;
-(void)getCategoryBooksResult:(BMBaseParam*)baseParam;
-(void)getBookChapterList:(BMBaseParam*)baseParam;
@end
