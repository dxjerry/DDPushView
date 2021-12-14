//
//  DDPushView.h
//  DDPushView
//
//  Created by Dxjerry on 2021/12/6.
//

#import <UIKit/UIKit.h>

typedef void(^ AlertComfirm)(NSInteger index);
@interface DDPushView : UIView
@property(nonatomic,copy) AlertComfirm comfirm;

//需要设置的变量
@property(nonatomic,copy)UIView *mainview;//主视图
@property(nonatomic,copy)NSString *title;//标题（可不设置，若为空则隐藏标题栏）
@property(nonatomic,assign)NSInteger direction;//弹出的方向（1屏幕顶部向下弹出，2屏幕底部向上弹出）
//手势
@property(nonatomic,assign)float height_PanGesture;//手势拖动弹出框时，停止手势时是展开还是缩回的决断距离（可不设置，默认为屏幕高度的0.18）

//标题栏控件，可以自由修改
@property(nonatomic,strong)UILabel *labeltitle;
@property(nonatomic,strong)UIView *viewline;

-(void)PushOutView;
@end
