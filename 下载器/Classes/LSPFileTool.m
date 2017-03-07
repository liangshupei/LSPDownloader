//
//  LSPFileTool.m
//  下载器
//
//  Created by lsp on 17/3/6.
//  Copyright © 2017年 LSP. All rights reserved.
//

#import "LSPFileTool.h"

@implementation LSPFileTool

+ (BOOL)createDirectoryIFNotExists:(NSString *)path
{
    NSFileManager *manger = [NSFileManager defaultManager];
    if (![manger fileExistsAtPath:path]) {
        NSError *error;
        [manger createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            return NO;
        }
    }
    return YES;
}
+(BOOL)fileExistsAtPath:(NSString *)path{
    NSFileManager *manger = [NSFileManager defaultManager];
    return [manger fileExistsAtPath:path];
}
+ (long long)fileSizeAtPath:(NSString *)path{
    
        if (![self fileExistsAtPath:path]) {
            return 0;
        }
        NSFileManager *manger = [NSFileManager defaultManager];
        NSDictionary *fileInfoDic = [manger attributesOfItemAtPath:path error:nil];
       return  [fileInfoDic[NSFileSize] longLongValue];
}
+ (void)removewFileAtPath:(NSString *)path{
    if (![self fileExistsAtPath:path]) {
        return ;
    }
    NSFileManager *manger = [NSFileManager defaultManager];
    [manger removeItemAtPath:path error:nil];
}
+(void)moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath
{
    if (![self fileExistsAtPath:fromPath]) {
        return ;
    }
    NSFileManager *manger = [NSFileManager defaultManager];
    [manger moveItemAtPath:fromPath toPath:toPath error:nil];
}
@end
