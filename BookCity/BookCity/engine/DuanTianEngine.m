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
#import "BookModel.h"

@implementation DuanTianEngine
-(void)downloadplist:(BMBaseParam*)baseParam
{
    BookModel *bookmodel = (BookModel*)baseParam.paramObject;

    if (bookmodel == nil || bookmodel.aryChapterList == nil || [bookmodel.aryChapterList count] == 0 ) {
        
        if (baseParam.withresultobjectblock) {
            baseParam.withresultobjectblock(-1,@"数据没有准备好，不要下载",nil);
        }
        
    }
    
    bookmodel.finishChapterNumber = 0;
    
    //一次请求过多会超时，必须控制请求数
    
//    for (NSInteger i = 0 ; i < [bookmodel.aryChapterList count]; i++) {
//        
//        BookChapterModel* bookchaptermodel = [bookmodel.aryChapterList objectAtIndex:i];
//        
//        usleep(100);
//        
//        NSString *strUrl = bookchaptermodel.url;
//        
//        strUrl = [strUrl stringByReplacingOccurrencesOfString:[DuanTianSessionManager getBaseUrl] withString:@""];
//        __weak DuanTianEngine *weakSelf = self;
//        [[DuanTianSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
//            
//            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
//            
//            NSLog(@"%@",responseStr);
//            bookchaptermodel.htmlContent = [weakSelf getChapterContent:responseStr];
//            bookchaptermodel.content = [weakSelf getChapterContentText:bookchaptermodel.htmlContent];
//            bookmodel.finishChapterNumber++;
//            if (baseParam.withresultobjectblock) {
//                NSString* strStatus = @"";
//                if (bookmodel.finishChapterNumber == [bookmodel.aryChapterList count]) {
//                    
//                    strStatus = @"finished";
//                    
//                    [bookmodel savePlist];
//                }
//                else
//                {
//                    strStatus = @"downloading";
//                }
//                baseParam.withresultobjectblock(0,strStatus,nil);
//            }
//            
//        } failure:^(NSURLSessionDataTask *__unused task, NSError *error)
//         {
//             NSLog(@"%@",[error userInfo]);
//             NSString* strStatus = @"";
//             if (bookmodel.finishChapterNumber == [bookmodel.aryChapterList count]) {
//                 strStatus = @"finished";
//                 [bookmodel savePlist];
//             }
//             else
//             {
//                 strStatus = @"downloading";
//                 
//             }
//             baseParam.withresultobjectblock(-1,strStatus,nil);
//             
//         }];
//        
//        
//    }
    
    [self downloadChapterOnePage:baseParam book:bookmodel];
    
}

-(void)downloadChapterOnePage:(BMBaseParam*)baseParam
                         book:(BookModel*)bookmodel
{
    NSInteger pageSize = 10;
    NSInteger curPageEnd = bookmodel.finishChapterNumber + pageSize;
    __weak DuanTianEngine *weakSelf = self;
    NSInteger i = bookmodel.finishChapterNumber;
    while (i < curPageEnd && i < [bookmodel.aryChapterList count])
    {
        
        BookChapterModel* bookchaptermodel = [bookmodel.aryChapterList objectAtIndex:i];
        i++;
        usleep(100);
        
        NSString *strUrl = bookchaptermodel.url;
        
        strUrl = [strUrl stringByReplacingOccurrencesOfString:[DuanTianSessionManager getBaseUrl] withString:@""];
        __weak DuanTianEngine *weakSelf = self;
        [[DuanTianSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
            
            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
            
            NSLog(@"%@",responseStr);
            bookchaptermodel.htmlContent = [weakSelf getChapterContent:responseStr];
            bookchaptermodel.content = [weakSelf getChapterContentText:bookchaptermodel.htmlContent];
            bookmodel.finishChapterNumber++;
            if (baseParam.withresultobjectblock) {
                NSString* strStatus = @"";
                if (bookmodel.finishChapterNumber == [bookmodel.aryChapterList count]) {
                    
                    strStatus = @"finished";
                    
                    [bookmodel savePlist];
                }
                else
                {
                    strStatus = @"downloading";
                    
                    if(bookmodel.finishChapterNumber == curPageEnd)
                    {
                        [weakSelf downloadChapterOnePage:baseParam book:bookmodel];
                    }
                }
                baseParam.withresultobjectblock(0,strStatus,nil);
            }
            
        } failure:^(NSURLSessionDataTask *__unused task, NSError *error)
         {
             NSLog(@"%@",[error userInfo]);
             NSString* strStatus = @"";
             if (bookmodel.finishChapterNumber == [bookmodel.aryChapterList count]) {
                 strStatus = @"finished";
                 [bookmodel savePlist];
             }
             else
             {
                 strStatus = @"downloading";
                 if(bookmodel.finishChapterNumber == curPageEnd)
                 {
                     [weakSelf downloadChapterOnePage:baseParam book:bookmodel];
                 }
             }
             baseParam.withresultobjectblock(-1,strStatus,nil);
             
         }];
        
        
    }

}



-(void)getBookChapterDetail:(BMBaseParam*)baseParam
{
    //paramString2 保存chapterDetail url
    NSString *strUrl = baseParam.paramString2;
    
    strUrl = [strUrl stringByReplacingOccurrencesOfString:[DuanTianSessionManager getBaseUrl] withString:@""];
//    __weak BMBaseParam *weakBaseParam = baseParam;
    __weak DuanTianEngine *weakSelf = self;
    [[DuanTianSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];

        NSLog(@"%@",responseStr);
        baseParam.resultString = [weakSelf getChapterContent:responseStr];
        
        BookChapterModel* bookchaptermodel = (BookChapterModel*)baseParam.paramObject;
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
    NSString *strPattern = @"id=\"bookContent\"\>.*?\<\/div\>";
    strContent = [self getStr:strSource pattern:strPattern];
    
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
        
        bookchaptermodel.hostUrl = [DuanTianSessionManager getBaseUrl];
        
        [aryChapterList addObject:bookchaptermodel];
    }
    
    
    
    
    return aryChapterList;
    
    
    
    
}





@end
