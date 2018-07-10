

//
//  AdvertisingTopView.m
//  LankeProject
//
//  Created by admin on 2017/7/27.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "AdvertisingTopView.h"
#import "advertisButton.h"
#import "BMNetworkHandler.h"
#import "GroupBuyListViewController.h"
@interface AdvertisingTopView ()<UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    // 定时刷新
    dispatch_source_t timer;
    NSInteger count;
}

@property(nonatomic,assign)NSInteger time;
@property(nonatomic,strong)advertisButton*codeBtn;
@property(nonatomic,strong)UIWebView *headlineWebView;

-(void)startTimer;
-(void)endTimer;

@end

@implementation AdvertisingTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        [self creaView];
        [self loadDate];
        
    }
    return self;
}
-(void)loadDate
{
    [UserServices guangGaoWithUserCompletionBlock:^(int result, id responseObject) {
        NSLog(@"qqqq111````%@",responseObject);
        
        id data=responseObject[@"data"];
        self.dataSource=responseObject[@"data"];
        if (![data isKindOfClass:[NSString class]]) {
            NSString*imageStr=data[@"advertContent"];
            if (imageStr.length!=0||imageStr!=nil) {
                
                NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                                      "<head> \n"
                                      "<style type=\"text/css\"> \n"
                                      "body {font-size: %f; color: %@;}\n"
                                      "</style> \n"
                                      "</head> \n"
                                      "<body>%@</body> \n"
                                      "</html>", 16.0, @"#9D9D9D", responseObject[@"data"][@"advertContent"]];
                
                [self.headlineWebView loadHTMLString:jsString baseURL:nil];
                
            }else{
                
               [self removeTopView];
            }
            
        }else{
            
           [self removeTopView];
            
        }
        
    }];
    
}
-(void)creaView
{
    
    self.headlineWebView=[[UIWebView alloc]init];
    self.headlineWebView.scrollView.scrollEnabled=NO;
    self.headlineWebView.delegate=self;
    self.headlineWebView.userInteractionEnabled=YES;
    [self addSubview:self.headlineWebView];
    [self.headlineWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(DEF_SCREEN_HEIGHT-30);
    }];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWebView:)];
    tap.delegate = self;
    [self.headlineWebView  addGestureRecognizer:tap];
    
    // 允许多个手势并发


    //选择触发事件的方式（默认单机触发）
    
   // [tapGesture setNumberOfTapsRequired:1];
    
    
    
    self.codeBtn = [[advertisButton alloc]initWithFrame:CGRectMake(DEF_SCREEN_WIDTH-120, 60, 80, 40)];
    self.codeBtn.time=11;
    [self.codeBtn startTimer];
    self.codeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.codeBtn setTitleColor:BM_Color_Blue forState:UIControlStateNormal];
    self.codeBtn.titleLabel.font = BM_FONTSIZE15;
    self.codeBtn.layer.cornerRadius = 5.0f;
    self.codeBtn.layer.masksToBounds = YES;
    self.codeBtn.alpha=0.6;
    [ self.codeBtn.layer setBorderWidth:2];//设置边界的宽度
    //设置按钮的边界颜色
    CGColorRef colorref = [UIColor colorWithHexString:@"#4E98F5"].CGColor;
    [ self.codeBtn.layer setBorderColor:colorref];
    [self.codeBtn receiveObject:^(id object) {
        [self removeTopView];
    }];
    [self.codeBtn addTarget:self action:@selector(removeTopView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: self.codeBtn];
    
    
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    // [self removeTopView];
    //	0：不跳转 1：跳转到团购列表 2：跳转到自营店铺
    
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
       
        switch ([self.dataSource[@"jumpType"] integerValue]) {
            case 0:
                
                break;
            case 1:
                [self sendObject:@"团购列表"];
                break;
            case 2:
                 [self sendObject:@"自营店铺"];
                break;
            default:
                break;
        }
        
    }
    
    return YES;
    
}
- (void)tapWebView:(UITapGestureRecognizer *)rotation

{

    
}
#pragma mark 执行触发的方法


#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    CGFloat scrollHeight =[[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    [self.headlineWebView mas_updateConstraints:^(MASConstraintMaker *make)
     {
         make.height.mas_equalTo(scrollHeight+20);
     }];
    
    //自己后台html适配手机屏幕
    NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth,oldheight;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "oldheight = myimg.height;"
    "myimg.width = %f;"
    "myimg.height = oldheight/oldwidth*myimg.width;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width-30,[UIScreen mainScreen].bounds.size.width-20];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
}
-(void)removeTopView
{
     KAPPDELEGATE.isFirst=NO;
    [self.codeBtn endTimer];
    [self sendObject:@"top"];
}

@end
