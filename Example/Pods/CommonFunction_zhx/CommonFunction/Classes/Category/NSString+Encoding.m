//
//  NSString+Encoding.m
//  CommonFunction
//
//  Created by zh on 2018/6/4.
//  Copyright © 2018年 zh. All rights reserved.
//

#import "NSString+Encoding.h"

@implementation NSString (Encoding)


- (NSString *)encoding {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSString *)decoding {
    return [self stringByRemovingPercentEncoding];
}

- (NSString *)urlEncoding {
    NSAssert([self isKindOfClass:[NSString class]], @"request parameters can be only of NSString or NSNumber classes.");
    NSString *str = (NSString *)self;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                 NULL,
                                                                                 (__bridge CFStringRef)str,
                                                                                 NULL,
                                                                                 (CFStringRef)@"!*'();:@&=+$,/?#[]",
                                                                                 kCFStringEncodingUTF8));

    
}

- (NSString *)base64Encoding {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64Str ? base64Str : @"";
}

- (NSString *)base64Decoding {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str ? str : @"";
}
@end
