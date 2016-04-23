//
//  SiKushuSessionManager.m
//  BookCity
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "SiKushuSessionManager.h"

static NSString * const BaseURLString = @"http://www.sikushu.com/";


@implementation SiKushuSessionManager

+ (instancetype)sharedClient {
    static SiKushuSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[SiKushuSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
        // _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        
        _sharedClient.requestSerializer.stringEncoding = enc;
        //        manager.responseSerializer.acceptableContentTypes
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
        
        //        _sharedClient.requestSerializer= [AFHTTPRequestSerializer serializer];
        _sharedClient.responseSerializer= [AFHTTPResponseSerializer serializer];
    });
    
    return _sharedClient;
}

- (NSString*)getBaseUrl
{
    return BaseURLString;
}

@end
