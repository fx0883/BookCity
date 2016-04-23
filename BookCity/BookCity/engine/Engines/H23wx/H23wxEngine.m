//
//  H23wxEngine.m
//  BookCity
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "H23wxEngine.h"
#import "So23wxSessionManager.h"
#import "H23wxSessionManager.h"

#import "BCTBookModel.h"
#import "BCTBookChapterModel.h"
#import "BCTBookAnalyzer.h"

@implementation H23wxEngine

- (BCTSessionManager *)sessionManager {
    return [So23wxSessionManager sharedClient];
}

-(void)getSearchBookResult:(BMBaseParam*)baseParam
{
    
    //    NSString *strSource = @"校花";
//    NSString *strSource = baseParam.paramString;
    NSString *strKeyWord = baseParam.paramString;
    
    if(baseParam.paramInt>0)
    {
        baseParam.paramInt--;
    }
    NSString *stringPage = [NSString stringWithFormat:@"%ld",(long)baseParam.paramInt];
    
    //NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_2312_80);
    
    
    
    
    NSDictionary *dict = @{@"q":strKeyWord,@"p":stringPage,@"s":@"15772447660171623812",@"nsid":@"",@"entry":@"1"};
    
//       NSString *strUrl = [NSString stringWithFormat:@"/modules/article/search.php?searchkey=%@&searchtype=articlename&submit=%@&page=%ld",strKeyWord,@"%CB%D1%CB%F7",(long)baseParam.paramInt];
    
    NSString *strUrl = @"/cse/search";
    
    //strUrl = @"/cse/search?q=校花&p=0&s=15772447660171623812&nsid=&entry=1";
    
    
    [[So23wxSessionManager sharedClient] GET:strUrl parameters:dict progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        //NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
        
        NSMutableArray *bookList = nil;
        
        //<tr>[\s\S]*?</tr>
        
        //        <h1 class="f20h">
        
//        if([self getStr:responseStr pattern:@"<h1 class=\"f20h\">"].length>0)
//        {
//            BookModel *oneBook = [self getBookModeSiKuShuForOne:responseStr];
//            bookList = [[NSMutableArray alloc]initWithCapacity:2];
//            [bookList addObject:oneBook];
//        }
//        else
//        {
//            NSArray *boollistSiKuShu = [self getBookListSiKuShu:responseStr];
//            
//            if ([boollistSiKuShu count]>0) {
//                bookList = [[NSMutableArray alloc]initWithArray:boollistSiKuShu];
//            }
//        }
        bookList = [[NSMutableArray alloc]initWithArray:[self getBookListH23wx:responseStr]];
        
        
        
        baseParam.resultArray = bookList;
        if (baseParam.withresultobjectblock) {
            baseParam.withresultobjectblock(0,@"",nil);
        }
        //
        //        NSLog(ary);
        //        NSLog(responseStr);
        //        NSLog(string);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error)
     {
         NSLog(@"%@",[error userInfo]);
         
         
     }];
}

-(NSArray*)getBookListH23wx:(NSString*)strSource
{
    NSString *strPattern = @"<div class=\"result-item result-game-item\">[\\s\\S]*?</p>\\s*?</div>";
    
    NSArray* arySource = [BCTBookAnalyzer getBookListBaseStr:strSource pattern:strPattern];
    NSMutableArray *bookList = [[NSMutableArray alloc]init];
    
    for (NSString* subStrSource in arySource) {
        BCTBookModel *book = [self getBookModeH23wx:subStrSource];
        [bookList addObject:book];
    }
    
    return bookList;
}

-(BCTBookModel*)getBookModeH23wx:(NSString*)strSource
{
    BCTBookModel *book = [BCTBookModel new];
    
    //    NSString *strPattern = @"\<a href=\"[^\"]*\"\\s*>([^<]*)\<\/a\>";
    
    book.title = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"<a cpos=\"title\" href=\"\[^\"]*\" title=\"([^\"]*)\""];
