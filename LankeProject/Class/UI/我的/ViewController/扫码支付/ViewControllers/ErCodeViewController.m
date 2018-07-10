//
//  ErCodeViewController.m
//  LankeProject
//
//  Created by 文诗墨笔 on 16/6/17.To Punish And Enslave
//  Copyright © 2016年 张涛. All rights reserved.
//

/**
 *  请在规定区域内填写代码，并且注意代码规范和注释！ - 文诗墨笔
 */

#import "ErCodeViewController.h"
#import "ErCodePayViewController.h"

#import <AVFoundation/AVFoundation.h>
#import "ErScanBackgroundView.h"
#import "DQAlertViewController.h"

@interface ErCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession * session;//输入输出的中间桥梁
}

@property (strong, nonatomic) ErScanBackgroundView *myScanBGView;
@property (strong, nonatomic) UIImageView *scanRectView, *lineView;
@property (strong, nonatomic) UILabel *tipLabel;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@end

@implementation ErCodeViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self showNavBarCustomByTitle:@"扫码支付"];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(applicationDidBecomeActive:)
               name:UIApplicationDidBecomeActiveNotification
             object:nil];
    [nc addObserver:self
           selector:@selector(applicationWillResignActive:)
               name:UIApplicationWillResignActiveNotification
             object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    if (!self.videoPreviewLayer.session.isRunning) {
        
        [_videoPreviewLayer.session startRunning];
    }
    [self scanLineStartAction];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self.videoPreviewLayer.session stopRunning];
//    [self.videoPreviewLayer removeFromSuperlayer];
    [self scanLineStopAction];
}

- (void)createUI{
    
    CGFloat width = DEF_SCREEN_WIDTH *2/3;
    CGFloat padding = (DEF_SCREEN_WIDTH - width)/2;
    CGRect scanRect = CGRectMake(padding, DEF_SCREEN_HEIGHT/5, width, width);
    
    if (!_videoPreviewLayer) {
        NSError *error;
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
        if (!input) {
            
            [self showTipByMessage:@"请检查是否打开了相机权限，您可以进入系统“设置>隐私>相机“,允许航天访问您的相机。"];//error.localizedDescription
            //            [self dismissViewControllerAnimated:YES completion:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            //设置会话的输入设备
            AVCaptureSession *captureSession = [AVCaptureSession new];
            [captureSession addInput:input];
            //对应输出
            AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
            [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_queue_create("ease_capture_queue",NULL)];
            [captureSession addOutput:captureMetadataOutput];
            
            //设置条码类型:包含 AVMetadataObjectTypeQRCode 就好
            if (![captureMetadataOutput.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
                [self showTipByMessage:@"摄像头不支持扫描二维码！"];
                //
                //                [self dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [captureMetadataOutput setMetadataObjectTypes:captureMetadataOutput.availableMetadataObjectTypes];
            }
            captureMetadataOutput.rectOfInterest = CGRectMake(CGRectGetMinY(scanRect)/CGRectGetHeight(self.view.frame),
                                                              1 - CGRectGetMaxX(scanRect)/CGRectGetWidth(self.view.frame),
                                                              CGRectGetHeight(scanRect)/CGRectGetHeight(self.view.frame),
                                                              CGRectGetWidth(scanRect)/CGRectGetWidth(self.view.frame));//设置扫描区域。。默认是手机头向左的横屏坐标系（逆时针旋转90度）
            //将捕获的数据流展现出来
            _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
            [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            [_videoPreviewLayer setFrame:self.view.bounds];
        }
    }
    
    if (!_myScanBGView) {
        _myScanBGView = [[ErScanBackgroundView alloc] initWithFrame:self.view.bounds];
        _myScanBGView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _myScanBGView.scanRect = scanRect;
    }
    
    if (!_scanRectView) {
        UIImage * scanRectImage = [[UIImage imageNamed:@"scan_bg"] tintedGradientImageWithColor:BM_Color_Blue];
        
        _scanRectView = [[UIImageView alloc] initWithFrame:scanRect];
        _scanRectView.image = [scanRectImage resizableImageWithCapInsets:UIEdgeInsetsMake(25, 25, 25, 25)];
        _scanRectView.clipsToBounds = YES;
    }
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont boldSystemFontOfSize:16];
        _tipLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _tipLabel.text = @"将二维码放入框内，即可自动扫描";
    }
    if (!_lineView) {
        UIImage *lineImage = [[UIImage imageNamed:@"scan_line"] tintedGradientImageWithColor:BM_Color_Blue];
        CGFloat lineHeight = 2;
        CGFloat lineWidth = CGRectGetWidth(_scanRectView.frame);
        _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -lineHeight, lineWidth, lineHeight)];
        _lineView.contentMode = UIViewContentModeScaleToFill;
        _lineView.image = lineImage;
    }
    UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton hll_setBackgroundImageWithColor:BM_Color_Blue forState:UIControlStateNormal];
