//
//  SiKushuEngine.m
//  BookCity
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "SiKushuEngine.h"
#import "SiKushuSessionManager.h"

@implementation SiKushuEngine

-(void)getSearchBookResult:(BMBaseParam*)baseParam
{
    
    //    NSString *strSource = @"校花";
    NSString *strSource = baseParam.paramString;
    NSString *strKeyWord = [strSource URLEncodedStringGB_18030_2000];
//    strKeyWord = [strKeyWord URLDecodedString];
    
    
    NSString *stringPage = [NSString stringWithFormat:@"%ld",(long)baseParam.paramInt];
    
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_2312_80);
    
//    NSData *dataKeyword = [strSource stringByAddingPercentEscapesUsingEncoding:gbkEncoding];
//     NSData *dataSearchtype = [@"articlename" stringByAddingPercentEscapesUsingEncoding:gbkEncoding];
//     NSData *dataSubmit = [@"搜索" stringByAddingPercentEscapesUsingEncoding:gbkEncoding];
//    NSData *dataPage = [stringPage stringByAddingPercentEscapesUsingEncoding:gbkEncoding];
    
//    NSDictionary *dict = @{ @"searchkey":strKeyWord,@"searchtype":dataSearchtype,@"submit":dataSubmit,@"page":dataPage};
    
    
    NSDictionary *dict = @{ @"searchkey":strKeyWord,@"searchtype":@"articlename",@"submit":@"搜索",@"page":stringPage};
    
    //    NSDictionary *dict = nil;
    
//    NSString *strUrl = [NSString stringWithFormat:@"/list/0/%ld.html" ,(long)baseParam.paramInt];
//    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
//    [[SiKushuSessionManager sharedClient] POST:@"/modules/article/search.php" parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
//        NSLog(@"%@",responseStr);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         NSLog(@"%@",error);
//    }];
    
    NSString *strUrl = [NSString stringWithFormat:@"/modules/article/search.php?searchkey=%@&searchtype=articlename&submit=%@&page=%ld",strKeyWord,@"%CB%D1%CB%F7",(long)baseParam.paramInt];
    
    
    [[SiKushuSessionManager sharedClient] GET:strUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
        //NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
        
        NSMutableArray *bookList = [[NSMutableArray alloc]init];
        
        
        //<tr>[\s\S]*?</tr>
        
        
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


-(NSArray*)getBookListSiKuShu:(NSString*)strSource
{
    NSString *strPattern = @"<tr>[\s\S]*?</tr>";
    return [self getBookListBase:strSource pattern:strPattern];
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




@end
