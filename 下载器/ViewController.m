//
//  ViewController.m
//  下载器
//
//  Created by 梁书培 on 17/3/6.
//  Copyright © 2017年 LSP. All rights reserved.
//

#import "ViewController.h"
#import "LSPDownLoader.h"
#import "LSPDownLoaderManager.h"

@interface ViewController ()


@property(nonatomic, strong) LSPDownLoader *downLoader;

@property(nonatomic, weak) NSTimer *timer;

@property(nonatomic, strong)  NSURL *url;
@end

@implementation ViewController
- (NSTimer *)timer
{
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    return _timer;
}
- (LSPDownLoader *)downLoader{
    if (!_downLoader) {
        _downLoader = [LSPDownLoader new];
    }
    return _downLoader;
}
- (IBAction)downLoad:(id)sender {
            self.url = [NSURL URLWithString:@"http://free2.macx.cn:8281/Tools/System/BetterZip32.dmg"];
            [[LSPDownLoaderManager shareInstance] downLoadWithUrl:self.url  messageBlock:^(long long totalSize, NSString *downLoadedPath) {
                NSLog(@"开始下载--%@--%lld",downLoadedPath,totalSize);
            } progressBlock:^(float Progress) {
                NSLog(@"下载中---%f",Progress);
            } stateChangeBlock:^(LSPDownLoaderState state) {
                NSLog(@"下载--%lu",(unsigned long)state);
            } successBlock:^(NSString *downLoadPath) {
                NSLog(@"完成--%@",downLoadPath);
            } faildBlock:^(NSString *errorMsg) {
                NSLog(@"失败--%@",errorMsg);
            }];
}
- (IBAction)pause:(id)sender {
    [[LSPDownLoaderManager shareInstance] pauseWithUrl:self.url];
}
- (IBAction)cancle:(id)sender {
    [[LSPDownLoaderManager shareInstance] cancleWithUrl:self.url];
}
- (IBAction)resume:(id)sender {
    [[LSPDownLoaderManager shareInstance] resumeWithUrl:self.url];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self timer];
}
- (void)update
{
//    NSLog(@"%zd",self.downLoader.state);
}

@end
