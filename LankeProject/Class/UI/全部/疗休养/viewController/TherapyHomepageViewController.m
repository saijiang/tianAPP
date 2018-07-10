//
//  TherapyHomepageViewController.m
//  LankeProject
//
//  Created by issuser on 2018/7/8.
//  Copyright © 2018年 张涛. All rights reserved.
//

#import "TherapyHomepageViewController.h"
#import <WebKit/WebKit.h>
@interface TherapyHomepageViewController ()<WKUIDelegate,WKNavigationDelegate>
@property(nonatomic,strong) WKWebView *webView;
@property(nonatomic,strong) UIProgressView *pro;
@end

@implementation TherapyHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self rewriteBackButton];
    NSString *strMD5 = [NSString stringWithFormat:@"%d%@%@",15,[KeychainManager readMobileNum],[KeychainManager readUserId]];
    NSString *superStr = [strMD5 uppercaseString];
    
    NSString *url = [NSString stringWithFormat:@"http://mpassdev.aoyou.com/unionlogin?uniontype=15&mobile=%@&unionid=%@&token=%@&jumptype=1",[KeychainManager readMobileNum],[KeychainManager readUserId],superStr];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];

    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    [self.view addSubview:self.pro];
    // Do any additional setup after loading the view.
}
#pragma mark delegate
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.pro.hidden = NO;
}

-(UIProgressView *)pro{
    if (!_pro) {
        _pro  = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _pro.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 5);
        
        [_pro setTrackTintColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0]];
        _pro.progressTintColor = [UIColor greenColor];
    }
    return _pro;
}
//kvo 监听进度
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == self.webView) {
        [self.pro setAlpha:1.0f];
        BOOL animated = self.webView.estimatedProgress > self.pro.progress;
        [self.pro setProgress:self.webView.estimatedProgress
                              animated:animated];
        
        if (self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [self.pro setAlpha:0.0f];
                             }
                             completion:^(BOOL finished) {
                                 [self.pro setProgress:0.0f animated:NO];
                             }];
        }
    }else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

-(void)dealloc{
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 重写返回按钮
-(void)rewriteBackButton{
//    UIButton *pageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [pageButton setImage:[UIImage imageNamed:@"navBar_back"] forState:UIControlStateNormal];
//    pageButton.frame = CGRectMake(0, 0, 14, 24);
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    //设置UIButton的图像
    [backButton setImage:[UIImage imageNamed:@"navBar_back"] forState:UIControlStateNormal];
    //给UIButton绑定一个方法，在这个方法中进行popViewControllerAnimated
    [backButton addTarget:self action:@selector(backItemClick) forControlEvents:UIControlEventTouchUpInside];
    //然后通过系统给的自定义BarButtonItem的方法创建BarButtonItem
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    //覆盖返回按键
    self.navigationItem.leftBarButtonItem = backItem;
 

}
-(void)backItemClick{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
