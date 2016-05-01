//
//  XiaoShuo7788Engine.m
//  BookCity
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "XiaoShuo7788Engine.h"
#import "XiaoShuo7788SessionManager.h"
#import "BCTBookModel.h"
#import "BCTBookChapterModel.h"
#import "BCTBookAnalyzer.h"

@implementation XiaoShuo7788Engine


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
//    __weak XiaoShuo7788SessionManager *weakSelf = self;
    NSInteger i = bookmodel.finishChapterNumber;
    while (i < curPageEnd && i < [bookmodel.aryChapterList count])
    {
        
        BCTBookChapterModel* bookchaptermodel = [bookmodel.aryChapterList objectAtIndex:i];
        i++;
        usleep(100);
        
        NSString *strUrl = bookchaptermodel.url;
        
        strUrl = [strUrl stringByReplacingOccurrencesOfString:[XiaoShuo7788SessionManager getBaseUrl] withString:@""];
        __weak XiaoShuo7788Engine *weakSelf = self;
        [[XiaoShuo7788SessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
            
            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
            
//            NSLog(@"%@",responseStr);
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




-(void)getBookChapterDetail:(BMBaseParam*)baseParam
{
    //paramString2 保存chapterDetail url
    NSString *strUrl = baseParam.paramString2;
    
    strUrl = [strUrl stringByReplacingOccurrencesOfString:[XiaoShuo7788SessionManager getBaseUrl] withString:@""];
    //    __weak BMBaseParam *weakBaseParam = baseParam;
    __weak XiaoShuo7788Engine *weakSelf = self;
    [[XiaoShuo7788SessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
        
//        NSLog(@"%@",responseStr);
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
    NSString *strPattern = @"\<div id=\\\"bookContent\\\" ondblclick=\\\"scrollRun\\(\\)\\\" onclick=\\\"scrollStop\\(\\)\\\" class=\\\"ic13\\\"\>.*?\<\/div\>";
    strContent = [BCTBookAnalyzer getStr:strSource pattern:strPattern];
    
    strContent = [strContent stringByReplacingOccurrencesOfString:@"<div id=\"bookContent\" ondblclick=\"scrollRun()\" onclick=\"scrollStop()\" class=\"ic13\">" withString:@""];
    strContent = [strContent stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
    
    
    NSString *strScriptPattern = @"\<script\>.*\<\/script\>";
    NSString *strScript = [BCTBookAnalyzer getStr:strContent pattern:strScriptPattern];

    
    strContent = [strContent stringByReplacingOccurrencesOfString:strScript withString:@""];
    
    
    

    
    return strContent;
}

//-(NSString*)getChapterContentText:(NSString*)strSource
//{
//    NSString *strContent = @"";
//    strContent = [strSource stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
//    strContent = [strContent stringByReplacingOccurrencesOfString:@"</p>" withString:@"\r\n"];
//    strContent = [strContent stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\r\n"];
//    strContent = [strContent stringByReplacingOccurrencesOfString:@"<br />" withString:@"\r\n"];
//    return strContent;
//}
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
//    strContent = [self replace:strContent aimSource:@"\r\n" pattern:@"<br/>[\\s]*?<br/>"];
//    strContent = [strContent stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\r\n"];
//    strContent = [strContent stringByReplacingOccurrencesOfString:@"<br />" withString:@"\r\n"];
//    strContent = [strContent stringByReplacingOccurrencesOfString:@"\r\n\r\n" withString:@"\r\n"];
//    return strContent;
    
    NSString *strContent = @"";
    strContent = [BCTBookAnalyzer getChapterContentText:strSource];
    return strContent;
    
}




-(void)getCategoryBooksResult:(BMBaseParam*)baseParam
{
//    NSString *strUrl = baseParam.paramString;
////    NSString *strKeyWord = [strSource ConvertUTF16Big];
//    
//    
//    NSDictionary *dict = @{ @"Search":strKeyWord};
    
//    XiaoShuo7788SessionManager BaseURLString
    
    NSString *strUrl = [NSString stringWithFormat:baseParam.paramString ,(long)baseParam.paramInt];
    
    strUrl = [strUrl stringByReplacingOccurrencesOfString:[XiaoShuo7788SessionManager getBaseUrl] withString:@""];
    
    [[XiaoShuo7788SessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
        //NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
        

        
        NSMutableArray *bookList = [[NSMutableArray alloc]init];
        
        
        //段天小说网的小说
//        NSArray *ary = [self getBookList:responseStr];
//        for (NSTextCheckingResult *match in ary) {
//            NSString* substringForMatch = [responseStr substringWithRange:match.range];
//            NSLog(@"Extracted URL: %@",substringForMatch);
//            //            [arrayOfURLs addObject:substringForMatch];
//            BookModel *bookModel = [self getBookModel:substringForMatch];
//            [bookList addObject:bookModel];
//            
//            NSLog(@"========================================");
//            NSLog(@"%@",bookModel.title);
//            NSLog(@"%@",bookModel.imgSrc);
//            NSLog(@"%@",bookModel.bookLink);
//            NSLog(@"%@",bookModel.memo);
//        }
        //7788小说网的小说
        NSArray *ary7788 = [self getBookList7788:responseStr];
        for (NSTextCheckingResult *match in ary7788) {
            NSString* substringForMatch = [responseStr substringWithRange:match.range];
            NSLog(@"Extracted URL: %@",substringForMatch);
            //            [arrayOfURLs addObject:substringForMatch];
            BCTBookModel *bookModel = [self getBookModel7788:substringForMatch];
            [bookList addObject:bookModel];
            
            NSLog(@"========================================");
            NSLog(@"%@",bookModel.title);
            NSLog(@"%@",bookModel.imgSrc);
            NSLog(@"%@",bookModel.bookLink);
            NSLog(@"%@",bookModel.memo);
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
         if (baseParam.withresultobjectblock) {
             baseParam.withresultobjectblock(-1,@"",nil);
         }
         
     }];
}


-(void)getSearchBookResult:(BMBaseParam*)baseParam
{
    
//    NSString *strSource = @"校花";
    NSString *strSource = baseParam.paramString;
    NSString *strKeyWord = [strSource ConvertUTF16Big];
    

    NSDictionary *dict = @{ @"Search":strKeyWord};
    
//    NSDictionary *dict = nil;
    
    NSString *strUrl = [NSString stringWithFormat:@"/list/0/%ld.html" ,(long)baseParam.paramInt];
strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[XiaoShuo7788SessionManager sharedClient] GET:strUrl parameters:dict progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
        //NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];

        NSMutableArray *bookList = [[NSMutableArray alloc]init];
        
        //段天小说网
//        NSArray *ary = [self getBookList:responseStr];
//        for (NSTextCheckingResult *match in ary) {
//            NSString* substringForMatch = [responseStr substringWithRange:match.range];
//            NSLog(@"Extracted URL: %@",substringForMatch);
//            //            [arrayOfURLs addObject:substringForMatch];
//            BookModel *bookModel = [self getBookModel:substringForMatch];
//            [bookList addObject:bookModel];
//            
//            NSLog(@"========================================");
//            NSLog(@"%@",bookModel.title);
//            NSLog(@"%@",bookModel.imgSrc);
//            NSLog(@"%@",bookModel.bookLink);
//            NSLog(@"%@",bookModel.memo);
//        }
                //7788小说网
        NSArray *ary7788 = [self getBookList7788:responseStr];
        for (NSTextCheckingResult *match in ary7788) {
            NSString* substringForMatch = [responseStr substringWithRange:match.range];
            NSLog(@"Extracted URL: %@",substringForMatch);
            //            [arrayOfURLs addObject:substringForMatch];
            BCTBookModel *bookModel = [self getBookModel7788:substringForMatch];
            [bookList addObject:bookModel];
            
            NSLog(@"========================================");
            NSLog(@"%@",bookModel.title);
            NSLog(@"%@",bookModel.imgSrc);
            NSLog(@"%@",bookModel.bookLink);
            NSLog(@"%@",bookModel.memo);
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



//-(NSArray*)getBookListBase:(NSString*)strSource
//                pattern:(NSString*)strPattern
//{
//    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:strPattern options:NSRegularExpressionCaseInsensitive error:nil];
//    NSArray *results = [regular matchesInString:strSource options:0 range:NSMakeRange(0, strSource.length)];
//    return results;
//}

-(NSArray*)getBookList7788:(NSString*)strSource
{
     NSString *strPattern = @"\<div class=\"lm1311\"\>.*?开始阅读";
    return [BCTBookAnalyzer getBookListBase:strSource pattern:strPattern];
}


//-(NSString*)getStr:(NSString*)strSource
//            pattern:(NSString*)strPattern
//{
////    NSString *strPattern = @"ShowIdtoItem\\(.*?\\)";
//    NSString* strResult = @"";
//    NSRegularExpression *regularexpression1 = [[NSRegularExpression alloc]initWithPattern:strPattern options:NSRegularExpressionCaseInsensitive error:nil];
//    
//    
//    NSTextCheckingResult *match1 = [regularexpression1 firstMatchInString:strSource
//                                                                  options:0
//                                                                    range:NSMakeRange(0, [strSource length])];
//    if (match1) {
//        strResult = [strSource substringWithRange:match1.range];
//    }
//    return strResult;
//}

//getBookImg
-(NSString*)getBookImgStr7788:(NSString*)strSource
{
    NSString *strPattern1 = @"\<img alt=\".*?\" src=\".*?\" \/\>";
    
    NSString *strResult = [BCTBookAnalyzer getStr:strSource pattern:strPattern1];
    
    NSString *strPattern2 = @"src=\".*?\"";
    
    strResult = [BCTBookAnalyzer getStr:strResult pattern:strPattern2];
    
    strResult = [strResult stringByReplacingOccurrencesOfString:@"src=" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    return strResult;
    
}

-(NSString*)getBookLink7788:(NSString*)strSource
{
    NSString *strPattern1 = @"\<a href=\".*?\"\>\<img";
    
    NSString *strResult = [BCTBookAnalyzer getStr:strSource pattern:strPattern1];
    
    NSString *strPattern2 = @"href=\".*?\"";
    
    strResult = [BCTBookAnalyzer getStr:strResult pattern:strPattern2];
    
    strResult = [strResult stringByReplacingOccurrencesOfString:@"href=" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    return strResult;
    
}



-(NSString*)getBookTitle7788:(NSString*)strSource
{
    NSString *strPattern1 = @"\<img alt=\".*?\" src=\".*?\" \/\>";
    
    NSString *strResult = [BCTBookAnalyzer getStr:strSource pattern:strPattern1];
    
    NSString *strPattern2 = @"alt=\".*?\"";
    
    strResult = [BCTBookAnalyzer getStr:strResult pattern:strPattern2];
    
    strResult = [strResult stringByReplacingOccurrencesOfString:@"alt=" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    return strResult;
    
}

-(NSString*)getBookMemo7788:(NSString*)strSource
{
    NSString *strPattern1 = @"\<span\>状态：.*?\<a href=\".*?\" class=\"sread\"\>开始阅读";
    
    NSString *strResult = [BCTBookAnalyzer getStr:strSource pattern:strPattern1];
    
    NSString *strPattern2 = @"\<br \/\>.*?\<a";
    
    strResult = [BCTBookAnalyzer getStr:strResult pattern:strPattern2];
    
    strResult = [strResult stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"<a" withString:@""];
    
    return strResult;
    
}

//获取作者
-(NSString*)getBookAuthor7788:(NSString*)strSource
{
    NSString *strPattern1 = @"作者：\<\/span\>\<a href=\".*?\">.*?</a>";
    
    NSString *strResult = [BCTBookAnalyzer getStr:strSource pattern:strPattern1];
    
    NSString *strPattern2 = @"\"\>.*?\<\/a\>";
    
    strResult = [BCTBookAnalyzer getStr:strResult pattern:strPattern2];
    

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
    
    NSString *strResult = [BCTBookAnalyzer getStr:strSource pattern:strPattern1];
    
    NSString *strPattern2 = @"\"\>.*?\<\/a\>";
    
    strResult = [BCTBookAnalyzer getStr:strResult pattern:strPattern2];
    
    
    strResult = [strResult stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@">" withString:@""];
    strResult = [strResult stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    return strResult;
    
}

-(NSArray*)getBookList:(NSString*)strSource
{
    NSString *strPattern = @"ShowIdtoItem\\(.*?\\)";
    return [BCTBookAnalyzer getBookListBase:strSource pattern:strPattern];
}

-(BCTBookModel*)getBookModel:(NSString*)strSource
{
    strSource = [strSource stringByReplacingOccurrencesOfString:@"ShowIdtoItem(" withString:@""];
    strSource = [strSource stringByReplacingOccurrencesOfString:@")" withString:@""];
    NSArray *array = [strSource componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
    BCTBookModel* book = [BCTBookModel new];
    
    NSInteger bookId = 0;
    NSString *chapterId;
    NSString *bookName;
    NSString *isHavePic;
    NSString *author;
    
    NSString *wordCount;
    NSString *cateogryName;
    NSString *subCategoryName;
    NSString *isFinally;
    NSString *memo;
    
    NSString *lastModify;
    NSString *imgStr;
    NSString *bookLink;
    
    for (NSInteger i=0; i<array.count; i++) {
        NSString* item = [array objectAtIndex:i];
        item = [item stringByReplacingOccurrencesOfString:@"'" withString:@""];
        
        switch (i) {
            case 0:
                bookId = [item integerValue];
                break;
            case 1:
                chapterId = item;
                break;
            case 2:
                bookName = item;
                break;
            case 3:
                isHavePic = item;
                break;
            case 4:
                author = item;
                break;
                
                
            case 5:
                wordCount = item;
                break;
            case 6:
                cateogryName = item;
                break;
            case 7:
                subCategoryName = item;
                break;
            case 8:
                isFinally = item;
                break;
            case 9:
                memo = item;
                break;
                
            case 10:
                lastModify = item;
                break;
                
                
            default:
                break;
        }
        
    }
    
    if ([isHavePic  isEqual: @"True"]) {
        imgStr = @"{t8(u}{9h$2}ii.{80gj(*F}{952J@fs}.com/BookImages/100x125";
        NSString *bookid1000000 = [NSString stringWithFormat:@"%ld",bookId/1000000];
        NSString *bookid1000 = [NSString stringWithFormat:@"%ld",bookId/1000];
        NSString *bookid1 = [NSString stringWithFormat:@"%ld",bookId/1];
        
        imgStr = [NSString stringWithFormat:@"%@/%@/%@/%@.jpg",imgStr,bookid1000000,bookid1000,bookid1];
        
        
        //+ bookid1000000 + @"/" +bookid1000+ @"/" +bookid1+ @".jpg";
        
        //            + parseInt(BookID / 1000000) + '/' + parseInt(BookID / 1000) + '/' + BookID + '.jpg';
    }
    else
    {
        imgStr = @"http://iii.7788xiaoshuo.info/BookImages/Def.jpg";
    }
    NSString *strBookId1 = [NSString stringWithFormat:@"%ld",bookId/1];
    bookLink = [self BuildLink:strBookId1 chapterId:chapterId];
    
    imgStr = [self re348str:imgStr];
    bookLink = [self re348str:bookLink];
    
    

    NSString *strBookid = [NSString stringWithFormat:@"%ld",bookId/1];
    
    book.title = bookName;
    book.bookId = strBookid;
    book.author = author;
    book.imgSrc = imgStr;
    book.wordCount = wordCount;
    
    book.cateogryName = cateogryName;
    book.subCategoryName = subCategoryName;
    book.isFinally = isFinally;
    book.memo = memo;
    book.bookLink = bookLink;
    
    
    
    return book;
}

-(BCTBookModel*)getBookModel7788:(NSString*)strSource
{
    BCTBookModel *book = [BCTBookModel new];
    book.bookLink = [self getBookLink7788:strSource];
    book.title = [self getBookTitle7788:strSource];
    book.memo = [self getBookMemo7788:strSource];
    book.imgSrc = [self getBookImgStr7788:strSource];
    book.author = [self getBookAuthor7788:strSource];
    book.subCategoryName = [self getBookCateogryName7788:strSource];
    
    return book;
}

-(NSString*)BuildLink:(NSString*)BID
            chapterId:(NSString*)CID
{
    //    NSString *strResult = [NSString stringWithFormat:@"{t8(u}{9h$2}www.{80gj(*F}{952J@fs}.com/xiaoshuo/%@/c/%@.html",BID,CID];
    
    NSString *strResult = [NSString stringWithFormat:@"{t8(u}{9h$2}www.{80gj(*F}{952J@fs}.com/xiaoshuo/%@/clist.html",BID];
    
    
    
    return strResult;
}


-(NSString*)re348str:(NSString*)iStr
{
    iStr = [iStr stringByReplacingOccurrencesOfString:@"{t8(u}" withString:@"htt"];
    iStr = [iStr stringByReplacingOccurrencesOfString:@"{9h$2}" withString:@"p://"];
    iStr = [iStr stringByReplacingOccurrencesOfString:@"{80gj(*F}" withString:@"dua"];
    iStr = [iStr stringByReplacingOccurrencesOfString:@"{952J@fs}" withString:@"ntian"];
    
    
    return iStr;
}


#pragma mark-  getBookChapterList

-(void)getBookChapterList:(BMBaseParam*)baseParam
{
//    NSString *strUrl = [NSString stringWithFormat:baseParam.paramString ,(long)baseParam.paramInt];
    NSString *strUrl = baseParam.paramString;
    
    strUrl = [strUrl stringByReplacingOccurrencesOfString:[XiaoShuo7788SessionManager getBaseUrl] withString:@""];
    
    [[XiaoShuo7788SessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
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
        bookchaptermodel.hostUrl = [XiaoShuo7788SessionManager getBaseUrl];
        [aryChapterList addObject:bookchaptermodel];
    }
    
    
    
    
    return aryChapterList;
    
    
    
    
}





@end
