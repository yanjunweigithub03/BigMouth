//
//  VideoTableViewCell.m
//  News
//
//  Created by lanou3g on 15/7/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "VideoTableViewCell.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation VideoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadView];
        //[self addNotificationCenter];
    }
    return self;
}

- (void)loadView
{
    _videoImage = [[UIImageView alloc] init];
    //_videoImage.image = [UIImage imageNamed:@"video-back.jpg"];
    _videoImage.backgroundColor = [UIColor whiteColor];
    [self addSubview:_videoImage];
    
    _BackImage = [[UIImageView alloc] init];
    [self addSubview:_BackImage];
    
    _runImage = [[UIImageView alloc] init];
    _runImage.image = [UIImage imageNamed:@"iconfont-bofang.png"];
    [_BackImage addSubview:_runImage];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [_videoImage addSubview:_titleLabel];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _videoImage.frame = CGRectMake(10, 8, WIDTH - 20, 181);
    _videoImage.layer.borderColor = [UIColor colorWithRed:0.845 green:0.667 blue:0.481 alpha:1.000].CGColor;
    _videoImage.layer.borderWidth = 1.0;
    
    _BackImage.frame = CGRectMake(11, 9, WIDTH - 22, 158);
    
    _titleLabel.frame = CGRectMake(4, 160, WIDTH - 28, 21);
    
    _runImage.frame = CGRectMake((WIDTH - 20) / 2 - 32, 48, 64, 64);
    
}

- (void)addNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNightStyle:) name:@"DayOrNight" object:nil];
}


- (void)changeNightStyle:(NSNotification *)notification
{
    self.backgroundColor = [notification.userInfo valueForKey:@"NightColor"];
    _videoImage.backgroundColor = [notification.userInfo valueForKey:@"NightColor"];
    _titleLabel.textColor = [notification.userInfo valueForKey:@"DayColor"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_BackImage release];
    [_titleLabel release];
    [_videoImage release];
    [_runImage release];
    [super dealloc];
}
@end
