//
//  BLMatterFormViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterFormViewController.h"
#import "BLMatterOperationService.h"
#import "BLMainBodyViewController.h"
#import "BLMatterInfoService.h"
#import "BLFromFieldItemEntity.h"

@interface BLMatterFormViewController () <UITableViewDataSource, UITableViewDelegate>

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


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


#pragma mark - Navigation

- (void)toBodyViewController
{
    BLMainBodyViewController *mainBodyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BLMainBodyViewController"];
    mainBodyViewController.bodyDocID = self.matterBodyDocID;
    mainBodyViewController.docTtitle = self.bodyTitle;
    
    [self.navigationController pushViewController:mainBodyViewController animated:YES];
}


#pragma mark - Private

- (void)configureMatterFormBaseCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSArray *itemListInLine = self.matterFormInfoList[indexPath.row];
    
    CGFloat currentX = 15;
    CGFloat cellWidth = cell.contentView.bounds.size.width; // cell 的宽度
    
    for (NSInteger i=0; i<[itemListInLine count]; i++) {
        BLFromFieldItemEntity *fieldItem = itemListInLine[i];
        
        // 计算当前 Label 的宽度
        CGFloat percent = fieldItem.percent / 100.f;
        CGFloat labelWidth = cellWidth * (percent == 0 ? 1 : percent);
        
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, 0, labelWidth, 44)];
        aLabel.tag = 1;
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
        UIButton *bodyButton = [[UIButton alloc] initWithFrame:CGRectMake(cellWidth - 90, 8, 80, 30)];
        [cell.contentView addSubview:bodyButton];
        
        bodyButton.titleLabel.text = @"查看正文";
        [bodyButton addTarget:self action:@selector(toBodyViewController) forControlEvents:UIControlEventTouchUpInside];
        [bodyButton setTitle:@"查看正文" forState:UIControlStateNormal];
        [bodyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        BLFromFieldItemEntity *fieldItem = itemListInLine[0];
        self.bodyTitle = fieldItem.value;
        
        UIView *aLabel = [cell viewWithTag:1];
        CGSize labelSize = aLabel.frame.size;
        CGSize newSize = CGSizeMake(cellWidth - 90, labelSize.height);
        aLabel.frame = CGRectMake(aLabel.frame.origin.x, aLabel.frame.origin.y, newSize.width, newSize.height);
    }
}
@end
