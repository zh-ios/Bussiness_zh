//
//  UIView+ExtendHitArea.h
//  CommonFunction
//
//  Created by zh on 2018/6/8.
//  Copyright © 2018年 zh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ExtendHitArea)

/*!
 @property
 @abstract 要扩展的区域
 @如上下左右扩展20的可点击区域 extendedHitArea = {20,20,20,20};
 */
@property(nonatomic, assign) CGRect extendedHitArea;
// or
- (void)extendHitAreaTop:(CGFloat)top
                    left:(CGFloat)left
                  bottom:(CGFloat)bottom
                   right:(CGFloat)right;

@end
