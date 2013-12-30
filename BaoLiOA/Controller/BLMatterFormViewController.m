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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat maxNameContentHeight = 0.f;
    CGFloat maxValueContentHeight = 0.f;
    
    NSArray *itemListInLine = self.matterFormInfoList[indexPath.row];
    
    for (NSInteger i=0; i<[itemListInLine count]; i++) {
        BLFromFieldItemEntity *fieldItem = itemListInLine[i];
        
        // 计算当前 Label 的宽度
        CGFloat cellWidth = tableView.bounds.size.width;
        CGFloat percent = fieldItem.percent / 100.f;
        CGFloat labelWidth = cellWidth * (percent == 0 ? 1 : percent);

        NSString *nameString = [NSString stringWithFormat:@"%@%@%@%@", fieldItem.beforeName, fieldItem.name, fieldItem.endName, fieldItem.splitString];
        NSString *valueString = [NSString stringWithFormat:@"%@%@%@", fieldItem.beforeValue, fieldItem.value, fieldItem.endValue];
        
        // 显示 name
        if (fieldItem.nameVisible) {
            // 分行显示，返回 name 加 value 的高度
            if (fieldItem.nameRN) {
                
                CGFloat nameLabelHeight = [self labelHeightWithMaxWidth:labelWidth content:nameString];
                CGFloat valueLabelHeight = [self labelHeightWithMaxWidth:labelWidth content:valueString];
                
                maxNameContentHeight = MAX(maxNameContentHeight, nameLabelHeight);
                maxValueContentHeight = MAX(maxValueContentHeight, valueLabelHeight);
            }
            // 不分行显示，返回 name 和 value 都在一行的高度
            else {
                CGFloat nameLabelHeight = [self labelHeightWithMaxWidth:labelWidth content:[NSString stringWithFormat:@"%@%@", nameString, valueString]];
                maxNameContentHeight = MAX(maxNameContentHeight, nameLabelHeight);
            }
        }
        // 不显示 name，返回 value 的高度
        else {
            CGFloat valueLabelHeight = [self labelHeightWithMaxWidth:labelWidth content:valueString];
            maxValueContentHeight = MAX(maxValueContentHeight, valueLabelHeight);
        }
    }
    
    return 8 + maxNameContentHeight + maxValueContentHeight + 8;
}

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
        
        NSString *nameString = [NSString stringWithFormat:@"%@%@%@%@", fieldItem.beforeName, fieldItem.name, fieldItem.endName, fieldItem.splitString];
        NSString *valueString = [NSString stringWithFormat:@"%@%@%@", fieldItem.beforeValue, fieldItem.value, fieldItem.endValue];
        
        /** 配置 Label 的显示内容 */
        // 显示 name
        if (fieldItem.nameVisible) {
            // 分行显示
            if (fieldItem.nameRN) {
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, 8, labelWidth, 20)];
                nameLabel.text = nameString;
                
                CGFloat valueLabelHeight = [self labelHeightWithMaxWidth:labelWidth content:valueString];
                // value 标签
                UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, 30, labelWidth, valueLabelHeight)];
                valueLabel.numberOfLines = 0;
                valueLabel.text = valueString;
                
                [cell.contentView addSubview:nameLabel];
                [cell.contentView addSubview:valueLabel];
            }
            // 不分行显示
            else {
                UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, 8, labelWidth, 20)];
                aLabel.text = [NSString stringWithFormat:@"%@%@", nameString, valueString];
                [cell.contentView addSubview:aLabel];
            }
        }
        // 不显示 name
        else {
            UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, 8, labelWidth, 20)];
            aLabel.text = valueString;
            [cell.contentView addSubview:aLabel];
        }
        
        currentX += labelWidth;  // 左移 x 值，供后续 Label 使用
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

- (CGFloat)labelHeightWithMaxWidth:(CGFloat)width content:(NSString *)content
{
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
    
    return [content boundingRectWithSize:CGSizeMake(width, 1000)
                                 options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                              attributes:dic
                                 context:nil].size.height;
}

@end
