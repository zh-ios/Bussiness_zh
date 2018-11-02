//
//  UIImage+color.m
//  CommonFunction
//
//  Created by zh on 2018/6/21.
//  Copyright © 2018年 zh. All rights reserved.
//

#import "UIImage+color.h"

@implementation UIImage (color)

+ (UIImage *)imageFromColor:(UIColor *)color size:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ref, color.CGColor);
    CGContextFillRect(ref, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageFromColor:(UIColor *)color {
    return [self imageFromColor:color size:CGSizeMake(1.f, 1.f)];
}

@end
