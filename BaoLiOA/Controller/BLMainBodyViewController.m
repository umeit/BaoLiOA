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

@interface BLMainBodyViewController ()

@property (weak, nonatomic) IBOutlet UITextView *mainBodyTextView;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UILabel *mainBodyLabel;
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
    
    self.mainBodyLabel.text = self.docTtitle;
    
    // 获取附件的本地路径，如果已下载
    NSString *localPath = [self.attchManageService attachLocalPathWithAttachID:self.bodyDocID];
    if (localPath) {
        
        [self.downloadButton setTitle:@"打开" forState:UIControlStateNormal];
        [self.downloadButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        
        self.progressView.hidden = YES;
        
        self.mainBodyFilePath = localPath;
    }
    
//    // 检查本地是否有下载过
//    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                                            NSUserDomainMask,
//                                                                            YES) firstObject];
//    NSString *attachmentFileLocalPath = [NSString stringWithFormat:@"%@/%@", documentsDirectoryPath, self.docTtitle];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:attachmentFileLocalPath]) {
//        [self.downloadButton setTitle:@"打开" forState:UIControlStateNormal];
//        self.mainBodyFilePath = attachmentFileLocalPath;
//    }
    
    // 获取正文内容
    [self.matterOprationService matterBodyTextWithBodyDocID:self.bodyDocID block:^(id obj, NSError *error) {
        self.mainBodyTextView.text = obj;
    }];
}


#pragma mark - Action

- (IBAction)downloadButtonPress:(UIButton *)button
{
    NSString *buttonTitle = button.titleLabel.text;
    
    // 点击下载
    if ([buttonTitle isEqualToString:@"下载"]) {
        [button setTitle:@"停止" forState:UIControlStateNormal];
        
        NSProgress *progress;
        
        // 下载正文文件
        [self.attchManageService downloadMatterAttachmentFileWithAttachID:self.bodyDocID progress:&progress
        block:^(NSString *localFilePath, NSError *error) {
            
            if (error) {
                NSLog(@"下载失败！");
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
    //    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    if ([keyPath isEqualToString:@"fractionCompleted"]) {
        NSProgress *progress = object;
        self.progressView.progress = progress.fractionCompleted;
        //        NSLog(@"Progress is %f", progress.fractionCompleted);
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
