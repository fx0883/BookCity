//
//  BookModel.m
//  AFNetworking Example
//
//  Created by apple on 15/12/29.
//
//

#import "BookModel.h"
#import "BookChapterModel.h"
#import "BookCategoryModel.h"
#import "BMUtilDefine.h"

@implementation BookModel

-(NSMutableDictionary*)toDic
{
    NSMutableDictionary *retDic = [NSMutableDictionary new];
    [retDic setObject:self.author forKey:@"author"];
    [retDic setObject:@"no_cover.png" forKey:@"cover"];
    [retDic setObject:@"" forKey:@"isbn"];
    [retDic setObject:@"999" forKey:@"order"];
    [retDic setObject:@"default.png" forKey:@"src"];
    [retDic setObject:@"已完成" forKey:@"status"];
    [retDic setObject:self.title forKey:@"title"];
    
    
    NSMutableArray *aryPartTitle = [NSMutableArray new];
    [aryPartTitle addObject:@"章节列表"];
    [retDic setObject:aryPartTitle forKey:@"partTitleArr"];
    
    NSMutableArray *aryChapter= [NSMutableArray new];
    NSMutableArray *aryChapter2= [NSMutableArray new];
    
    for (NSInteger i = 0; i < [self.aryChapterList count]; i++) {
        BookChapterModel *bookchaptermodel = [self.aryChapterList objectAtIndex:i];
        
        NSMutableDictionary *chapterDic = [NSMutableDictionary new];
        
        [chapterDic setObject:bookchaptermodel.content forKey:@"chapterContent"];
        [chapterDic setObject:@"" forKey:@"chapterSrcs"];
        [chapterDic setObject:bookchaptermodel.title forKey:@"chapterTitle"];
        [chapterDic setObject:@"" forKey:@"href"];
        
        [aryChapter2 addObject:chapterDic];
    }
    [aryChapter addObject:aryChapter2];
    
    [retDic setObject:aryChapter forKey:@"chapterArrArr"];
    
    return retDic;
}

-(Boolean)savePlist
{
    NSString *plistFile = [NSString stringWithFormat:@"%@/%@.plist",DocumentsDir,self.title];
    NSMutableDictionary *bookDic = [self toDic];
    
    
    return [bookDic writeToFile:plistFile atomically:YES];
}
@end
