//
//  LSPDownLoaderManager.h
//  下载器
//
//  Created by 梁书培 on 17/3/7.
//  Copyright © 2017年 LSP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSPDownLoader.h"

@interface LSPDownLoaderManager : NSObject

+ (instancetype)shareInstance;
- (void)downLoadWithUrl:(NSURL *)url messageBlock:(DownLoadMessage)messageBlock progressBlock:(DownLoadProgressChange)progressBlock stateChangeBlock:(DownLoadStateChange)stateChangeBlock successBlock:(DownLoadSuccess)successBlock faildBlock:(DownLoadFailed)faildBlock;
- (void)pauseWithUrl:(NSURL *)url;
- (void)cancleWithUrl:(NSURL *)url;
- (void)resumeWithUrl:(NSURL *)url;
- (void)pauseAll;

@end
