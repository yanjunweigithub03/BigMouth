//
//  VideoTableViewCell.h
//  News
//
//  Created by lanou3g on 15/7/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *BackImage;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIImageView *videoImage; 
@property (retain, nonatomic) IBOutlet UIImageView *runImage; //播放图标

@end
