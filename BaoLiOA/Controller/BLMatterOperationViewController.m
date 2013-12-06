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
#import "BLMatterOprationService.h"
#import "BLManageFollowViewController.h"
#import "BLMatterInfoService.h"

@interface BLMatterOperationViewController () <BLManageFollowViewControllerDelegate>

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
@property (strong, nonatomic) BLMatterOprationService *matterOprationService;

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

@end

@implementation BLMatterOperationViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.matterOprationService = [[BLMatterOprationService alloc] init];
        self.matterInfoService = [[BLMatterInfoService alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self loadDefualtVC];
    
	[self.matterInfoService matterDetailInfoWithMatterID:self.matterID block:^(NSDictionary *dic, NSError *error) {
        self.matterFormInfoList = dic[kBLMatterInfoServiceFormInfo];
        self.matterOperationList = dic[kBLMatterInfoServiceOperationInfo];
        self.matterAttachList = dic[kBLMatterInfoServiceAttachInfo];
    }];
    
    // 为默认第一个被选中的 segment 获取对应的 view controller
    UIViewController *vc = [self viewControllerForSelectedSegment];
    if ([vc respondsToSelector:@selector(setMatterFormInfoList:)]) {
        [vc performSelector:@selector(setMatterFormInfoList:) withObject:self.matterFormInfoList];
    }
    
    [self switchVC:vc];
    
    // 将当前正在操作的「事项」的 ID 传给有需要的子视图控制器
    //    if ([vc respondsToSelector:@selector(setMatterID:)]) {
    //        [vc performSelector:@selector(setMatterID:) withObject:self.matterID];
    //    }
    //
    
}

#pragma - mark Action

- (IBAction)segmentChanged:(UISegmentedControl *)segmentedControl
{
    UIViewController *vc = [self viewControllerForSelectedSegment];
    
    // 将当前正在操作的「事项」的 ID 传给有需要的子视图控制器
    if ([vc respondsToSelector:@selector(setMatterID:)]) {
        [vc performSelector:@selector(setMatterID:) withObject:self.matterID];
    }
    
    [self addChildViewController:vc];
    
    [self.currentViewController.view removeFromSuperview];
    
    vc.view.frame = self.contentView.bounds;
    [self.contentView addSubview:vc.view];
    
    [vc didMoveToParentViewController:self];
    [self.currentViewController removeFromParentViewController];
    
    self.currentViewController = vc;
    
    // 动画
    //    [self transitionFromViewController:self.currentViewController
    //                      toViewController:vc
    //                              duration:0.5
    //                               options:UIViewAnimationOptionOverrideInheritedOptions
    //                            animations:^{
    //                                [self.currentViewController.view removeFromSuperview];
    //                                vc.view.frame =self.contentView.bounds;
    //                                [self.contentView addSubview:vc.view];
    //                            }
    //                            completion:^(BOOL finished){
    //                                [vc didMoveToParentViewController:self];
    //                                [self.currentViewController removeFromParentViewController];
    //                                self.currentViewController = vc;
    //                            }
    //    ];
}

// 提交
- (IBAction)submitButtonPress:(id)sender
{
    self.isSelectionPersonnel = NO;
    [self.matterOprationService folloDepartmentWithBlock:^(NSArray *list, NSError *error) {
        
        if (error) {
            
        }
        else if ([list count] > 0) {
              UINavigationController *navigation = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowNavigation"];
            BLManageFollowViewController *manageFollowViewController = (BLManageFollowViewController *)[navigation topViewController];
            manageFollowViewController.followList = list;
            manageFollowViewController.delegate = self;
            manageFollowViewController.title = @"办理路由";
            
            [navigation setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [navigation setModalPresentationStyle:UIModalPresentationFormSheet];
            
            [self presentViewController:navigation animated:YES completion:nil];
        }
        else {
            // 提交服务器
        }
    }];
}

// 已阅
- (IBAction)HasReadButtonPress:(id)sender
{
    
}

// 暂存
- (IBAction)temporaryButtonPress:(id)sender
{
    
}

// 回退
- (IBAction)fallbackButtonPress:(id)sender
{
    
}

#pragma - mark BLManageFollowViewControllerDelegate

- (void)FollowDidSelected:(NSArray *)followList
{
    if (self.isSelectionPersonnel) {
        
        // 提交服务器
    }
    else {
        
        
        [self.matterOprationService folloDepartmentWithBlock:^(NSArray *list, NSError *error) {
            
            if (error) {
                
            }
            else if ([list count] > 0) {
                self.isSelectionPersonnel = YES;
                
                UINavigationController *navigation = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowNavigation"];
                BLManageFollowViewController *manageFollowViewController = (BLManageFollowViewController *)[navigation topViewController];
                manageFollowViewController.followList = list;
                manageFollowViewController.delegate = self;
                manageFollowViewController.title = @"办理人员";
                
                [navigation setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                [navigation setModalPresentationStyle:UIModalPresentationFormSheet];
                
                [self presentViewController:navigation animated:YES completion:nil];
            }
            else {
                // 提交服务器
            }
        }];
    }
}

#pragma - mark Private

//- (void)loadDefualtVC
//{
//    // 为默认第一个被选中的 segment 获取对应的 view controller
//    UIViewController *vc = [self viewControllerForSelectedSegment];
//    
//    // 将当前正在操作的「事项」的 ID 传给有需要的子视图控制器
//    //    if ([vc respondsToSelector:@selector(setMatterID:)]) {
//    //        [vc performSelector:@selector(setMatterID:) withObject:self.matterID];
//    //    }
//    //
//    [self addChildViewController:vc];
//    
//    // 修改新加入的的视图的尺寸，可以刚好放在预留好的地方
//    vc.view.frame = self.contentView.bounds;
//    [self.contentView addSubview:vc.view];
//    
//    self.currentViewController = vc;
//}

- (void)switchVC:(UIViewController *)vc
{
    [self addChildViewController:vc];
    
    // 修改新加入的的视图的尺寸，可以刚好放在预留好的地方
    vc.view.frame = self.contentView.bounds;
    [self.contentView addSubview:vc.view];
    
    self.currentViewController = vc;
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
