//
//  UIColor+HexString.h
//  CommonFunction
//
//  Created by zh on 2018/6/7.
//  Copyright © 2018年 zh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)

+ (UIColor *)colorWithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)hexStr;

+ (UIColor *)colorWithRGB:(NSInteger)r G:(NSInteger)g B:(NSInteger)b alpha:(CGFloat)alpha;

+ (UIColor *)colorWithRGB:(NSInteger)r G:(NSInteger)g B:(NSInteger)b;

@end
