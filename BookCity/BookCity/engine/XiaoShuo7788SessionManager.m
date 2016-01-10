//
//  XiaoShuo7788SessionManager.m
//  BookCity
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "XiaoShuo7788SessionManager.h"

static NSString * const BaseURLString = @"http://www.7788xiaoshuo.com/";






@implementation XiaoShuo7788SessionManager

+ (instancetype)sharedClient {
    static XiaoShuo7788SessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[XiaoShuo7788SessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
        // _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        //        manager.responseSerializer.acceptableContentTypes
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
        
        //        _sharedClient.requestSerializer= [AFHTTPRequestSerializer serializer];
        _sharedClient.responseSerializer= [AFHTTPResponseSerializer serializer];
    });
    
    return _sharedClient;
}

@end
