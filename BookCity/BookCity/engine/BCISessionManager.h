//
//  BCISessionManager.h
//  BookCity
//
//  Created by Dong Yiming on 16/4/23.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BCISessionManager <NSObject>

+ (instancetype)sharedClient;

- (NSString*)getBaseUrl;

@end
