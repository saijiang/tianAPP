//
//  HealthDetailViewController.m
//  LankeProject
//
//  Created by Justin on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "HealthDetailViewController.h"

#import "CLPlayerView.h"
#import "UIView+CLSetRect.h"

@interface HealthDetailViewController ()<UIWebViewDelegate>
{
    
    UIImageView *iconImage;
}
@property (nonatomic ,strong) UIButton * leftBtn;
@property (nonatomic ,strong) UILabel * titleLb;
@property (nonatomic ,strong) UILabel * titleLabel;

@property (nonatomic ,strong) UILabel * dateLabel;

@property (nonatomic, strong) UIWebView * webContentView;

@property (nonatomic ,strong) id responseData;

@property(nonatomic,weak) CLPlayerView *zglplayer;
@end

@implementation HealthDetailViewController

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.zglplayer destroyPlayer];
    self.zglplayer=nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资讯详情";
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIImage * normalImage = [UIImage imageNamed:@"navigation_bar_collection_normal"];
    UIImage * selectImage = [UIImage imageNamed:@"ding_shoucang"];
    [self showRightBarButtonNormalImage:normalImage selectImage:selectImage];
    
    //标题
    UILabel *titleLB = [UnityLHClass initUILabel:@"我们的地球" font:17.0 color:BM_BLACK rect:CGRectMake(15, 5, DEF_SCREEN_WIDTH - 30, 20)];
    //[self addSubview:titleLB];
    self.titleLabel = titleLB;
    
    UILabel *timeLB = [UnityLHClass initUILabel:@"2016-11-13" font:13.0 color:BM_BLACK rect:CGRectMake(0, 0, 0, 0)];
    timeLB.textColor = [UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:1];
    //[self addSubview:timeLB];
    self.dateLabel = timeLB;
    
    //文本
    self.webContentView = [[UIWebView alloc] initWithFrame:CGRectMake(0, timeLB.bottom, DEF_SCREEN_WIDTH, DEF_CONTENT -DEF_HEIGHT(timeLB))];
    for (UIView *_aView in [self.webContentView subviews])
    {
        if ([_aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO];
            //右侧的滚动条
            
            [(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
            //下侧的滚动条
            
            for (UIView *_inScrollview in _aView.subviews)
            {
                if ([_inScrollview isKindOfClass:[UIImageView class]])
                {
                    _inScrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                }
            }
        }
    }
    self.webContentView.delegate = self;
    [self addSubview:self.webContentView];
    
    [self requestAdviceDetail];
}
-(void)loadFrame
{
    
    CLPlayerView*zglplayer = [[CLPlayerView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 200)];
    self.zglplayer=zglplayer;
    [self.view addSubview:self.zglplayer];
    
    //    //重复播放，默认不播放
    self.zglplayer.repeatPlay = YES;
    //    //当前控制器是否支持旋转，当前页面支持旋转的时候需要设置，告知播放器
    self.zglplayer.isLandscape = YES;
    //设置等比例全屏拉伸，多余部分会被剪切
    //          self.zglplayer.fillMode = ResizeAspectFill;
    //设置进度条背景颜色
    self.zglplayer.progressBackgroundColor = [UIColor purpleColor];
    //设置进度条缓冲颜色
    self.zglplayer.progressBufferColor = [UIColor redColor];
    //设置进度条播放完成颜色
    self.zglplayer.progressPlayFinishColor = [UIColor greenColor];
    //全屏是否隐藏状态栏
    self.zglplayer.fullStatusBarHidden = YES;
    //视频地址
    //播放
    [ self.zglplayer playVideo];
    
    //返回按钮点击事件回调
    [   self.zglplayer backButton:^(UIButton *button) {
        NSLog(@"返回按钮被点击");
    }];
    //播放完成回调
    [ self.zglplayer endPlay:^{
        //        //销毁播放器
        
        NSLog(@"播放完成");
    }];
    
    
    
    self.titleLabel.frame=CGRectMake(15, 205, DEF_SCREEN_WIDTH - 30, 20);
    self.dateLabel.frame=CGRectMake(15, DEF_BOTTOM(self.titleLabel)+5, DEF_SCREEN_WIDTH - 30, 20);
    self.webContentView.frame=CGRectMake(0,self.dateLabel.bottom, self.contentView.frame.size.width, self.contentView.frame.size.height -  self.dateLabel.bottom);
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //图片适配屏幕大小
    NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.width = %f;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-15];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor = [UIColor whiteColor];
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.view.backgroundColor = [UIColor blackColor];
    }
}
- (void)baseRightBtnAction:(UIButton *)btn
{
    if (self.teachId) {
        return;
    }
    if (btn.isSelected) {
        [self requestCancelCollection];
    }else{
        [self requestAddCollection];
    }
}

