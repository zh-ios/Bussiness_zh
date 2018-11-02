//
//  UIView+mainThread.m
//  PerformanceMonitor
//
//  Created by autohome on 2018/3/6.
//  Copyright © 2018年 autohome. All rights reserved.
//  检测view展示是否在主线程中进行

#import "UIView+mainThread.h"
#import <objc/runtime.h>
@implementation UIView (mainThread)


+ (void)swzMethod:(Class)cls originalM:(SEL)originalSEL swzM:(SEL)swzSEL {
    Method oriM = class_getInstanceMethod(cls, originalSEL);
    Method swzM = class_getInstanceMethod(cls, swzSEL);
    IMP swzIMP = method_getImplementation(swzM);
    IMP oriIMP = method_getImplementation(oriM);
//    IMP swzIMP = class_getMethodImplementation(cls, swzSEL);
    

    // 交换方法实现 
    BOOL addSuccess = class_addMethod(cls, originalSEL, swzIMP, method_getTypeEncoding(swzM));
    if (addSuccess) {
        class_replaceMethod(cls, swzSEL, oriIMP, method_getTypeEncoding(oriM));
    } else {
        method_exchangeImplementations(oriM, swzM);
    }
}


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL layoutSEL = @selector(setNeedsDisplay);
        SEL swzLayoutSEL = @selector(swz_setNeedsLayout);
        [self swzMethod:[self class] originalM:layoutSEL swzM:swzLayoutSEL];
        
        SEL displaySEL = @selector(setNeedsDisplay);
        SEL swzDisplaySEL = @selector(swz_setNeedsDisplay);
        [self swzMethod:[self class] originalM:displaySEL swzM:swzDisplaySEL];
        
        SEL inRectSEL = @selector(setNeedsDisplayInRect:);
        SEL swzInRectSEL = @selector(swz_setNeedsDisplayInRect:);
        [self swzMethod:[self class] originalM:inRectSEL swzM:swzInRectSEL];
    });
}

// 调用originalSEL，执行的是下面的代码实现
- (void)swz_setNeedsLayout {
    BOOL ret =  [NSThread isMainThread];
    if (!ret) {
        NSLog(@"--------------------->>>>>>>>>");
        NSAssert(0, @"UI绘制需要在主线程中进行！！！");
    }
    // 交换方法的实现之后，这个方法调用的是 originalIMP
    [self swz_setNeedsLayout];
}

- (void)swz_setNeedsDisplay {
    BOOL ret =  [NSThread isMainThread];
    if (!ret) {
        NSLog(@"--------------------->>>>>>>>>");
        NSAssert(0, @"UI绘制需要在主线程中进行！！！");
    }
    // 交换方法的实现之后，这个方法调用的是 originalIMP
    [self swz_setNeedsDisplay];
}

- (void)swz_setNeedsDisplayInRect:(CGRect)rect {
    BOOL ret =  [NSThread isMainThread];
    if (!ret) {
        NSLog(@"--------------------->>>>>>>>>");
        NSAssert(0, @"UI绘制需要在主线程中进行！！！");
    }
    // 交换方法的实现之后，这个方法调用的是 originalIMP
    [self swz_setNeedsDisplayInRect:rect];
}


@end
