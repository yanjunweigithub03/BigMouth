//
//  ModelForList.h
//  News
//
//  Created by lanou3g on 15/7/6.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageModelForList.h"

@interface ModelForList : NSObject

@property (nonatomic , copy) NSString *title; // 标题

@property (nonatomic , copy) NSString *digest; //简介

@property (nonatomic , copy) NSString *imgsrc; //图片

@property (nonatomic , copy) NSString *skipID; //图片模式跳转ID

@property (nonatomic , copy) NSString *docid;  //文本模式跳转id

@property (nonatomic , copy) NSString *skipType; //类型

@property (nonatomic , copy) NSString *url_share; //分享

@property (nonatomic , retain) NSMutableArray *imagextra; //图片数组

@end
