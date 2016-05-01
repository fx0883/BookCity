//
//  SiKushuSessionManager.h
//  BookCity
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SiKushuSessionManager : AFHTTPSessionManager

+ (instancetype)sharedClient;

+ (NSString*)getBaseUrl;

@end
