//
//  BLMatterAttachmentViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-26.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterAttachmentListViewController.h"
#import "BLMatterOprationService.h"
#import "BLMatterAttachmentCell.h"

@interface BLMatterAttachmentListViewController ()

@property (strong, nonatomic) BLMatterOprationService *matterOprationService;

@property (strong, nonatomic) NSArray *attachmentList;

@end

@implementation BLMatterAttachmentListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.matterOprationService = [[BLMatterOprationService alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 获取附件列表数据
    [self.matterOprationService matterAttachmentListWithBlock:^(NSArray *list, NSError *error) {
        self.attachmentList = list;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.attachmentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BLMatterAttachmentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [self configureMatterAttachmentCell:(BLMatterAttachmentCell *)cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Action

- (IBAction)downloadOrOpenFileButtonPress:(UIButton *)sender
{
    NSInteger cellIndex = sender.tag;
    
    // 判断是否已经下载到了本地
    NSString *attachmentFileLocalPath = [self attachmentFileLocalPathAtIndex:cellIndex];
    if (attachmentFileLocalPath && [attachmentFileLocalPath length] > 0) {
        // 使用第三放 app 打开正文文件
        
    }
    else {
        // 下载正文文件
        [self.matterOprationService downloadMatterAttachmentFileFromURL:[self attachmentFileRemotePathAtIndex:cellIndex]
                                                              withBlock:^(NSString *localFilePath, NSError *error) {
//                                                                  self.mainbodyFileLocalPath = localFilePath;
                                                                  [sender setTitle:@"打开" forState:UIControlStateNormal];
                                                              }];
    }
}

#pragma mark - Private

// 配置正文 cell 的标题与按钮的标题
- (void)configureMatterAttachmentCell:(BLMatterAttachmentCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.attachmentTitleLabel.text = @"测试附件";
    
    // 检查本地是否有下载过
    NSString *attachmentFileLocalPath = [self attachmentFileLocalPathAtIndex:indexPath.row];
    if (attachmentFileLocalPath && [attachmentFileLocalPath length] > 0) {
        [cell.downloadButton setTitle:@"打开" forState:UIControlStateNormal];
    }
    
    // 使用 tag 记录「下载按钮」是属于哪一行的
    cell.downloadButton.tag = indexPath.row;
}

- (NSString *)attachmentFileLocalPathAtIndex:(NSInteger)index
{
    return nil;
}

- (NSString *)attachmentFileRemotePathAtIndex:(NSInteger)index
{
    return nil;
}

@end
