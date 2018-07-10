//
//  MBProgressManager.m
//  BlueMobiProject
//
//  Created by 步晓虎 on 14-8-13.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#import "MBProgressManager.h"
#define HudTag 99999

@implementation MBProgressManager

+ (void)ShowWithText:(NSString *)text fromView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = text;
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:2];
}
+ (void)hidFormView:(UIView *)view
{
    MBProgressHUD *viewHud = (MBProgressHUD *)[view viewWithTag:HudTag];
    if (viewHud)
    {
        [viewHud hide:YES afterDelay:0.1];
    }
}

+ (void)hidFormView:(UIView *)view afterDelay:(CGFloat)delay
{
    MBProgressHUD *viewHud = (MBProgressHUD *)[view viewWithTag:HudTag];
    if (viewHud)
    {
        [viewHud hide:YES afterDelay:delay];
    }
}

+ (void)SHowLoadingToView:(UIView *)view
{
    MBProgressHUD *viewHud = (MBProgressHUD *)[view viewWithTag:HudTag];
    if (!viewHud)
    {
        MBProgressHUD *hud  = [[MBProgressHUD alloc] initWithView:view];
        hud.tag = HudTag;
        hud.backgroundColor=[UIColor clearColor];
//        hud.userInteractionEnabled = YES;
        //hud.frame=CGRectMake(0,204, DEF_SCREEN_WIDTH, DEF_SCREEN_HEIGHT-200);
        hud.removeFromSuperViewOnHide = YES;
        [view addSubview:hud];
        hud.labelText = @"正在加载...";
        [hud show:YES];
        hud.userInteractionEnabled = YES;
        
//        UIView *falseNav=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH/3, 80)];
//        falseNav.backgroundColor=BM_GREEN;
//        falseNav.tag=999;
//        [hud addSubview:falseNav];
        
    }
//	hud.delegate = self;
}

@end
