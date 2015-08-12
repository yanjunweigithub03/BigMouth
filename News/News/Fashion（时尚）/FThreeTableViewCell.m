//
//  FThreeTableViewCell.m
//  News
//
//  Created by lanou3g on 15/7/1.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "FThreeTableViewCell.h"
#import "shareView.h"

@implementation FThreeTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [_imageView1 release];
    [_label1 release];
    [_label2 release];
    [super dealloc];
}
@end
