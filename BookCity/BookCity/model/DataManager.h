//
//  DataManager.h
//  BookCity
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject
AS_SINGLETON(DataManager)

@property (nonatomic,strong) NSMutableArray *bookCategory;



@end
