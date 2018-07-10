//
//  MallShopInfoDetailCCell.m
//  LankeProject
//
//  Created by Rocky Young on 2017/1/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "MallShopInfoDetailCCell.h"

@interface MallShopInfoDetailCCell ()<UIWebViewDelegate>

@property (strong, nonatomic) UIActivityIndicatorView * activityIndicator;

@end
@implementation MallShopInfoDetailCCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self){
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        if (!_displayLabel) {
            _displayLabel = [UnityLHClass masonryLabel:@"店铺简介" font:17 color:BM_Color_BlackColor];
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
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [_activityIndicator startAnimating];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    
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
    [_activityIndicator stopAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        CGFloat scrollHeight =[[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
        if (ABS(scrollHeight - _content.contentHeight) > 5) {
            webView.scalesPageToFit = YES;
            webView.scrollView.scrollEnabled = NO;
            _content.contentHeight = scrollHeight;
            if (self.bCellHeightChangedBlock) {
                self.bCellHeightChangedBlock();
            }
        }
    });
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self sendObject:@"finish"];
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
#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return NSStringFromClass([self class]);
}

- (void) configCellWithData:(id)data{
    NSString *dishesDescription=data[@"dishesDescription"];
    dishesDescription=[dishesDescription stringByReplacingOccurrencesOfString:@"\r\n" withString:@"<br>"];

    [_conentWebView loadHTMLString:dishesDescription baseURL:nil];
}

- (void) configCellForShopDetail:(id)data{
    
    NSString *merchantIntroduction=data[@"merchantIntroduction"];
    merchantIntroduction=[merchantIntroduction stringByReplacingOccurrencesOfString:@"\r\n" withString:@"<br>"];
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        [_conentWebView loadHTMLString:merchantIntroduction baseURL:nil];
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
    });
    
    
    //[_conentWebView loadHTMLString:@"<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>" baseURL:nil];
}
+ (CGFloat) cellHeightWithData:(MallShopInfoDetailContent *)data{
    
    CGFloat cellHeight = 0;
    
    cellHeight += 35;
    cellHeight += data.contentHeight;
    
    return cellHeight;
}

//获取高度 2017.08.10
+ (float)getCellHeightWithData:(id)data
{
    NSString *merchantIntroduction=data[@"merchantIntroduction"];
    merchantIntroduction=[merchantIntroduction stringByReplacingOccurrencesOfString:@"\r\n" withString:@"<br>"];
    
    CGFloat scrollHeight = [UnityLHClass getHeight:merchantIntroduction wid:DEF_SCREEN_WIDTH - 100 font:15.0];
    
    CGFloat cellHeight = 0;
    
    cellHeight += 35;
    cellHeight += scrollHeight;
    
    return cellHeight;
}


@end

@implementation MallShopInfoDetailContent

- (instancetype)init
{
    self = [super init];
    if (self) {
        _contentHeight = 60.0f;
    }
    return self;
}

@end
