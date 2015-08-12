//
//  FOneTableViewCell.m
//  News
//
//  Created by lanou3g on 15/7/1.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "FOneTableViewCell.h"
#import "shareView.h"

@implementation FOneTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)dealloc {
    [_titleLab release];
    [_imageView1 release];
    [_imageView2 release];
    [_imageView3 release];
    [super dealloc];
}
@end
