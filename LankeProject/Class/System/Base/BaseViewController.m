//
//  BaseViewController.m
//  PerfectProject
//
//  Created by Meng huan on 14/11/19.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"


@interface BaseViewController ()

@end

@implementation BaseViewController




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Do any additional setup after loading the view.
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BOOL hide = [self hidenNavigationBar];
    [self.navigationController setNavigationBarHidden:hide animated:YES];
    
}

- (void)viewDidLoad
{
    BOOL hide = [self hidenNavigationBar];
    self.fd_prefersNavigationBarHidden = hide;
    self.navigationController.navigationBarHidden = hide;
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    //顶部屏幕适配
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // push进来的界面都添加上手势滑动返回的效果
 
    [self addPopGesture];
    [self configNavigationBar];
    [self addContentView];
    
    [self createUI];
}

-(void) configNavigationBar
{
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:BM_Color_NaviBarTitleColor}];
    // navigationBar的背景颜色
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColorHexString:@"ffffff"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    
}

- (BOOL)hidenNavigationBar{
    
    return NO;
}

- (BOOL) isRootViewController{
    
    BOOL isRootNavigationController = NO;
    if (self.navigationController) {
        isRootNavigationController = self.navigationController.viewControllers[0] == self;
    }
    return isRootNavigationController;
}

-(void)addContentView
{
    // 内容视图
    self.contentView = [[BaseScrollView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_HEIGHT(self.view))];
    // 这里的frame是不对的
    [self.view addSubview:self.contentView];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
}

- (void) createUI{
    
    // 子类添加控件
}
- (void)viewWillLayoutSubviews{

    // 需要在这里就行校正frame
    self.contentView.frame = self.view.bounds;
    
    [self.contentView setNeedsLayout];
    
    [super viewWillLayoutSubviews];
    
}

#pragma mark - 添加子视图
/**
 *  添加子视图，以后所有添加子视图的操作,
 *  都使用[self addSubview:...];
 *  而不再用[self.view addSubview:...]
 *
 *  @param view 子视图
 */
- (void)addSubview:(UIView *)view
{
    [self.contentView addSubview:view];
}


#pragma mark - 显示系统自带的导航栏
/**
 *  显示系统自带的导航栏
 *
 *  @param title 标题
 */
- (void)showNavBarCustomByTitle:(NSString *)title
{
//    self.navigationController.navigationBarHidden = NO;
    // 标题
    self.navigationItem.title = title;
    
}

/**
 *  显示系统自带的导航栏
 *
 *  @param view 自定义的view
 */
- (void)showNavBarCustomByView:(UIView *)view
{
    // 如果是调用系统的，不管什么情况，先显示navigationBar，防止别的地方隐藏了系统的navigationBar
//    self.navigationController.navigationBarHidden = NO;
    // 复制自定义的控件
    
    self.navigationItem.titleView = view;
    
}

/**
 *  自定义导航栏view
 *  结合 [self showNavBarCustomByView:view]; 使用
 *
 *  @param navTitle     标题
 *  @param rightTitle   右侧按钮文字或图片
 *  @param isBack       YES为显示返回按钮，NO为不显示
 */
- (UIView *)viewWithNavBarByTitle:(NSString *)navTitle
                       rightTitle:(NSString *)rightTitle
                           isBack:(BOOL)isBack
{
    // 背景
    UIView *v          = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 44)];
    v.backgroundColor  = [UIColor clearColor];
    
