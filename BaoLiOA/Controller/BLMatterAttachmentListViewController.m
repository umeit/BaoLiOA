//
//  BLMatterAttachmentViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-26.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterAttachmentListViewController.h"
#import "BLAttachPreviewViewController.h"
#import "BLMatterOperationService.h"
#import "BLMatterAttachmentCell.h"
#import "BLAttachEntity.h"

@interface BLMatterAttachmentListViewController ()

@property (strong, nonatomic) BLMatterOperationService *matterOprationService;

@property (strong, nonatomic) NSMutableArray *progressList;

@end

@implementation BLMatterAttachmentListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.matterOprationService = [[BLMatterOperationService alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.matterAttachList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BLMatterAttachmentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureMatterAttachmentCell:(BLMatterAttachmentCell *)cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Action

// 下载 / 打开 附件
- (IBAction)downloadOrOpenFileButtonPress:(UIButton *)sender
{
    NSInteger row = sender.tag;

    // 点击打开
    if ([sender.titleLabel.text isEqualToString:@"打开"]) {
        // 使用 web view 打开附件文件
        [self showPreviewViewControllerWithFilePath:((BLAttachEntity *)self.matterAttachList[row]).localPath];
    }
    // 点击下载
    else {
        [sender setTitle:@"停止" forState:UIControlStateNormal];
        
        BLAttachEntity *attachEntity = self.matterAttachList[row];
        
        NSProgress *progress;
        
        // 下载正文文件
        [self.matterOprationService
         downloadMatterAttachmentFileWithAttachID:attachEntity.attachID
                                         progress:&progress
                                            block:^(NSString *localFilePath, NSError *error) {
                                       
                                                BLAttachEntity *attachEntity = self.matterAttachList[row];
                                                attachEntity.localPath = [NSString stringWithFormat:@"%@/%@", localFilePath, attachEntity.attachTitle];
                                       
                                                [sender setTitle:@"打开" forState:UIControlStateNormal];
                                            }];
        [progress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:NULL];
        [self.progressList addObject:progress];
    }
}



#pragma mark - Observe

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"fractionCompleted"]) {
        NSProgress *progress = object;
    }
}

#pragma mark - Private

- (void)showPreviewViewControllerWithFilePath:(NSString *)filePath
{
    BLAttachPreviewViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BLAttachPreviewViewController"];
    
    vc.filePath = filePath;
    
    [self presentViewController:vc animated:YES completion:nil];
}

// 配置正文 cell 的标题与按钮的标题
- (void)configureMatterAttachmentCell:(BLMatterAttachmentCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BLAttachEntity *attachEntity = self.matterAttachList[indexPath.row];
    
    cell.attachmentTitleLabel.text = attachEntity.attachTitle;
    
    // 检查本地是否有下载过
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                            NSUserDomainMask,
                                                                            YES) firstObject];
    NSString *attachmentFileLocalPath = [NSString stringWithFormat:@"%@/%@", documentsDirectoryPath, attachEntity.attachTitle];
    if ([[NSFileManager defaultManager] fileExistsAtPath:attachmentFileLocalPath]) {
        [cell.downloadButton setTitle:@"打开" forState:UIControlStateNormal];
        attachEntity.localPath = attachmentFileLocalPath;
    }
    
    // 使用 tag 记录「下载按钮」是属于哪一行的
    cell.downloadButton.tag = indexPath.row;
}

//// 附件的本地路径
//- (NSString *)attachmentFileLocalPathWithAttach:(BLAttachEntity *)attachEntity
//{
//    return nil;
//}

//// 附件的服务器端地址
//- (NSString *)attachmentFileRemotePathWithAttach:(BLAttachEntity *)attachEntity
//{
//    return nil;
//}

@end
