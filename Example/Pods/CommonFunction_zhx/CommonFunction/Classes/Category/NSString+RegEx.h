//
//  NSString+RegEx.h
//  CommonFunction
//
//  Created by zh on 2018/6/1.
//  Copyright © 2018年 zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegEx)


/**
 校验是否是合法的电话号码、邮箱、密码、名字
 */
- (BOOL)isPhoneNumber;

- (BOOL)isEmail;

- (BOOL)isPassword;

- (BOOL)isUserName;

- (BOOL)isHttpURL;

- (BOOL)isIDCardNumber;

@end
