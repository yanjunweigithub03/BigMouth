//
//  Network.h
//  UI---异步加载
//
//  Created by lanou3g on 15/6/16.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^Block) (id tempObj);
@interface Network : NSObject

+ (void)receivedDataWithURLString:(NSString *)string method:(NSString *)mehod body:(NSString *)body block:(Block)block;

@end
