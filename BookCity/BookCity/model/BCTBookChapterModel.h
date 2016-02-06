//
//  BookChapterModel.h
//  BookCity
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCTBookChapterModel : NSObject


@property (nonatomic,strong) NSString *hostUrl;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *content;


@property (nonatomic,strong) NSString *htmlContent;

@end
