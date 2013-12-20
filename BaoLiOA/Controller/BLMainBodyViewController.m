//
//  BLMainBodyViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-25.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMainBodyViewController.h"
#import "BLMatterOperationService.h"
#import "BLAttachPreviewViewController.h"

@interface BLMainBodyViewController ()

@property (weak, nonatomic) IBOutlet UITextView *mainBodyTextView;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UILabel *mainBodyLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (strong, nonatomic) NSString *mainBodyFilePath;

@property (strong, nonatomic) BLMatterOperationService *matterOprationService;

@end

@implementation BLMainBodyViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _matterOprationService = [[BLMatterOperationService alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mainBodyLabel.text = self.docTtitle;
    
    // 检查本地是否有下载过
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                            NSUserDomainMask,
                                                                            YES) firstObject];
    NSString *attachmentFileLocalPath = [NSString stringWithFormat:@"%@/%@", documentsDirectoryPath, self.docTtitle];
    if ([[NSFileManager defaultManager] fileExistsAtPath:attachmentFileLocalPath]) {
        [self.downloadButton setTitle:@"打开" forState:UIControlStateNormal];
        self.mainBodyFilePath = attachmentFileLocalPath;
    }
    
    // 获取正文内容
    [self.matterOprationService matterBodyTextWithBodyDocID:self.bodyDocID block:^(id obj, NSError *error) {
        self.mainBodyTextView.text = obj;
    }];
}


#pragma mark - Action

- (IBAction)downloadButtonPress:(UIButton *)button
{
    NSString *buttonTitle = button.titleLabel.text;
    if ([buttonTitle isEqualToString:@"下载"]) {
        [button setTitle:@"停止" forState:UIControlStateNormal];
        
        NSProgress *progress;
        
        // 下载正文文件
        [self.matterOprationService
         downloadMatterAttachmentFileWithAttachID:self.bodyDocID
         progress:&progress
         block:^(NSString *localFilePath, NSError *error) {
             
             self.mainBodyFilePath = [NSString stringWithFormat:@"%@/%@", localFilePath, self.docTtitle];
             
             [button setTitle:@"打开" forState:UIControlStateNormal];
         }];
        [progress addObserver:self
                   forKeyPath:@"fractionCompleted"
                      options:NSKeyValueObservingOptionNew
                      context:NULL];

    }
    else if ([buttonTitle isEqualToString:@"打开"]) {
        
    }
    else if ([buttonTitle isEqualToString:@"停止"]) {
        
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
