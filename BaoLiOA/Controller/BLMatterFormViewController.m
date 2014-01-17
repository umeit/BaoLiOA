//
//  BLMatterFormViewController.m
//  BaoLiOA
//
//  Created by Liu Feng on 13-11-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterFormViewController.h"
#import "BLCommonOpinionViewController.h"
#import "BLMatterOpinionViewController.h"
#import "BLQuickOpinionViewController.h"
#import "BLMatterOperationService.h"
#import "BLMainBodyViewController.h"
#import "BLMatterInfoService.h"
#import "BLFromFieldItemEntity.h"
#import "BLInfoRegionEntity.h"

@interface BLMatterFormViewController () <UITableViewDataSource, UITableViewDelegate, BLCommonOpinionViewControllerDelegate, BLMatterOpinionViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) BLCommonOpinionViewController *opinionViewController;

@property (strong, nonatomic) BLMatterOpinionViewController *matterOpinionViewController;

@property (strong, nonatomic) BLQuickOpinionViewController *quickOpinionViewController;

//@property (strong, nonatomic) BLMatterInfoService *matterService;
//
//@property (strong, nonatomic) BLMatterOperationService *matterOprationService;

//@property (strong, nonatomic) NSString *mainbodyFileLocalPath;

//@property (strong, nonatomic) NSString *bodyTitle;

@property (nonatomic) NSInteger currentEidtFieldItemIndex;
@property (nonatomic) NSInteger currentEidtRegionIndex;
@end

