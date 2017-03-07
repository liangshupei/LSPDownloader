//
//  LSPDownLoader.h
//  下载器
//
//  Created by lsp on 17/3/6.
//  Copyright © 2017年 LSP. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LSPDownLoaderState) {
    /** 下载暂停 */
    LSPDownLoaderStatePause,
    /** 正在下载 */
    LSPDownLoaderStateDowning,
    /** 已经下载 */
    LSPDownLoaderStateSuccess,
    /** 下载失败 */
    LSPDownLoaderStateFailed
};

typedef void(^DownLoadStateChange) (LSPDownLoaderState state);
typedef void(^DownLoadMessage)(long long totalSize,NSString *downLoadedPath);
typedef void(^DownLoadProgressChange)(float Progress);
typedef void(^DownLoadSuccess)(NSString *downLoadPath);
typedef void(^DownLoadFailed)(NSString *errorMsg);


@interface LSPDownLoader : NSObject

@property(nonatomic, assign, readonly) LSPDownLoaderState state;
@property(nonatomic,  copy) DownLoadMessage messageBlock;
@property(nonatomic,  copy) DownLoadStateChange stateChangeBlock;
@property(nonatomic,  copy) DownLoadProgressChange progressBlock;
@property(nonatomic,  copy) DownLoadSuccess successBlock;
@property(nonatomic,  copy) DownLoadFailed faildBlock;

- (void)downLoadWithUrl:(NSURL *)url;
- (void)downLoadWithUrl:(NSURL *)url messageBlock:(DownLoadMessage)messageBlock progressBlock:(DownLoadProgressChange)progressBlock stateChangeBlock:(DownLoadStateChange)stateChangeBlock successBlock:(DownLoadSuccess)successBlock faildBlock:(DownLoadFailed)faildBlock;

- (void)cancle;
- (void)resume;
- (void)pause;

@end
