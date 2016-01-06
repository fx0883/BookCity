//
//  XiaoShuo7788Engine.m
//  BookCity
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "XiaoShuo7788Engine.h"
#import "XiaoShuo7788SessionManager.h"

@implementation XiaoShuo7788Engine

-(void)getSearchBookResult:(BMBaseParam*)baseParam
{
    NSDictionary *dict = @{ @"Search":@"校花" };
    [[XiaoShuo7788SessionManager sharedClient] GET:@"/list/0/1.html" parameters:dict progress:nil success:^(NSURLSessionDataTask * __unused task, id responseObject) {
        
        
  
        
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];

//        NSArray *ary = [Post getBookList:responseStr];
//        
//        NSMutableArray *bookList = [[NSMutableArray alloc]init];
//        
//        for (NSTextCheckingResult *match in ary) {
//            NSString* substringForMatch = [responseStr substringWithRange:match.range];
//            NSLog(@"Extracted URL: %@",substringForMatch);
//            //            [arrayOfURLs addObject:substringForMatch];
//            BookModel *bookModel = [Post getBookModel:substringForMatch];
//            [bookList addObject:bookModel];
//            
//            NSLog(@"========================================");
//            NSLog(@"%@",bookModel.title);
//            NSLog(@"%@",bookModel.imgSrc);
//            NSLog(@"%@",bookModel.bookLink);
//            NSLog(@"%@",bookModel.memo);
//        }
//        
        //        NSLog(ary);
        NSLog(responseStr);
        //        NSLog(string);
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        
        

    }];
}

@end
