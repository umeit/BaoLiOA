//
//  BLMatterOperationViewController.m
//  BaoLiOA
//
//  操作「事项」的主视图。
//  它管理了「表单」、「操作列表」、「附件」和「发表意见」四个部分。（「流程」视图暂无）
//
//  Created by Liu Feng on 13-11-24.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "BLMatterOperationViewController.h"
#import "BLMatterOperationService.h"
#import "BLManageFollowViewController.h"
#import "BLMatterOpinionViewController.h"
#import "BLMatterInfoService.h"
#import "UIViewController+GViewController.h"
#import "NSArray+GArray.h"

#define OperationButtonParentViewTag 30

#define Route    0
#define Employee 1

@interface BLMatterOperationViewController () <BLManageFollowViewControllerDelegate, BLMatterOpinionViewControllerDelegate>

/**
 *  切换控件
 */
@property (weak, nonatomic) IBOutlet UISegmentedControl *SegmentView;

/**
 *  界面中间用于显示切换的视图
 */
@property (weak, nonatomic) IBOutlet UIView *contentView;

/**
 *  记录当前切换到的 controller
 */
@property (strong, nonatomic) UIViewController *currentViewController;

/**
 *  操作「事项」服务
 */
@property (strong, nonatomic) BLMatterOperationService *matterOprationService;

/**
 *  获取「事项」信息的服务
 */
@property (strong, nonatomic) BLMatterInfoService *matterInfoService;

/**
 *  记录是否已选过部门
 */
@property (nonatomic) BOOL isSelectionPersonnel;

/**
 *  Form 信息
 */
@property (strong, nonatomic) NSArray *matterFormInfoList;

/**
 *  操作选项列表
 */
@property (strong, nonatomic) NSArray *matterOperationList;

/**
 *  附件列表
 */
@property (strong, nonatomic) NSArray *matterAttachList;

/**
 * 附加信息
 */
@property (strong, nonatomic) NSDictionary *matterAppendInfo;

@property (strong, nonatomic) NSArray *matterReturnDataInfo;

/**
 *  保存用户的意见
 */
@property (strong, nonatomic) NSString *comment;

/**
 *  保存用户意见的正文
 */
//@property (strong, nonatomic) NSString *commentText;

/**
 *  用于回传的字段
 */
@property (strong, nonatomic) NSArray *commentList;

/**
 *  代表当前是在选择部门路由还是在选择人员
 */
@property (nonatomic) NSInteger currentSelectRoute;

/**
 *  待选择的部门路由
 */
@property (strong, nonatomic) NSArray *routeList;

/**
 *  已选择的部门路由
 */
@property (strong, nonatomic) NSMutableArray *selectedRouteList;

/**
 *  待选择的办理人员
 */
@property (strong, nonatomic) NSArray *employeeList;

/**
 *  已选择的办理人员
 */
@property (strong, nonatomic) NSMutableArray *selectedEmployeeList;

/**
 *  正文附件 ID
 */
@property (strong, nonatomic) NSString *matterBodyDocID;

/**
 *  记录对事项当前的操作
 */
@property (strong, nonatomic) NSString *currentActionID;

@end

