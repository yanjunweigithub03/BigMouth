//
//  CollectButton.h
//  News
//
//  Created by lanou3g on 15/7/7.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CollectButtonDelegate <NSObject>

@optional
- (void)collectButtonAction:(UIButton *)btn;

@end

@interface CollectButton : UIView

@property (nonatomic , assign) id<CollectButtonDelegate> delegate;



- (void)setupButton:(CGRect)frame isCollect:(BOOL)isCollect;

@end
