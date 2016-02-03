//
//  So23wxSessionManager.h
//  BookCity
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface So23wxSessionManager : AFHTTPSessionManager

+ (instancetype)sharedClient;

+ (NSString*)getBaseUrl;
@end