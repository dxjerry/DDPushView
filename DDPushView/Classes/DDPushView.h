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



@property(nonatomic,copy)UIView *mainview;
@property(nonatomic,copy)NSString *title;



@property(nonatomic,strong)UILabel *labeltitle;
@property(nonatomic,strong)UIView *viewline;

-(void)PushAlertView;
@end
