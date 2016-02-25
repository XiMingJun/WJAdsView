//
//  ViewController.m
//  WJAdsViewDemo
//
//  Created by wangjian on 16/2/25.
//  Copyright © 2016年 qhfax. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "WJAdsView.h"
@interface ViewController ()<WJAdsViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor brownColor];
    [self performSelector:@selector(showAdsView)
               withObject:nil
               afterDelay:2];
}
- (void)showAdsView{
    //    [_infoCard show];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    WJAdsView *adsView = [[WJAdsView alloc] initWithWindow:app.window];
    adsView.tag = 10;
    adsView.delegate = self;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,adsView.mainContainView.frame.size.width, adsView.mainContainView.frame.size.width)];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"视图 %d", i+1];
        label.textColor = [UIColor redColor];
        label.backgroundColor = [UIColor colorWithRed:0 green:183.0/255.0 blue:238.0/255.0 alpha:1.000];
        label.layer.cornerRadius = adsView.mainContainView.frame.size.width/2;
        label.layer.masksToBounds = YES;
        [array addObject:label];
    }
    [self.view addSubview:adsView];
    adsView.containerSubviews = array;
    [adsView showAnimated:YES];
}
- (void)hide{
    
    WJAdsView *adsView = (WJAdsView *)[self.view viewWithTag:10];
    [adsView hideAnimated:YES];
    
}
- (void)wjAdsViewDidAppear:(WJAdsView *)view{
    
    NSLog(@"视图出现");
    
}
- (void)wjAdsViewDidDisAppear:(WJAdsView *)view{
    
    NSLog(@"视图消失");
    
}
- (void)wjAdsViewTapMainContainView:(WJAdsView *)view currentSelectIndex:(long)selectIndex{
    NSLog(@"点击主内容视图:--%ld",selectIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
