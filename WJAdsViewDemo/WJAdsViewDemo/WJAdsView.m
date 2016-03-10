//
//  WJAdsView.m
//  QKInfoCardDemo
//
//  Created by wangjian on 16/2/4.
//  Copyright © 2016年 qhfax. All rights reserved.
//

#import "WJAdsView.h"


# define CloseButton_Width 30 //关闭按钮宽度
# define Line_Width   1.5f   //线条宽度
//RGB转UIColor（带alpha值）
# define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

# pragma mark-----内容视图
@implementation WJAdsContainerView
{
    UIScrollView  *_scrollView;
    
}
@synthesize containtViews;
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
    }
    return self;
}
- (void)buildUI{
    
    _scrollView                                = [[UIScrollView alloc] init];
    _scrollView.backgroundColor                = [UIColor whiteColor];
    _scrollView.pagingEnabled                  = YES;
    _scrollView.showsHorizontalScrollIndicator = YES;
    _scrollView.showsVerticalScrollIndicator   = YES;
    _scrollView.delegate                       = self;
    [self addSubview:_scrollView];
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    long subviewCount                 = containtViews.count;
    _scrollView.frame = CGRectInset(self.bounds, 0, 0);
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame) * subviewCount, CGRectGetHeight(_scrollView.frame));
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < subviewCount; i++) {
        UIView *viewToAdd = [containtViews objectAtIndex:i];
        viewToAdd.center = CGPointMake(i * CGRectGetWidth(_scrollView.frame) + _scrollView.frame.size.width/2, _scrollView.center.y);
        [_scrollView addSubview:viewToAdd];
    }
    _scrollView.contentOffset = CGPointZero;
    
}
- (void)setContaintViews:(NSArray *)containtSubViews{
    
    if (containtSubViews.count <= 0) {
        return;
    }
    containtViews = containtSubViews;
    [self layoutSubviews];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    long index = _scrollView.contentOffset.x / self.frame.size.width;
    if (self.scrollViewIndex) {
        self.scrollViewIndex(index);
    }
}
@end

