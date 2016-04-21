//
//  H23wxSessionManager.m
//  BookCity
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "H23wxSessionManager.h"



static NSString * const BaseURLString = @"http://www.23wx.com/";


@implementation H23wxSessionManager

+ (instancetype)sharedClient {
    static H23wxSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[H23wxSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
        // _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        //        manager.responseSerializer.acceptableContentTypes
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
        
        //        _sharedClient.requestSerializer= [AFHTTPRequestSerializer serializer];
        _sharedClient.responseSerializer= [AFHTTPResponseSerializer serializer];
    });
    
    return _sharedClient;
}

+ (NSString*)getBaseUrl
{
    return BaseURLString;
}
@end