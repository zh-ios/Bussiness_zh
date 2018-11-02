//
//  NSString+stringUtil.h
//  CommonFunction
//
//  Created by zh on 2018/6/1.
//  Copyright © 2018年 zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (stringUtil)

/**
 是否是有效的字符串，去除字符串中的空格和换行之后，字符串长度是否大于0
 */
- (BOOL)isValidateString;


/**
 去掉字符串中的空格和换行符
 */
- (NSString *)trimingWhiteSpaceAndNewline;

@end
