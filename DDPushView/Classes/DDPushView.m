//
//  DDPushView.m
//  DDPushView
//
//  Created by Dxjerry on 2021/12/6.
//

#import "DDPushView.h"

#define WIN_WIDTH         [UIScreen mainScreen].bounds.size.width
#define WIN_HEIGHT         [UIScreen mainScreen].bounds.size.height
#define RGB_COLOR(_R_,_G_,_B_) [UIColor colorWithRed:_R_/255.0f green:_G_/255.0f blue:_B_/255.0f alpha:1]
#define RGB_COLOR_ALPHA(_R_,_G_,_B_,_ALPHA_) [UIColor colorWithRed:_R_/255.0f green:_G_/255.0f blue:_B_/255.0f alpha:_ALPHA_]

//适配iPhone X
#define IS_IPHONE_X ({\
BOOL isBangsScreen = NO; \
if (@available(iOS 11.0, *)) { \
UIWindow *window = [[UIApplication sharedApplication].windows firstObject]; \
isBangsScreen = window.safeAreaInsets.bottom > 0; \
} \
isBangsScreen; \
})
#define Height_Indicator (((IS_IPHONE_X ) == (YES))?(34.0): (0.0))

@interface DDPushView()<UIGestureRecognizerDelegate>
{
    float startY;
    CGPoint startGCenter;
    
    CGRect rectShow;
    CGRect rectHide;
    
}
/** 弹窗 */
@property(nonatomic,strong) UIView *alertView;

@end
@implementation DDPushView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = RGB_COLOR_ALPHA(0, 0, 0, 0.5);
        
        startGCenter = CGPointMake(0, 0);
        
        rectHide = CGRectMake(0, WIN_HEIGHT, WIN_WIDTH, WIN_HEIGHT);
        
        UIButton *buttoncancel=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        buttoncancel.backgroundColor=[UIColor clearColor];
        [buttoncancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttoncancel];
        
        self.alertView = [[UIView alloc]init];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius = 10.0;
        self.alertView.layer.shouldRasterize = YES;
        self.alertView.layer.rasterizationScale = UIScreen.mainScreen.scale;
        //计算高度
        self.alertView.frame = rectHide;
        //self.alertView.contentSize=CGSizeMake(WIN_WIDTH, WIN_HEIGHT*3);
        [self addSubview:self.alertView];
        
        
        UIImageView *buttonX=[[UIImageView alloc]initWithFrame:CGRectMake(self.alertView.frame.size.width-15-16, 15, 16, 16)];
        NSBundle *imageBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[DDPushView class]] pathForResource:@"DDPushView" ofType:@"bundle"]];
        buttonX.image=[UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"btn_guanbi" ofType:@"png"]];
        UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancel)];
        buttonX.userInteractionEnabled = YES;
        [buttonX addGestureRecognizer:Tap];
        [self.alertView addSubview:buttonX];
        
        self.labeltitle=[[UILabel alloc]initWithFrame:CGRectMake(20+15, 20-7.5, self.alertView.frame.size.width-2*(20+15), 30)];
        self.labeltitle.textAlignment=NSTextAlignmentCenter;
        self.labeltitle.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
        self.labeltitle.textColor=RGB_COLOR(51, 51, 51);
        [self.alertView addSubview:self.labeltitle];
        
        self.viewline=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.labeltitle.frame)+10, self.alertView.frame.size.width, 1)];
        self.viewline.backgroundColor=RGB_COLOR(243, 243, 243);
        [self.alertView addSubview:self.viewline];
        
        
        UIPanGestureRecognizer * alertViewpan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(Alertpan:)];
        alertViewpan.delegate=self;
        [self.alertView addGestureRecognizer:alertViewpan];
    }
    return self;
}

-(void)setMainview:(UIView *)mainview{
    _mainview = mainview;
    
    //确定弹出时的位置
    rectShow = CGRectMake(0, WIN_HEIGHT-Height_Indicator-mainview.frame.size.height-(20-7.5+30+1), WIN_WIDTH, WIN_HEIGHT);
    
    mainview.frame = CGRectMake(0, CGRectGetMaxY(self.viewline.frame), mainview.frame.size.width, mainview.frame.size.height);
    [self.alertView addSubview:mainview];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.labeltitle.text=title;
}


#pragma mark - 弹出
-(void)PushAlertView
{
    UIWindow *rootWindow = [UIApplication sharedApplication].windows[0];
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}

-(void)creatShowAnimation
{
    self.alertView.frame = rectHide;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.alertView.frame = self->rectShow;
    } completion:^(BOOL finished) {
        
    }];
    
}

//完成并消除弹窗（block返回1）
-(void)confirm{
    if (self.comfirm) {
        self.comfirm(1);
    }
    [self removeAlertView];
}
//取消并消除弹窗（block返回0）
-(void)cancel{
    if (self.comfirm) {
        self.comfirm(0);
    }
    [self removeAlertView];
}
//-(void)alertViewTap{
//
//}
-(void)removeAlertView{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.alertView.frame = self->rectHide;
        
        self.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)Alertpan:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        //记录起始位置
        startY = self.alertView.frame.origin.y;
        startGCenter = [pan locationInView:self];
        return;
    }
    
    CGPoint GCenter = [pan locationInView:self];
    
    float startyy = startGCenter.y;
    float nowyy = GCenter.y;
    
    if (nowyy>=startyy){
        self.alertView.frame = CGRectMake(0, startY+(nowyy-startyy), WIN_WIDTH, WIN_HEIGHT);
        
        if (pan.state == UIGestureRecognizerStateEnded){
            if (((self.alertView.frame.origin.y)-rectShow.origin.y)>(WIN_HEIGHT*0.18)){
                [self cancel];
            }
            else{
                [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    self.alertView.frame = self->rectShow;
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
    }
}
@end
