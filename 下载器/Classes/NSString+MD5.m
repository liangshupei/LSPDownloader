//
//  NSString+MD5.m
//  下载器
//
//  Created by 梁书培 on 17/3/7.
//  Copyright © 2017年 LSP. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

- (NSString *)md5Str{
        //c字符串
        //c字符串长度
        const char *data = [self UTF8String];
        unsigned char  result[CC_MD5_DIGEST_LENGTH];
        //结果
        CC_MD5(data, (CC_LONG)strlen(data), result);
        NSMutableString *results = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH *2];
        
        for (int i = 0;  i < CC_MD5_DIGEST_LENGTH; i++) {
            [results appendFormat:@"%02x",result[i]];
        }
        return results;
}

@end
