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
#import "BLAttachManageService.h"
#import "BLMatterAttachmentCell.h"
#import "BLAttachEntity.h"

@interface BLMatterAttachmentListViewController ()

@property (strong, nonatomic) BLMatterOperationService *matterOprationService;

@property (strong, nonatomic) BLAttachManageService *attachManageService;

@property (strong, nonatomic) NSMutableArray *progressList;

@end

@implementation BLMatterAttachmentListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _matterOprationService = [[BLMatterOperationService alloc] init];
        _attachManageService = [[BLAttachManageService alloc] init];
    }
    return self;
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
    BLAttachEntity *attachEntity = self.matterAttachList[row];
    NSString *buttonTitle = sender.titleLabel.text;
    NSProgress *progress;
    
    // 点击打开
    if ([buttonTitle isEqualToString:@"打开"]) {
        // 打开附件文件
        [self showPreviewViewControllerWithFilePath:((BLAttachEntity *)self.matterAttachList[row]).localPath];
    }
    
    // 点击下载
    else if ([buttonTitle isEqualToString:@"下载"]) {
        [sender setTitle:@"停止" forState:UIControlStateNormal];
        
        // 下载附件
        [self.attachManageService downloadMatterAttachmentFileWithAttachID:attachEntity.attachID progress:&progress
        block:^(NSString *localFilePath, NSError *error) {
            if (error) {
                NSLog(@"下载附件失败！");
            }
            else {
                BLAttachEntity *attachEntity = self.matterAttachList[row];
                attachEntity.localPath = localFilePath;
                
                // 保存附件的本地路径
                [self.attachManageService saveAttchLocalPath:localFilePath withAttachID:attachEntity.attachID];
                
                [sender setTitle:@"打开" forState:UIControlStateNormal];
                [sender setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            }
        }];
        
        // 监听下载进度
        [progress addObserver:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]]
                   forKeyPath:@"fractionCompleted"
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
    }
    
    // 点击停止
    else if ([buttonTitle isEqualToString:@"停止"]) {
        [sender setTitle:@"下载" forState:UIControlStateNormal];
        [self.attachManageService cancelDownloadAttachWithAttachID:attachEntity.attachID];
    }
}


#pragma mark - Observe
// 更新进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    if ([keyPath isEqualToString:@"fractionCompleted"]) {
        NSProgress *progress = object;
        NSUInteger index = [self.progressList indexOfObject:progress];
        BLMatterAttachmentCell *cell = (BLMatterAttachmentCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.progress.progress = progress.fractionCompleted;
    }
}


#pragma mark - Private
// 显示附件内容
- (void)showPreviewViewControllerWithFilePath:(NSString *)filePath
{
    BLAttachPreviewViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BLAttachPreviewViewController"];
    
    vc.filePath = filePath;
    
    [self presentViewController:vc animated:YES completion:nil];
}

// 配置 cell
- (void)configureMatterAttachmentCell:(BLMatterAttachmentCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BLAttachEntity *attachEntity = self.matterAttachList[indexPath.row];
    
    cell.attachmentTitleLabel.text = attachEntity.attachTitle;
    
    // 获取附件的本地路径，如果已下载
    NSString *localPath = [self.attachManageService attachLocalPathWithAttachID:attachEntity.attachID];
    if (localPath) {
        // 该附件已下载
        [cell.downloadButton setTitle:@"打开" forState:UIControlStateNormal];
        [cell.downloadButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        cell.progress.hidden = YES;
        
        attachEntity.localPath = localPath;
    }
    else {
        // 该附件未下载
        [cell.downloadButton setTitle:@"下载" forState:UIControlStateNormal];
        [cell.downloadButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        cell.progress.hidden = NO;
    }
    
    // 使用 tag 记录「下载按钮」是属于哪一行的
    cell.downloadButton.tag = indexPath.row;
}
@end
