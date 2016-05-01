//
//  BCTBookAnalyzer.h
//  BookCity
//
//  Created by apple on 16/1/4.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMFramework.h"

@interface BCTBookAnalyzer : NSObject

+ (NSArray*)getBookListBase:(NSString*)strSource
                   pattern:(NSString*)strPattern;


+ (NSArray*)getBookListBaseStr:(NSString*)strSource
                   pattern:(NSString*)strPattern;



+ (NSString*)getStr:(NSString*)strSource
           pattern:(NSString*)strPattern;

+ (NSString*)getStrGroup1:(NSString*)strSource
                 pattern:(NSString*)strPattern;

+ (NSString*)replace:(NSString*)strSource
          aimSource:(NSString*)strAimSource
            pattern:(NSString*)strPattern;

+ (NSString*)getChapterContentText:(NSString*)strSource;
@end
