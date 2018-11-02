//
//  NSString+Encoding.h
//  CommonFunction
//
//  Created by zh on 2018/6/4.
//  Copyright © 2018年 zh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encoding)


/**
   对url字符串进行编码
 */
- (NSString *)encoding;

/**
 对url字符串进行解码
 */
- (NSString *)decoding;


/**
 对url进行编码，encoding 这个编码方法不会对 , 和 : 进行编码！，如果url(如：url中有JSON串)需要对 , 或者 : 编码需要使用下面这个方法.
 */
- (NSString *)urlEncoding;



/**
 base64编码

 @return 编码后的字符串
 */
- (NSString *)base64Encoding;

/**
 base64解码

 @return 解码后字符串
 */
- (NSString *)base64Decoding;

@end
