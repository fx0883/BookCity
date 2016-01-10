//
//  XiaoShuo7788Engine.m
//  BookCity
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "XiaoShuo7788Engine.h"
#import "XiaoShuo7788SessionManager.h"
#import "BookModel.h"

@implementation XiaoShuo7788Engine

-(void)getSearchBookResult:(BMBaseParam*)baseParam
{
    
//    NSString *strSource = @"校花";
    NSString *strSource = baseParam.paramString;
    NSString *strKeyWord = [strSource ConvertUTF16Big];
    

    NSDictionary *dict = @{ @"Search":strKeyWord};
    
    [[XiaoShuo7788SessionManager sharedClient] GET:@"/list/0/1.html" parameters:dict progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
        //NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];

        NSArray *ary = [self getBookList:responseStr];
        
        NSMutableArray *bookList = [[NSMutableArray alloc]init];
        
        for (NSTextCheckingResult *match in ary) {
            NSString* substringForMatch = [responseStr substringWithRange:match.range];
            NSLog(@"Extracted URL: %@",substringForMatch);
            //            [arrayOfURLs addObject:substringForMatch];
            BookModel *bookModel = [self getBookModel:substringForMatch];
            [bookList addObject:bookModel];
            
            NSLog(@"========================================");
            NSLog(@"%@",bookModel.title);
            NSLog(@"%@",bookModel.imgSrc);
            NSLog(@"%@",bookModel.bookLink);
            NSLog(@"%@",bookModel.memo);
        }
        
        NSArray *ary7788 = [self getBookList7788:responseStr];
        

        for (NSTextCheckingResult *match in ary7788) {
            NSString* substringForMatch = [responseStr substringWithRange:match.range];
            NSLog(@"Extracted URL: %@",substringForMatch);
            //            [arrayOfURLs addObject:substringForMatch];
            BookModel *bookModel = [self getBookModel7788:substringForMatch];
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



-(NSArray*)getBookListBase:(NSString*)strSource
                pattern:(NSString*)strPattern
{
//    NSString *pattern = @"ShowIdtoItem\\(.*?\\)";
    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:strPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *results = [regular matchesInString:strSource options:0 range:NSMakeRange(0, strSource.length)];
    return results;
}

-(NSArray*)getBookList7788:(NSString*)strSource
{
     NSString *strPattern = @"\<div class=\"lm1311\"\>.*?开始阅读";
    return [self getBookListBase:strSource pattern:strPattern];
}


-(NSString*)getStr:(NSString*)strSource
            pattern:(NSString*)strPattern
{
//    NSString *strPattern = @"ShowIdtoItem\\(.*?\\)";
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

-(NSArray*)getBookList:(NSString*)strSource
{
    NSString *strPattern = @"ShowIdtoItem\\(.*?\\)";
    return [self getBookListBase:strSource pattern:strPattern];
}

-(BookModel*)getBookModel:(NSString*)strSource
{
    strSource = [strSource stringByReplacingOccurrencesOfString:@"ShowIdtoItem(" withString:@""];
    strSource = [strSource stringByReplacingOccurrencesOfString:@")" withString:@""];
    NSArray *array = [strSource componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
    BookModel* book = [BookModel new];
    
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

-(BookModel*)getBookModel7788:(NSString*)strSource
{
    BookModel *book = [BookModel new];
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




@end
