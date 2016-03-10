//
//  WJAdsView.h
//  QKInfoCardDemo
//
//  Created by wangjian on 16/2/4.
//  Copyright © 2016年 qhfax. All rights reserved.
//
//广告弹框视图
#import <UIKit/UIKit.h>

# pragma mark-----内容视图
@interface WJAdsContainerView : UIView<UIScrollViewDelegate>
@property (strong, nonatomic) NSArray *containtViews;
@property (nonatomic,copy)void (^scrollViewIndex)(long index);
@end

@interface WJAdsCloseButton : UIButton
/**关闭按钮前景色*/
@property (nonatomic,retain)UIColor *closeButtonTintColor;
@end
# pragma mark------主视图

@class WJAdsView;

@protocol WJAdsViewDelegate <NSObject>
@optional
/**
 *  广告弹框视图已经出现
 *
 *  @param view 弹框视图
 */
- (void)wjAdsViewDidAppear:(WJAdsView *)view;
/**
 *  广告弹框视图已经消失
 *
 *  @param view 弹框视图
 */
- (void)wjAdsViewDidDisAppear:(WJAdsView *)view;
/**
 *  点击主内容视图
 *
 *  @param view 弹框视图
 *  @param selectIndex 当前选中索引
 */
- (void)wjAdsViewTapMainContainView:(WJAdsView *)view
                 currentSelectIndex:(long)selectIndex;

@end
@interface WJAdsView : UIView
{
    long _selectIndex;//当前索引值
}
/**内容视图数组*/
@property (nonatomic,retain) NSArray *containerSubviews;
/**主内容视图*/
@property (nonatomic,retain) WJAdsContainerView *mainContainView;
/**关闭按钮*/
@property (nonatomic,retain) WJAdsCloseButton *closeButton;
@property (nonatomic,retain) UIView *lineView;//直线
/**水平边距*/
@property (nonatomic,assign) float minHorizontalPadding;
/**垂直边距*/
@property (nonatomic,assign) float minVertalPadding;
/**宽高比例*/
@property (nonatomic,assign) float proportion;

@property (nonatomic,weak) id <WJAdsViewDelegate> delegate;

- (instancetype)initWithView:(UIView *)view;
- (instancetype)initWithWindow:(UIWindow *)window;
- (void)showAnimated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;
@end


