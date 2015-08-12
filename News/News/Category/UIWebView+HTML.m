//
//  UIWebView+HTML.m
//  News
//
//  Created by lanou3g on 15/7/5.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "UIWebView+HTML.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation UIWebView (HTML)

#pragma mark 把model类的文件重新赋值并给html
- (NSString *)setUpData:(ModelForDetail *)model
{
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"html" ofType:@"txt"];
    
    NSMutableString * str = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSString * cssPath = [[NSBundle mainBundle] pathForResource:@"htmlCSS" ofType:@"css"];
    
    NSRange rangeOfCSSPath = [str rangeOfString:@"#CSSPath#"];
    
    [str replaceCharactersInRange:rangeOfCSSPath withString:cssPath];
    
    NSRange titleRange = [str rangeOfString:@"#title#"];
    NSString *titleStr1 = @"\n";
    NSString *titleString = [titleStr1 stringByAppendingString:model.title];
    [str replaceCharactersInRange:titleRange withString:titleString];
    
    //self.digestString = model.digest;
    
    
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSInteger myInteger = [userDefaultes integerForKey:@"ReadSwitchIsOn"];
    [userDefaultes synchronize];
    if (myInteger != 1) {
        
        NSRange sourceRange = [str rangeOfString:@"#source#"];
        if (model.source)
        {
            [str replaceCharactersInRange:sourceRange withString:model.source];
        }
        
    }
    NSRange timeRange = [str rangeOfString:@"#time#"];
    if (model.ptime)
    {
        [str replaceCharactersInRange:timeRange withString:[model.ptime substringFromIndex:5]];
        
        //self.ptimeString = (NSMutableString *)[model.ptime substringToIndex:13];
    }
    
    
    NSRange bodyRange = [str rangeOfString:@"#body#"];
    if (model.body)
    {
        
        [str replaceCharactersInRange:bodyRange withString:model.body];
        
        for (NSDictionary * dict in model.img)
        {
            NSArray * arr = [dict[@"pixel"] componentsSeparatedByString:@"*"];
            int a = [arr[0] intValue];
            int b = [arr[1] intValue];
            if ([[dict objectForKey:@"alt"] length] != 0 && (a != 0))
            {
                NSMutableString *imgHtml = [NSMutableString stringWithFormat:@"<img class=\"content-image\" src=\"%@\" alt=\"\" width = %@px height = %@px /><p style=\"font-size:14px\">%@</p>",[dict objectForKey:@"src"],[NSString stringWithFormat:@"%f",WIDTH - 20],[NSString stringWithFormat:@"%f",(WIDTH - 20)*b/a],[dict objectForKey:@"alt"]];
                NSRange rangeOfImg = [str rangeOfString:[dict objectForKey:@"ref"]];
                if (rangeOfImg.length != 0)
                {
                    [str replaceCharactersInRange:rangeOfImg withString:imgHtml];
                }
            }else
            {
                NSMutableString * imgHtml = [NSMutableString stringWithFormat:@"<img class=\"content-image\" src=\"%@\" width = %@px height = %@px />",[dict objectForKey:@"src"],[NSString stringWithFormat:@"%f",WIDTH - 20],[NSString stringWithFormat:@"%f",(WIDTH - 20)*b/a]];
                NSRange rangeOfImg = [str rangeOfString:[dict objectForKey:@"ref"]];
                if (rangeOfImg.length != 0)
                {
                    [str replaceCharactersInRange:rangeOfImg withString:imgHtml];
                }
            }
        }
    }
    

    return str;
}




@end