# pragma mark-----关闭按钮
@implementation WJAdsCloseButton
+ (instancetype)buttonWithType:(UIButtonType)buttonType{
    return [super buttonWithType:buttonType];
}
- (void)drawRect:(CGRect)rect {
    
    CGFloat buttonWidth      = MIN(CGRectGetWidth(rect), CGRectGetHeight(rect));
    CGFloat radius           = buttonWidth / 2.0;
    
    self.layer.cornerRadius  = radius;
    self.layer.masksToBounds = YES;
    self.backgroundColor     = [UIColor clearColor];
    self.layer.borderColor   = self.closeButtonTintColor.CGColor;
    self.layer.borderWidth   = Line_Width;
    
    
    CGContextRef contex      = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(contex, self.closeButtonTintColor.CGColor);
    CGContextSetLineWidth(contex,Line_Width);
    
    CGContextBeginPath(contex);
    
    CGPathRef path           = [UIBezierPath bezierPath].CGPath;
    
    CGContextAddPath(contex, path);
    
    CGContextMoveToPoint(contex,rect.size.width/4,rect.size.height/4);
    CGContextAddLineToPoint(contex, CGRectGetMaxX(rect)/4*3, CGRectGetMaxY(rect)/4*3);
    
    CGContextMoveToPoint(contex, CGRectGetMaxX(rect)/4*3, rect.size.height/4);
    CGContextAddLineToPoint(contex,rect.size.width/4, CGRectGetMaxY(rect)/4*3);
    
    CGContextStrokePath(contex);
}
@end
# pragma mark------主视图
@implementation WJAdsView
@synthesize minVertalPadding;
@synthesize minHorizontalPadding;
@synthesize proportion;
@synthesize containerSubviews;
@synthesize closeButton;
@synthesize mainContainView;
@synthesize lineView;
- (instancetype)initWithView:(UIView *)view{
    
    return [self initWithFrame:view.bounds];
    
}
- (instancetype)initWithWindow:(UIWindow *)window{
    
    return [self initWithFrame:window.bounds];
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.size.height, frame.size.width, frame.size.height)];
    if (self) {
        [self buildUI];
    }
    return self;
}
/**构建主视图*/
- (void)buildUI{
    
    self.backgroundColor               = UIColorFromRGBWithAlpha(0x606060, 0.7);
    self.userInteractionEnabled        = YES;
    //    self.alpha                         = 0.0;
    self.clipsToBounds                 = YES;
    _selectIndex                       = 0;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(closeButtonAction:)];
    [self addGestureRecognizer:tapGesture];
    
    mainContainView                    = [[WJAdsContainerView alloc] initWithFrame:CGRectZero];
    mainContainView.backgroundColor    = [UIColor whiteColor];
    mainContainView.scrollViewIndex    = ^(long index){
        _selectIndex = index;
    };
    [self addSubview:mainContainView];
    
    UITapGestureRecognizer *containViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(tapContainView:)];
    [mainContainView addGestureRecognizer:containViewTap];
    
    closeButton                        = [WJAdsCloseButton buttonWithType:UIButtonTypeCustom];
    closeButton.closeButtonTintColor   = [UIColor whiteColor];
    [self addSubview:closeButton];
    [closeButton setNeedsDisplay];
    
    lineView = [[UIView alloc] init];
    lineView.bounds = CGRectMake(0, 0, 1, 0);
    lineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:lineView];
    
    
    self.minHorizontalPadding          = 40;
    self.minVertalPadding              = 120;
    self.proportion                    = 0.875;
    mainContainView.layer.cornerRadius = 10;
    mainContainView.clipsToBounds      = YES;
    
    
}
# pragma mark----set/get
- (void)setMinHorizontalPadding:(float)minHorizontalPadding1{
    
    minHorizontalPadding               = minHorizontalPadding1;
    CGRect containRect                 = mainContainView.frame;
    containRect.origin.x               = minHorizontalPadding;
    containRect.size.width             = self.frame.size.width - minHorizontalPadding *2;
    mainContainView.frame              = containRect;
    
}
- (void)setMinVertalPadding:(float)minVertalPadding1{
    
    minVertalPadding                   = minVertalPadding1;
    CGRect containRect                 = mainContainView.frame;
    containRect.origin.y               = minVertalPadding;
    containRect.size.height            = self.frame.size.height - minVertalPadding *2;
    mainContainView.frame              = containRect;
    
    
}
- (void)setProportion:(float)proportionValue{
    
    if (proportionValue <= 0) {
        return;
    }
    proportion = proportionValue;
    CGRect containRect                 = mainContainView.frame;
    containRect.size.height            = containRect.size.width / proportion;
    //    containRect.origin.y               = (self.frame.size.height - containRect.size.height)/2;
    containRect.origin.y               = self.frame.size.height;
    mainContainView.frame              = containRect;
    
    closeButton.bounds                 = CGRectMake(0, 0,CloseButton_Width,CloseButton_Width);
    closeButton.center                 = CGPointMake(CGRectGetMaxX(mainContainView.frame) - closeButton.bounds.size.width/2, -closeButton.frame.size.height);
    closeButton.layer.cornerRadius     = closeButton.frame.size.width/2;
    closeButton.clipsToBounds          = YES;
    [closeButton addTarget:self
                    action:@selector(closeButtonAction:)
          forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)setContainerSubviews:(NSArray *)containerSubview{
    
    if (containerSubview.count <= 0) {
        return;
    }
    containerSubviews = containerSubview;
    self.mainContainView.containtViews = containerSubviews;
}
- (void)showAnimated:(BOOL)animated{
    
    __weak WJAdsView *weakSelf = self;
    CGRect rect = self.frame;
    rect.origin.y = 0;
    self.frame = rect;
    
    if (animated) {
        [UIView animateWithDuration:.75f
                              delay:0.2
             usingSpringWithDamping:0.65f
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect containRect = weakSelf.mainContainView.frame;
                             containRect.origin.y = (weakSelf.frame.size.height - weakSelf.mainContainView.frame.size.height)/2;
                             weakSelf.mainContainView.frame = containRect;
                             weakSelf.closeButton.center                 = CGPointMake(CGRectGetMaxX(weakSelf.mainContainView.frame) - weakSelf.closeButton.bounds.size.width/2,CGRectGetMinY(weakSelf.mainContainView.frame)/2);
                         }
                         completion:^(BOOL finished) {
                             CGRect lineRect = weakSelf.lineView.frame;
                             lineRect.origin.y = CGRectGetMaxY(weakSelf.closeButton.frame);
                             lineRect.size.height = CGRectGetMinY(weakSelf.mainContainView.frame) - CGRectGetMaxY(weakSelf.closeButton.frame);
                             lineRect.origin.x = weakSelf.closeButton.center.x;
                             weakSelf.lineView.frame = lineRect;
                             
                         }];
    }
    else {
        self.alpha = 1.0f;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(wjAdsViewDidAppear:)]) {
        [self.delegate wjAdsViewDidAppear:self];
    }
    
}
- (void)hideAnimated:(BOOL)animated{
    
    __weak WJAdsView *weakSelf = self;
    if (animated) {
        [UIView animateWithDuration:.5f
                              delay:0.2
             usingSpringWithDamping:0.65f
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect containRect = weakSelf.mainContainView.frame;
                             containRect.origin.y = weakSelf.frame.size.height;
                             weakSelf.mainContainView.frame = containRect;
                             
                             weakSelf.closeButton.center                 = CGPointMake(CGRectGetMaxX(weakSelf.mainContainView.frame) - weakSelf.closeButton.bounds.size.width/2,weakSelf.frame.size.height+ weakSelf.closeButton.frame.size.height/2);
                             CGRect lineRect = weakSelf.lineView.frame;
                             lineRect.origin.y = CGRectGetMaxY(weakSelf.closeButton.frame);
                             weakSelf.lineView.frame = lineRect;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             CGRect rect = weakSelf.frame;
                             rect.origin.y = weakSelf.frame.size.height;
                             weakSelf.frame = rect;
                             weakSelf.alpha = 0.0f;
                             [weakSelf removeFromSuperview];
                         }];
    }
    else {
        [self removeFromSuperview];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(wjAdsViewDidDisAppear:)]) {
        [self.delegate wjAdsViewDidDisAppear:self];
    }
    
}
/**
 *  画线
 *
 *  @param superView 父视图
 *  @param width     线条宽度
 *  @param color     线条颜色
 *  @param sPoint    开始点
 *  @param ePoint    结束点
 */
