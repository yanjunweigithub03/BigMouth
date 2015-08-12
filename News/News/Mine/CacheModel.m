//
//  CacheModel.m
//  News
//
//  Created by lanou3g on 15/7/9.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "CacheModel.h"

@implementation CacheModel

- (void)dealloc
{
    [_cache release];
    [super dealloc];
}
@end
