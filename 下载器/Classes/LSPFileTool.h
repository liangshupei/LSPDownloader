//
//  LSPFileTool.h
//  下载器
//
//  Created by lspon 17/3/6.
//  Copyright © 2017年 LSP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSPFileTool : NSObject

+ (BOOL)createDirectoryIFNotExists:(NSString *)path;

+ (BOOL)fileExistsAtPath:(NSString *)path;

+ (long long)fileSizeAtPath:(NSString *)path;

+ (void)removewFileAtPath:(NSString *)path;
+(void)moveFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath;
@end
