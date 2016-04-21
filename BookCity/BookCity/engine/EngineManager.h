//
//  SearchEngineManage.h
//  BookCity
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMFramework.h"
#import "BCIBookEngine.h"

@interface EngineManager : NSObject <BCIBookEngine>
AS_SINGLETON(EngineManager)

-(void)registerEngine:(id<BCIBookEngine>)bookEngine;

@end
