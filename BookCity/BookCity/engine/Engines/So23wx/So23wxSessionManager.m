//
//  So23wxSessionManager.m
//  BookCity
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "So23wxSessionManager.h"





static NSString * const BaseURLString = @"http://so.23wx.com/";


@implementation So23wxSessionManager

+ (instancetype)sharedClient {
    static So23wxSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
//        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//        [config setHTTPAdditionalHeaders:@{ @"User-Agent" : @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.4.4 (KHTML, like Gecko) Version/9.0.3 Safari/601.4.4"}];
//        _sharedClient = [[So23wxSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString] sessionConfiguration:config];     
        
        _sharedClient = [[So23wxSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];

        // _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        //        manager.responseSerializer.acceptableContentTypes
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
        
        //        _sharedClient.requestSerializer= [AFHTTPRequestSerializer serializer];
        _sharedClient.responseSerializer= [AFHTTPResponseSerializer serializer];
        
        [_sharedClient.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/601.4.4 (KHTML, like Gecko) Version/9.0.3 Safari/601.4.4" forHTTPHeaderField:@"User-Agent"];
//        
//                [self setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    });
    
    return _sharedClient;
}

- (NSString*)getBaseUrl
{
    return BaseURLString;
}

@end