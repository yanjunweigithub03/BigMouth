//
//  ModelForList.m
//  News
//
//  Created by lanou3g on 15/7/6.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "ModelForList.h"

@implementation ModelForList


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"url"]) {
        self.url_share = value;
    }
    if ([key isEqualToString:@"imgextra"]) {
        self.imagextra = [NSMutableArray array];
        for (NSDictionary *imageDic in value) {
            
            ImageModelForList *iModel = [[ImageModelForList alloc] init];
            [iModel setValuesForKeysWithDictionary:imageDic];
            
            [self.imagextra addObject:iModel];
            
            [iModel release];
        }
    }
}


- (void)dealloc
{
    [_title release];
    [_digest release];
    [_imgsrc release];
    [_skipID release];
    [_docid release];
    [_skipType release];
    [_imagextra release];
    [super dealloc];
}


@end
