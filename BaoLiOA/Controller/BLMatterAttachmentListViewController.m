//
//  BLMatterAttachmentViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-26.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterOperationViewController.h"
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
        // 对于 gllc 类型的附件，直接打开对应的公文即可
        if ([attachEntity.attachType compare:@"gllc" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            [self showMatterOperationViewControllerWithMatterID:attachEntity.attachID matterTitle:attachEntity.attachTitle delegate:self];
        }
        else {
            [self showPreviewViewControllerWithFilePath:((BLAttachEntity *)self.matterAttachList[row]).localPath];
        }
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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 首先查看服务端是否已生成对应的 zip 文件
        NSDictionary *resultDic = [self.attachManageService isReadyForDownloadWithAttachID:attachEntity.attachID
                                                                                      name:attachEntity.attachTitle
                                                                                attachType:kAttach];
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
            [self.attachManageService downloadMatterAttachmentFileWithAttachID:attachEntity.attachID
            attachName:attachEntity.attachTitle progress:&progress
            block:^(NSString *localFilePath, NSError *error) {
                                                                             
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

// 显示公文附件
- (void)showMatterOperationViewControllerWithMatterID:(NSString *)matterID matterTitle:(NSString *)matterTitle delegate:(id)delegate
{
    BLMatterOperationViewController *matterOperationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BLMatterOperationViewController"];
    matterOperationViewController.matterID = matterID;
    matterOperationViewController.matterTitle = [NSString stringWithFormat:@"附件：%@", matterTitle];
    matterOperationViewController.delegate = delegate;
    
    [matterOperationViewController setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:matterOperationViewController];
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:matterOperationViewController action:@selector(cancel:)];

    
    [nav setModalPresentationStyle:UIModalPresentationCurrentContext];
//    [nav.navigationItem setLeftBarButtonItem:cancelButtonItem];
    [matterOperationViewController.navigationItem setLeftBarButtonItem:cancelButtonItem];
    [self presentViewController:nav animated:YES completion:nil];
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
//        [cell.downloadButton setTitle:@"打开" forState:UIControlStateNormal];
//        [cell.downloadButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//        cell.progress.hidden = YES;
        [self setAttachCellToOpenState:cell];
        
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
    
    if ([attachEntity.attachType compare:@"docx"options:NSCaseInsensitiveSearch] == NSOrderedSame
        || [attachEntity.attachType compare:@"doc" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        cell.typeImageView.image = [UIImage imageNamed:@"W"];
    }
    else if ([attachEntity.attachType compare:@"xlsx"options:NSCaseInsensitiveSearch] == NSOrderedSame
        || [attachEntity.attachType compare:@"xls" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        cell.typeImageView.image = [UIImage imageNamed:@"S"];
    }
    else if ([attachEntity.attachType compare:@"pptx"options:NSCaseInsensitiveSearch] == NSOrderedSame
             || [attachEntity.attachType compare:@"ppt" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        cell.typeImageView.image = [UIImage imageNamed:@"P"];
    }
    else if ([attachEntity.attachType compare:@"PDF" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        cell.typeImageView.image = [UIImage imageNamed:@"PDF"];
    }
    // 2014.7.15 Add
    // 新的附件类型：gllc
    else if ([attachEntity.attachType compare:@"gllc" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        cell.typeImageView.image = [UIImage imageNamed:@"OTHER"];
        // 这种类型的附件就是一个待办事件，无需下载，直接打开即可
        [self setAttachCellToOpenState:cell];
    }
    else {
        cell.typeImageView.image = [UIImage imageNamed:@"OTHER"];
    }
}


#pragma mark - Private - UI Operation
- (void)setAttachCellToOpenState:(BLMatterAttachmentCell *)cell
{
    [cell.downloadButton setTitle:@"打开" forState:UIControlStateNormal];
    [cell.downloadButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    cell.progress.hidden = YES;
}
@end
