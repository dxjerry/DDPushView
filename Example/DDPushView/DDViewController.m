//
//  DDViewController.m
//  DDPushView
//
//  Created by dxjerry on 12/08/2021.
//  Copyright (c) 2021 dxjerry. All rights reserved.
//

#import "DDViewController.h"
#import "DDPushView.h"

@interface DDViewController ()

@end

@implementation DDViewController

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 100, 200, 50)];
    [button setTitle:@"PushOut" forState:UIControlStateNormal];
    button.layer.cornerRadius = 8;
    button.layer.borderColor = UIColor.blackColor.CGColor;
    button.layer.borderWidth = 1;
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
    UILabel *labeltext = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, showview.frame.size.width, showview.frame.size.height)];
    labeltext.backgroundColor = [UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    labeltext.text = @"这里设置需要弹出的视图";
    labeltext.textColor = UIColor.blackColor;
    labeltext.textAlignment = NSTextAlignmentCenter;
    labeltext.font = [UIFont systemFontOfSize:18];
    [showview addSubview:labeltext];
    
    
    //初始化弹出视图
    DDPushView *pushview = [[DDPushView alloc]init];
    pushview.title = @"这里设置标题";
    pushview.mainview = showview;//已经设置好的显示视图
    [pushview PushOutView];//弹出动画
    //通过block获得返回值
    pushview.comfirm = ^(NSInteger index){
        NSLog(@"%ld",(long)index);
    };
}
@end
