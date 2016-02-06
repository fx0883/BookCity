//
//  DataManager.h
//  BookCity
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCTDataManager : NSObject
AS_SINGLETON(BCTDataManager)



@property (nonatomic,strong) NSMutableArray *bookCategory;

@property (nonatomic,strong) NSMutableDictionary *dicBooksCategoryAry;

-(NSMutableArray*)getBookArybyCategoryname:(NSString*)strCategoryname;

@end
