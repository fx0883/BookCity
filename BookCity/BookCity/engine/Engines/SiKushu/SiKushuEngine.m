//
//  SiKushuEngine.m
//  BookCity
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "SiKushuEngine.h"
#import "SiKushuSessionManager.h"
#import "BCTBookModel.h"
#import "BCTBookChapterModel.h"
#import "BCTBookAnalyzer.h"

@implementation SiKushuEngine

- (BCTSessionManager *)sessionManager {
    return [SiKushuSessionManager sharedClient];
}

-(void)getSearchBookResult:(BMBaseParam*)baseParam {
    NSString *strSource = baseParam.paramString;
    NSString *strKeyWord = [strSource URLEncodedStringGB_18030_2000];

    NSString *strUrl = [NSString stringWithFormat:@"/modules/article/search.php?searchkey=%@&searchtype=articlename&submit=%@&page=%ld",strKeyWord,@"%CB%D1%CB%F7",(long)baseParam.paramInt];
    
    
    [[SiKushuSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
        
        NSMutableArray *bookList = nil;
        
        if([BCTBookAnalyzer getStr:responseStr pattern:@"<h1 class=\"f20h\">"].length > 0)
        {
            BCTBookModel *oneBook = [self getBookModeSiKuShuForOne:responseStr];
            bookList = [[NSMutableArray alloc]initWithCapacity:2];
            [bookList addObject:oneBook];
        } else {
            NSArray *boollistSiKuShu = [self getBookListSiKuShu:responseStr];
            
            if ([boollistSiKuShu count]>0) {
                bookList = [[NSMutableArray alloc]initWithArray:boollistSiKuShu];
            }
        }
        
        baseParam.resultArray = bookList;
        if (baseParam.withresultobjectblock) {
            baseParam.withresultobjectblock(0,@"",nil);
        }
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
         NSLog(@"%@",[error userInfo]);
     }];
}

//整个HTML一本书
-(BCTBookModel*)getBookModeSiKuShuForOne:(NSString*)strSource {
    BCTBookModel *book = [BCTBookModel new];
    
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
    
    book.bookLink = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"<a href=\"([^\"]*)\" title=\"开始阅读\"><span>开始阅读</span>"];
//    <div class="pic"[^\"]*\"([^\"]*)\"
        book.imgSrc = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"<div class=\"pic\"[^\"]*\"([^\"]*)\""];
    return book;
}


-(NSArray*)getBookListSiKuShu:(NSString*)strSource
{
    NSString *strPattern = @"<tr>[\\s\\S]*?</tr>";
    
    NSArray* arySource = [BCTBookAnalyzer getBookListBaseStr:strSource pattern:strPattern];
    NSMutableArray *bookList = [[NSMutableArray alloc]init];
    
    for (NSString* subStrSource in arySource) {
        BCTBookModel *book = [self getBookModeSiKuShu:subStrSource];
        [bookList addObject:book];
    }
    
    return bookList;
}

-(BCTBookModel*)getBookModeSiKuShu:(NSString*)strSource
{
    BCTBookModel *book = [BCTBookModel new];
    
//    NSString *strPattern = @"\<a href=\"[^\"]*\"\\s*>([^<]*)\<\/a\>";
    
    book.title = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"\<a href=\"[^\"]*\"\\s*>([^<]*)\<\/a\>"];
    
    book.bookLink = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"\<a href=\"([^\"]*)\"\\s*target[^>]*>[^<]*\<\/a\>"];
    
//    <td class=\"odd\">([^<]*)</td>
    book.author = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"<td class=\"odd\">([^<]*)</td>"];
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


#pragma mark-  getBookChapterList

-(void)getBookChapterList:(BMBaseParam*)baseParam
{
    //NSString *strUrlParam = [NSString stringWithFormat:baseParam.paramString ,(long)baseParam.paramInt];
    
    NSString *strUrlParam = baseParam.paramString;
    
    NSString *strUrl = [strUrlParam stringByReplacingOccurrencesOfString:[self.sessionManager getBaseUrl] withString:@""];
    
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
        
        BCTBookChapterModel *bookchaptermodel = [BCTBookChapterModel new];
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
    __weak SiKushuEngine *weakSelf = self;
    [[SiKushuSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
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
    NSString *strPattern = @"<div id=\"content\">([\\S\\s]*?)</div>";
    strContent = [BCTBookAnalyzer getStrGroup1:strSource pattern:strPattern];
    strContent = [strContent stringByReplacingOccurrencesOfString:@"(四库书www.sikushu.com)" withString:@""];
    
    NSString *strScriptPattern = @"\\[最快的更新.*?\\]";
    NSString *strScript = [BCTBookAnalyzer getStr:strContent pattern:strScriptPattern];
    
    
    strContent = [strContent stringByReplacingOccurrencesOfString:strScript withString:@""];
    
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
    strContent = [BCTBookAnalyzer getChapterContentText:strSource];
    return strContent;
    
}

#pragma mark-  getCategoryBooksResult

-(void)getCategoryBooksResult:(BMBaseParam*)baseParam
{
    NSString *strUrl = [NSString stringWithFormat:baseParam.paramString ,(long)baseParam.paramInt];
    
    strUrl = [strUrl stringByReplacingOccurrencesOfString:[self.sessionManager getBaseUrl] withString:@""];
    
    [[SiKushuSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
        //NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
        
        
        
        NSMutableArray *bookList = nil;

        NSString *strListMain = [self getMainListContent:responseStr];
        
        bookList = [self getBookListFromCategorySiku:strListMain];
        
        baseParam.resultArray = bookList;
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

-(NSString*)getMainListContent:(NSString*)strSource
{
    NSString *strRet = @"";
    strRet = [BCTBookAnalyzer getStr:strSource pattern:@"<ul class=\"list_box1\">[\\S\\s]*?</ul>"];
    
    return strRet;
}

-(NSMutableArray*)getBookListFromCategorySiku:(NSString*)strSource
{
    NSMutableArray *retAry = [NSMutableArray new];
    
    NSString *strPattern = @"<li>[\\S\\s]*?</li>";
    NSArray *arySiku = [BCTBookAnalyzer getBookListBase:strSource pattern:strPattern];
    for (NSTextCheckingResult *match in arySiku) {
        NSString* substringForMatch = [strSource substringWithRange:match.range];
        NSLog(@"Extracted URL: %@",substringForMatch);

        BCTBookModel *bookModel = [self getBookModelFromCategory:substringForMatch];
        [retAry addObject:bookModel];
    }
    
    return retAry;
}

-(BCTBookModel*)getBookModelFromCategory:(NSString*)strSource
{
    BCTBookModel *bookmodel = [BCTBookModel new];
    bookmodel.imgSrc = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"<img src=\"([^\"]*)\""];
    bookmodel.bookLink = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"最新章节：<a href=\"([^\"]*)\""];
    bookmodel.title = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"<img src=\"[^\"]*\" alt=\"([^\"]*)\"/>"];
    bookmodel.memo = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"<p>([\\S\\s]*?)</p>"];
    bookmodel.author = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"作者：([^<]*)</a>"];
    
    return bookmodel;
}


@end