- (void)drawLineOnView:(UIView *)superView
             lineWidth:(CGFloat )width
          strokeColor :(UIColor *)color
            startPoint:(CGPoint )sPoint
              endPoint:(CGPoint )ePoint
{
    CAShapeLayer *lineShape   = nil;
    CGMutablePathRef linePath = nil;
    linePath                  = CGPathCreateMutable();
    lineShape                 = [CAShapeLayer layer];
    lineShape.lineWidth       = width;
    lineShape.lineCap         = kCALineCapRound;
    lineShape.strokeColor     = color.CGColor;
    CGPathMoveToPoint(linePath, NULL, sPoint.x , sPoint.y );
    CGPathAddLineToPoint(linePath, NULL, ePoint.x , ePoint.y);
    lineShape.path            = linePath;
    CGPathRelease(linePath);
    [superView.layer addSublayer:lineShape];
}
# pragma mark---closeButton Action
/**关闭按钮调用方法*/
- (void)closeButtonAction:(UIButton *)sender{
    [self hideAnimated:YES];
}
/**点击主视图调用方法*/
- (void)tapContainView:(UITapGestureRecognizer *)tapgesture{
    
    [self hideAnimated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(wjAdsViewTapMainContainView: currentSelectIndex:)]) {
        [self.delegate wjAdsViewTapMainContainView:self currentSelectIndex:_selectIndex];
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