//    // 如需特殊修改背景颜色，需要一并修改navigationBar的背景颜色一起修改，保持统一
//    v  = [UIColor blueColor];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor blueColor]]
//                                                  forBarMetrics:UIBarMetricsDefault];
    
    // 文字
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DEF_WIDTH(v), DEF_HEIGHT(v))];
    navLabel.textAlignment  = NSTextAlignmentCenter;
    navLabel.font           = [UIFont boldSystemFontOfSize:20];
    navLabel.textColor      = [UIColor whiteColor];
    navLabel.text           = navTitle;
    [v addSubview:navLabel];
    
    if (isBack == YES)
    {
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, 44, DEF_HEIGHT(v));
        [backBtn setEnlargeEdgeWithTop:0 right:10 bottom:0 left:10];
        [backBtn setImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
        backBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [backBtn addTarget:self action:@selector(baseBackBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [v addSubview:backBtn];
    }
    
    UIButton *rightBtn                = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame                    = CGRectMake(DEF_WIDTH(v)-55, 0, 50, DEF_HEIGHT(v));
    rightBtn.titleLabel.font          = [UIFont systemFontOfSize:15];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    rightBtn.titleLabel.tintColor     = [UIColor whiteColor];
    rightBtn.imageView.contentMode    = UIViewContentModeScaleAspectFit;
    [rightBtn addTarget:self action:@selector(baseRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:rightBtn];
    
    //没有右侧按钮
    if ([rightTitle isEqualToString:@""])
    {
        rightBtn.hidden = YES;
    }
    //按钮是图片还是文字
    if ([rightTitle rangeOfString:@"png"].location != NSNotFound)
    {
        [rightBtn setBackgroundImage:[UIImage imageNamed:rightTitle] forState:UIControlStateNormal];
    }
    else
    {
        [rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    }
    
    return v;
}


// 单独设置导航栏的返回按钮
- (void)showBackBtnHUD
{
    // 交给导航控制器做
}

// 返回按钮默认方法，根据需求，可自行重写
- (void)baseBackBtnAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 右侧按钮默认方法，根据需求，可自行重写
- (void)baseRightBtnAction:(UIButton *)btn
{
    // 默认什么都不做
}


// 添加右侧文字按钮
- (void)showRightBarButtonItemHUDByName:(NSString *)name
{
    CGFloat width = [UnityLHClass getWidth:name wid:44 font:15];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, width + 4, 44);
    [btn setTitle:name forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn addTarget:self action:@selector(baseRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setEnlargeEdgeWithTop:0 right:10 bottom:0 left:10];
    _rightButton = btn;
    
    // 自定义右侧按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
    //== 如果是自定义多个按钮，可把多个按钮放在同一个view上，再设置 self.navigationItem.rightBarButtonItem = view; ==//
}

// 添加右侧图片按钮
- (void)showRightBarButtonItemHUDByImage:(UIImage *)image
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(baseRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [btn setEnlargeEdgeWithTop:0 right:10 bottom:0 left:10];
    _rightButton = btn;
//    CGFloat f = (44-20)/2;
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(f, f+f, f, 0)];

  

//    // 自定义右侧按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
    //== 如果是自定义多个按钮，可把多个按钮放在同一个view上，再设置 self.navigationItem.rightBarButtonItem = view; ==//
}

- (void)showRightBarButtonNormalImage:(UIImage *)normalImage selectImage:(UIImage *)selectImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(DEF_SCREEN_WIDTH-60, 0, 44, 44);
    [btn setImage:normalImage forState:UIControlStateNormal];
    [btn setImage:selectImage forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(baseRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
   [btn setEnlargeEdgeWithTop:0 right:10 bottom:0 left:10];
    _rightButton = btn;
    
    CGFloat f = (44-20)/2;
//    [btn setImageEdgeInsets:UIEdgeInsetsMake(f, f+f, f, 0)];

    // 自定义右侧按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}

// 添加右侧图片按钮
- (void)showRightBarButtonItemHUDByImageArray:(NSArray *)imageArray
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 44*imageArray.count, 44)];
    for (int i=0; i<imageArray.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(44*i, 0, 44, 44);
        btn.tag=100+i;
        [btn setImage:imageArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(baseRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton = btn;
        CGFloat f = (44-20)/2;
//        [btn setImageEdgeInsets:UIEdgeInsetsMake(f, f+f, f, 0)];

        [view addSubview:btn];
    }
    
    // 自定义右侧按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = item;
 
}
/**
 *  界面push前后如果需要隐藏下方的tabbar，则分别在push的前后调用下面方法
 *
 *  [self hideTabbarAndScreenPush];
 *  UIViewController *vc = [[UIViewController alloc] init];
 *  [self.navigationController pushViewController:vc animated:YES];
 *  [self showTabbarAndScreenPush];
 */
// push之前调用
- (void)hideTabbarAndScreenPush
{
    self.hidesBottomBarWhenPushed = YES;
}

// push完之后调用
- (void)showTabbarAndScreenPush
{
    self.hidesBottomBarWhenPushed = NO;
}

- (void)removeSelfFromNavigationStack{

    if (self.navigationController && [self.navigationController.viewControllers count]) {
        
        NSMutableArray * vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        NSArray * temp = [NSArray arrayWithArray:vcs];
        for (UIViewController * vc in temp) {
            
            if ([vc isKindOfClass:[self class]]) {
                [vcs removeObject:vc];
            }
        }   
        self.navigationController.viewControllers = vcs;
    }
}
// 信息弹框提示
- (void)showTipByMessage:(NSString *)message
{
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
                                                 message:message
                                                delegate:nil
                                       cancelButtonTitle:@"好"
                                       otherButtonTitles:nil, nil];
    [av show];
}

- (void) showTipMessage:(NSString *)message cancel:(void(^)())cancel handle:(void(^)())handle{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (cancel) {
            cancel();
        }
    }];
    [alert addAction:action];
    
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handle) {
            handle();
        }
    }];
    [alert addAction:sureAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 界面push之后，添加界面的手势侧滑Pop效果
/**
 *  界面push之后，添加界面的手势侧滑Pop效果
 *  在需要的界面里调用此方法
 */
- (void)addPopGesture
{
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

// 移除pop手势
- (void)removePopGesture
{
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
}


#pragma mark - 支持重力感应，屏幕旋转
- (UIInterfaceOrientationMask)application:(UIApplication *)application
  supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    // 根据旋转状态做处理，具体默认旋转的状态根据实际情况而定
    //    return (self.isNeedRotate == YES) ? UIInterfaceOrientationMaskAll : UIInterfaceOrientationMaskPortrait;
    //    return UIInterfaceOrientationMaskAll;
    //    return UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

@end


@implementation UIViewController (StringForController)

+ (UIViewController *) controllerWithString:(NSString *)string{
    
    if (string == nil || [string length] <= 0) {
        
        return nil;
    }
    
    NSString * class = string;
    
    const char * className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    
    Class newClass = objc_getClass(className);
    
    if (!newClass) {
        
        Class superClass = [UIViewController class];
        
        newClass = objc_allocateClassPair(superClass, className, 0);
        
        objc_registerClassPair(newClass);
    }
    id instance = [[newClass alloc] init];
    
    return instance;
}

@end

@implementation BaseViewController (CartDot)

- (void) fetchCartCount{
    
    // 联网请求购物车个数
}
- (void) showCartDotWithCount:(NSInteger)count{

    if ([self hasDotLabel]) {
        [self removeDotLabel];
    }else{
        UILabel * cartCountLabel = [self addDotLabel];
        cartCountLabel.text = [NSString stringWithFormat:@" %ld ",(long)count];
    }
    
}

- (BOOL) hasDotLabel{
    
    return self.rightButton && [self.rightButton viewWithTag:101010101];
}

- (UILabel *) addDotLabel{
    
    UILabel * cartCountLabel = [UnityLHClass masonryLabel:@"0" font:10 color:[UIColor whiteColor]];
    cartCountLabel.backgroundColor = [UIColor redColor];
    cartCountLabel.layer.cornerRadius = 15.0f/2;
    cartCountLabel.layer.masksToBounds = YES;
    cartCountLabel.tag = 101010101;
    [self.rightButton addSubview:cartCountLabel];
    cartCountLabel.hidden = YES;
    [cartCountLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.rightButton.mas_top).mas_offset(-5);
        make.right.mas_equalTo(self.rightButton.mas_right).mas_offset(5);
        make.height.mas_equalTo(15);
    }];
    return cartCountLabel;
}

- (void) removeDotLabel{
    
    UILabel * cartCountLabel = [self.rightButton viewWithTag:101010101];
    
    [cartCountLabel removeFromSuperview];
}
@end

