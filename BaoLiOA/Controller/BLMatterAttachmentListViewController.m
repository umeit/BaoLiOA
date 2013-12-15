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
        NSString *attachmentFileLocalPath = [self attachmentFileLocalPathWithAttach:self.matterAttachList[row]];
        
        [self showPreviewViewControllerWithFilePath:attachmentFileLocalPath];
    }
    // 点击下载
    else {
        [sender setTitle:@"停止" forState:UIControlStateNormal];
        
        BLAttachEntity *attachEntity = self.matterAttachList[row];
        
        // 下载正文文件
        [self.matterOprationService
         downloadMatterAttachmentFileWithAttachID:attachEntity.attachID
                                         fileType:@"zip"
                                            block:^(NSString *localFilePath, NSError *error) {
                                       
                                                BLAttachEntity *attachEntity = self.matterAttachList[row];
                                                attachEntity.localPath = localFilePath;
                                       
                                                [sender setTitle:@"打开" forState:UIControlStateNormal];
                                            }];
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
    NSString *attachmentFileLocalPath = [self attachmentFileLocalPathWithAttach:attachEntity];
    if (attachmentFileLocalPath && [attachmentFileLocalPath length] > 0) {
        [cell.downloadButton setTitle:@"打开" forState:UIControlStateNormal];
    }
    
    // 使用 tag 记录「下载按钮」是属于哪一行的
    cell.downloadButton.tag = indexPath.row;
}

// 附件的本地路径
- (NSString *)attachmentFileLocalPathWithAttach:(BLAttachEntity *)attachEntity
{
    return nil;
}

//// 附件的服务器端地址
//- (NSString *)attachmentFileRemotePathWithAttach:(BLAttachEntity *)attachEntity
//{
//    return nil;
//}

@end
