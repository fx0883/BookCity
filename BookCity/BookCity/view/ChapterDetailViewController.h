//
//  ChapterDetailViewController.h
//  BookCity
//
//  Created by apple on 16/1/16.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCTBookChapterModel.h"
#import "BCTBookModel.h"

@interface ChapterDetailViewController : UIViewController


@property (nonatomic,weak) BCTBookChapterModel *bookChapterModel;
@property (nonatomic,strong) BCTBookModel *bookModel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
