//
//  BCTBookEngine.m
//  BookCity
//
//  Created by Dong Yiming on 16/4/23.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "BCTBookEngine.h"
#import "BCTBookModel.h"
#import "BCTBookChapterModel.h"
#import "BCISessionManager.h"
#import "AFHTTPSessionManager.h"
#import "BCTSessionManager.h"

@implementation BCTBookEngine

- (BCTSessionManager *)sessionManager {
    return nil;
}

-(void)downloadChapterOnePage:(BMBaseParam*)baseParam
                         book:(BCTBookModel*)bookmodel {
    NSInteger pageSize = 10;
    NSInteger curPageEnd = bookmodel.finishChapterNumber + pageSize;
    BCTSessionManager *sessionManager = [self sessionManager];
    
    __weak id<BCIBookEngine> weakSelf = self;
    NSInteger i = bookmodel.finishChapterNumber;
    while (i < curPageEnd && i < [bookmodel.aryChapterList count]) {
        
        BCTBookChapterModel* bookchaptermodel = [bookmodel.aryChapterList objectAtIndex:i];
        i++;
        usleep(100);
        
        // Get chapter url
        NSString *strUrl = bookchaptermodel.url;
        strUrl = [strUrl stringByReplacingOccurrencesOfString:[sessionManager getBaseUrl] withString:@""];
        
        // completion block
        void (^completionBlock)(BMBaseParam *baseParam, BCTBookModel *bookmodel) = ^void(BMBaseParam *baseParam, BCTBookModel *bookmodel) {
            
            bookmodel.finishChapterNumber++;
            
            if (baseParam.withresultobjectblock) {
                if (bookmodel.finishChapterNumber == [bookmodel.aryChapterList count]) {
                    
                    [bookmodel savePlist];
                    
                    baseParam.withresultobjectblock(0, @"finished", nil);
                    
                } else {
                    
                    if(bookmodel.finishChapterNumber == curPageEnd) {
                        [weakSelf downloadChapterOnePage:baseParam book:bookmodel];
                    }
                    
                    baseParam.withresultobjectblock(0, @"downloading", nil);
                }
            }
        };
        
        // Start downloading
        [sessionManager GET:strUrl parameters:nil progress:nil
                                        success:^(NSURLSessionDataTask * __unused task, id responseObject) {
            
            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:0x80000632];
            bookchaptermodel.htmlContent = [weakSelf getChapterContent:responseStr];
            bookchaptermodel.content = [weakSelf getChapterContentText:bookchaptermodel.htmlContent];
            
            completionBlock(baseParam, bookmodel);
            
        } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
            
            NSLog(@"%@",[error userInfo]);
            
            completionBlock(baseParam, bookmodel);
        }];
    }
}

@end