//    book.title = [book.title stringByReplacingOccurrencesOfString:@"<em>" withString:@""];
//    book.title = [book.title stringByReplacingOccurrencesOfString:@"</em>" withString:@""];
//    book.title = [book.title stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
//     book.title = [book.title stringByReplacingOccurrencesOfString:@" " withString:@""];
   // <img src=\"([^\"]*)\"
    book.imgSrc = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"\<img src=\"([^\"]*)\""];
    book.bookLink = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"<a cpos=\"img\" href=\"([^\"]*)\""];
    
    //    <td class=\"odd\">([^<]*)</td>
    book.author = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"<a cpos=\"author\"[^>]*>([^<]*)</a>"];
    book.author = [book.author stringByReplacingOccurrencesOfString:@" " withString:@""];
    book.author = [book.author stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    
    
    book.memo = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"<p class=\"result-game-item-desc\">[^.]*..([\\s\\S]*?)</p>"];
    book.memo = [book.memo stringByReplacingOccurrencesOfString:@"<em>" withString:@""];
    book.memo = [book.memo stringByReplacingOccurrencesOfString:@"</em>" withString:@""];
    //    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:strPattern options:NSRegularExpressionCaseInsensitive error:nil];
    //    NSArray *matchs = [regular matchesInString:strSource options:0 range:NSMakeRange(0, strSource.length)];
    //
    //    if ([matchs count]>0) {
    //
    //        NSTextCheckingResult *match = [matchs objectAtIndex:0];
    //
    //        book.bookLink = [strSource substringWithRange:[match rangeAtIndex:1]];
    //        book.title = [strSource substringWithRange:[match rangeAtIndex:2]];
    //    }
    
//    NSArray *aryBookNumber = [book.bookLink componentsSeparatedByString:@"/"];
//    
//    NSString *strBookNumber = [aryBookNumber objectAtIndex:[aryBookNumber count]-2];
//    
//    NSString *strBookNumberFront2 = [strBookNumber substringToIndex:2];
//    
//    
//    
//    book.imgSrc = [NSString stringWithFormat:@"http://www.sikushu.com/files/article/image/%@/%@/%@s.jpg",strBookNumberFront2,strBookNumber,strBookNumber];
    return book;
}


#pragma mark-  getBookChapterList

