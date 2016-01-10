//
//  BookModel.h
//  AFNetworking Example
//
//  Created by apple on 15/12/29.
//
//

#import <Foundation/Foundation.h>

@interface BookModel : NSObject


@property (nonatomic, strong) NSString *bookId;
@property (nonatomic, strong) NSString *chapterId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *imgSrc;

@property (nonatomic, strong) NSString *wordCount;
@property (nonatomic, strong) NSString *cateogryName;
@property (nonatomic, strong) NSString *subCategoryName;

@property (nonatomic, strong) NSString *isFinally;

@property (nonatomic, strong) NSString *memo;
@property (nonatomic, strong) NSString *lastModify;
@property (nonatomic, strong) NSString *bookLink;


@property (nonatomic, strong) NSString *chapterList;



@end
