//
//  BCTBookAnalyzer.m
//  BookCity
//
//  Created by apple on 16/1/4.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "BCTBookAnalyzer.h"

@implementation BCTBookAnalyzer

+ (NSString*)getStrGroup1:(NSString*)strSource
           pattern:(NSString*)strPattern
{
    NSString* strResult = @"";
    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:strPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matchs = [regular matchesInString:strSource options:0 range:NSMakeRange(0, strSource.length)];
    
    if ([matchs count]>0) {
  
        strResult = [strSource substringWithRange:[((NSTextCheckingResult*)[matchs objectAtIndex:0]) rangeAtIndex:1]];
    }
    return strResult;
}

+ (NSString*)replace:(NSString*)strSource
          aimSource:(NSString*)strAimSource
            pattern:(NSString*)strPattern
{
//    NSString* strResult = @"";
    
    NSError *error = nil;
    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:strPattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matchs = [regular matchesInString:strSource options:0 range:NSMakeRange(0, strSource.length)];
    NSMutableArray *retArray = [NSMutableArray new];
    for (NSTextCheckingResult *match in matchs) {
        NSString* substringForMatch = [strSource substringWithRange:match.range];
        [retArray addObject:substringForMatch];
//         = [strSource stringByReplacingOccurrencesOfString:substringForMatch withString:strAimSource];
    }
    
    for (NSString *strSub in retArray) {
        strSource = [strSource stringByReplacingOccurrencesOfString:strSub withString:strAimSource];
    }
    
    return strSource;
}


+ (NSString*)getStr:(NSString*)strSource
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

+ (NSArray*)getBookListBase:(NSString*)strSource
                   pattern:(NSString*)strPattern
{
    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:strPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regular matchesInString:strSource options:0 range:NSMakeRange(0, strSource.length)];
    return results;
}

+ (NSArray*)getBookListBaseStr:(NSString*)strSource
                      pattern:(NSString*)strPattern
{
    NSError *error = nil;
    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:strPattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matchs = [regular matchesInString:strSource options:0 range:NSMakeRange(0, strSource.length)];
    NSMutableArray *retArray = [NSMutableArray new];
    for (NSTextCheckingResult *match in matchs) {
        NSString* substringForMatch = [strSource substringWithRange:match.range];
        [retArray addObject:substringForMatch];

    }
    return retArray;
    
}

+ (NSString*)getChapterContentText:(NSString*)strSource
{
    //&nbsp;&nbsp;&nbsp;&nbsp;
    
    NSString *strContent = @"";
    strContent = [strSource stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    strContent = [strContent stringByReplacingOccurrencesOfString:@"&nbsp;&nbsp;" withString:@" "];
    strContent = [strContent stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    strContent = [strContent stringByReplacingOccurrencesOfString:@"</p>" withString:@"\r\n"];
    
    strContent = [self replace:strContent aimSource:@"\r\n" pattern:@"<br />[\\s]*?<br />"];
    strContent = [self replace:strContent aimSource:@"\r\n" pattern:@"<br/>[\\s]*?<br/>"];
    strContent = [strContent stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\r\n"];
    strContent = [strContent stringByReplacingOccurrencesOfString:@"<br />" withString:@"\r\n"];
    strContent = [strContent stringByReplacingOccurrencesOfString:@"\r\n\r\n" withString:@"\r\n"];
    return strContent;
    
}

@end
