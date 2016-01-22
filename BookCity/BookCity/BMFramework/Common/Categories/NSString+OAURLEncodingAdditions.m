//
//  NSString+OAURLEncodingAdditions.m
//  BookCity
//
//  Created by apple on 16/1/6.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "NSString+OAURLEncodingAdditions.h"

@implementation
NSString (OAURLEncodingAdditions)
- (NSString *)URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
//    [result autorelease];
    return result;
}

- (NSString*)URLDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)self, CFSTR(""),kCFStringEncodingUTF8));
    
//    CFSTR(""),kCFStringEncodingUTF8));
//    [result autorelease];
    return result;
}




//转码
-(NSString *)ConvertUTF8
{
    NSMutableString *keyWord = [NSMutableString stringWithFormat:@""];
for (int i=0; i<[self length]; i++) {
    
    NSUInteger location = i;
    
    unichar temp = [self characterAtIndex:location];
    
    NSString *str = [NSString stringWithFormat: @"%C", temp];
    
    //NSLog(@"str = %@", str);
    
    NSString *str2 = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSLog(@"str2 = %@", str2);
    
    [keyWord appendString:str2];
    
    [keyWord appendString:@";"];
    
}
    return keyWord;
}


-(NSString *)ConvertUTF16Big
{
    NSMutableString *strResult = [NSMutableString stringWithFormat:@""];
    
    
    for (int i=0; i<[self length]; i++) {
        
        NSUInteger location = i;
        
        unichar temp = [self characterAtIndex:location];
        
        NSString *str = [NSString stringWithFormat: @"%C", temp];
        
        //NSLog(@"str = %@", str);
        
        NSString *str2 = [str stringByAddingPercentEscapesUsingEncoding:NSUTF16BigEndianStringEncoding];
        
        //NSLog(@"str2 = %@", str2);
        
        str2 =  [str2 stringByReplacingOccurrencesOfString:@"%" withString:@""];
        
        [strResult appendString:[NSString stringWithFormat:@"%%u%@",str2 ]];
        
//        [keyWord appendString:@";"];
    }
    
//    NSString *strResult = [self stringByAddingPercentEscapesUsingEncoding:NSUTF16BigEndianStringEncoding];
//    strResult =  [strResult stringByReplacingOccurrencesOfString:@"%" withString:@""];
    
    return strResult;
}

-(NSString *)URLEncodedStringGB_18030_2000
{
    //    NSString *str = @"校花";
//    NSString *str = @"hello";
    NSStringEncoding encGB_18030_2000 = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
    
//    NSString *strUTF8 = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *strGB_18030_2000 = [self stringByAddingPercentEscapesUsingEncoding:encGB_18030_2000];
    return strGB_18030_2000;

}

@end
