//
//  LSPDownLoaderManager.m
//  下载器
//
//  Created by 梁书培 on 17/3/7.
//  Copyright © 2017年 LSP. All rights reserved.
//

#import "LSPDownLoaderManager.h"
#import "NSString+MD5.h"

@interface LSPDownLoaderManager ()<NSCopying,NSMutableCopying>

//key ：url    MD5      value : 下载器
@property(nonatomic, strong) NSMutableDictionary *downLoadInfo;

@end

static LSPDownLoaderManager *_shareInstancel;

@implementation LSPDownLoaderManager

+ (instancetype)shareInstance
{
        if (!_shareInstancel) {
            _shareInstancel = [[self alloc] init];
        }
        return _shareInstancel;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
        if (!_shareInstancel) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                _shareInstancel = [super allocWithZone:zone];
            }) ;
    }
        return _shareInstancel;
}
- (id)copyWithZone:(NSZone *)zone
{
        return _shareInstancel;
}
- (id)mutableCopyWithZone:(NSZone *)zone
{
        return _shareInstancel;
}

- (NSMutableDictionary *)downLoadInfo
{
        if (!_downLoadInfo) {
            _downLoadInfo = [NSMutableDictionary dictionary];
        }
        return _downLoadInfo;
}

- (void)downLoadWithUrl:(NSURL *)url messageBlock:(DownLoadMessage)messageBlock progressBlock:(DownLoadProgressChange)progressBlock stateChangeBlock:(DownLoadStateChange)stateChangeBlock successBlock:(DownLoadSuccess)successBlock faildBlock:(DownLoadFailed)faildBlock
{
    
        //创建一个下载器
        NSString *urlStr = [url.absoluteString md5Str];
        LSPDownLoader *downLoader = self.downLoadInfo[urlStr];
        if (downLoader == nil) {
            downLoader = [[LSPDownLoader alloc] init];
            self.downLoadInfo[urlStr] = downLoader;
        }
        [downLoader downLoadWithUrl:url messageBlock:messageBlock progressBlock:progressBlock stateChangeBlock:stateChangeBlock successBlock:^(NSString *downLoadPath) {
            [self.downLoadInfo removeObjectForKey:urlStr];
            if (successBlock) {
                successBlock(downLoadPath);
            }
        } faildBlock:faildBlock];
    
}
- (void)pauseWithUrl:(NSURL *)url
{
    NSString *urlStr =[url.absoluteString md5Str];
    LSPDownLoader *downLoader = self.downLoadInfo[urlStr];
    [downLoader pause];
}
- (void)cancleWithUrl:(NSURL *)url
{
    NSString *urlStr =[url.absoluteString md5Str];
    LSPDownLoader *downLoader = self.downLoadInfo[urlStr];
    [downLoader cancle];
}
- (void)resumeWithUrl:(NSURL *)url
{
    NSString *urlStr =[url.absoluteString md5Str];
    LSPDownLoader *downLoader = self.downLoadInfo[urlStr];
    [downLoader resume];
}
- (void)pauseAll{
    [self.downLoadInfo.allValues performSelector:@selector(pause) withObject:nil];
}
@end
