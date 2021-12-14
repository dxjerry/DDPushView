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
    [button setTitle:@"向下弹出，有标题" forState:UIControlStateNormal];
    button.layer.cornerRadius = 8;
    button.layer.borderColor = UIColor.blackColor.CGColor;
    button.layer.borderWidth = 1;
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [button addTarget:self action:@selector(PushOutDDView:) forControlEvents:UIControlEventTouchUpInside];
    button.tag=101;
    [self.view addSubview:button];
    
    
    UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(50, 100+(50+20)*1, 200, 50)];
    [button2 setTitle:@"向上弹出，有标题" forState:UIControlStateNormal];
    button2.layer.cornerRadius = 8;
    button2.layer.borderColor = UIColor.blackColor.CGColor;
    button2.layer.borderWidth = 1;
    [button2 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(PushOutDDView:) forControlEvents:UIControlEventTouchUpInside];
    button2.tag=102;
    [self.view addSubview:button2];
    
    
    UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(50, 100+(50+20)*2, 200, 50)];
    [button3 setTitle:@"向下弹出，无标题" forState:UIControlStateNormal];
    button3.layer.cornerRadius = 8;
    button3.layer.borderColor = UIColor.blackColor.CGColor;
    button3.layer.borderWidth = 1;
    [button3 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(PushOutDDView:) forControlEvents:UIControlEventTouchUpInside];
    button3.tag=103;
    [self.view addSubview:button3];
    
    
    UIButton *button4 = [[UIButton alloc]initWithFrame:CGRectMake(50, 100+(50+20)*3, 200, 50)];
    [button4 setTitle:@"向上弹出，无标题" forState:UIControlStateNormal];
    button4.layer.cornerRadius = 8;
    button4.layer.borderColor = UIColor.blackColor.CGColor;
    button4.layer.borderWidth = 1;
    [button4 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(PushOutDDView:) forControlEvents:UIControlEventTouchUpInside];
    button4.tag=104;
    [self.view addSubview:button4];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//弹出
-(void)PushOutDDView:(UIButton *)sender {
    //设置需要在弹出框里显示的视图
    UIView *view = [[UIView alloc]init];
    
    //只需要设置视图的长宽即可
    if ((sender.tag==101)||(sender.tag==103)){
        view.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 600);
    }
    else if ((sender.tag==102)||sender.tag==104){
        view.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 600);
    }
    
    
    UILabel *labeltext = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    labeltext.backgroundColor = [UIColor colorWithRed:243/255.0f green:243/255.0f blue:243/255.0f alpha:1];
    labeltext.text = @"这里设置需要弹出的视图";
    labeltext.textColor = UIColor.blackColor;
    labeltext.textAlignment = NSTextAlignmentCenter;
    labeltext.font = [UIFont systemFontOfSize:18];
    [view addSubview:labeltext];
    
    
    //初始化弹出视图
    DDPushView *pushview = [[DDPushView alloc]init];
    pushview.mainview = view;//已经设置好的显示视图
    if (sender.tag==101){
        pushview.title = @"这里设置标题";
        pushview.direction = 1;
    }
    else if (sender.tag==102){
        pushview.title = @"这里设置标题";
        pushview.direction = 2;
    }
    else if (sender.tag==103){
        pushview.title = @"";//或不设置
        pushview.direction = 1;
    }
    else if (sender.tag==104){
        pushview.title = @"";//或不设置
        pushview.direction = 2;
    }
    else{}
    [pushview PushOutView];//弹出动画
    //通过block获得返回值
    pushview.comfirm = ^(NSInteger index){
        NSLog(@"%ld",(long)index);
    };
}
@end
