//
//  BookChapterModel.m
//  BookCity
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "BCTBookChapterModel.h"

@implementation BCTBookChapterModel

-(id)init
{
//    1 - (id) init
//    2 {
//        3 if ( self = [super init] )
//            4 {
//                5 // Class-specific initializations
//                6 }
//        7 return self;
//        8 }
    
    if (self = [super init])
    {
        self.hostUrl = @"";
        self.title = @"";
        self.url = @"";
        self.content = @"";
        
        
        self.htmlContent = @"";
        
    }
    return self;
}

@end
