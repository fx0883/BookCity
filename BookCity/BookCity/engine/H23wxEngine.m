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
@implementation H23wxEngine


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
    
    NSArray* arySource = [self getBookListBaseStr:strSource pattern:strPattern];
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
    
    book.title = [self getStrGroup1:strSource pattern:@"<a cpos=\"title\" href=\"\[^\"]*\" title=\"([^\"]*)\""];
//    book.title = [book.title stringByReplacingOccurrencesOfString:@"<em>" withString:@""];
//    book.title = [book.title stringByReplacingOccurrencesOfString:@"</em>" withString:@""];
//    book.title = [book.title stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
//     book.title = [book.title stringByReplacingOccurrencesOfString:@" " withString:@""];
   // <img src=\"([^\"]*)\"
    book.imgSrc = [self getStrGroup1:strSource pattern:@"\<img src=\"([^\"]*)\""];
    book.bookLink = [self getStrGroup1:strSource pattern:@"<a cpos=\"img\" href=\"([^\"]*)\""];
    
    //    <td class=\"odd\">([^<]*)</td>
    book.author = [self getStrGroup1:strSource pattern:@"<a cpos=\"author\"[^>]*>([^<]*)</a>"];
    book.author = [book.author stringByReplacingOccurrencesOfString:@" " withString:@""];
    book.author = [book.author stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    
    
    book.memo = [self getStrGroup1:strSource pattern:@"<p class=\"result-game-item-desc\">[^.]*..([\\s\\S]*?)</p>"];
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
    
    NSString *strUrl = [strUrlParam stringByReplacingOccurrencesOfString:[H23wxSessionManager getBaseUrl] withString:@""];
    
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
        bookchaptermodel.hostUrl = [H23wxSessionManager getBaseUrl];
        [aryChapterList addObject:bookchaptermodel];
    }
    
    
    
    
    return aryChapterList;
    
    
    
    
}


#pragma mark-  getBookChapterDetail

-(void)getBookChapterDetail:(BMBaseParam*)baseParam
{
    //paramString2 保存chapterDetail url
    NSString *strUrl = baseParam.paramString2;
    
    strUrl = [strUrl stringByReplacingOccurrencesOfString:[H23wxSessionManager getBaseUrl] withString:@""];
    //    __weak BMBaseParam *weakBaseParam = baseParam;
    __weak H23wxEngine *weakSelf = self;
    [[H23wxSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
        
        NSLog(@"%@",responseStr);
        baseParam.resultString = [weakSelf getChapterContent:responseStr];
        
        // BookChapterModel* bookchaptermodel = (BookChapterModel*)baseParam.paramObject;
        //       ((BookChapterModel*)baseParam.paramObject).content = [weakSelf getChapterContentText:baseParam.resultString];
        
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
    NSString *strPattern = @"<dd id=\"contents\">([\\s\\S]*?)</dd>";
    strContent = [self getStrGroup1:strSource pattern:strPattern];
//    strContent = [strContent stringByReplacingOccurrencesOfString:@"(四库书www.sikushu.com)" withString:@""];
//    
//    NSString *strScriptPattern = @"\\[最快的更新.*?\\]";
//    NSString *strScript = [self getStr:strContent pattern:strScriptPattern];
    
//    
//    strContent = [strContent stringByReplacingOccurrencesOfString:strScript withString:@""];
    
    //
    //    strContent = [strContent stringByReplacingOccurrencesOfString:@"[最快的更新尽在四&amp;库*书*小说网<a href=\"http://www.SikUShu.com\" target=\"_blank\">www.SikUShu.com</a>]" withString:@""];
    
    
    
    
    return strContent;
}

-(NSString*)getChapterContentText:(NSString*)strSource
{
    //&nbsp;&nbsp;&nbsp;&nbsp;
    
//    NSString *strContent = @"";
//    strContent = [strSource stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
//    strContent = [strContent stringByReplacingOccurrencesOfString:@"&nbsp;&nbsp;" withString:@" "];
//    strContent = [strContent stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
//    strContent = [strContent stringByReplacingOccurrencesOfString:@"</p>" withString:@"\r\n"];
//    
//    strContent = [self replace:strContent aimSource:@"\r\n" pattern:@"<br />[\\s]*?<br />"];
//    strContent = [strContent stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\r\n"];
//    strContent = [strContent stringByReplacingOccurrencesOfString:@"<br />" withString:@"\r\n"];
//    strContent = [strContent stringByReplacingOccurrencesOfString:@"\r\n\r\n" withString:@"\r\n"];
//    return strContent;
    
    NSString *strContent = @"";
    strContent = [super getChapterContentText:strSource];
    return strContent;
    
}

#pragma mark-  downloadplist

-(void)downloadplist:(BMBaseParam*)baseParam
{
    BCTBookModel *bookmodel = (BCTBookModel*)baseParam.paramObject;
    
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
                         book:(BCTBookModel*)bookmodel
{
    NSInteger pageSize = 10;
    NSInteger curPageEnd = bookmodel.finishChapterNumber + pageSize;
    __weak H23wxEngine *weakSelf = self;
    NSInteger i = bookmodel.finishChapterNumber;
    while (i < curPageEnd && i < [bookmodel.aryChapterList count])
    {
        
        BCTBookChapterModel* bookchaptermodel = [bookmodel.aryChapterList objectAtIndex:i];
        i++;
        usleep(100);
        
        NSString *strUrl = bookchaptermodel.url;
        
        strUrl = [strUrl stringByReplacingOccurrencesOfString:[H23wxSessionManager getBaseUrl] withString:@""];
        //        __weak XiaoShuo7788Engine *weakSelf = self;
        [[H23wxSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
            
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
             bookmodel.finishChapterNumber++;
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

#pragma mark-  getCategoryBooksResult

-(void)getCategoryBooksResult:(BMBaseParam*)baseParam
{
    NSString *strUrl = [NSString stringWithFormat:baseParam.paramString ,(long)baseParam.paramInt];
    
    strUrl = [strUrl stringByReplacingOccurrencesOfString:[H23wxSessionManager getBaseUrl] withString:@""];
    
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
    NSArray *ary = [self getBookListBase:strSource pattern:strPattern];
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

    bookmodel.bookLink = [self getStrGroup1:strSource pattern:@"<a href=\"([^\"]*)\" target=\"_blank\">"];
    bookmodel.title = [self getStrGroup1:strSource pattern:@"<a href=\"[^\"]*\">(.*?)</a>"];
    //bookmodel.memo = [self getStrGroup1:strSource pattern:@"<p>([\\S\\s]*?)</p>"];
    bookmodel.author = [self getStrGroup1:strSource pattern:@"<td class=\"C\">(.*?)</td>[\\s\\S]*?<td class=\"R\">"];
    
    
//        bookmodel.imgSrc = [self getStrGroup1:strSource pattern:@"<img src=\"([^\"]*)\""];
    
    
    NSArray *aryBookNumber = [bookmodel.bookLink componentsSeparatedByString:@"/"];
    
    NSString *strBookNumber = [aryBookNumber objectAtIndex:[aryBookNumber count]-2];
    
    NSString *strBookNumberFront2 = [strBookNumber substringToIndex:2];
    
    //http://www.23wx.com/files/article/image/59/59945/59945s.jpg
    
    bookmodel.imgSrc = [NSString stringWithFormat:@"http://www.23wx.com/files/article/image/%@/%@/%@s.jpg",strBookNumberFront2,strBookNumber,strBookNumber];

    
    return bookmodel;
}



@end
