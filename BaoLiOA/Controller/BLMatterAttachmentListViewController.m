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
#import "UIViewController+GViewController.h"

@interface BLMatterAttachmentListViewController ()

@property (strong, nonatomic) BLMatterOperationService *matterOprationService;

@property (strong, nonatomic) BLAttachManageService *attachManageService;

@property (strong, nonatomic) NSMutableDictionary *progressDictionary;

@end

@implementation BLMatterAttachmentListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _matterOprationService = [[BLMatterOperationService alloc] init];
        _attachManageService = [[BLAttachManageService alloc] init];
        _progressDictionary = [[NSMutableDictionary alloc] init];
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


#pragma mark - UITableViewDelegate

// cell 已经不在视图中显示，移除对下载进度的监听
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BLAttachEntity *attachEntity = self.matterAttachList[indexPath.row];
    NSProgress *progress = self.progressDictionary[attachEntity.attachID];
    
    [progress removeObserver:cell forKeyPath:@"fractionCompleted"];
}


#pragma mark - Action
// 下载 / 打开 附件
- (IBAction)downloadOrOpenFileButtonPress:(UIButton *)sender
{
    NSInteger row = sender.tag;
    BLAttachEntity *attachEntity = self.matterAttachList[row];
    NSString *buttonTitle = sender.titleLabel.text;
    
    
    // 点击打开
    if ([buttonTitle isEqualToString:@"打开"]) {
        // 打开附件文件
        [self showPreviewViewControllerWithFilePath:((BLAttachEntity *)self.matterAttachList[row]).localPath];
    }
    
    // 点击下载
    else if ([buttonTitle isEqualToString:@"下载"]) {
        [self downloadAttch:attachEntity withButton:sender row:row];
    }
    
    // 点击停止
    else if ([buttonTitle isEqualToString:@"停止"]) {
        [sender setTitle:@"下载" forState:UIControlStateNormal];
        [self.attachManageService cancelDownloadAttachWithAttachID:attachEntity.attachID];
    }
}


#pragma mark - Private
// 下载附件
- (void)downloadAttch:(BLAttachEntity *)attachEntity withButton:(UIButton *)button row:(NSInteger)row
{
    [button setTitle:@"停止" forState:UIControlStateNormal];
    
//    [self showLodingView]; // test main thread
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    // 首先查看服务端是否已生成对应的 zip 文件
    NSDictionary *resultDic = [self.attachManageService isReadyForDownloadWithAttachID:attachEntity.attachID name:attachEntity.attachTitle];
    
    // 网络错误
    NSError *error = resultDic[@"kError"];
    if (error) {
        [self showNetworkingErrorAlert];
        
        return;
    }
    
    // 可以下载
    if ([resultDic[@"kResult"] boolValue]) {
        
        NSProgress *progress;
        
        // 下载附件
        [self.attachManageService downloadMatterAttachmentFileWithAttachID:attachEntity.attachID attachName:attachEntity.attachTitle progress:&progress
                                                                     block:^(NSString *localFilePath, NSError *error) {
//                                                                         [self hideLodingView];
                                                                         
                                                                         if (error) {
                                                                             [self showNetworkingErrorAlert];
                                                                         }
                                                                         else {
                                                                             attachEntity.localPath = localFilePath;
                                                                             
                                                                             // 保存附件的本地路径
                                                                             [self.attachManageService saveAttchLocalPath:localFilePath withAttachID:attachEntity.attachID];
                                                                             
                                                                             [button setTitle:@"打开" forState:UIControlStateNormal];
                                                                             [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                                                                             
                                                                             [self.progressDictionary removeObjectForKey:attachEntity.attachID];
                                                                         }
                                                                     }];
        
        if (progress) {
            self.progressDictionary[attachEntity.attachID] = progress;
        }
        // 监听下载进度
        [progress addObserver:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]]
                   forKeyPath:@"fractionCompleted"
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
    }
    
    // 服务器端没有生成指定附件，暂不能下载
    else {
        [self showCustomTextAlert:@"网络不稳定，请稍后再试。"];
    }
        });
}

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
    NSProgress *progress = self.progressDictionary[attachEntity.attachID];
    
    // 监听下载进度（如果有）
    [progress addObserver:cell forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:NULL];
    
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
    else if (progress) {
        // 该附件正在下载
        [cell.downloadButton setTitle:@"停止" forState:UIControlStateNormal];
        [cell.downloadButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        cell.progress.hidden = NO;
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
