//
//  NSString+OAURLEncodingAdditions.h
//  BookCity
//
//  Created by apple on 16/1/6.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (OAURLEncodingAdditions)
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

-(NSString *)ConvertUTF8;

-(NSString *)ConvertUTF16Big;

-(NSString *)URLEncodedStringGB_18030_2000;
@end
