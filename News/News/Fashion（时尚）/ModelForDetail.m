//
//  ModelForDetail.m
//  时昼新闻
//
//  Created by lanou3g on 15-5-3.
//  Copyright (c) 2015年 张金城. All rights reserved.
//

#import "ModelForDetail.h"

@implementation ModelForDetail


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)dealloc
{
    [_img release];
    [_ptime release];
    [_title release];
    [_body release];
    [_source release];
    [_digest release];
    [_Class release];
    [super dealloc];
}

@end
