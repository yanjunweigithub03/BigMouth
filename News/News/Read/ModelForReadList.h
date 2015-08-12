//
//  ModelForReadList.h
//  News
//
//  Created by lanou3g on 15/7/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelForReadList : NSObject

@property (nonatomic , copy) NSString *title; //标题

@property (nonatomic , copy) NSString *digest;//简介

@property (nonatomic , copy) NSString *imgsrc; //图片

//@property (nonatomic , copy) NSString *skipID;

@property (nonatomic , copy) NSString *docid; //跳转id

//@property (nonatomic , copy) NSString *skipType;

@property (nonatomic , retain) NSMutableArray *imagextra;//图片数组

@end
