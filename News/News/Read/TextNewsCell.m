//
//  TextNewsCell.m
//  News
//
//  Created by lanou3g on 15/7/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "TextNewsCell.h"
#import "NSString+height.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width


@implementation TextNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self layoutCellView];
        //[self addNotificationCenter];
    }
    return self;
}

- (void)layoutCellView
{
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, WIDTH - 20, 103)];
    backImage.image = [UIImage imageNamed:@"read-back.jpeg"];
    backImage.tag = 325;
    backImage.layer.masksToBounds = YES;
    backImage.layer.cornerRadius = 5.0;
    [self.contentView addSubview:backImage];
    [backImage release];
    
    _textImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 8, 120, 90)];
    _textImage.layer.masksToBounds = YES;
    _textImage.layer.cornerRadius = 10.0;
    [backImage addSubview:_textImage];
    [_textImage release];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 5, WIDTH - 155, 30)];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [backImage addSubview:_titleLabel];
    [_titleLabel release];
    
    _digestLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 10 + _titleLabel.bounds.size.height, WIDTH - 155, 55)];
    _digestLabel.numberOfLines = 0;
    _digestLabel.font = [UIFont systemFontOfSize:12.0];
    _digestLabel.textColor = [UIColor colorWithWhite:0.335 alpha:1.000];
    [backImage addSubview:_digestLabel];
    [_digestLabel release];
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    UIImageView *backImage = (UIImageView *)[self viewWithTag:325];
    backImage.frame = CGRectMake(10, 8, WIDTH - 20, 103);
    
    CGFloat height = [NSString heightForString:_titleLabel.text size:CGSizeMake(WIDTH - 155, 1000) font:17.0];
    _titleLabel.frame = CGRectMake(130, 5, WIDTH - 155, height);
    
    _digestLabel.frame = CGRectMake(130, 5 + height, WIDTH - 155, 90 - height);
}

- (void)addNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNightStyle:) name:@"DayOrNight" object:nil];
}


- (void)changeNightStyle:(NSNotification *)notification
{
    self.backgroundColor = [notification.userInfo valueForKey:@"NightColor"];
}
- (void)dealloc
{
    [_textImage release];
    [_titleLabel release];
    [_digestLabel release];
    [super dealloc];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
