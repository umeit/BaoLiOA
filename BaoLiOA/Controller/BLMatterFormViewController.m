//
//  BLMatterFormViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterFormViewController.h"
#import "BLMatterOperationService.h"
#import "BLMatterMainBodyCell.h"
#import "BLMainBodyViewController.h"
#import "BLMatterInfoService.h"
#import "BLFromFieldItemEntity.h"

@interface BLMatterFormViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) BLMatterInfoService *matterService;

@property (strong, nonatomic) BLMatterOperationService *matterOprationService;

@property (strong, nonatomic) NSString *mainbodyFileLocalPath;

@property (strong, nonatomic) NSString *bodyTitle;

@end

@implementation BLMatterFormViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _matterOprationService = [[BLMatterOperationService alloc] init];
        _matterService = [[BLMatterInfoService alloc] init];
    }
    return self;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.matterFormInfoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *matterFormBaseCell = @"BLMatterFormBaseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:matterFormBaseCell forIndexPath:indexPath];
    
    [self configureMatterFormBaseCell:cell atIndexPath:indexPath];

    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 导航到正文视图
    BLMainBodyViewController *mainBodyViewController = (BLMainBodyViewController *)segue.destinationViewController;
    BLMatterMainBodyCell *matterMainBodyCell = (BLMatterMainBodyCell *)sender;
    
    mainBodyViewController.mainBodyLabel.text = matterMainBodyCell.mainBodyTitleLabel.text;
    mainBodyViewController.mainBodyTextView.text = [self mainBodyText];
    mainBodyViewController.mainBodyFilePath = self.mainbodyFileLocalPath;
}

- (void)toBodyViewController
{
    BLMainBodyViewController *mainBodyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BLMainBodyViewController"];
    mainBodyViewController.bodyDocID = self.matterBodyDocID;
    mainBodyViewController.mainBodyLabel.text = self.bodyTitle;
    
    [self.navigationController pushViewController:mainBodyViewController animated:YES];
}


#pragma mark - Action

- (IBAction)downloadMainBodyFileOrOpenButtonPress:(UIButton *)button
{
    // 判断是否已经下载到了本地
    if (self.mainbodyFileLocalPath && [self.mainbodyFileLocalPath length] > 0) {
        // 使用第三放 app 打开正文文件
        
    }
    else {
        // 下载正文文件
        [self.matterOprationService downloadMatterMainBodyFileFromURL:@"remote file path"
                                                            withBlock:^(NSString *localFilePath, NSError *error) {
                                                                self.mainbodyFileLocalPath = localFilePath;
                                                                [button setTitle:@"打开" forState:UIControlStateNormal];
        }];
    }
}

#pragma mark - Private

// 配置正文 cell 的标题与按钮的标题
- (void)configureMatterMainBodyCell:(BLMatterMainBodyCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.mainBodyTitleLabel.text = @"测试";
    
    // 检查本地是否有下载过
    if (self.mainbodyFileLocalPath && [self.mainbodyFileLocalPath length] > 0) {
        [cell.downloadButton setTitle:@"打开" forState:UIControlStateNormal];
    }
}

- (void)configureMatterFormBaseCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSArray *itemListInLine = self.matterFormInfoList[indexPath.row];
    
    CGFloat currentX = 15;
    CGFloat cellWidth = cell.contentView.bounds.size.width; // cell 的宽度
    
    for (NSInteger i=0; i<[itemListInLine count]; i++) {
        BLFromFieldItemEntity *fieldItem = itemListInLine[i];
        
        // 计算当前 Label 的宽度
        CGFloat percent = fieldItem.percent / 100.f;
        CGFloat labelWidth = cellWidth * percent;
        
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, 0, labelWidth, 44)];
        currentX += labelWidth;  // 左移 x 值，供后续 Label 使用
        
        // 配置 Label 的显示内容
        if (fieldItem.nameVisible) {
            aLabel.text = [NSString stringWithFormat:@"%@%@", fieldItem.name, fieldItem.value];
        }
        else {
            aLabel.text = fieldItem.value;
        }
        
        // 将 Label 添加到 cell 中
        [cell.contentView addSubview:aLabel];
    }
    
    // 对于第一行做特殊处理：判断是否有正文附件，如果有，在第一行的行尾放一个按钮，用于导航到正文页面
    if (indexPath.row == 0 && self.matterBodyDocID) {
        CGRect cellBounds = cell.bounds;
        UIButton *bodyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [cell.contentView addSubview:bodyButton];
//        [cell.contentView bringSubviewToFront:bodyButton];
        
        bodyButton.titleLabel.text = @"查看正文";
        [bodyButton addTarget:self action:@selector(toBodyViewController) forControlEvents:UIControlEventTouchUpInside];
        
        BLFromFieldItemEntity *fieldItem = itemListInLine[0];
        self.bodyTitle = fieldItem.value;
        
//        cell.contentView.subviews;
    }
}

// 获取正文预览文本
- (NSString *)mainBodyText
{
    #warning 从实体类读 或 从服务器读
    return @"test, test main body Text";
}

- (BOOL)isMainBodyIndex
{
    return YES;
}
@end