-(void)getBookChapterList:(BMBaseParam*)baseParam
{
    //NSString *strUrlParam = [NSString stringWithFormat:baseParam.paramString ,(long)baseParam.paramInt];
    
    NSString *strUrlParam = baseParam.paramString;
    
    NSString *strUrl = [strUrlParam stringByReplacingOccurrencesOfString:[self.sessionManager getBaseUrl] withString:@""];
    
    [[H23wxSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
        baseParam.resultArray = [self getChapterList:responseStr url:strUrlParam];
        
        
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
                             url:(NSString*)strUrl
{
    
    NSMutableArray *aryChapterList = [NSMutableArray new];
    
    NSString *pattern = @"<td class=\"L\"><a href=\"([^\"]*)\">([^<]*)</a>";
    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regular matchesInString:strSource options:0 range:NSMakeRange(0, strSource.length)];
    for (NSTextCheckingResult *match in results) {
        
        BCTBookChapterModel *bookchaptermodel = [BCTBookChapterModel new];
//        NSString* substringForMatch = [strSource substringWithRange:match.range];
//        NSLog(@"chapter list: %@",substringForMatch);
//        
//        NSString *strPatternListDetail = @"<a href=\"([^\"]*)\">([^<]*)</a>";
//        NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:strPatternListDetail options:NSRegularExpressionCaseInsensitive error:nil];
//        NSArray *matchs = [regular matchesInString:substringForMatch options:0 range:NSMakeRange(0, substringForMatch.length)];
//        
//        if ([matchs count]>0) {
//            
//            NSTextCheckingResult *match2 = [matchs objectAtIndex:0];
//            
//            
//            bookchaptermodel.url = [substringForMatch substringWithRange:[match2 rangeAtIndex:1]];
//            
//            
//            NSString* strChapterUrlBase = [strUrl stringByDeletingLastPathComponent];
//            bookchaptermodel.url = [NSString stringWithFormat:@"%@/%@",strChapterUrlBase,bookchaptermodel.url];
//            
//            bookchaptermodel.title = [substringForMatch substringWithRange:[match2 rangeAtIndex:2]];
//        }
        
        bookchaptermodel.url = [strSource substringWithRange:[match rangeAtIndex:1]];
//        NSString* strChapterUrlBase = [strUrl stringByDeletingLastPathComponent];
        bookchaptermodel.url = [NSString stringWithFormat:@"%@%@",strUrl,bookchaptermodel.url];
        bookchaptermodel.title = [strSource substringWithRange:[match rangeAtIndex:2]];
        bookchaptermodel.hostUrl = [self.sessionManager getBaseUrl];
        [aryChapterList addObject:bookchaptermodel];
    }
    
    
    
    
    return aryChapterList;
    
    
    
    
}


#pragma mark-  getBookChapterDetail

-(void)getBookChapterDetail:(BMBaseParam*)baseParam
{
    //paramString2 保存chapterDetail url
    NSString *strUrl = baseParam.paramString2;
    
    strUrl = [strUrl stringByReplacingOccurrencesOfString:[self.sessionManager getBaseUrl] withString:@""];
    //    __weak BMBaseParam *weakBaseParam = baseParam;
    __weak H23wxEngine *weakSelf = self;
    [[H23wxSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
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

-(NSString*)getChapterContent:(NSString*)strSource {
    NSString *strPattern = @"<dd id=\"contents\">([\\s\\S]*?)</dd>";
    NSString *strContent = [BCTBookAnalyzer getStrGroup1:strSource pattern:strPattern];

    return strContent ? : @"";
}

-(NSString*)getChapterContentText:(NSString*)strSource {
    NSString *strContent = [BCTBookAnalyzer getChapterContentText:strSource];
    return strContent ? : @"";
}

#pragma mark-  downloadplist

-(void)downloadplist:(BMBaseParam*)baseParam {
    BCTBookModel *bookmodel = (BCTBookModel*)baseParam.paramObject;
    
    if (bookmodel == nil || bookmodel.aryChapterList.count == 0 ) {
        
        if (baseParam.withresultobjectblock) {
            baseParam.withresultobjectblock(-1,@"数据没有准备好，不要下载",nil);
        }
        
    }
    
    // Start downloading book
    bookmodel.finishChapterNumber = 0;
    [self downloadChapterOnePage:baseParam book:bookmodel];
}

//-(void)downloadChapterOnePage:(BMBaseParam*)baseParam
//                         book:(BCTBookModel*)bookmodel {
//    NSInteger pageSize = 10;
//    NSInteger curPageEnd = bookmodel.finishChapterNumber + pageSize;
//    
//    __weak H23wxEngine *weakSelf = self;
//    NSInteger i = bookmodel.finishChapterNumber;
//    while (i < curPageEnd && i < [bookmodel.aryChapterList count]) {
//        
//        BCTBookChapterModel* bookchaptermodel = [bookmodel.aryChapterList objectAtIndex:i];
//        i++;
//        usleep(100);
//        
//        // Get chapter url
//        NSString *strUrl = bookchaptermodel.url;
//        strUrl = [strUrl stringByReplacingOccurrencesOfString:[H23wxSessionManager getBaseUrl] withString:@""];
//        
//        // Start downloading
//        [[H23wxSessionManager sharedClient] GET:strUrl parameters:nil progress:nil
//                                        success:^(NSURLSessionDataTask * __unused task, id responseObject) {
//            bookmodel.finishChapterNumber++;
//            
//            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
//            bookchaptermodel.htmlContent = [weakSelf getChapterContent:responseStr];
//            bookchaptermodel.content = [weakSelf getChapterContentText:bookchaptermodel.htmlContent];
//            
//            if (baseParam.withresultobjectblock) {
//                NSString* strStatus = @"";
//                if (bookmodel.finishChapterNumber == [bookmodel.aryChapterList count]) {
//                    strStatus = @"finished";
//                    
//                    [bookmodel savePlist];
//                }
//                else {
//                    strStatus = @"downloading";
//                    if(bookmodel.finishChapterNumber == curPageEnd) {
//                        [weakSelf downloadChapterOnePage:baseParam book:bookmodel];
//                    }
//                }
//                
//                baseParam.withresultobjectblock(0,strStatus,nil);
//            }
//            
//        } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
//            
//             bookmodel.finishChapterNumber++;
//             NSLog(@"%@",[error userInfo]);
//            
//             NSString* strStatus = @"";
//             if (bookmodel.finishChapterNumber == [bookmodel.aryChapterList count]) {
//                 strStatus = @"finished";
//                 [bookmodel savePlist];
//             }
//             else
//             {
//                 strStatus = @"downloading";
//                 if(bookmodel.finishChapterNumber == curPageEnd)
//                 {
//                     [weakSelf downloadChapterOnePage:baseParam book:bookmodel];
//                 }
//             }
//             baseParam.withresultobjectblock(-1,strStatus,nil);
//             
//         }];
//        
//        
//    }
//    
//}

#pragma mark-  getCategoryBooksResult

-(void)getCategoryBooksResult:(BMBaseParam*)baseParam
{
    NSString *strUrl = [NSString stringWithFormat:baseParam.paramString ,(long)baseParam.paramInt];
    
    strUrl = [strUrl stringByReplacingOccurrencesOfString:[self.sessionManager getBaseUrl] withString:@""];
    
    [[H23wxSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
        //NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
        
        
        
        NSMutableArray *bookList = nil;
        
        //7788小说网的小说
        //        NSArray *ary7788 = [self getBookList7788:responseStr];
        //        for (NSTextCheckingResult *match in ary7788) {
        //            NSString* substringForMatch = [responseStr substringWithRange:match.range];
        //            NSLog(@"Extracted URL: %@",substringForMatch);
        //            //            [arrayOfURLs addObject:substringForMatch];
        //            BookModel *bookModel = [self getBookModel7788:substringForMatch];
        //            [bookList addObject:bookModel];
        //
        //            NSLog(@"========================================");
        //            NSLog(@"%@",bookModel.title);
        //            NSLog(@"%@",bookModel.imgSrc);
        //            NSLog(@"%@",bookModel.bookLink);
        //            NSLog(@"%@",bookModel.memo);
        //        }
//        NSString *strListMain = [self getMainListContent:responseStr];
        
        bookList = [self getBookListFromCategoryH23w:responseStr];
        
        baseParam.resultArray = bookList;
        if (baseParam.withresultobjectblock) {
            baseParam.withresultobjectblock(0,@"",nil);
        }
        //
        //        NSLog(ary);
        //        NSLog(responseStr);
        //        NSLog(string);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error)
     {
         NSLog(@"%@",[error userInfo]);
         if (baseParam.withresultobjectblock) {
             baseParam.withresultobjectblock(-1,@"",nil);
         }
         
     }];
}

//-(NSString*)getMainListContent:(NSString*)strSource
//{
//    NSString *strRet = @"";
//    strRet = [self getStr:strSource pattern:@"<ul class=\"list_box1\">[\\S\\s]*?</ul>"];
//    
//    return strRet;
//}

-(NSMutableArray*)getBookListFromCategoryH23w:(NSString*)strSource
{
    NSMutableArray *retAry = [NSMutableArray new];
    
    NSString *strPattern = @"<tr bgcolor=\"#FFFFFF\">[\\s\\S]*?</tr>";
    NSArray *ary = [BCTBookAnalyzer getBookListBase:strSource pattern:strPattern];
    for (NSTextCheckingResult *match in ary) {
        NSString* substringForMatch = [strSource substringWithRange:match.range];
        NSLog(@"Extracted URL: %@",substringForMatch);
        //            [arrayOfURLs addObject:substringForMatch];
        //        BookModel *bookModel = [self getBookModel7788:substringForMatch];
        //        [bookList addObject:bookModel];
        //
        //        NSLog(@"========================================");
        //        NSLog(@"%@",bookModel.title);
        //        NSLog(@"%@",bookModel.imgSrc);
        //        NSLog(@"%@",bookModel.bookLink);
        //        NSLog(@"%@",bookModel.memo);
        
        BCTBookModel *bookModel = [self getBookModelFromCategory:substringForMatch];
        [retAry addObject:bookModel];
    }
    
    return retAry;
}

-(BCTBookModel*)getBookModelFromCategory:(NSString*)strSource
{
    BCTBookModel *bookmodel = [BCTBookModel new];

    bookmodel.bookLink = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"<a href=\"([^\"]*)\" target=\"_blank\">"];
    bookmodel.title = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"<a href=\"[^\"]*\">(.*?)</a>"];
    //bookmodel.memo = [self getStrGroup1:strSource pattern:@"<p>([\\S\\s]*?)</p>"];
    bookmodel.author = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"<td class=\"C\">(.*?)</td>[\\s\\S]*?<td class=\"R\">"];
    
    
//        bookmodel.imgSrc = [self getStrGroup1:strSource pattern:@"<img src=\"([^\"]*)\""];
    
    
    NSArray *aryBookNumber = [bookmodel.bookLink componentsSeparatedByString:@"/"];
    
    NSString *strBookNumber = [aryBookNumber objectAtIndex:[aryBookNumber count]-2];
    
    NSString *strBookNumberFront2 = [strBookNumber substringToIndex:2];
    
    //http://www.23wx.com/files/article/image/59/59945/59945s.jpg
    
    bookmodel.imgSrc = [NSString stringWithFormat:@"http://www.23wx.com/files/article/image/%@/%@/%@s.jpg",strBookNumberFront2,strBookNumber,strBookNumber];

    
    return bookmodel;
}



@end
