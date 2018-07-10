//
//  DishesDetailContentCell.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "DishesDetailContentCell.h"

@interface DishesDetailContentCell ()<UIWebViewDelegate>

@property (strong, nonatomic) UIActivityIndicatorView * activityIndicator;
@property (nonatomic ,strong) UIWebView * conentWebView;
@property (nonatomic ,assign) BOOL  isOneShop;
@property (nonatomic ,assign) BOOL  isJDShop;
@end
@implementation DishesDetailContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        if (!_displayLabel) {
            _displayLabel = [UnityLHClass masonryLabel:@"简介" font:17 color:BM_Color_BlackColor];
            [self.contentView addSubview:_displayLabel];
        }
        
        if (!_conentWebView) {
            _conentWebView = [[UIWebView alloc] init];
            _conentWebView.delegate = self;
            _conentWebView.scrollView.scrollEnabled = NO;
            _conentWebView.backgroundColor = [UIColor whiteColor];
            _conentWebView.scrollView.showsVerticalScrollIndicator = NO;
            [self.contentView addSubview:_conentWebView];
        }
        
        if (!_activityIndicator) {
            _activityIndicator = [[UIActivityIndicatorView alloc]
                                  initWithActivityIndicatorStyle:
                                  UIActivityIndicatorViewStyleGray];
            _activityIndicator.hidesWhenStopped = YES;
            [_activityIndicator startAnimating];
            [self.contentView addSubview:_activityIndicator];
        }
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    [_displayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(35);
    }];
    [_activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [_conentWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(_displayLabel.mas_bottom).mas_offset(0);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{

    [_activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityIndicator stopAnimating];
    //字体颜色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'gray'"];
    
    if (self.isOneShop)
    {
        //一号店html适配手机屏幕
        CGFloat scrollWidth =[[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth"] floatValue];
        CGFloat scale=(DEF_SCREEN_WIDTH-20.0)/scrollWidth;//宽度缩放比例
        NSString *meta = [NSString stringWithFormat:@"document.body.style.zoom=%f,document.getElementsByName(\"viewport\")[0].content = \"width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"",scale];
        [webView stringByEvaluatingJavaScriptFromString:meta];//(style.zoom=0.4//缩放比initial-scale是初始缩放比,minimum-scale=1.0最小缩放比,maximum-scale=5.0最大缩放比,user-scalable=yes是否支持缩放
        CGFloat scrollHeight =[[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
        if (ABS(scrollHeight - _content.contentHeight) > 5) {
            _content.contentHeight = scrollHeight;
            if (self.bCellHeightChangedBlock) {
                self.bCellHeightChangedBlock();
            }
        }
    }
    else{
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
        js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width-30,[UIScreen mainScreen].bounds.size.width-30];
        [webView stringByEvaluatingJavaScriptFromString:js];
        [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
     
        
        CGFloat scrollHeight =[[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
        
        if (ABS(scrollHeight - _content.contentHeight) > 5) {
            _content.contentHeight = scrollHeight;
            webView.scalesPageToFit=YES;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.55 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.bCellHeightChangedBlock) {
                    self.bCellHeightChangedBlock();
                }
                
            });
            
            
        }

    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    [_activityIndicator stopAnimating];
    
    if([error code] == NSURLErrorCancelled){
        return;
    }else{
        // error handle
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *strLink = request.URL.absoluteString;
    
    if ([strLink rangeOfString:@"about:blank"].location != NSNotFound) {// 加载富文本
        return YES;
    }else{// 确实是一个网页
        if (self.bLoadRequestBlock) {
            self.bLoadRequestBlock(request);
        }
        return NO;
    }
}

//获取宽度已经适配于webView的html。这里的原始html也可以通过js从webView里获取
- (NSString *)htmlAdjustWithPageWidth:(CGFloat )pageWidth
                                 html:(NSString *)html
                              webView:(UIWebView *)webView
{
    NSMutableString *str = [NSMutableString stringWithString:html];
    //计算要缩放的比例
    CGFloat initialScale = webView.frame.size.width/pageWidth;
    //将</head>替换为meta+head
    NSString *stringForReplace = [NSString stringWithFormat:@"<meta name=\"viewport\" content=\" initial-scale=%f, minimum-scale=0.1, maximum-scale=2.0, user-scalable=yes\"></head>",initialScale];
    
    NSRange range =  NSMakeRange(0, str.length);
    //替换
    [str replaceOccurrencesOfString:@"</head>" withString:stringForReplace options:NSLiteralSearch range:range];
    return str;
}
#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return @"DishesDetailContentCell";
}

- (void) configCellWithData:(id)data{
    
    [_conentWebView loadHTMLString:data[@"dishesDescription"] baseURL:nil];
}

- (void) configCellForGroupDetail:(id)data{
    
    [_conentWebView loadHTMLString:data[@"goodsDetailDescribe"] baseURL:nil];
}

- (void) configCellForGoodsDetail:(id)data{

    [_conentWebView loadHTMLString:data[@"goodsDescribe"] baseURL:nil];
}

- (void) configCellForStoreOneDetail:(id)data{
    self.isOneShop=YES;
    [_conentWebView loadHTMLString:data[@"tabdetail"] baseURL:nil];
}
- (void) configCellForStoreJDDetail:(id)data{
    self.isJDShop=YES;
    [_conentWebView loadHTMLString:data[@"introduction"] baseURL:nil];
}

- (void) configCellForFitnessDetail:(id)data
{
    
    [_conentWebView loadHTMLString:data[@"fitnessReport"] baseURL:nil];

}

+ (CGFloat) cellHeightWithData:(DishesDetailContent *)data{

    CGFloat cellHeight = 0;
    
    cellHeight += 35;
    cellHeight += data.contentHeight;
    
    return cellHeight;
}
@end

@implementation DishesDetailContent

- (instancetype)init
{
    self = [super init];
    if (self) {
        _contentHeight = 60.0f;
    }
    return self;
}

@end
