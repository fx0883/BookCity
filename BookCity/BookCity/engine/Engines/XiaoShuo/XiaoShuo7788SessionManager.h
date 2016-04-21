//
//  XiaoShuo7788SessionManager.h
//  BookCity
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XiaoShuo7788SessionManager : AFHTTPSessionManager

+ (instancetype)sharedClient;

+ (NSString*)getBaseUrl;
@end
