//
//  ImageModelForList.m
//  News
//
//  Created by lanou3g on 15/7/6.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "ImageModelForList.h"

@implementation ImageModelForList

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)dealloc
{
    [_imgsrc release];
    [super dealloc];
}

@end
