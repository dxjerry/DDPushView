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

#define Height_StatusBar (((IS_IPHONE_X ) == (YES))?(44.0): (20.0))
#define Height_Indicator (((IS_IPHONE_X ) == (YES))?(34.0): (0.0))
#define Height_NavBar (((IS_IPHONE_X ) == (YES))?(88.0): (64.0))
#define Height_TabBar (((IS_IPHONE_X ) == (YES))?(83.0): (49.0+14))

@interface DDPushView()<UIGestureRecognizerDelegate>
{
    float startY;
    CGPoint startCenter;
}

@property(nonatomic,strong) UIView *PushView;//弹出的白色框背景视图
@property(nonatomic,strong) UIView *ShowView;//显示区域的视图（设置为上下弹出时，用来让出刘海和底部黑条区域）
@property(nonatomic,strong) UIView *viewTopCover;

@end
@implementation DDPushView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = RGB_COLOR_ALPHA(0, 0, 0, 0.5);
        
        startCenter = CGPointMake(0, 0);
        
        UIButton *buttoncancel=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        buttoncancel.backgroundColor=[UIColor clearColor];
        [buttoncancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttoncancel];
        
        self.PushView = [[UIView alloc]init];
        self.PushView.backgroundColor = [UIColor whiteColor];
        self.PushView.layer.cornerRadius = 8;
        self.PushView.clipsToBounds = YES;
        
        self.ShowView = [[UIView alloc]init];
        self.ShowView.backgroundColor = self.PushView.backgroundColor;
        [self.PushView addSubview:self.ShowView];
        
        
        UIImageView *buttonX=[[UIImageView alloc]initWithFrame:CGRectMake(WIN_WIDTH-15-16, (50-16)/2, 16, 16)];
        NSBundle *imageBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[DDPushView class]] pathForResource:@"DDPushView" ofType:@"bundle"]];
        buttonX.image=[UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"btn_guanbi" ofType:@"png"]];
//        UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancel)];
//        buttonX.userInteractionEnabled = YES;
//        [buttonX addGestureRecognizer:Tap];
        [self.ShowView addSubview:buttonX];
        
        UIButton *buttonXcover = [[UIButton alloc]initWithFrame:CGRectMake(buttonX.frame.origin.x-5, buttonX.frame.origin.y-5, buttonX.frame.size.width+10, buttonX.frame.size.height+10)];
        buttonXcover.backgroundColor = [UIColor clearColor];
        [buttonXcover addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self.ShowView addSubview:buttonXcover];
        
        self.labeltitle=[[UILabel alloc]initWithFrame:CGRectMake(20+15, 10, WIN_WIDTH-2*(20+15), 30)];
        self.labeltitle.textAlignment=NSTextAlignmentCenter;
        self.labeltitle.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
        self.labeltitle.textColor=RGB_COLOR(51, 51, 51);
        [self.ShowView addSubview:self.labeltitle];
        
        self.viewline=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.labeltitle.frame)+10, WIN_WIDTH, 1)];
        self.viewline.backgroundColor=RGB_COLOR(243, 243, 243);
        [self.ShowView addSubview:self.viewline];
        
        
        self.viewTopCover = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIN_WIDTH-15-16-10, 10+30+10)];
        self.viewTopCover.backgroundColor = [UIColor clearColor];
        [self.ShowView addSubview:self.viewTopCover];
        [self.ShowView bringSubviewToFront:self.viewTopCover];
        [self.ShowView bringSubviewToFront:buttonX];
    }
    return self;
}

-(void)setMainview:(UIView *)mainview{
    _mainview = mainview;
    [self.ShowView addSubview:self.mainview];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.labeltitle.text=title;
}

-(void)setDirection:(NSInteger)direction{
    _direction = direction;
}

-(void)setIsNarrowDrogArea:(BOOL)isNarrowDrogArea{
    _isNarrowDrogArea = isNarrowDrogArea;
    
    UIPanGestureRecognizer * PushViewpan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(Alertpan:)];
    PushViewpan.delegate=self;
    
    if (self.isNarrowDrogArea == YES){
        [self.viewTopCover addGestureRecognizer:PushViewpan];
    }
    else{
        [self.PushView addGestureRecognizer:PushViewpan];
    }
}


