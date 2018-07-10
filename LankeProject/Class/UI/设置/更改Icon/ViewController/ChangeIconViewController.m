//
//  ChangeIconViewController.m
//  LankeProject
//
//  Created by itman on 17/6/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ChangeIconViewController.h"

@interface ChangeIconViewController ()

@end

@implementation ChangeIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"changeAPPIcon";
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override 重载父类的方法


#pragma mark - Intial Methods 初始化的方法

- (void)IntialView{
    
}

#pragma mark - Target Methods 点击事件或通知事件
//info.plist 如何填写呢
//Primary Icon 字段写为 Icon60X60 是因为这里 xcassets 里面我只导入了 60pt@2x 和 60pt@3x 的图片资源，这里选为 60 是因为对于 iPhone，60pt 的图片资源图标所需最高质量，更低分辨率的版本系统会自动压缩以展示。
//
//newIcon 是我的用于替换原生图标的图片资源。文件名需要和 info.plist 中保持一致（注意 info.plist 中用到了两次 "newIcon"），同时这也是你在代码中设置图标时，需要给 API 传入的参数。同样是 60pt@2x 和 60pt@3x 的图片资源，文件不通过 Assets.xcassets 添加进来，而是直接放到目录中。
//
//如果你需要支持 iPad，建议这里使用 83.5pt（iPad Pro）的图片资源。另外还有些其他关于在 iPad 上替换图标的注意事项，在这里有说明，注意我们这里在 info.plist 里面所用的 key 是 CFBundleIcons，还有另外一个 key 是 CFBundleIcons~ipad。

- (void)changeAppIcon
{
//    if ([UIApplication sharedApplication].supportsAlternateIcons) {
//        NSLog(@"you can change this app's icon");
//    }else{
//        NSLog(@"you can not change this app's icon");
//        return;
//    }
//    
//    NSString *iconName = [[UIApplication sharedApplication] alternateIconName];
//    
//    if (iconName) {
//        // change to primary icon
//        [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
//            if (error) {
//                NSLog(@"set icon error: %@",error);
//            }
//            NSLog(@"The alternate icon's name is %@",iconName);
//        }];
//    }else{
//        // change to alterante icon
//        [[UIApplication sharedApplication] setAlternateIconName:@"newIcon" completionHandler:^(NSError * _Nullable error) {
//            if (error) {
//                NSLog(@"set icon error: %@",error);
//            }
//            NSLog(@"The alternate icon's name is %@",iconName);
//        }];
//    }
}

//优化：
//
//很多人就说了，每次都要弹框修改多费劲啊，能不能优化在后台切换icon呢？我的答案是：能！
// 利用runtime来替换展现弹出框的方法
- (void)runtimeReplaceAlert
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method presentM = class_getInstanceMethod(self.class, @selector(presentViewController:animated:completion:));
        Method presentSwizzlingM = class_getInstanceMethod(self.class, @selector(ox_presentViewController:animated:completion:));
        // 交换方法实现
        method_exchangeImplementations(presentM, presentSwizzlingM);
    });
}

// 自己的替换展示弹出框的方法
- (void)ox_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    if ([viewControllerToPresent isKindOfClass:[UIAlertController class]]) {
        NSLog(@"title : %@",((UIAlertController *)viewControllerToPresent).title);
        NSLog(@"message : %@",((UIAlertController *)viewControllerToPresent).message);
        
        // 换图标时的提示框的title和message都是nil，由此可特殊处理
        UIAlertController *alertController = (UIAlertController *)viewControllerToPresent;
        if (alertController.title == nil && alertController.message == nil) { // 是换图标的提示
            return;
        } else {// 其他提示还是正常处理
            [self ox_presentViewController:viewControllerToPresent animated:flag completion:completion];
            return;
        }
    }
    
    [self ox_presentViewController:viewControllerToPresent animated:flag completion:completion];
}
#pragma mark - delegate Delegate的事件


#pragma mark - Setter Getter Methods 所有的property使用懒加载，并将setter或getter放在底部


#pragma mark - Privater Methods 私有方法的代码


#pragma mark - Network 网络请求方法

- (void) initiateNetworkListRequest{
    
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
