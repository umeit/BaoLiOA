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

@property (strong, nonatomic) BLCommonOpinionViewController *opinionViewController;

@property (strong, nonatomic) BLMatterOpinionViewController *matterOpinionViewController;

@property (strong, nonatomic) BLQuickOpinionViewController *quickOpinionViewController;

@property (nonatomic) NSInteger currentEidtFieldItemIndex;

@property (nonatomic) NSInteger currentEidtRegionIndex;

@property (strong, nonatomic) NSArray *matterFormInfoListForiPhone;

@end

@implementation BLMatterFormViewController

//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    
//    if (self) {
////        _matterOprationService = [[BLMatterOperationService alloc] init];
////        _matterService = [[BLMatterInfoService alloc] init];
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 构建 iPhone 版使用的数据，iPhone 版每行只显示一个 FeildItem
    NSMutableArray *feildItemList = [[NSMutableArray alloc] init];
    for (BLInfoRegionEntity *infoRegion in self.matterFormInfoList) {
        [feildItemList addObjectsFromArray:infoRegion.feildItemList];
    }
    self.matterFormInfoListForiPhone = feildItemList;
    
    // 将必填的 feildItem 项发送给 BLMatterOperationViewController，它将在用户办理事宜时判断用户是否已填写
    [self sendMustEditFeildItemsToOperationViewController];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (IS_IPAD) {
        return [self.matterFormInfoList count];
    }
    else {
//        return [self.matterFormInfoListForiPhone count];
        return [self.matterFormInfoList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (IS_IPAD) {
        static NSString *matterFormBaseCell = @"BLMatterFormBaseCell";
        cell = [tableView dequeueReusableCellWithIdentifier:matterFormBaseCell forIndexPath:indexPath];
        [self iPadConfigureCell:cell atIndexPath:indexPath];
    }
    else {
        static NSString *matterFormBaseCell = @"BLMatterFormBaseCellForiPhone";
        cell = [tableView dequeueReusableCellWithIdentifier:matterFormBaseCell forIndexPath:indexPath];
//        [self iPhoneConfigureCell:cell atIndexPath:indexPath];
        [self iPadConfigureCell:cell atIndexPath:indexPath];
    }

    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD) {
        return [self iPadtableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else {
//        return [self iPhonetableView:tableView heightForRowAtIndexPath:indexPath];
        return [self iPadtableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


#pragma mark - Action

- (void)eidtButtonPress:(UIButton *)button
{
    self.currentEidtFieldItemIndex = button.tag;
    BLFromFieldItemEntity *fieldItem;
    
    if (IS_IPAD) {
        UITableViewCell *cell = (UITableViewCell *)[[[button superview] superview] superview];
        self.currentEidtRegionIndex = [self.tableView indexPathForCell:cell].row;
        
        BLInfoRegionEntity *infoRegion = self.matterFormInfoList[self.currentEidtRegionIndex];
        fieldItem = infoRegion.feildItemList[self.currentEidtFieldItemIndex];
        
    }
    else {
        UITableViewCell *cell = (UITableViewCell *)[[[button superview] superview] superview];
        self.currentEidtRegionIndex = [self.tableView indexPathForCell:cell].row;
        
        BLInfoRegionEntity *infoRegion = self.matterFormInfoList[self.currentEidtRegionIndex];
        fieldItem = infoRegion.feildItemList[self.currentEidtFieldItemIndex];
//        fieldItem = self.matterFormInfoListForiPhone[button.tag];
    }
    
    UINavigationController *navVC;

    navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OpinionNavigation"];

    self.quickOpinionViewController = (BLQuickOpinionViewController *)navVC.topViewController;
    self.quickOpinionViewController.delegate = self;
    
    self.quickOpinionViewController.comment = fieldItem.eidtValue;
    
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
    BLFromFieldItemEntity *fieldItem;
    if (IS_IPAD) {
        BLInfoRegionEntity *infoRegion = self.matterFormInfoList[self.currentEidtRegionIndex];
        
        fieldItem = infoRegion.feildItemList[self.currentEidtFieldItemIndex];
        
        
    }
    else {
        BLInfoRegionEntity *infoRegion = self.matterFormInfoList[self.currentEidtRegionIndex];
        
        fieldItem = infoRegion.feildItemList[self.currentEidtFieldItemIndex];
//        fieldItem = self.matterFormInfoListForiPhone[self.currentEidtFieldItemIndex];
    }
    
    [self.delegate eidtOpinionForKey:fieldItem.itemID value:opinion];
    
    fieldItem.eidtValue = [NSString stringWithFormat:@"%@\n", opinion];
    [self.tableView reloadData];
}


#pragma mark - Private

- (void)sendMustEditFeildItemsToOperationViewController
{
    // 找出所有的必填项
    NSMutableSet *mustEditFeildItems = [[NSMutableSet alloc] init];
    for (BLInfoRegionEntity *infoRegion in self.matterFormInfoList) {
        for (BLFromFieldItemEntity *fieldItem in infoRegion.feildItemList) {
//            if ([fieldItem.mode isEqualToString:@"200"] && [fieldItem.inputType isEqualToString:@"11"]) {
            if (fieldItem.mustInput) {
                [mustEditFeildItems addObject:fieldItem];
            }
        }
    }
    
    [self.operationDelegate mustEditFeildItems:mustEditFeildItems];
}

- (CGFloat)iPadtableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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
//        CGFloat labelWidth = cellWidth * (percent == 0 ? 1 : percent);
        CGFloat labelWidth = (cellWidth - 15) * (percent == 0 ? 1 : percent) - 10;
        
        NSString *nameString = [NSString stringWithFormat:@"%@%@%@%@", fieldItem.beforeName, fieldItem.name, fieldItem.endName, fieldItem.splitString];
        NSString *valueString = [NSString stringWithFormat:@"%@%@%@%@", fieldItem.beforeValue, (fieldItem.eidtValue ? fieldItem.eidtValue : @""), fieldItem.value, fieldItem.endValue];
        
        // 显示 name
        if (fieldItem.nameVisible) {
            // 分行显示，返回 name 加 value 的高度
            if (fieldItem.nameRN) {
                
                CGFloat nameLabelHeight = [self labelSizeWithMaxWidth:labelWidth content:nameString].height;
                CGFloat valueLabelHeight = [self labelSizeWithMaxWidth:labelWidth content:[NSString stringWithFormat:@"  %@", valueString]].height;
                
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

//- (CGFloat)iPhonetableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGFloat nameLabelHeight = 0.f;
//    CGFloat valueLabelHeight = 0.f;
//    
//    BLFromFieldItemEntity *fieldItem = self.matterFormInfoListForiPhone[indexPath.row];
//    
//    CGFloat labelWidth = tableView.bounds.size.width;
//    
//    NSString *nameString = [NSString stringWithFormat:@"%@%@%@%@", fieldItem.beforeName, fieldItem.name, fieldItem.endName, fieldItem.splitString];
//    NSString *valueString = [NSString stringWithFormat:@"%@%@%@%@", fieldItem.beforeValue, (fieldItem.eidtValue ? fieldItem.eidtValue : @""), fieldItem.value, fieldItem.endValue];
//    
//    // 显示 name
//    if (fieldItem.nameVisible) {
//        // 分行显示，返回 name 加 value 的高度
//        if (fieldItem.nameRN) {
//            
//            nameLabelHeight = [self labelSizeWithMaxWidth:labelWidth content:nameString].height;
//            valueLabelHeight = [self labelSizeWithMaxWidth:labelWidth content:valueString].height;
//        }
//        // 不分行显示，返回 name 和 value 都在一行的高度
//        else {
//            nameLabelHeight = [self labelSizeWithMaxWidth:labelWidth content:[NSString stringWithFormat:@"%@%@", nameString, valueString]].height;
//        }
//    }
//    // 不显示 name，返回 value 的高度
//    else {
//        valueLabelHeight = [self labelSizeWithMaxWidth:labelWidth content:valueString].height;
//    }
//    
//    return 8 + nameLabelHeight + valueLabelHeight + 8;
//}

- (void)iPadConfigureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
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
        
        /** 配置 Label 的显示内容 */
        // 显示 name
        if (fieldItem.nameVisible) {
            // 分行显示
            if (fieldItem.nameRN) {
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, 8, labelWidth, 20)];
                nameLabel.text = nameString;
                nameLabel.textColor = [self colorWithString:fieldItem.nameColor];
                
                CGFloat valueLabelHeight = [self labelSizeWithMaxWidth:labelWidth content:[NSString stringWithFormat:@"  %@", valueString]].height;
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
                
                NSMutableAttributedString *nameAttrString = [[NSMutableAttributedString alloc] initWithString:nameString];
                NSMutableAttributedString *valueAttrString = [[NSMutableAttributedString alloc] initWithString:valueString];
                
                [nameAttrString beginEditing];
                [nameAttrString addAttribute:NSForegroundColorAttributeName value:[self colorWithString:fieldItem.nameColor] range:[nameString rangeOfString:nameString]];
                [nameAttrString endEditing];
                
                [valueAttrString beginEditing];
                [valueAttrString addAttribute:NSForegroundColorAttributeName value:[self colorWithString:fieldItem.valueColor] range:[valueString rangeOfString:valueString]];
                [valueAttrString endEditing];
                
                [nameAttrString appendAttributedString:valueAttrString];
                
                CGFloat valueLabelHeight = [self labelSizeWithMaxWidth:labelWidth content:[nameAttrString string]].height;
                UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, 8, labelWidth, valueLabelHeight)];
                aLabel.numberOfLines = 0;
                aLabel.attributedText = nameAttrString;
                
                [cell.contentView addSubview:aLabel];
            }
        }
        // 不显示 name
        else {
            CGFloat valueLabelHeight = [self labelSizeWithMaxWidth:labelWidth content:valueString].height;
            UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, 8, labelWidth, valueLabelHeight)];
            valueLabel.numberOfLines = 0;
            valueLabel.text = valueString;
            valueLabel.textColor = [self colorWithString:fieldItem.valueColor];
            valueLabel.textAlignment = [self alignmentWithString:fieldItem.align];
            
            [cell.contentView addSubview:valueLabel];
        }
        
        // 是否可以编辑
//        if (([fieldItem.mode isEqualToString:@"1"] || [fieldItem.mode isEqualToString:@"200"])
        if (([fieldItem.mode isEqualToString:@"1"] || fieldItem.mustInput)
            && [fieldItem.inputType isEqualToString:@"11"]) {
            
            UIButton *eidtButton = [[UIButton alloc] initWithFrame:CGRectMake(currentX, 0, labelWidth, cell.bounds.size.height)];
            // 用 tag 记录当前编辑的 item 的 index
            eidtButton.tag = i;
            eidtButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.6 blue:0.1 alpha:0.08];
            [eidtButton addTarget:self action:@selector(eidtButtonPress:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:eidtButton];
        }
        
        currentX += labelWidth;  // 左移 x 值，供后续 Label 使用
    }
}

