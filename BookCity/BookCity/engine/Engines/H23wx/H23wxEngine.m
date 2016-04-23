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

-(void)getSearchBookResult:(BMBaseParam*)baseParam {
    NSString *strKeyWord = baseParam.paramString;
    
    if(baseParam.paramInt > 0) {
        baseParam.paramInt--;
    }
    NSString *stringPage = [NSString stringWithFormat:@"%ld",(long)baseParam.paramInt];
    
    NSDictionary *dict = @{@"q":strKeyWord,@"p":stringPage,@"s":@"15772447660171623812",@"nsid":@"",@"entry":@"1"};
    NSString *strUrl = @"/cse/search";
    
    [[So23wxSessionManager sharedClient] GET:strUrl parameters:dict progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSMutableArray *bookList = nil;
        
        bookList = [[NSMutableArray alloc]initWithArray:[self getBookListH23wx:responseStr]];
        
        baseParam.resultArray = bookList;
        if (baseParam.withresultobjectblock) {
            baseParam.withresultobjectblock(0,@"",nil);
        }

    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
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

-(BCTBookModel*)getBookModeH23wx:(NSString*)strSource {
    BCTBookModel *book = [BCTBookModel new];
    
    book.title = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"<a cpos=\"title\" href=\"\[^\"]*\" title=\"([^\"]*)\""];
    book.imgSrc = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"<img src=\"([^\"]*)\""];
    book.bookLink = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"<a cpos=\"img\" href=\"([^\"]*)\""];
    
    book.author = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"<a cpos=\"author\"[^>]*>([^<]*)</a>"];
    book.author = [book.author stringByReplacingOccurrencesOfString:@" " withString:@""];
    book.author = [book.author stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    
    
    book.memo = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"<p class=\"result-game-item-desc\">[^.]*..([\\s\\S]*?)</p>"];
    book.memo = [book.memo stringByReplacingOccurrencesOfString:@"<em>" withString:@""];
    book.memo = [book.memo stringByReplacingOccurrencesOfString:@"</em>" withString:@""];

    return book;
}


#pragma mark-  getBookChapterList

-(void)getBookChapterList:(BMBaseParam*)baseParam {
    
    NSString *strUrlParam = baseParam.paramString;
    
    NSString *strUrl = [strUrlParam stringByReplacingOccurrencesOfString:[self.sessionManager getBaseUrl] withString:@""];
    
    [[H23wxSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
        baseParam.resultArray = [self getChapterList:responseStr url:strUrlParam];
        
        
        if (baseParam.withresultobjectblock) {
            baseParam.withresultobjectblock(0,@"",nil);
        }
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
         NSLog(@"%@",[error userInfo]);
         if (baseParam.withresultobjectblock) {
             baseParam.withresultobjectblock(-1,@"",nil);
         }
         
     }];
}


-(NSMutableArray*)getChapterList:(NSString*)strSource url:(NSString*)strUrl {
    
    NSMutableArray *aryChapterList = [NSMutableArray new];
    
    NSString *pattern = @"<td class=\"L\"><a href=\"([^\"]*)\">([^<]*)</a>";
    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regular matchesInString:strSource options:0 range:NSMakeRange(0, strSource.length)];
    for (NSTextCheckingResult *match in results) {
        
        BCTBookChapterModel *bookchaptermodel = [BCTBookChapterModel new];
        
        bookchaptermodel.url = [strSource substringWithRange:[match rangeAtIndex:1]];
        bookchaptermodel.url = [NSString stringWithFormat:@"%@%@",strUrl,bookchaptermodel.url];
        bookchaptermodel.title = [strSource substringWithRange:[match rangeAtIndex:2]];
        bookchaptermodel.hostUrl = [self.sessionManager getBaseUrl];
        [aryChapterList addObject:bookchaptermodel];
    }
    
    return aryChapterList;
}


#pragma mark-  getBookChapterDetail

-(void)getBookChapterDetail:(BMBaseParam*)baseParam {
    //paramString2 保存chapterDetail url
    NSString *strUrl = baseParam.paramString2;
    
    strUrl = [strUrl stringByReplacingOccurrencesOfString:[self.sessionManager getBaseUrl] withString:@""];

    __weak H23wxEngine *weakSelf = self;
    [[H23wxSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
        
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

#pragma mark-  getCategoryBooksResult

-(void)getCategoryBooksResult:(BMBaseParam*)baseParam {
    NSString *strUrl = [NSString stringWithFormat:baseParam.paramString ,(long)baseParam.paramInt];
    
    strUrl = [strUrl stringByReplacingOccurrencesOfString:[self.sessionManager getBaseUrl] withString:@""];
    
    [[H23wxSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
        
        NSMutableArray *bookList = nil;
        
        bookList = [self getBookListFromCategoryH23w:responseStr];
        
        baseParam.resultArray = bookList;
        if (baseParam.withresultobjectblock) {
            baseParam.withresultobjectblock(0,@"",nil);
        }

    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
         NSLog(@"%@",[error userInfo]);
         if (baseParam.withresultobjectblock) {
             baseParam.withresultobjectblock(-1,@"",nil);
         }
         
     }];
}

-(NSMutableArray*)getBookListFromCategoryH23w:(NSString*)strSource {
    NSMutableArray *retAry = [NSMutableArray new];
    
    NSString *strPattern = @"<tr bgcolor=\"#FFFFFF\">[\\s\\S]*?</tr>";
    NSArray *ary = [BCTBookAnalyzer getBookListBase:strSource pattern:strPattern];
    for (NSTextCheckingResult *match in ary) {
        NSString* substringForMatch = [strSource substringWithRange:match.range];
        NSLog(@"Extracted URL: %@",substringForMatch);
        
        BCTBookModel *bookModel = [self getBookModelFromCategory:substringForMatch];
        [retAry addObject:bookModel];
    }
    
    return retAry;
}

-(BCTBookModel*)getBookModelFromCategory:(NSString*)strSource {
    BCTBookModel *bookmodel = [BCTBookModel new];

    bookmodel.bookLink = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"<a href=\"([^\"]*)\" target=\"_blank\">"];
    bookmodel.title = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"<a href=\"[^\"]*\">(.*?)</a>"];
    bookmodel.author = [BCTBookAnalyzer getStrGroup1:strSource pattern:@"<td class=\"C\">(.*?)</td>[\\s\\S]*?<td class=\"R\">"];
    
    NSArray *aryBookNumber = [bookmodel.bookLink componentsSeparatedByString:@"/"];
    
    NSString *strBookNumber = [aryBookNumber objectAtIndex:[aryBookNumber count]-2];
    
    NSString *strBookNumberFront2 = [strBookNumber substringToIndex:2];
    
    //http://www.23wx.com/files/article/image/59/59945/59945s.jpg
    bookmodel.imgSrc = [NSString stringWithFormat:@"http://www.23wx.com/files/article/image/%@/%@/%@s.jpg",strBookNumberFront2,strBookNumber,strBookNumber];

    return bookmodel;
}

@end
