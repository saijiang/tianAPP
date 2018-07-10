//
//  HumanBodyViewController.m
//  LankeProject
//
//  Created by itman on 17/3/9.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "HumanBodyViewController.h"

@interface HumanBodyViewController ()

@property(nonatomic,strong)UIButton *switchButton;
@property(nonatomic,strong)UIImageView *humanBody;

@end

@implementation HumanBodyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createView];
}
-(void)createView
{
    UILabel *message=[UnityLHClass masonryLabel:@"点击不舒服的人体部位可定位到相关病症哦" font:14.0 color:BM_Color_GrayColor];
    [self.view addSubview:message];
    [message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(20);
    }];
    
    //图片大小固定
    self.humanBody=[[UIImageView alloc]init];
    self.humanBody.userInteractionEnabled=YES;
    self.humanBody.image=[UIImage imageNamed:@"zice_zhengmian"];
    [self.view addSubview:self.humanBody];
    [self.humanBody mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(message.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(433);
    }];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(humanBodyTapAction:)];
    [self.humanBody addGestureRecognizer:tap];
    
    UIButton *switchButton=[UnityLHClass masonryButton:@"" imageStr:@"zice_qiehuan" font:14.0 color:BM_Color_GrayColor];
    [self.view addSubview:switchButton];
    [switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-15);
        make.right.mas_equalTo(self.view.mas_right).offset(-5);
    }];
    [switchButton addTarget:self action:@selector(switchHumanBody:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *switchMessage=[UnityLHClass masonryLabel:@"正反切换" font:14.0 color:BM_Color_GrayColor];
    [self.view addSubview:switchMessage];
    [switchMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-15);
        make.centerX.mas_equalTo(switchButton.mas_centerX);
    }];
    self.switchButton=switchButton;
}
-(void)switchHumanBody:(UIButton *)switchButton
{
    switchButton.selected=!switchButton.selected;
    self.humanBody.image=[UIImage imageNamed:@"zice_zhengmian"];
    if (switchButton.selected)
    {
        self.humanBody.image=[UIImage imageNamed:@"zice_beimian"];

    }
}

-(void)humanBodyTapAction:(UITapGestureRecognizer *)tap
{
    CGPoint point=[tap locationInView:tap.view];
    NSLog(@"x=====%f y=======%f",point.x,point.y);

    BOOL isAlpha=[self isAlphaWithPoint:point setImage:self.humanBody];
    if (!isAlpha)
    {
        NSString *organ= [self getClickOrganWithPoint:point];
        [self sendObject:organ];

    }
    
}

//判断部位
-(NSString *)getClickOrganWithPoint:(CGPoint)point
{
    if (self.switchButton.selected)
    {
        //人体背面
        if (point.y<68)
        {
            return @"头部";
        }
        else if (point.y>=68&&point.y<80)
        {
            return @"咽颈部";
            
        }
        else if ((point.x<55||point.x>140)||point.y>240)
        {
            return @"四肢";
        }
        else if (point.y>=80&&point.y<200)
        {
            return @"腰背部";
        }
        else if (point.y>=200&&point.y<240)
        {
            return @"臀部及肛门";
        }
        return @"未知";

    }
    else
    {
        //人体正面
        if (point.y<68)
        {
            return @"头部";
        }
        else if (point.y>=68&&point.y<80)
        {
            return @"咽颈部";
            
        }
        else if ((point.x<94||point.x>174)||point.y>240)
        {
            return @"四肢";
        }
        else if (point.y>=80&&point.y<160)
        {
            return @"胸部";
        }
        else if (point.y>=160&&point.y<200)
        {
            return @"腹部";
        }
        else if (point.y>=200&&point.y<240)
        {
            if (point.x>130&&point.x<140)
            {
                return @"生殖部位";
            }
            return @"骨盆";
        }
        return @"未知";

    }
}

//判断点击的区域是否透明
- (BOOL)isAlphaWithPoint:(CGPoint)point setImage: (UIImageView *) iv
{
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, iv.frame.size.width, iv.frame.size.height), point)) {
        return nil;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = iv.image.CGImage;
    NSUInteger width = iv.frame.size.width;
    NSUInteger height = iv.frame.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    // Draw the pixel we are interested in onto the bitmap context
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    UIColor *color=[UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    if (alpha==0)
    {
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
