//
//  RecommendedViewController.m
//  WeGo
//
//  Created by 董胖胖 on 14-11-16.
//  Copyright (c) 2014年 liyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityIDModel : NSObject

@property (nonatomic, retain)NSString *cityName;
@property (nonatomic, retain)NSString *cityID;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
