//
//  ChapterDetailViewController.h
//  BookCity
//
//  Created by apple on 16/1/16.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookChapterModel.h"

@interface ChapterDetailViewController : UIViewController


@property (nonatomic,strong) BookChapterModel *bookChapterModel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
