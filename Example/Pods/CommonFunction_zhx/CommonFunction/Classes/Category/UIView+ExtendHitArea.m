//
//  UIView+ExtendHitArea.m
//  CommonFunction
//
//  Created by zh on 2018/6/8.
//  Copyright © 2018年 zh. All rights reserved.
//

#import "UIView+ExtendHitArea.h"
#import <objc/runtime.h>
@implementation UIView (extendHitArea)

//static const void *nameKey = &nameKey;
static char *kLeft_extendKey;
static char *kRight_extendKey;
static char *kBottom_extendKey;
static char *kTop_extendKey;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalM = class_getInstanceMethod([self class], @selector(pointInside:withEvent:));
        Method swzM = class_getInstanceMethod([self class], @selector(swz_pointInside:withEvent:));
        
        SEL originalSelector = @selector(pointInside:withEvent:);
        SEL swzSelector = @selector(swz_pointInside:withEvent:);
        
        BOOL addMethod = class_addMethod([self class], originalSelector, method_getImplementation(swzM), method_getTypeEncoding(swzM));
        if (addMethod) {
            //     当前类本身没有实现需要替换的原方法，而是继承了父类 如：没有实现 - (void)viewWillAppear:(BOOL)animated ，class_addMethod 方法返回 YES 。这时使用 class_getInstanceMethod 函数获取到的 originalSelector 指向的就是父类的方法，我们再通过执行 class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod)); 将原方法替换到我们自定义的方法中。这样就达到了在 swz_pointInside:withEvent: 方法的实现中调用父类实现的目的。
            class_replaceMethod([self class], swzSelector, method_getImplementation(originalM), method_getTypeEncoding(originalM));
        } else {
//            主类本身有实现需要替换的方法，也就是 class_addMethod 方法返回 NO 。这种情况的处理比较简单，直接交换两个方法的实现就可以了
            method_exchangeImplementations(originalM, swzM);
        }
        
        // 本质都是交换两个方法的实现 原方法-->被交换方法的实现 ， 被交换方法的实现-->原方法的实现 。
    });
}

- (void)setExtendedHitArea:(CGRect)extendedHitArea {
    objc_setAssociatedObject(self, @selector(extendedHitArea), @(extendedHitArea), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)extendedHitArea {
    CGRect rect = [objc_getAssociatedObject(self, @selector(extendedHitArea)) CGRectValue];
    if (CGRectEqualToRect(rect, CGRectZero)) {
        return self.bounds;
    }
    return rect;
}

/*!
 @method 可以响应点击事件的rect
 */
- (CGRect)responseHitArea {
    CGRect extendedHitArea = [objc_getAssociatedObject(self, @selector(extendedHitArea)) CGRectValue];
    if (!CGRectEqualToRect(extendedHitArea, CGRectZero)) {
        return                       CGRectMake(
                                                self.bounds.origin.x-extendedHitArea.origin.x,
                                                self.bounds.origin.y-extendedHitArea.origin.y,
                                                self.bounds.size.width+extendedHitArea.origin.x+extendedHitArea.size.width,
                                                self.bounds.size.height+extendedHitArea.origin.y+extendedHitArea.size.height);
        
    } else {
        return self.bounds;
    }
}

- (BOOL)swz_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL result = [self swz_pointInside:point withEvent:event];
    CGRect responseHitArea = [self responseHitArea];
    BOOL ret = ( result
                ||CGRectEqualToRect(responseHitArea, CGRectZero)
                ||!self.isUserInteractionEnabled
                ||self.isHidden);
    if (ret) return result;
    return CGRectContainsPoint(responseHitArea, point);
}


/////////////////////////////////////////////////////////////////////////


- (CGRect)resonseHitArea_associateObj {
    NSNumber *left = objc_getAssociatedObject(self, kLeft_extendKey);
    NSNumber *top = objc_getAssociatedObject(self, kTop_extendKey);
    NSNumber *right = objc_getAssociatedObject(self, kRight_extendKey);
    NSNumber *bottom = objc_getAssociatedObject(self, kBottom_extendKey);
    if (left&&top&&right&&bottom) {
        return CGRectMake(
                          self.bounds.origin.x-left.floatValue,
                          self.bounds.origin.y-top.floatValue,
                          self.bounds.size.width+left.floatValue+right.floatValue,
                          self.bounds.size.height+top.floatValue+bottom.floatValue);
    } else {
        return self.bounds;
    }
}

- (void)extendHitAreaTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right {
    objc_setAssociatedObject(self, kLeft_extendKey, @(left), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kBottom_extendKey, @(bottom), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kRight_extendKey, @(right), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kTop_extendKey, @(top), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.isHidden||!self.isUserInteractionEnabled) {
        return NO;
    }
    CGRect responseArea = [self resonseHitArea_associateObj];
    return CGRectContainsPoint(responseArea, point);
}

@end