@implementation BLMatterOperationViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _matterOprationService = [[BLMatterOperationService alloc] init];
        _matterInfoService = [[BLMatterInfoService alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	[self.matterInfoService matterDetailInfoWithMatterID:self.matterID block:^(NSDictionary *dic, NSError *error) {
        // 获取到表单列表
        self.matterFormInfoList = dic[kBLMatterInfoServiceFormInfo];
        // 获取到操作列表
        self.matterOperationList = dic[kBLMatterInfoServiceOperationInfo];
        // 获取到附件列表
        self.matterAttachList = dic[kBLMatterInfoServiceAttachInfo];
        // 获取正文附件 ID
        self.matterBodyDocID = dic[kBLMatterInfoServiceBodyDocID];
        // 获取附加信息
        self.matterAppendInfo = dic[kBlMatterInfoServiceAppendInfo];
        // 获取回传信息
        self.matterReturnDataInfo = dic[kBlMatterInfoServiceReturnDataInfo];
        // 放置操作按钮到界面上
        [self initOperationButton:self.matterOperationList];
        
        // 默认被选中的 view controller，为 表单 controller
        UIViewController *vc = [self viewControllerForSelectedSegment];
        
        [self switchVC:vc];
    }];
}


#pragma - mark Action

- (IBAction)segmentChanged:(UISegmentedControl *)segmentedControl
{
    UIViewController *vc = [self viewControllerForSelectedSegment];
    
    [self switchVC:vc];
}

- (void)operationButtonPress:(UIButton *)button
{
    NSString *actionID = [self actionIDWithButtonName:button.titleLabel.text];
    
    NSString *comment = @"同意";
    
    self.currentActionID = actionID;
    
    [self operationMatterWithAction:actionID
                            comment:comment
                          routeList:nil
                       employeeList:nil
                           matterID:self.matterID];
}


#pragma - mark BLManageFollowViewControllerDelegate

- (void)followDidSelected:(NSArray *)followList
{
    // 本次返回的是「部门路由」
    if (self.currentSelectRoute == Route) {
        self.selectedRouteList = [[NSMutableArray alloc] init];
        for (NSNumber *selectedIndex in followList) {
            [self.selectedRouteList addObject:self.routeList[[selectedIndex integerValue]][@"RouteID"]];
        }
    }
    // 本次返回的是「办理人员」
    else if (self.currentSelectRoute == Employee) {
        self.selectedEmployeeList = [[NSMutableArray alloc] init];
        for (NSNumber *selectedIndex in followList) {
            [self.selectedEmployeeList addObject:self.employeeList[[selectedIndex integerValue]][@"UserID"]];
        }
    }
    
#warning 改用用真实的意见
    [self operationMatterWithAction:self.currentActionID
                            comment:@"同意"
                          routeList:self.selectedRouteList
                       employeeList:self.selectedEmployeeList
                           matterID:self.matterID];
}


#pragma - mark BLMatterOpinionViewControllerDelegate
// 保存用户选择的意见
- (void)opinionDidSelect:(NSString *)opinion
{
    self.comment = opinion;
}


#pragma - mark Private
// 通过操作的名称获取操作 ID
- (NSString *)actionIDWithButtonName:(NSString *)name
{
    for (NSDictionary *operationInfo in self.matterOperationList) {
        if ([operationInfo[@"ActionName"] isEqualToString:name]) {
            return operationInfo[@"ActionID"];
        }
    }
    return nil;
}

// 提交对事项的操作
- (void)operationMatterWithAction:(NSString *)actionID
                          comment:(NSString *)comment
                        routeList:(NSArray *)routList
                     employeeList:(NSArray *)employeeList
                         matterID:(NSString *)matterID
{
    NSString *currentNodeID = self.matterAppendInfo[@"currentNodeID"];
    NSString *currentTrackID = self.matterAppendInfo[@"currentTrackID"];
    NSString *returnData = [self.matterReturnDataInfo oneStringFormat];
    NSString *flowID = self.matterAppendInfo[@"flowID"];
    [self showLodingView];
    
    // 将用户的「意见」和「意见正文」提交
    [self.matterOprationService operationMatterWithAction:actionID comment:comment commentList:returnData
    routeList:routList employeeList:employeeList matterID:matterID flowID:flowID
    currentNodeID:currentNodeID currentTrackID:currentTrackID
    block:^(NSInteger retCode, NSArray *list, NSString *title) {
        
        [self hideLodingView];
        
        if (retCode == kSuccess) {
            
            [self.delegate matterOperationDidFinish];
            
            [self showCustomTextAlert:@"操作成功！" withBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        else if ((retCode == kHasRoute || retCode == kHasEmployee)
                 && [list count] > 0) {
      
            NSArray *itemList;
      
            if (retCode == kHasRoute) {
                self.currentSelectRoute = Route;
                self.routeList = list;
                itemList = [list valueForKey:@"RouteName"];
            }
            else if (retCode == kHasEmployee) {
                self.currentSelectRoute = Employee;
                self.employeeList = list;
                itemList = [list valueForKey:@"UserName"];
            }
      
            // 有待选择的部门或待选择的办理人员
            UINavigationController *navigation = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowNavigation"];
            BLManageFollowViewController *manageFollowViewController = (BLManageFollowViewController *)[navigation topViewController];
      
            manageFollowViewController.title = title;
      
            manageFollowViewController.followList = itemList;
            manageFollowViewController.delegate = self;
      
            [navigation setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [navigation setModalPresentationStyle:UIModalPresentationFormSheet];
      
            [self presentViewController:navigation animated:YES completion:nil];
        }
        else {
            [self showCustomTextAlert:@"操作失败，请稍后再试。"];
        }
    }];
}

- (void)initOperationButton:(NSArray *)buttonList
{
    // 计算每个 Button 的宽度
    CGFloat buttonWidth = 703.f / [buttonList count];
    
    CGFloat x = 0;
    
    for (NSDictionary *buttonInfo in buttonList) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, buttonWidth, 70)];
        
        [button addTarget:self action:@selector(operationButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:buttonInfo[@"ActionName"] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor grayColor]];
        
        [[self.view viewWithTag:OperationButtonParentViewTag] addSubview:button];
        
        x += buttonWidth;
    }
}

- (void)switchVC:(UIViewController *)vc
{
    [self addChildViewController:vc];
    
    [self.currentViewController.view removeFromSuperview];
    
    // 修改新加入的的视图的尺寸，可以刚好放在预留好的地方
    vc.view.frame = self.contentView.bounds;
    [self.contentView addSubview:vc.view];
    
    [vc didMoveToParentViewController:self];
    [self.currentViewController removeFromParentViewController];
    
    self.currentViewController = vc;
    
    // 设置事项 ID
    if ([vc respondsToSelector:@selector(setMatterID:)]) {
        [vc performSelector:@selector(setMatterID:) withObject:self.matterID];
    }
    
    // 设置表单列表
    if ([vc respondsToSelector:@selector(setMatterFormInfoList:)]) {
        [vc performSelector:@selector(setMatterFormInfoList:) withObject:self.matterFormInfoList];
    }
    
    // 设置附件列表
    if ([vc respondsToSelector:@selector(setMatterAttachList:)]) {
        [vc performSelector:@selector(setMatterAttachList:) withObject:self.matterAttachList];
    }
    
    // 设置 delegate
    if ([vc respondsToSelector:@selector(setDelegate:)]) {
        [vc performSelector:@selector(setDelegate:) withObject:self];
    }
    
    // 设置 MatterID
    if ([vc respondsToSelector:@selector(setMatterID:)]) {
        [vc performSelector:@selector(setMatterID:) withObject:self.matterID];
    }
    
    // 设置正文附件ID
    if ([vc respondsToSelector:@selector(setMatterBodyDocID:)]) {
        [vc performSelector:@selector(setMatterBodyDocID:) withObject:self.matterBodyDocID];
    }
}

- (UIViewController *)viewControllerForSelectedSegment
{
    UIViewController *vc;
    
    // 根据 segment 的 index 找到相应的 view controller
    switch (self.SegmentView.selectedSegmentIndex) {
        case 0:
            // 表单视图
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BLMatterFormViewController"];
            break;
            
        case 1:
            // 附件视图
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BLMatterAttachmentListViewController"];
            break;
            
        case 2:
            // 流程视图
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BLMatterFlowListViewController"];
            break;
            
        case 3:
            // 意见视图
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BLMatterOpinionViewController"];
            break;
        default:
            break;
    }
    return vc;
}

@end
