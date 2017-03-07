//
//  LSPDownLoader.m
//  下载器
//
//  Created by lsp on 17/3/6.
//  Copyright © 2017年 LSP. All rights reserved.
//

#import "LSPDownLoader.h"
#import "LSPFileTool.h"

#define kCache     NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject


@interface LSPDownLoader ()<NSURLSessionDataDelegate>
{
    long long   _fileTmpSize;
    long long _totlaSize;
}
@property(nonatomic, strong)  NSURLSession *session;
@property(nonatomic, copy)  NSString *downLoadedFilePath;
@property(nonatomic, copy)  NSString *downLoadingFilePath;
@property(nonatomic, strong) NSOutputStream *outputStream;
@property(nonatomic, weak) NSURLSessionDataTask *task;


@end

@implementation LSPDownLoader

- (void)downLoadWithUrl:(NSURL *)url messageBlock:(DownLoadMessage)messageBlock progressBlock:(DownLoadProgressChange)progressBlock stateChangeBlock:(DownLoadStateChange)stateChangeBlock successBlock:(DownLoadSuccess)successBlock faildBlock:(DownLoadFailed)faildBlock
{
    self.messageBlock = messageBlock;
    self.progressBlock = progressBlock;
    self.stateChangeBlock = stateChangeBlock;
    self.successBlock = successBlock;
    self.faildBlock = faildBlock;
    [self downLoadWithUrl:url];
}
- (void)downLoadWithUrl:(NSURL *)url
{
        self.downLoadedFilePath = [self.downLoadedPath stringByAppendingPathComponent:url.lastPathComponent];
        self.downLoadingFilePath = [self.downLoadingPath stringByAppendingPathComponent:url.lastPathComponent];
        if ([url isEqual: self.task.originalRequest.URL]) {
            if (self.state == LSPDownLoaderStatePause) {
                [self resume];
                return;
            }
            if (self.state == LSPDownLoaderStateDowning) {
                return;
            }
            if (self.state == LSPDownLoaderStateSuccess) {
                if (_successBlock) {
                    self.successBlock(self.downLoadedFilePath);
                }
                return;
            }
        }
            if ([LSPFileTool fileExistsAtPath:self.downLoadedFilePath]) {
                if (self.successBlock) {
                    self.successBlock(self.downLoadedFilePath);
                }
                return;
            }
    
            if (![LSPFileTool fileExistsAtPath:self.downLoadingFilePath]) {
                [self downLoadWithUrl:url offSet:_fileTmpSize];
                return;
            }
    
        [self cancle];
         _fileTmpSize = [LSPFileTool fileSizeAtPath:self.downLoadingFilePath];//临时文件总大小
        [self downLoadWithUrl:url offSet:_fileTmpSize];
}

#pragma mark  私有方法

- (void)cancle
{
    self.state = LSPDownLoaderStateFailed;
    [self.session invalidateAndCancel];
    self.session = nil;
}
- (void)resume
{
    if ((self.task && self.state == LSPDownLoaderStatePause) || self.state == LSPDownLoaderStateFailed) {
        [self.task resume];
        self.state = LSPDownLoaderStateDowning;
    }
}
- (void)pause
{
    if (self.task && self.state == LSPDownLoaderStateDowning ) {
        [self.task suspend];
        self.state = LSPDownLoaderStatePause;
    }
}
- (void)cancleAndClean
{
    [self cancle];
    [LSPFileTool removewFileAtPath:self.downLoadingFilePath];
}

- (void)downLoadWithUrl:(NSURL *)url offSet:(long long)offSet
{
        NSMutableURLRequest *request = [NSMutableURLRequest  requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
        [request setValue:[NSString stringWithFormat:@"bytes=%lld-",offSet] forHTTPHeaderField:@"Range"];
        self.task =  [self.session  dataTaskWithRequest:request];
        [self resume];
}
#pragma mark NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
            NSString *rangeStr =  response.allHeaderFields[@"Content-Range"];
            _totlaSize = [[rangeStr componentsSeparatedByString:@"/"].lastObject longLongValue];
            if (_fileTmpSize == _totlaSize) {
                if (self.successBlock) {
                    self.successBlock(self.downLoadedFilePath);
                }
                [LSPFileTool moveFileFromPath:self.downLoadingFilePath toPath:self.downLoadedFilePath];
                completionHandler(NSURLSessionResponseCancel);
                return;
            }
            if (_fileTmpSize > _totlaSize) {//下载文件 大于文件总大小
                [LSPFileTool removewFileAtPath:self.downLoadingFilePath];
                 completionHandler(NSURLSessionResponseCancel);
                [self downLoadWithUrl:response.URL];
                return;
            }
        if (self.messageBlock) {
            self.messageBlock(_totlaSize,self.downLoadingFilePath);
        }
            self.outputStream = [NSOutputStream outputStreamToFileAtPath:self.downLoadingFilePath append:YES];
            [self.outputStream open];
            completionHandler(NSURLSessionResponseAllow);
}
- (void)URLSession:(NSURLSession *)session dataTask:(nonnull NSURLSessionDataTask *)dataTask didReceiveData:(nonnull NSData *)data {
    _fileTmpSize += data.length;
    if (self.progressBlock) {
        self.progressBlock(1.0 * _fileTmpSize / _totlaSize);
    }
    [self.outputStream  write:data.bytes maxLength:data.length];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (!error) {
        if (_fileTmpSize == _totlaSize) {
            [LSPFileTool moveFileFromPath:self.downLoadingFilePath toPath:self.downLoadedFilePath];
            self.state = LSPDownLoaderStateSuccess;
        }
    }else{
        self.state = LSPDownLoaderStateFailed;
        if (self.faildBlock) {
            self.faildBlock(error.localizedDescription);
        }
    }
}
#pragma mark 懒加载 seter  geter
- (NSURLSession *)session
{
    if (!_session) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue new]];
    }
    return  _session;
}
- (NSString *)downLoadingPath
{
    NSString *path  = [kCache stringByAppendingPathComponent:@"downLaoder/dowmLoading"];
    BOOL result = [LSPFileTool createDirectoryIFNotExists:path];
    if (result) {
        return path;
    }
    return @"";
}
- (NSString *)downLoadedPath
{
    NSString *path  = [kCache stringByAppendingPathComponent:@"downLaoder/dowmLoaded"];
    BOOL result = [LSPFileTool createDirectoryIFNotExists:path];
    if (result) {
        return path;
    }
    return @"";
}
- (void)setState:(LSPDownLoaderState)state
{
        _state = state;
        if (self.stateChangeBlock) {
            self.stateChangeBlock(state);
        }
}
@end