#pragma mark - 弹出
-(void)PushOutView
{
    //判断是否设置了主视图
    if (!self.mainview){
        NSLog(@"未设置要显示的视图");
        return;
    }
    
    
    float height_title = 0;//用来记录标题栏高度（若隐藏标题栏时为0）
    //弹出时判断有title则显示标题和横线，否则不显示
    if ((!self.title)||[self.title isEqualToString:@""]){
        self.labeltitle.hidden = YES;
        self.viewline.hidden = YES;
        
        self.mainview.frame = CGRectMake(0, 0, self.mainview.frame.size.width, self.mainview.frame.size.height);
        height_title = 0;
    }
    else{
        self.labeltitle.hidden = NO;
        self.viewline.hidden = NO;
        
        self.mainview.frame = CGRectMake(0, CGRectGetMaxY(self.viewline.frame), self.mainview.frame.size.width, self.mainview.frame.size.height);
        height_title = 10+30+10+1;
    }
    
    
    //判断direction是否合法，并确定弹出时的位置
    if (self.direction == 1){
        self.rectShow = CGRectMake(0, -(WIN_HEIGHT-Height_Indicator-self.mainview.frame.size.height-height_title), WIN_WIDTH, WIN_HEIGHT);
        self.rectHide = CGRectMake(0, -WIN_HEIGHT, WIN_WIDTH, WIN_HEIGHT);
        self.ShowView.frame = CGRectMake(0, WIN_HEIGHT-(self.mainview.frame.size.height+height_title), WIN_WIDTH, self.mainview.frame.size.height+height_title);
    }
    else if (self.direction == 2){
        self.rectShow = CGRectMake(0, WIN_HEIGHT-Height_Indicator-self.mainview.frame.size.height-height_title, WIN_WIDTH, WIN_HEIGHT);
        self.rectHide = CGRectMake(0, WIN_HEIGHT, WIN_WIDTH, WIN_HEIGHT);
        self.ShowView.frame = CGRectMake(0, 0, WIN_WIDTH, self.mainview.frame.size.height+height_title);
    }
    else{
        NSLog(@"设置方向错误，请设置：1屏幕顶部向下弹出，2屏幕底部向上弹出");
        return;
    }
    
    //动画开始前，先将视图置于隐藏位置
    self.PushView.frame = self.rectHide;
    [self addSubview:self.PushView];
    
    
    //判断是否设置了动画时间
    if (self.time_animation == 0){
        self.time_animation = 0.8;
    }
    
    UIWindow *rootWindow = [UIApplication sharedApplication].windows[0];
    [rootWindow addSubview:self];
    [self PushOutAnimation];
}

//开始动画
-(void)PushOutAnimation
{
    self.PushView.frame = self.rectHide;
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:self.time_animation delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        weakSelf.PushView.frame = weakSelf.rectShow;
    } completion:^(BOOL finished) {
        
    }];
    
}

//完成并消除弹窗（block返回1）
-(void)confirm{
    if (self.comfirm) {
        self.comfirm(1);
    }
    [self removePushView];
}
//取消并消除弹窗（block返回0）
-(void)cancel{
    if (self.comfirm) {
        self.comfirm(0);
    }
    [self removePushView];
}
//-(void)PushViewTap{
//
//}
-(void)removePushView{
    __weak __typeof(&*self)weakSelf = self;
    [UIView animateWithDuration:self.time_animation delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        weakSelf.PushView.frame = weakSelf.rectHide;
        
        self.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}


//支持用手势拖曳方式消除弹窗
- (void)Alertpan:(UIPanGestureRecognizer *)pan {
    if(self.height_PanGesture==0){
        self.height_PanGesture = WIN_HEIGHT*0.18;
    }
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        //记录起始位置
        startY = self.PushView.frame.origin.y;
        startCenter = [pan locationInView:self];
        return;
    }
    
    CGPoint GCenter = [pan locationInView:self];
    
    float startyy = startCenter.y;
    float nowyy = GCenter.y;
    
    if (self.direction==1){
        if (nowyy<=startyy){
            self.PushView.frame = CGRectMake(0, startY-(startyy-nowyy), WIN_WIDTH, WIN_HEIGHT);
            
            if (pan.state == UIGestureRecognizerStateEnded){
                if ((self.rectShow.origin.y-(self.PushView.frame.origin.y))>self.height_PanGesture){
                    [self cancel];
                }
                else{
                    __weak __typeof(&*self)weakSelf = self;
                    [UIView animateWithDuration:self.time_animation delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        weakSelf.PushView.frame = weakSelf.rectShow;
                    } completion:^(BOOL finished) {
                        
                    }];
                }
            }
        }
    }
    else if (self.direction==2){
        if (nowyy>=startyy){
            self.PushView.frame = CGRectMake(0, startY+(nowyy-startyy), WIN_WIDTH, WIN_HEIGHT);
            
            if (pan.state == UIGestureRecognizerStateEnded){
                if (((self.PushView.frame.origin.y)-self.rectShow.origin.y)>self.height_PanGesture){
                    [self cancel];
                }
                else{
                    __weak __typeof(&*self)weakSelf = self;
                    [UIView animateWithDuration:self.time_animation delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        weakSelf.PushView.frame = weakSelf.rectShow;
                    } completion:^(BOOL finished) {
                        
                    }];
                }
            }
        }
    }
    else{
        NSLog(@"设置方向错误，请设置：1屏幕顶部向下弹出，2屏幕底部向上弹出");
        return;
    }
}
@end
