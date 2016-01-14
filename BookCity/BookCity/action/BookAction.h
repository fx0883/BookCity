//
//  BookAction.h
//  BookCity
//
//  Created by 冯璇 on 16/1/2.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMFramework.h"

@interface BookAction : NSObject

-(void)getSearchBookResult:(BMBaseParam*)baseParam;
-(void)getCategoryBooksResult:(BMBaseParam*)baseParam;
@end
