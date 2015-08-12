//
//  ModelForReadList.m
//  News
//
//  Created by lanou3g on 15/7/11.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "ModelForReadList.h"
#import "ModelForListImage.h"
@implementation ModelForReadList

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"imgnewextra"]) {
        self.imagextra = [NSMutableArray array];
        NSArray *array = value;
        for (NSDictionary *dic in array) {
            ModelForListImage *model = [[ModelForListImage alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            
            [self.imagextra addObject:model];
            [model release];
        }
    }
}

- (void)dealloc
{
    [_title release];
    [_digest release];
    [_imgsrc release];
    //[_skipID release];
    [_docid release];
    //[_skipType release];
    [_imagextra release];
    [super dealloc];
}

@end
