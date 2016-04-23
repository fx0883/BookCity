//
//  BCIBookEngine.h
//  BookCity
//
//  Created by Dong Yiming on 16/4/21.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BMBaseParam;
@class BCTSessionManager;
@class BCTBookModel;

@protocol BCIBookEngine <NSObject>

- (BCTSessionManager *)sessionManager;

- (NSString*)getChapterContent:(NSString*)strSource;

- (NSString*)getChapterContentText:(NSString*)strSource;

- (void)getSearchBookResult:(BMBaseParam*)baseParam;

- (void)getCategoryBooksResult:(BMBaseParam*)baseParam;

- (void)getBookChapterList:(BMBaseParam*)baseParam;

- (void)getBookChapterDetail:(BMBaseParam*)baseParam;

- (void)downloadplist:(BMBaseParam*)baseParam;

- (void)downloadChapterOnePage:(BMBaseParam*)baseParam
                         book:(BCTBookModel*)bookmodel;

@end
