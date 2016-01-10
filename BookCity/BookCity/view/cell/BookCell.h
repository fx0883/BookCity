//
//  BookCell.h
//  BookCity
//
//  Created by apple on 16/1/10.
//  Copyright © 2016年 FS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"
#import "BookModel.h"

@interface BookCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *bookImg;

@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *memo;


- (void)setBookModel:(BookModel*)bookModel;
@end
