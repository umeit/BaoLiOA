//
//  BLMatterFormViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterFormViewController.h"
#import "BLMatterOprationService.h"
#import "BLMatterMainBodyCell.h"
#import "BLMainBodyViewController.h"

@interface BLMatterFormViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *matterFormList;

@property (strong, nonatomic) BLMatterOprationService *matterOprationService;

@property (strong, nonatomic) NSString *mainbodyFileLocalPath;

@end

@implementation BLMatterFormViewController

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
    
    // 获取表单数据
    [self.matterOprationService matterFormListWithBlock:^(NSArray *list, NSError *error) {
        self.matterFormList = list;
        [self.tableView reloadData];
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.matterFormList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *matterMainBodyCell = @"BLMatterMainBodyCell";
    static NSString *matterFormBaseCell = @"BLMatterFormBaseCell";
    
    UITableViewCell *cell;
    
    if ([self isMainBodyIndex]) {
        cell = [tableView dequeueReusableCellWithIdentifier:matterMainBodyCell forIndexPath:indexPath];
        [self configureMatterMainBodyCell:(BLMatterMainBodyCell *)cell atIndexPath:indexPath];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:matterFormBaseCell forIndexPath:indexPath];
        [self configureMatterFormBaseCell:cell atIndexPath:indexPath];
    }
    

    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BLMainBodyViewController *mainBodyViewController = (BLMainBodyViewController *)segue.destinationViewController;
    BLMatterMainBodyCell *matterMainBodyCell = (BLMatterMainBodyCell *)sender;
    
    mainBodyViewController.mainBodyLabel.text = matterMainBodyCell.mainBodyTitleLabel.text;
    mainBodyViewController.mainBodyTextView.text = [self mainBodyText];
    mainBodyViewController.mainBodyFilePath = self.mainbodyFileLocalPath;
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
