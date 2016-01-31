//
//  BookCategoryModel.h
//  BookCity
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>


#define DESCRIPTION @"description"
#define ORDER @"order"
#define CATEGORYNAME @"categoryname"
#define URL @"url"
#define URLARY @"urlAry"



@interface BookCategoryModel : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *strUrl;
@property (nonatomic,strong) NSString *categoryDescription;
@property (readwrite) NSInteger curIndex;

@property (nonatomic,strong) NSMutableArray *aryUrl;

@end
