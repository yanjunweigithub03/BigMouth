//
//  RecommendedViewController.m
//  WeGo
//
//  Created by 董胖胖 on 14-11-16.
//  Copyright (c) 2014年 liyan. All rights reserved.
//

#import "CityIDModel.h"

@implementation CityIDModel


-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"市名"]) {
        self.cityName = value;
    }
    
    if ([key isEqualToString:@"编码"]) {
        self.cityID = value;
    }
    
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        self.cityName = [dictionary objectForKey:@"市名"];
        self.cityID = [dictionary objectForKey:@"编码"];
        
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}

@end
