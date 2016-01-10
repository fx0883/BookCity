//
//  BookCell.m
//  BookCity
//
//  Created by apple on 16/1/10.
//  Copyright © 2016年 FS. All rights reserved.
//

#import "BookCell.h"
#import "BMFramework.h"
#import "BookModel.h"

@implementation BookCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBookModel:(BookModel*)bookModel
{
    [self.bookImg sd_setImageWithURL:[NSURL URLWithString:bookModel.imgSrc]
                      placeholderImage:[UIImage imageNamed:@"def.jpg"]];
    self.bookTitle.text = bookModel.title;
    self.author.text = bookModel.author;
    self.memo.text = bookModel.memo;
}




@end
