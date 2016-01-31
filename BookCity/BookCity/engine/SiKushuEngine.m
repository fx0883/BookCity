//
//  SiKushuEngine.m
//  BookCity
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "SiKushuEngine.h"
#import "SiKushuSessionManager.h"
#import "BookModel.h"
#import "BookChapterModel.h"

@implementation SiKushuEngine

-(void)getSearchBookResult:(BMBaseParam*)baseParam
{
    
    //    NSString *strSource = @"校花";
    NSString *strSource = baseParam.paramString;
    NSString *strKeyWord = [strSource URLEncodedStringGB_18030_2000];

    
    
//    NSString *stringPage = [NSString stringWithFormat:@"%ld",(long)baseParam.paramInt];
    
    //NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_2312_80);
    

    
    
   // NSDictionary *dict = @{ @"searchkey":strKeyWord,@"searchtype":@"articlename",@"submit":@"搜索",@"page":stringPage};
    

    
    NSString *strUrl = [NSString stringWithFormat:@"/modules/article/search.php?searchkey=%@&searchtype=articlename&submit=%@&page=%ld",strKeyWord,@"%CB%D1%CB%F7",(long)baseParam.paramInt];
    
    
    [[SiKushuSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
        //NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
        
        NSMutableArray *bookList = nil;
        
        //<tr>[\s\S]*?</tr>
        
//        <h1 class="f20h">
        
        if([self getStr:responseStr pattern:@"<h1 class=\"f20h\">"].length>0)
        {
            BookModel *oneBook = [self getBookModeSiKuShuForOne:responseStr];
            bookList = [[NSMutableArray alloc]initWithCapacity:2];
            [bookList addObject:oneBook];
        }
        else
        {
            NSArray *boollistSiKuShu = [self getBookListSiKuShu:responseStr];
            
            if ([boollistSiKuShu count]>0) {
                bookList = [[NSMutableArray alloc]initWithArray:boollistSiKuShu];
            }
        }
        

        
        
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

//整个HTML一本书
-(BookModel*)getBookModeSiKuShuForOne:(NSString*)strSource
{
    BookModel *book = [BookModel new];
    
//    <h1 class=\"f20h\">([^<]*)<em>([^<]*)</em></h1>
    NSString *strPatternAuthorAndTitle = @"<h1 class=\"f20h\">([^<]*)<em>([^<]*)</em></h1>";
    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:strPatternAuthorAndTitle options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *matchs = [regular matchesInString:strSource options:0 range:NSMakeRange(0, strSource.length)];
    
        if ([matchs count]>0) {
    
            NSTextCheckingResult *match = [matchs objectAtIndex:0];
    
            book.title = [strSource substringWithRange:[match rangeAtIndex:1]];
            book.author = [strSource substringWithRange:[match rangeAtIndex:2]];
            
            //作者：
            book.author = [book.author stringByReplacingOccurrencesOfString:@"作者：" withString:@""];
        }
    
    book.bookLink = [self getStrGroup1:strSource pattern:@"<a href=\"([^\"]*)\" title=\"开始阅读\"><span>开始阅读</span>"];
//    <div class="pic"[^\"]*\"([^\"]*)\"
        book.imgSrc = [self getStrGroup1:strSource pattern:@"<div class=\"pic\"[^\"]*\"([^\"]*)\""];
    return book;
}


-(NSArray*)getBookListSiKuShu:(NSString*)strSource
{
    NSString *strPattern = @"<tr>[\\s\\S]*?</tr>";
    
    NSArray* arySource = [self getBookListBaseStr:strSource pattern:strPattern];
    NSMutableArray *bookList = [[NSMutableArray alloc]init];
    
    for (NSString* subStrSource in arySource) {
        BookModel *book = [self getBookModeSiKuShu:subStrSource];
        [bookList addObject:book];
    }
    
    return bookList;
}

-(BookModel*)getBookModeSiKuShu:(NSString*)strSource
{
    BookModel *book = [BookModel new];
    
//    NSString *strPattern = @"\<a href=\"[^\"]*\"\\s*>([^<]*)\<\/a\>";
    
    book.title = [self getStrGroup1:strSource pattern:@"\<a href=\"[^\"]*\"\\s*>([^<]*)\<\/a\>"];
    
    book.bookLink = [self getStrGroup1:strSource pattern:@"\<a href=\"([^\"]*)\"\\s*target[^>]*>[^<]*\<\/a\>"];
    
//    <td class=\"odd\">([^<]*)</td>
    book.author = [self getStrGroup1:strSource pattern:@"<td class=\"odd\">([^<]*)</td>"];
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
    
    NSArray *aryBookNumber = [book.bookLink componentsSeparatedByString:@"/"];
    
    NSString *strBookNumber = [aryBookNumber objectAtIndex:[aryBookNumber count]-2];
    
    NSString *strBookNumberFront2 = [strBookNumber substringToIndex:2];
    
    
    
    book.imgSrc = [NSString stringWithFormat:@"http://www.sikushu.com/files/article/image/%@/%@/%@s.jpg",strBookNumberFront2,strBookNumber,strBookNumber];
    return book;
}



//getBookImg
-(NSString*)getBookImgStr7788:(NSString*)strSource
{
    NSString *strPattern1 = @"\<img alt=\".*?\" src=\".*?\" \/\>";
    
    NSString *strResult = [self getStr:strSource pattern:strPattern1];
    
    NSString *strPattern2 = @"src=\".*?\"";
    
    strResult = [self getStr:strResult pattern:strPattern2];
    
    strResult = [strResult stringByReplacingOccurrencesOfString:@"src=" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    return strResult;
    
}

-(NSString*)getBookLink7788:(NSString*)strSource
{
    NSString *strPattern1 = @"\<a href=\".*?\"\>\<img";
    
    NSString *strResult = [self getStr:strSource pattern:strPattern1];
    
    NSString *strPattern2 = @"href=\".*?\"";
    
    strResult = [self getStr:strResult pattern:strPattern2];
    
    strResult = [strResult stringByReplacingOccurrencesOfString:@"href=" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    return strResult;
    
}



-(NSString*)getBookTitle7788:(NSString*)strSource
{
    NSString *strPattern1 = @"\<img alt=\".*?\" src=\".*?\" \/\>";
    
    NSString *strResult = [self getStr:strSource pattern:strPattern1];
    
    NSString *strPattern2 = @"alt=\".*?\"";
    
    strResult = [self getStr:strResult pattern:strPattern2];
    
    strResult = [strResult stringByReplacingOccurrencesOfString:@"alt=" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    return strResult;
    
}

-(NSString*)getBookMemo7788:(NSString*)strSource
{
    NSString *strPattern1 = @"\<span\>状态：.*?\<a href=\".*?\" class=\"sread\"\>开始阅读";
    
    NSString *strResult = [self getStr:strSource pattern:strPattern1];
    
    NSString *strPattern2 = @"\<br \/\>.*?\<a";
    
    strResult = [self getStr:strResult pattern:strPattern2];
    
    strResult = [strResult stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"<a" withString:@""];
    
    return strResult;
    
}

//获取作者
-(NSString*)getBookAuthor7788:(NSString*)strSource
{
    NSString *strPattern1 = @"作者：\<\/span\>\<a href=\".*?\">.*?</a>";
    
    NSString *strResult = [self getStr:strSource pattern:strPattern1];
    
    NSString *strPattern2 = @"\"\>.*?\<\/a\>";
    
    strResult = [self getStr:strResult pattern:strPattern2];
    
    
    strResult = [strResult stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@">" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    return strResult;
    
}

//cateogryName
//获取分类
-(NSString*)getBookCateogryName7788:(NSString*)strSource
{
    NSString *strPattern1 = @"分类：\<\/span\>\<a href=\".*?\"\>.*?\<\/a\>";
    
    NSString *strResult = [self getStr:strSource pattern:strPattern1];
    
    NSString *strPattern2 = @"\"\>.*?\<\/a\>";
    
    strResult = [self getStr:strResult pattern:strPattern2];
    
    
    strResult = [strResult stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@">" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    return strResult;
    
}


#pragma mark-  getBookChapterList

-(void)getBookChapterList:(BMBaseParam*)baseParam
{
    NSString *strUrlParam = [NSString stringWithFormat:baseParam.paramString ,(long)baseParam.paramInt];
    
    NSString *strUrl = [strUrlParam stringByReplacingOccurrencesOfString:[SiKushuSessionManager getBaseUrl] withString:@""];
    
    [[SiKushuSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
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
    
    NSString *pattern = @"<li>[^<]*<a href=\"[^\"]*\"\\s*>([^<]*)\<\/a\>[^<]*</li>";
    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regular matchesInString:strSource options:0 range:NSMakeRange(0, strSource.length)];
    for (NSTextCheckingResult *match in results) {
        
        BookChapterModel *bookchaptermodel = [BookChapterModel new];
        NSString* substringForMatch = [strSource substringWithRange:match.range];
        NSLog(@"chapter list: %@",substringForMatch);

        NSString *strPatternListDetail = @"<a href=\"([^\"]*)\">([^<]*)</a>";
        NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:strPatternListDetail options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray *matchs = [regular matchesInString:substringForMatch options:0 range:NSMakeRange(0, substringForMatch.length)];
        
            if ([matchs count]>0) {
        
                NSTextCheckingResult *match2 = [matchs objectAtIndex:0];
        
                
                bookchaptermodel.url = [substringForMatch substringWithRange:[match2 rangeAtIndex:1]];
                
                
                NSString* strChapterUrlBase = [strUrl stringByDeletingLastPathComponent];
                bookchaptermodel.url = [NSString stringWithFormat:@"%@/%@",strChapterUrlBase,bookchaptermodel.url];
                
                bookchaptermodel.title = [substringForMatch substringWithRange:[match2 rangeAtIndex:2]];
            }
        bookchaptermodel.hostUrl = [SiKushuSessionManager getBaseUrl];
        [aryChapterList addObject:bookchaptermodel];
    }
    
    
    
    
    return aryChapterList;
    
    
    
    
}


#pragma mark-  getBookChapterDetail

-(void)getBookChapterDetail:(BMBaseParam*)baseParam
{
    //paramString2 保存chapterDetail url
    NSString *strUrl = baseParam.paramString2;
    
    strUrl = [strUrl stringByReplacingOccurrencesOfString:[SiKushuSessionManager getBaseUrl] withString:@""];
    //    __weak BMBaseParam *weakBaseParam = baseParam;
    __weak SiKushuEngine *weakSelf = self;
    [[SiKushuSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
        
        NSLog(@"%@",responseStr);
        baseParam.resultString = [weakSelf getChapterContent:responseStr];
        
        // BookChapterModel* bookchaptermodel = (BookChapterModel*)baseParam.paramObject;
        //       ((BookChapterModel*)baseParam.paramObject).content = [weakSelf getChapterContentText:baseParam.resultString];
        
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
    NSString *strPattern = @"<div id=\"content\">([\\S\\s]*?)</div>";
    strContent = [self getStrGroup1:strSource pattern:strPattern];
    strContent = [strContent stringByReplacingOccurrencesOfString:@"(四库书www.sikushu.com)" withString:@""];
    
    NSString *strScriptPattern = @"\\[最快的更新.*?\\]";
    NSString *strScript = [self getStr:strContent pattern:strScriptPattern];
    
    
    strContent = [strContent stringByReplacingOccurrencesOfString:strScript withString:@""];
    
//    
//    strContent = [strContent stringByReplacingOccurrencesOfString:@"[最快的更新尽在四&amp;库*书*小说网<a href=\"http://www.SikUShu.com\" target=\"_blank\">www.SikUShu.com</a>]" withString:@""];
    
    
    
    
    return strContent;
}

-(NSString*)getChapterContentText:(NSString*)strSource
{
//    &nbsp;&nbsp;&nbsp;&nbsp;
    
    NSString *strContent = @"";
    strContent = [strSource stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    strContent = [strContent stringByReplacingOccurrencesOfString:@"&nbsp;&nbsp;" withString:@" "];
    strContent = [strContent stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    strContent = [strContent stringByReplacingOccurrencesOfString:@"</p>" withString:@"\r\n"];
    strContent = [strContent stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\r\n"];
    strContent = [strContent stringByReplacingOccurrencesOfString:@"<br />" withString:@"\r\n"];
    
    
    return strContent;
}


#pragma mark-  downloadplist

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
    __weak SiKushuEngine *weakSelf = self;
    NSInteger i = bookmodel.finishChapterNumber;
    while (i < curPageEnd && i < [bookmodel.aryChapterList count])
    {
        
        BookChapterModel* bookchaptermodel = [bookmodel.aryChapterList objectAtIndex:i];
        i++;
        usleep(100);
        
        NSString *strUrl = bookchaptermodel.url;
        
        strUrl = [strUrl stringByReplacingOccurrencesOfString:[SiKushuSessionManager getBaseUrl] withString:@""];
//        __weak XiaoShuo7788Engine *weakSelf = self;
        [[SiKushuSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
            
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
    
    strUrl = [strUrl stringByReplacingOccurrencesOfString:[SiKushuSessionManager getBaseUrl] withString:@""];
    
    [[SiKushuSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
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
        NSString *strListMain = [self getMainListContent:responseStr];
        
        bookList = [self getBookListFromCategorySiku:strListMain];
        
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

-(NSString*)getMainListContent:(NSString*)strSource
{
    NSString *strRet = @"";
    strRet = [self getStr:strSource pattern:@"<ul class=\"list_box1\">[\\S\\s]*?</ul>"];
    
    return strRet;
}

-(NSMutableArray*)getBookListFromCategorySiku:(NSString*)strSource
{
    NSMutableArray *retAry = [NSMutableArray new];
    
    NSString *strPattern = @"<li>[\\S\\s]*?</li>";
    NSArray *arySiku = [self getBookListBase:strSource pattern:strPattern];
    for (NSTextCheckingResult *match in arySiku) {
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
        
        BookModel *bookModel = [self getBookModelFromCategory:substringForMatch];
        [retAry addObject:bookModel];
    }
    
    return retAry;
}

-(BookModel*)getBookModelFromCategory:(NSString*)strSource
{
    BookModel *bookmodel = [BookModel new];
    bookmodel.imgSrc = [self getStrGroup1:strSource pattern:@"<img src=\"([^\"]*)\""];
    bookmodel.bookLink = [self getStrGroup1:strSource pattern:@"最新章节：<a href=\"([^\"]*)\""];
    bookmodel.title = [self getStrGroup1:strSource pattern:@"<img src=\"[^\"]*\" alt=\"([^\"]*)\"/>"];
    bookmodel.memo = [self getStrGroup1:strSource pattern:@"<p>([\\S\\s]*?)</p>"];
    bookmodel.author = [self getStrGroup1:strSource pattern:@"作者：([^<]*)</a>"];
    
    return bookmodel;
}


@end
