//
//  FTwoTableViewCell.m
//  News
//
//  Created by lanou3g on 15/7/1.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "FTwoTableViewCell.h"
#import "shareView.h"

@implementation FTwoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)dealloc {
    [_imageView1 release];
    [_Label1 release];
    [super dealloc];
}
@end
