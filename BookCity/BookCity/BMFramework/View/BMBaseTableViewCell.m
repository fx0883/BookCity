//
//  BMBaseTableViewCell.m
//  BMCoreFramework
//
//  Created by fx on 14-8-19.
//  Copyright (c) 2014年 bluemobi. All rights reserved.
//

#import "BMBaseTableViewCell.h"

@implementation BMBaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