//- (void)iPhoneConfigureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
//{
//    BLFromFieldItemEntity *fieldItem = self.matterFormInfoListForiPhone[indexPath.row];
//    
//    NSString *nameString = [NSString stringWithFormat:@"%@%@%@%@", fieldItem.beforeName, fieldItem.name, fieldItem.endName, fieldItem.splitString];
//    NSString *valueString = [NSString stringWithFormat:@"%@%@%@%@", fieldItem.beforeValue, (fieldItem.eidtValue ? fieldItem.eidtValue : @""), fieldItem.value, fieldItem.endValue];
//    
//    CGFloat labelWidth = cell.contentView.bounds.size.width;
//    
//    /** 配置 Label 的显示内容 */
//    // 显示 name
//    if (fieldItem.nameVisible) {
//        // 分行显示
//        if (fieldItem.nameRN) {
//            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, labelWidth, 20)];
//            nameLabel.text = nameString;
//            nameLabel.textColor = [self colorWithString:fieldItem.nameColor];
//            
//            CGFloat valueLabelHeight = [self labelSizeWithMaxWidth:labelWidth content:valueString].height;
//            // value 标签
//            UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, labelWidth, valueLabelHeight)];
//            valueLabel.numberOfLines = 0;
//            valueLabel.text = [NSString stringWithFormat:@"  %@", valueString];
//            valueLabel.textColor = [self colorWithString:fieldItem.valueColor];
//            valueLabel.textAlignment = [self alignmentWithString:fieldItem.align];
//            
//            [cell.contentView addSubview:nameLabel];
//            [cell.contentView addSubview:valueLabel];
//        }
//        // 不分行显示
//        else {
//            
//            NSMutableAttributedString *nameAttrString = [[NSMutableAttributedString alloc] initWithString:nameString];
//            NSMutableAttributedString *valueAttrString = [[NSMutableAttributedString alloc] initWithString:valueString];
//            
//            [nameAttrString beginEditing];
//            [nameAttrString addAttribute:NSForegroundColorAttributeName value:[self colorWithString:fieldItem.nameColor] range:[nameString rangeOfString:nameString]];
//            [nameAttrString endEditing];
//            
//            [valueAttrString beginEditing];
//            [valueAttrString addAttribute:NSForegroundColorAttributeName value:[self colorWithString:fieldItem.valueColor] range:[valueString rangeOfString:valueString]];
//            [valueAttrString endEditing];
//            
//            [nameAttrString appendAttributedString:valueAttrString];
//            
//            CGFloat valueLabelHeight = [self labelSizeWithMaxWidth:labelWidth content:[nameAttrString string]].height;
//            UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, labelWidth, valueLabelHeight)];
//            aLabel.numberOfLines = 0;
//            aLabel.attributedText = nameAttrString;
//            
//            [cell.contentView addSubview:aLabel];
//        }
//    }
//    // 不显示 name
//    else {
//        CGFloat valueLabelHeight = [self labelSizeWithMaxWidth:labelWidth content:valueString].height;
//        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, labelWidth, valueLabelHeight)];
//        valueLabel.numberOfLines = 0;
//        valueLabel.text = valueString;
//        valueLabel.textColor = [self colorWithString:fieldItem.valueColor];
//        valueLabel.textAlignment = [self alignmentWithString:fieldItem.align];
//        
//        [cell.contentView addSubview:valueLabel];
//    }
//    
//    // 是否可以编辑
//    if ([fieldItem.mode isEqualToString:@"1"] && [fieldItem.inputType isEqualToString:@"11"]) {
//        UIButton *eidtButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, labelWidth, cell.bounds.size.height)];
//        // 用 tag 记录当前编辑的 item 的 index
//        eidtButton.tag = indexPath.row;
//        eidtButton.backgroundColor = [UIColor colorWithRed:0.1 green:0.6 blue:0.1 alpha:0.08];
//        [eidtButton addTarget:self action:@selector(eidtButtonPress:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:eidtButton];
//    }
//}

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
