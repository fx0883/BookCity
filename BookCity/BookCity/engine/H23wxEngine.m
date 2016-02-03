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

#import "BookModel.h"
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
        BookModel *book = [self getBookModeH23wx:subStrSource];
        [bookList addObject:book];
    }
    
    return bookList;
}

-(BookModel*)getBookModeH23wx:(NSString*)strSource
{
    BookModel *book = [BookModel new];
    
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



@end
