//
//  BCTSessionManager.h
//  BookCity
//
//  Created by Dong Yiming on 16/4/23.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "BCISessionManager.h"

@interface BCTSessionManager : AFHTTPSessionManager <BCISessionManager>

@end
