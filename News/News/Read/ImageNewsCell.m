//
//  ImageNewsCell.m
//  News
//
//  Created by lanou3g on 15/7/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "ImageNewsCell.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation ImageNewsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
        //[self addNotificationCenter];
    }
    return self;
}

- (void)setupView
{
    _backImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"read-back.jpeg"]];
    _backImage.layer.masksToBounds = YES;
     _backImage.layer.cornerRadius = 5.0;
    
    [self addSubview:_backImage];
    [_backImage release];
    
    _mainImage = [[UIImageView alloc] init];
    _mainImage.layer.masksToBounds = YES;
    _mainImage.layer.cornerRadius = 5.0;
    
    [self addSubview:_mainImage];
    [_mainImage release];
    
    _upImage = [[UIImageView alloc] init];
    _upImage.layer.masksToBounds = YES;
    _upImage.layer.cornerRadius = 5.0;
    
    [self addSubview:_upImage];
    [_upImage release];
    
    _downImage = [[UIImageView alloc] init];
    _downImage.layer.masksToBounds = YES;
    _downImage.layer.cornerRadius = 5.0;
    
    [self addSubview:_downImage];
    [_downImage release];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
    
    [self addSubview:_titleLabel];
    [_titleLabel release];
    
    
   
    
    
   
    
    
    
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
    
    _backImage.frame = CGRectMake(10, 10, WIDTH - 20, 181);
    _mainImage.frame = CGRectMake(10, 10, (WIDTH - 20) / 3 * 2 - 3, 150);
    _downImage.frame = CGRectMake(10 + (WIDTH - 20) / 3 * 2, 86, (WIDTH - 20) / 3, 74);
    _upImage.frame = CGRectMake(10 + (WIDTH - 20) / 3 * 2, 10, (WIDTH - 20) / 3, 74);
    _titleLabel.frame = CGRectMake(13, 160, WIDTH - 26, 31);
    

}

- (void)addNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNightStyle:) name:@"DayOrNight" object:nil];
}


- (void)changeNightStyle:(NSNotification *)notification
{
    self.backgroundColor = [notification.userInfo valueForKey:@"NightColor"];
    _titleLabel.textColor = [notification.userInfo valueForKey:@"DayColor"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_mainImage release];
    [_upImage release];
    [_downImage release];
    [_titleLabel release];
    [_backImage release];
    [super dealloc];
}
@end