#pragma mark -
#pragma mark Network M

- (void) requestAdviceDetail{
    
    if (self.adviceId) {
        [UserServices healthAdviceDetailWithId:self.adviceId userId:[KeychainManager readUserId] completionBlock:^(int result, id responseObject) {
            
            if (result == 0) {
                id data = responseObject[@"data"];
                self.responseData = data;
                
                NSString * title = [NSString stringWithFormat:@"%@",data[@"title"]];
                NSString * date = [[NSString stringWithFormat:@"%@",data[@"createDate"]]stringformatterDate:@"YYYY-MM-dd"];
                NSInteger isCollect = [[NSString stringWithFormat:@"%@",data[@"isCollect"]] integerValue];
                
                if (isCollect == 0) {// 未收藏
                    self.rightButton.selected = NO;
                }else{
                    self.rightButton.selected = YES;
                }
                NSString * temp;
                
                NSString * html;
                
                NSString * type = [NSString stringWithFormat:@"%@",data[@"type"]];
                if ([type  isEqual: @"01"]) {// 图文
                    
                    temp = [NSString stringWithFormat:@"<p style=\"font-size:17px;height:20px;border:0px;\">%@</p><p style=\"color:gray;font-size:14px;height:15px;border:0px;\">%@</p>",title,date];
                    html = [NSString stringWithFormat:@"%@%@",temp,data[@"graphicDescription"]];
                }
                if ([type  isEqual: @"02"]) {// 视频
                    [self loadFrame];
                    
                    self.title = title;
                    
                    temp = [NSString stringWithFormat:@"<p style=\"color:gray;font-size:14px;height:15px;border:0px;\">%@</p>",date];
                    html = [NSString stringWithFormat:@"%@%@",temp,data[@"graphicDescription"]];
                    
                    self.zglplayer.url = [NSURL URLWithString:data[@"videoFile"]];
                    
                }
                [self.webContentView loadHTMLString:html baseURL:nil];
            }else{
                // error handle here
                [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            }
        }];
        
    }else{
        self.rightButton.hidden = YES;
        [UserServices getTeachDetailWithTeachId:self.teachId completionBlock:^(int result, id responseObject)
         {
             if (result == 0) {
                 id data = responseObject[@"data"];
                 self.responseData = data;
                 
                 NSString * title = [NSString stringWithFormat:@"%@",data[@"title"]];
                 NSString * date = [[NSString stringWithFormat:@"%@",data[@"createDate"]]stringformatterDate:@"YYYY-MM-dd"];
                 NSString * temp;
                 NSString * html;
                 NSString * type = [NSString stringWithFormat:@"%@",data[@"teachingType"]];
                 //教学类型（01：视频， 02：咨询）
                 if ([type  isEqual: @"02"]) {// 图文
                     
                     
                     
                     temp = [NSString stringWithFormat:@"<p style=\"font-size:17px;height:20px;border:0px;\">%@</p><p style=\"color:gray;font-size:14px;height:15px;border:0px;\">%@</p>",title,date];
                     html = [NSString stringWithFormat:@"%@%@",temp,data[@"graphicDescription"]];
                     
                 }
                 if ([type  isEqual: @"01"]) {// 视频
                     [self loadFrame];
                     self.title = title;
                     temp = [NSString stringWithFormat:@"<p style=\"color:gray;font-size:14px;height:15px;border:0px;\">%@</p>",date];
                     html = [NSString stringWithFormat:@"%@%@",temp,data[@"graphicDescription"]];
                     
                     self.zglplayer.url = [NSURL URLWithString:data[@"videoFile"]];
                 }
                 [self.webContentView loadHTMLString:html baseURL:nil];
             }else{
                 // error handle here
                 [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
             }
             
         }];
    }
}
- (void) requestAddCollection{
    
    NSString * itemsId = [NSString stringWithFormat:@"%@",self.responseData[@"id"]];
    
    [UserServices collectionHeadlthAdviceWithUserId:[KeychainManager readUserId] itemsId:itemsId collectType:@"03" userName:[KeychainManager readUserName] completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            
            [UnityLHClass showHUDWithStringAndTime:@"收藏成功"];
            self.rightButton.selected = YES;
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

- (void) requestCancelCollection{
    
    NSString * itemsId = [NSString stringWithFormat:@"%@",self.responseData[@"id"]];
    
    [UserServices cancelHealthAdviceWithUserId:[KeychainManager readUserId] itemsId:itemsId collectType:@"03" completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            
            [UnityLHClass showHUDWithStringAndTime:@"取消收藏成功"];
            self.rightButton.selected = NO;
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}



@end
