//
//  ModelForListImage.m
//  News
//
//  Created by lanou3g on 15/7/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "ModelForListImage.h"

@implementation ModelForListImage

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)dealloc
{
    [_imgsrc release];
    [super dealloc];
}

@end
