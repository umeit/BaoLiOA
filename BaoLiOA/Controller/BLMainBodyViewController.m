//
//  BLMainBodyViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-25.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMainBodyViewController.h"
#import "BLMatterOperationService.h"
#import "BLAttachManageService.h"
#import "BLAttachPreviewViewController.h"
#import "UIViewController+GViewController.h"

@interface BLMainBodyViewController ()

@property (weak, nonatomic) IBOutlet UITextView *mainBodyTextView;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
//@property (weak, nonatomic) IBOutlet UILabel *mainBodyLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (strong, nonatomic) NSString *mainBodyFilePath;

@property (strong, nonatomic) BLMatterOperationService *matterOprationService;
@property (strong, nonatomic) BLAttachManageService *attchManageService;
@end

@implementation BLMainBodyViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _matterOprationService = [[BLMatterOperationService alloc] init];
        _attchManageService = [[BLAttachManageService alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.mainBodyLabel.text = self.docTtitle;
    
    self.progressView.hidden = YES;
    
    // 获取附件的本地路径，如果已下载
    NSString *localPath = [self.attchManageService attachLocalPathWithAttachID:self.bodyDocID];
    if (localPath) {
        
        [self.downloadButton setTitle:@"打开" forState:UIControlStateNormal];
        [self.downloadButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        
        self.mainBodyFilePath = localPath;
    }
    
    // 获取正文内容
    [self showLodingView];
    [self.matterOprationService matterBodyTextWithBodyDocID:self.bodyDocID block:^(id obj, NSError *error) {
        [self hideLodingView];
        self.mainBodyTextView.text = obj;
    }];
}


#pragma mark - Action

- (IBAction)downloadButtonPress:(UIButton *)button
{
    NSString *buttonTitle = button.titleLabel.text;
    
    // 点击下载
    if ([buttonTitle isEqualToString:@"下载文件"]) {
        self.progressView.hidden = NO;
        [button setTitle:@"停止" forState:UIControlStateNormal];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showLodingView];
            });
            
            // 首先查看服务端是否已生成对应的 zip 文件
            NSDictionary *resultDic = [self.attchManageService isReadyForDownloadWithAttachID:self.bodyDocID
                                                                                         name:self.docTtitle
                                                                                   attachType:kMainDoc];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideLodingView];
            });
            
            // 网络错误
            NSError *error = resultDic[@"kError"];
            if (error) {
                [self showNetworkingErrorAlert];
                
                return;
            }
            
            // 可以下载
            if ([resultDic[@"kResult"] boolValue]) {
                
                NSProgress *progress;
                // 下载正文文件
                [self.attchManageService downloadMatterAttachmentFileWithAttachID:self.bodyDocID attachName:@"" progress:&progress
                block:^(NSString *localFilePath, NSError *error) {
                    
                    if (error) {
                        [self showNetworkingErrorAlert];
                    }
                    else {
                        self.mainBodyFilePath = localFilePath;
                        
                        // 保存附件的本地路径
                        [self.attchManageService saveAttchLocalPath:localFilePath withAttachID:self.bodyDocID];
                        
                        [button setTitle:@"打开" forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                    }
                }];
                [progress addObserver:self
                           forKeyPath:@"fractionCompleted"
                              options:NSKeyValueObservingOptionNew
                              context:NULL];
                
            }
            
            // 服务器端没有生成指定附件，暂不能下载
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showCustomTextAlert:@"下载遇到问题，请重试。"];
                    
                    [button setTitle:@"下载文件" forState:UIControlStateNormal];
                });
                
            }
        });
    }
    
    // 点击打开
    else if ([buttonTitle isEqualToString:@"打开"]) {
        // 打开附件文件
        [self showPreviewViewControllerWithFilePath:self.mainBodyFilePath];
    }
    
    // 点击停止
    else if ([buttonTitle isEqualToString:@"停止"]) {
        [button setTitle:@"下载" forState:UIControlStateNormal];
        [self.attchManageService cancelDownloadAttachWithAttachID:self.bodyDocID];
    }
}


#pragma mark - Observe

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"fractionCompleted"]) {
        NSProgress *progress = object;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = progress.fractionCompleted;
        });
    }
}


#pragma mark - Private

- (void)showPreviewViewControllerWithFilePath:(NSString *)filePath
{
    BLAttachPreviewViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BLAttachPreviewViewController"];
    
    vc.filePath = filePath;
    
    [self presentViewController:vc animated:YES completion:nil];
}
@end
