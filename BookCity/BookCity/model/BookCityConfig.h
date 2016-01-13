//
//  BookCityConfig.h
//  BookCity
//
//  Created by apple on 16/1/11.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookCityConfig : NSObject
AS_SINGLETON(BookCityConfig)


@property (nonatomic,strong) NSDictionary *dicConfig;
@property (nonatomic,strong) NSArray *bookCategory;

@end
