//
//  ChapterDetailViewController.h
//  BookCity
//
//  Created by apple on 16/1/16.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookChapterModel.h"
#import "BookModel.h"

@interface ChapterDetailViewController : UIViewController


@property (nonatomic,weak) BookChapterModel *bookChapterModel;
@property (nonatomic,strong) BookModel *bookModel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
