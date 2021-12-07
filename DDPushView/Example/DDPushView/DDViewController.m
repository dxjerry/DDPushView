//
//  DDViewController.m
//  DDPushView
//
//  Created by dxjerry on 12/07/2021.
//  Copyright (c) 2021 dxjerry. All rights reserved.
//

#import "DDViewController.h"
#import "DDPushView.h"

@interface DDViewController ()

@end

@implementation DDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 100, 200, 50)];
    button.backgroundColor = UIColor.yellowColor;
    [button setTitle:@"PushOut" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(PushOutDDView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//弹出
-(void)PushOutDDView{
    //设置需要在弹出框里显示的视图
    UIView *showview = [[UIView alloc]init];
    //只需要设置视图的长宽即可
    showview.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 600);
    UILabel *labeltext = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 200, 60)];
    labeltext.backgroundColor = UIColor.greenColor;
    labeltext.text = @"hello";
    labeltext.textColor = UIColor.whiteColor;
    labeltext.font = [UIFont systemFontOfSize:16];
    [showview addSubview:labeltext];
    
    
    //初始化弹出视图
    DDPushView *pushview = [[DDPushView alloc]init];
    pushview.title = @"这里设置标题";
    pushview.mainview = showview;//已经设置好的显示视图
    [pushview PushAlertView];//弹出动画
    //通过block获得返回值
    pushview.comfirm = ^(NSInteger index){
        NSLog(@"%ld",(long)index);
    };
}

@end