//    [cancelButton addCornerRound:5.0f];
    cancelButton.layer.cornerRadius = 5.0f;
    cancelButton.layer.masksToBounds = YES;
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelButton addTarget:self action:@selector(cancelScanHandle:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    
    [self.view.layer addSublayer:_videoPreviewLayer];
    [self.view addSubview:_myScanBGView];
    [self.view addSubview:_scanRectView];
    [self.view addSubview:_tipLabel];
    [self.view addSubview:cancelButton];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_scanRectView.mas_bottom).offset(20);
        make.height.mas_equalTo(45);
    }];
    
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.size.mas_equalTo(CGSizeMake(width + 40, 45));
        make.centerX.equalTo(_tipLabel);
        make.top.mas_equalTo(_tipLabel.mas_bottom).mas_offset(30);
    }];
    [_scanRectView addSubview:_lineView];
    [_videoPreviewLayer.session startRunning];
//    [self scanLineStartAction];
}

- (void) cancelScanHandle:(UIButton *)button{
    
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)scanLineStartAction{
    [self scanLineStopAction];
    
    CABasicAnimation *scanAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    scanAnimation.fromValue = @(-CGRectGetHeight(_lineView.frame));
    scanAnimation.toValue = @(CGRectGetHeight(_lineView.frame) + CGRectGetHeight(_scanRectView.frame));
    
    scanAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scanAnimation.repeatCount = CGFLOAT_MAX;
    scanAnimation.duration = 2.0;
    [self.lineView.layer addAnimation:scanAnimation forKey:@"basic"];
}

- (void)scanLineStopAction{
    [self.lineView.layer removeAllAnimations];
}

- (void)dealloc {
    [self.videoPreviewLayer removeFromSuperlayer];
    self.videoPreviewLayer = nil;
    [self scanLineStopAction];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    //判断是否有数据，是否是二维码数据
    if (metadataObjects.count > 0) {
        __block AVMetadataMachineReadableCodeObject *result = nil;
        [metadataObjects enumerateObjectsUsingBlock:^(AVMetadataMachineReadableCodeObject *obj, NSUInteger idx, BOOL *stop) {
            if ([obj.type isEqualToString:AVMetadataObjectTypeQRCode]) {
                result = obj;
                *stop = YES;
            }
        }];
        if (!result) {
            result = [metadataObjects firstObject];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self analyseResult:result];
        });
    }
}

- (void)analyseResult:(AVMetadataMachineReadableCodeObject *)result{
    
    if (![result isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
        
        return;
    }
    if (result.stringValue.length <= 0) {
        return;
    }
    
    //停止扫描
    [self.videoPreviewLayer.session stopRunning];
    [self scanLineStopAction];
    
    //震动反馈
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    SBJsonParser *jsonParser = [SBJsonParser new];
    id repr = [jsonParser objectWithString:result.stringValue];
    if (!repr || ![repr[@"appId"] isEqualToString: @"zhsq"]){// 不是json格式、不是NSArray、不是NSDictionary
        //捕获异常
        DQAlertViewController * alert = [[DQAlertViewController alloc] initWithTitle:@"提示" message:@"不是有效的商家信息二维码" buttons:@[@"确定"] afterDismiss:^(NSInteger buttonIndex) {

            [self.videoPreviewLayer.session startRunning];
        }];
        [alert showAlert:self];
        [self scanLineStartAction];
        return;
    }
    
    // 跳转至支付界面
    ErCodePayViewController * vc = [[ErCodePayViewController alloc] init];
    vc.payData = repr;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Notification
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self.videoPreviewLayer.session startRunning];
    [self scanLineStartAction];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [self.videoPreviewLayer.session stopRunning];
    [self scanLineStopAction];
}


- (void) navigationToPay{
    
}
@end
