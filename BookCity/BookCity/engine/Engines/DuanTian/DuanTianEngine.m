//
//  DuanTianSearchEngine.m
//  BookCity
//
//  Created by apple on 16/1/4.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "DuanTianEngine.h"
#import "DuanTianSessionManager.h"
#import "BCTBookChapterModel.h"
#import "BCTBookModel.h"
#import "BCTBookAnalyzer.h"

@implementation DuanTianEngine

- (BCTSessionManager *)sessionManager {
    return [DuanTianSessionManager sharedClient];
}

-(void)getCategoryBooksResult:(BMBaseParam *)baseParam {
#warning Not implemented!
}

-(void)getBookChapterDetail:(BMBaseParam*)baseParam
{
    //paramString2 保存chapterDetail url
    NSString *strUrl = baseParam.paramString2;
    
    strUrl = [strUrl stringByReplacingOccurrencesOfString:[self.sessionManager getBaseUrl] withString:@""];
//    __weak BMBaseParam *weakBaseParam = baseParam;
    __weak DuanTianEngine *weakSelf = self;
    [[DuanTianSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];

//        NSLog(@"%@",responseStr);
        baseParam.resultString = [weakSelf getChapterContent:responseStr];
        
        BCTBookChapterModel* bookchaptermodel = (BCTBookChapterModel*)baseParam.paramObject;
        bookchaptermodel.content = [weakSelf getChapterContentText:baseParam.resultString];
        bookchaptermodel.htmlContent = baseParam.resultString;
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

-(NSString*)getChapterContent:(NSString*)strSource
{
    NSString *strContent = @"";
    NSString *strPattern = @"id=\"bookContent\">.*?</div>";
    strContent = [BCTBookAnalyzer getStr:strSource pattern:strPattern];
    
    strContent = [strContent stringByReplacingOccurrencesOfString:@"id=\"bookContent\">" withString:@""];
    strContent = [strContent stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
    
    
    strContent = [strContent stringByReplacingOccurrencesOfString:@"<script>document.write('<br />断天小说网 www.duantian.com 欢迎您，本站提供免费小说阅读和下载<br />手机访问3g.duantian.com流量最省，速度最快')</script>" withString:@""];
    

    
    return strContent;
}

-(NSString*)getChapterContentText:(NSString*)strSource
{
    NSString *strContent = @"";
    strContent = [strSource stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    strContent = [strContent stringByReplacingOccurrencesOfString:@"</p>" withString:@"\r\n"];
    strContent = [strContent stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\r\n"];
    return strContent;
}

-(void)getSearchBookResult:(BMBaseParam*)baseParam {
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
    
    strUrl = [strUrl stringByReplacingOccurrencesOfString:[self.sessionManager getBaseUrl] withString:@""];
    
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
        
        BCTBookChapterModel *bookchaptermodel = [BCTBookChapterModel new];
        NSString* substringForMatch = [strSource substringWithRange:match.range];
        NSLog(@"chapter list: %@",substringForMatch);
        //            [arrayOfURLs addObject:substringForMatch];
        NSString *patternChapterlink = @"href=\".*?\"\>";
        NSRegularExpression *regularChapterLink = [[NSRegularExpression alloc]initWithPattern:patternChapterlink options:NSRegularExpressionCaseInsensitive error:nil];
        
        
        NSTextCheckingResult *matchChapterLink = [regularChapterLink firstMatchInString:substringForMatch
                                                                                options:0
                                                                                  range:NSMakeRange(0, [substringForMatch length])];
        if (matchChapterLink) {
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
            NSString* strChapterTitle = [substringForMatch substringWithRange:matchChapterTitle.range];
            strChapterTitle = [strChapterTitle stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            strChapterTitle = [strChapterTitle stringByReplacingOccurrencesOfString:@">" withString:@""];
            strChapterTitle = [strChapterTitle stringByReplacingOccurrencesOfString:@"</a" withString:@""];
            NSLog(@"chapter title: %@",strChapterTitle);
            
            bookchaptermodel.title = strChapterTitle;
            
        }
        
        bookchaptermodel.hostUrl = [self.sessionManager getBaseUrl];
        
        [aryChapterList addObject:bookchaptermodel];
    }
    
    return aryChapterList;
}

@end
