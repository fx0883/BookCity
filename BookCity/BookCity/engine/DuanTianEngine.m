//
//  DuanTianSearchEngine.m
//  BookCity
//
//  Created by apple on 16/1/4.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "DuanTianEngine.h"
#import "DuanTianSessionManager.h"
#import "BookChapterModel.h"

@implementation DuanTianEngine

-(void)getSearchBookResult:(BMBaseParam*)baseParam
{
//    NSString *strUrl = [NSString stringWithFormat:baseParam.paramString ,(long)baseParam.paramInt];
//    
//    strUrl = [strUrl stringByReplacingOccurrencesOfString:[DuanTianSessionManager getBaseUrl] withString:@""];
//    
//    [[DuanTianSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
//        
//        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
//        
//        
//        
//        if (baseParam.withresultobjectblock) {
//            baseParam.withresultobjectblock(0,@"",nil);
//        }
//        
//    } failure:^(NSURLSessionDataTask *__unused task, NSError *error)
//     {
//         NSLog(@"%@",[error userInfo]);
//         if (baseParam.withresultobjectblock) {
//             baseParam.withresultobjectblock(-1,@"",nil);
//         }
//         
//     }];
}

-(void)getBookChapterList:(BMBaseParam*)baseParam
{
    NSString *strUrl = [NSString stringWithFormat:baseParam.paramString ,(long)baseParam.paramInt];
    
    strUrl = [strUrl stringByReplacingOccurrencesOfString:[DuanTianSessionManager getBaseUrl] withString:@""];
    
    [[DuanTianSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
        baseParam.resultArray = [self getChapterList:responseStr];
        
        
        if (baseParam.withresultobjectblock) {
            baseParam.withresultobjectblock(0,@"",nil);
        }
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error)
     {
         NSLog(@"%@",[error userInfo]);
         if (baseParam.withresultobjectblock) {
             baseParam.withresultobjectblock(-1,@"",nil);
         }
         
     }];
}


-(NSMutableArray*)getChapterList:(NSString*)strSource
{
    
    NSMutableArray *aryChapterList = [NSMutableArray new];
    
    NSString *pattern = @"\<td\>\<a href=\".*?\.html\"\>.*?\<\/a\>\<\/td\>";
    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regular matchesInString:strSource options:0 range:NSMakeRange(0, strSource.length)];
    for (NSTextCheckingResult *match in results) {
        
        BookChapterModel *bookchaptermodel = [BookChapterModel new];
        NSString* substringForMatch = [strSource substringWithRange:match.range];
        NSLog(@"chapter list: %@",substringForMatch);
        //            [arrayOfURLs addObject:substringForMatch];
        NSString *patternChapterlink = @"href=\".*?\"\>";
        NSRegularExpression *regularChapterLink = [[NSRegularExpression alloc]initWithPattern:patternChapterlink options:NSRegularExpressionCaseInsensitive error:nil];
        
        
        NSTextCheckingResult *matchChapterLink = [regularChapterLink firstMatchInString:substringForMatch
                                                                                options:0
                                                                                  range:NSMakeRange(0, [substringForMatch length])];
        if (matchChapterLink) {
            //            NSRange matchRange = [match2 range];
            //            NSRange firstHalfRange = [match2 rangeAtIndex:1];
            //            NSRange secondHalfRange = [match rangeAtIndex:2];
            NSString* strChapterLink = [substringForMatch substringWithRange:matchChapterLink.range];
            strChapterLink = [strChapterLink stringByReplacingOccurrencesOfString:@"href=\"" withString:@""];
            strChapterLink = [strChapterLink stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            strChapterLink = [strChapterLink stringByReplacingOccurrencesOfString:@">" withString:@""];
            NSLog(@"chapter list: %@",strChapterLink);
            

            bookchaptermodel.url = strChapterLink;
            
        }
        
        NSString *patternChapterTitle = @"\"\s?\>.*?\<\/a\>";
        NSRegularExpression *regularChapterTitle = [[NSRegularExpression alloc]initWithPattern:patternChapterTitle options:NSRegularExpressionCaseInsensitive error:nil];
        
        
        NSTextCheckingResult *matchChapterTitle = [regularChapterTitle firstMatchInString:substringForMatch
                                                                                  options:0
                                                                                    range:NSMakeRange(0, [substringForMatch length])];
        if (matchChapterTitle) {
            //            NSRange matchRange = [match2 range];
            //            NSRange firstHalfRange = [match2 rangeAtIndex:1];
            //            NSRange secondHalfRange = [match rangeAtIndex:2];
            NSString* strChapterTitle = [substringForMatch substringWithRange:matchChapterTitle.range];
            strChapterTitle = [strChapterTitle stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            strChapterTitle = [strChapterTitle stringByReplacingOccurrencesOfString:@">" withString:@""];
            strChapterTitle = [strChapterTitle stringByReplacingOccurrencesOfString:@"</a" withString:@""];
            NSLog(@"chapter title: %@",strChapterTitle);
            
            bookchaptermodel.title = strChapterTitle;
            
        }
        
        [aryChapterList addObject:bookchaptermodel];
    }
    
    
    
    
    return aryChapterList;
    
    
    
    
}

-(void)getChapterDetail:(NSString*)urlPath
{
//    [manage GET:urlPath parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
//        
//        NSLog(@"%@",responseStr);
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
}

@end