@implementation BLMatterFormViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
//        _matterOprationService = [[BLMatterOperationService alloc] init];
//        _matterService = [[BLMatterInfoService alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat maxNameContentHeight = 0.f;
    CGFloat maxValueContentHeight = 0.f;
    
    BLInfoRegionEntity *infoRegion = self.matterFormInfoList[indexPath.row];
    
    NSArray *itemListInLine = infoRegion.feildItemList;
    
    for (NSInteger i=0; i<[itemListInLine count]; i++) {
        BLFromFieldItemEntity *fieldItem = itemListInLine[i];
        
        // 计算当前 Label 的宽度
        CGFloat cellWidth = tableView.bounds.size.width;
        CGFloat percent = fieldItem.percent / 100.f;
        CGFloat labelWidth = cellWidth * (percent == 0 ? 1 : percent);

        NSString *nameString = [NSString stringWithFormat:@"%@%@%@%@", fieldItem.beforeName, fieldItem.name, fieldItem.endName, fieldItem.splitString];
        NSString *valueString = [NSString stringWithFormat:@"%@%@%@%@", fieldItem.beforeValue, (fieldItem.eidtValue ? fieldItem.eidtValue : @""), fieldItem.value, fieldItem.endValue];
        
        // 显示 name
        if (fieldItem.nameVisible) {
            // 分行显示，返回 name 加 value 的高度
            if (fieldItem.nameRN) {
                
                CGFloat nameLabelHeight = [self labelSizeWithMaxWidth:labelWidth content:nameString].height;
                CGFloat valueLabelHeight = [self labelSizeWithMaxWidth:labelWidth content:valueString].height;
                
                maxNameContentHeight = MAX(maxNameContentHeight, nameLabelHeight);
                maxValueContentHeight = MAX(maxValueContentHeight, valueLabelHeight);
            }
            // 不分行显示，返回 name 和 value 都在一行的高度
            else {
                CGFloat nameLabelHeight = [self labelSizeWithMaxWidth:labelWidth content:[NSString stringWithFormat:@"%@%@", nameString, valueString]].height;
                maxNameContentHeight = MAX(maxNameContentHeight, nameLabelHeight);
            }
        }
        // 不显示 name，返回 value 的高度
        else {
            CGFloat valueLabelHeight = [self labelSizeWithMaxWidth:labelWidth content:valueString].height;
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


#pragma mark - Action

- (void)eidtButtonPress:(UIButton *)button
{
    self.currentEidtFieldItemIndex = button.tag;
    UITableViewCell *cell = (UITableViewCell *)[[[button superview] superview] superview];
    self.currentEidtRegionIndex = [self.tableView indexPathForCell:cell].row;
    
    UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OpinionNavigation"];
    self.quickOpinionViewController = (BLQuickOpinionViewController *)navVC.topViewController;
    
    self.quickOpinionViewController.delegate = self;
    [navVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [navVC setModalPresentationStyle:UIModalPresentationFormSheet];
    
    [self presentViewController:navVC animated:YES completion:nil];
}


#pragma mark - BLCommonOpinionViewControllerDelegate
// 选择完常用意见
- (void)opinionDidSelecte:(NSString *)opinion
{
    [self.opinionViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - BLMatterOpinionViewControllerDelegate
// 填写完意见
- (void)opinionDidFinish:(NSString *)opinion
{
    BLInfoRegionEntity *infoRegion = self.matterFormInfoList[self.currentEidtRegionIndex];
    
    BLFromFieldItemEntity *fieldItem = infoRegion.feildItemList[self.currentEidtFieldItemIndex];
    
    [self.delegate eidtOpinionForKey:fieldItem.itemID value:opinion];
    
#warning 待实现,加名字
//    fieldItem.value = [NSString stringWithFormat:@"%@\n%@", opinion, [NSDate date]];
    fieldItem.eidtValue = [NSString stringWithFormat:@"%@\n", opinion];
    [self.tableView reloadData];
}


#pragma mark - Private

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    BLInfoRegionEntity *infoRegion = self.matterFormInfoList[indexPath.row];
    
    NSArray *itemListInLine = infoRegion.feildItemList;
    
    CGFloat currentX = 15;
    CGFloat cellWidth = cell.contentView.bounds.size.width; // cell 的宽度
    
    for (NSInteger i=0; i<[itemListInLine count]; i++) {
        
        BLFromFieldItemEntity *fieldItem = itemListInLine[i];
        
        // 加上一条纵向的分割线
        if (i > 0 && infoRegion.vlineVisible) {
            UIView *splitView = [[UIView alloc] initWithFrame:CGRectMake(currentX, 0, 1, cell.frame.size.height)];
            splitView.backgroundColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:splitView];
            
            currentX += 11;
        }
        
        // 计算当前 Label 的宽度
        CGFloat percent = fieldItem.percent / 100.f;
        CGFloat labelWidth = (cellWidth - 15) * (percent == 0 ? 1 : percent) - 10;
        
        NSString *nameString = [NSString stringWithFormat:@"%@%@%@%@", fieldItem.beforeName, fieldItem.name, fieldItem.endName, fieldItem.splitString];
        NSString *valueString = [NSString stringWithFormat:@"%@%@%@%@", fieldItem.beforeValue, (fieldItem.eidtValue ? fieldItem.eidtValue : @""), fieldItem.value, fieldItem.endValue];
//        NSString *valueString = [NSString stringWithFormat:@"%@%@%@", fieldItem.beforeValue, fieldItem.value, fieldItem.endValue];
        /** 配置 Label 的显示内容 */
        // 显示 name
        if (fieldItem.nameVisible) {
            // 分行显示
            if (fieldItem.nameRN) {
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, 8, labelWidth, 20)];
                nameLabel.text = nameString;
                nameLabel.textColor = [self colorWithString:fieldItem.nameColor];
                
                CGFloat valueLabelHeight = [self labelSizeWithMaxWidth:labelWidth content:valueString].height;
                // value 标签
                UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, 30, labelWidth, valueLabelHeight)];
                valueLabel.numberOfLines = 0;
                valueLabel.text = [NSString stringWithFormat:@"  %@", valueString];
                valueLabel.textColor = [self colorWithString:fieldItem.valueColor];
                valueLabel.textAlignment = [self alignmentWithString:fieldItem.align];
                
                [cell.contentView addSubview:nameLabel];
                [cell.contentView addSubview:valueLabel];
            }
            // 不分行显示
            else {
                UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, 8, labelWidth, 20)];
                
                NSMutableAttributedString *nameAttrString = [[NSMutableAttributedString alloc] initWithString:nameString];
                NSMutableAttributedString *valueAttrString = [[NSMutableAttributedString alloc] initWithString:valueString];
                
                [nameAttrString beginEditing];
                [nameAttrString addAttribute:NSForegroundColorAttributeName value:[self colorWithString:fieldItem.nameColor] range:[nameString rangeOfString:nameString]];
                [nameAttrString endEditing];
                
                [valueAttrString beginEditing];
                [valueAttrString addAttribute:NSForegroundColorAttributeName value:[self colorWithString:fieldItem.valueColor] range:[valueString rangeOfString:valueString]];
                [valueAttrString endEditing];
                
                [nameAttrString appendAttributedString:valueAttrString];
                
                aLabel.attributedText = nameAttrString;
                
                [cell.contentView addSubview:aLabel];
            }
        }
        // 不显示 name
        else {
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, 8, labelWidth, 20)];
            valueLabel.text = valueString;
            valueLabel.textColor = [self colorWithString:fieldItem.valueColor];
            valueLabel.textAlignment = [self alignmentWithString:fieldItem.align];
            
            [cell.contentView addSubview:valueLabel];
        }
        
        // 是否可以编辑
        if ([fieldItem.mode isEqualToString:@"1"] && [fieldItem.inputType isEqualToString:@"11"]) {
            UIButton *eidtButton = [[UIButton alloc] initWithFrame:CGRectMake(currentX, 0, labelWidth, cell.bounds.size.height)];
            // 用 tag 记录当前编辑的 item 的 index
            eidtButton.tag = i;
            [eidtButton addTarget:self action:@selector(eidtButtonPress:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:eidtButton];
        }
        
        currentX += labelWidth;  // 左移 x 值，供后续 Label 使用
    }
}

- (CGSize)labelSizeWithMaxWidth:(CGFloat)width content:(NSString *)content
{
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
    
    return [content boundingRectWithSize:CGSizeMake(width, 1000)
                                 options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                              attributes:dic
                                 context:nil].size;
}

- (UIColor *)colorWithString:(NSString *)colorStr
{
    if ([colorStr isEqualToString:@"red"]) {
        return [UIColor redColor];
    }
    else if ([colorStr isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    }
    else if ([colorStr isEqualToString:@"green"]) {
        return [UIColor greenColor];
    }
    else {
        return [UIColor blackColor];
    }
}

- (NSTextAlignment)alignmentWithString:(NSString *)alignStr
{
    if ([alignStr isEqualToString:@"Right"]) {
        return NSTextAlignmentRight;
    }
    else if ([alignStr isEqualToString:@"Left"]) {
        return NSTextAlignmentLeft;
    }
    else if ([alignStr isEqualToString:@"Center"]) {
        return NSTextAlignmentCenter;
    }
    else {
        return NSTextAlignmentLeft;
    }
}

@end
