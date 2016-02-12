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

-(NSArray*)getBookListBase:(NSString*)strSource
                   pattern:(NSString*)strPattern;


-(NSArray*)getBookListBaseStr:(NSString*)strSource
                   pattern:(NSString*)strPattern;

-(void)getSearchBookResult:(BMBaseParam*)baseParam;
-(void)getCategoryBooksResult:(BMBaseParam*)baseParam;
-(void)getBookChapterList:(BMBaseParam*)baseParam;
-(void)getBookChapterDetail:(BMBaseParam*)baseParam;

-(void)downloadplist:(BMBaseParam*)baseParam;

-(NSString*)getStr:(NSString*)strSource
           pattern:(NSString*)strPattern;

-(NSString*)getStrGroup1:(NSString*)strSource
                 pattern:(NSString*)strPattern;

-(NSString*)replace:(NSString*)strSource
          aimSource:(NSString*)strAimSource
            pattern:(NSString*)strPattern;

-(NSString*)getChapterContentText:(NSString*)strSource;
@end
