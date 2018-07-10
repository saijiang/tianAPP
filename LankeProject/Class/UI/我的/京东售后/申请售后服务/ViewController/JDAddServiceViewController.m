//
//  JDAddServiceViewController.m
//  LankeProject
//
//  Created by fud on 2017/12/11.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDAddServiceViewController.h"
//服务类型
#import "InvoiceTypeView.h"
#import "LKStepView.h"
#import "JYZTextView.h"
#import "SelectedPhotoView.h"

@interface JDAddServiceViewController ()<UITextViewDelegate>
{
    UIView *productView;//商品信息;
    UIImageView *proImageView;//商品图片
    UILabel *proNameLab;//商品名称;
    UILabel *proPriceLab;//商品价格
    UILabel *proCountLab;//商品数量
    
    
    InvoiceTypeView *typeView;//服务类型view
    UIView *countView;//申请数量
    LKStepView *stepView;//数量块
    
    InvoiceTypeView *packageDescView;//包装描述view
    
    InvoiceTypeView *pickwareTypeView;//取件方式view
    
    UIView *problemView;//问题描述
    JYZTextView *problemTfView;//问题描述
    SelectedPhotoView *addPhoto;//添加照片
    UILabel *_limitLabel;//输入的字符串
    
    UIButton *submitBtn;//提交
}

@end

@implementation JDAddServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"申请售后服务";
    
}

-(void)createUI
{
    UILabel *noticeLab = [UnityLHClass initUILabel:@"本次售后服务由京东为您提供" font:15.0 color:BM_GRAY rect:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 40)];
    noticeLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:noticeLab];
    
    productView  = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(noticeLab), DEF_SCREEN_WIDTH, 80)];
    productView.backgroundColor = BM_WHITE;
    [self.contentView addSubview:productView];
    
    proImageView = [[UIImageView alloc]init];
    [proImageView sd_setImageWithURL:[NSURL URLWithString:_orderData[@"imagePath"]] placeholderImage:[UIImage imageNamed:@"default_dishes"]];
    [productView addSubview:proImageView];
    [proImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(productView.mas_centerY);
        make.left.mas_equalTo(10);
        make.height.and.width.mas_equalTo(60);
    }];
    
    proNameLab = [UnityLHClass masonryLabel:_orderData[@"name"] font:14.0 color:BM_BLACK];
    proNameLab.numberOfLines = 0;
    [productView addSubview:proNameLab];
    [proNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(proImageView.mas_top);
        make.left.mas_equalTo(proImageView.mas_right).offset(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(proImageView.mas_height).multipliedBy(0.5);
    }];
    
    proPriceLab = [UnityLHClass masonryLabel:[NSString stringWithFormat:@"价格：%@",_orderData[@"zkPrice"]] font:14.0 color:BM_GRAY];
    [productView addSubview:proPriceLab];
    [proPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(proNameLab.mas_left);
        make.height.mas_equalTo(proImageView.mas_height).multipliedBy(0.5);
        make.top.mas_equalTo(proImageView.mas_centerY);
    }];
    
    proCountLab = [UnityLHClass masonryLabel:[NSString stringWithFormat:@"数量：%@",_orderData[@"num"]] font:14.0 color:BM_GRAY];
    [productView addSubview:proCountLab];
    [proCountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(proPriceLab.mas_right).offset(15);
        make.centerY.mas_equalTo(proPriceLab.mas_centerY);
    }];
    
    
    //服务类型
    typeView = [[InvoiceTypeView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(productView)+15, DEF_SCREEN_WIDTH, 120)];
    typeView.type = AfterSellServiceType;
    typeView.jdOrderId = self.orderData[@"jdOrderId"];
    typeView.skuId = self.orderData[@"sku"];
    typeView.noticeLable.hidden = YES;
    typeView.typeTitleLab.text = @"服务类型";
    [typeView getCustomerExpectCompRequest];
    [self.contentView addSubview:typeView];
    
    
    //包装描述
    packageDescView = [[InvoiceTypeView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(typeView)+15, DEF_SCREEN_WIDTH, 120)];
    packageDescView.type = AfterSellPackageType;
    packageDescView.noticeLable.hidden = YES;
    packageDescView.typeTitleLab.text = @"包装描述";
//    0 无包装 10 包装完整 20 包装破损
  
    packageDescView.dataArray =  @[@{@"name":@"无包装",@"code":@"0"},@{@"name":@"包装完整",@"code":@"10"},@{@"name":@"包装破损",@"code":@"20"}];
    [self.contentView addSubview:packageDescView];
    
    //取件方式
    pickwareTypeView = [[InvoiceTypeView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(packageDescView)+15, DEF_SCREEN_WIDTH, 120)];
    pickwareTypeView.type = AfterSellPickwareType;
    pickwareTypeView.jdOrderId = self.orderData[@"jdOrderId"];
    pickwareTypeView.skuId = self.orderData[@"sku"];
    pickwareTypeView.noticeLable.hidden = YES;
    pickwareTypeView.typeTitleLab.text = @"取件方式";
    [pickwareTypeView getWareReturnJdCompRequest];
    [self.contentView addSubview:pickwareTypeView];
    
    
    //申请数量
    countView = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(pickwareTypeView)+15, DEF_SCREEN_WIDTH, 100)];
    countView.backgroundColor = BM_WHITE;
    [self.contentView addSubview:countView];
    
    UILabel *countTitleLab = [UnityLHClass masonryLabel:@"申请数量" font:15.0 color:BM_BLACK];
    [countView addSubview:countTitleLab];
    [countTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(proImageView.mas_left);
    }];
    
    stepView = [LKStepView view];
    stepView.minValue = 1;
    stepView.maxValue = [self.orderData[@"canAfterSellApplyNum"] integerValue];// test max value for limit
    stepView.value = 1;
    [countView addSubview:stepView];
    [stepView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(countTitleLab.mas_bottom).mas_offset(15);
        make.left.mas_equalTo(countTitleLab.mas_left);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
    }];
    
    float height = DEF_SCREEN_WIDTH;
    problemView = [[UIView alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(countView)+15, DEF_SCREEN_WIDTH, height)];
    problemView.backgroundColor = BM_WHITE;
    [self.contentView addSubview:problemView];
    
    UILabel *problemTitleLab = [UnityLHClass masonryLabel:@"问题描述" font:15.0 color:BM_BLACK];
    [problemView addSubview:problemTitleLab];
    [problemTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(proImageView.mas_left);
    }];
    
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
    [problemView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(problemTitleLab.mas_bottom).offset(15);
        make.left.mas_equalTo(problemTitleLab.mas_left);
        make.right.mas_equalTo(problemView.mas_right).offset(-10);
        make.bottom.mas_equalTo(problemView.mas_bottom).offset(-120);
    }];
    
    problemTfView = [[JYZTextView alloc]init];
    problemTfView.placeholder = @"请您在此描述问题";
    problemTfView.font = BM_FONTSIZE14;
    problemTfView.backgroundColor = BM_CLEAR;
    problemTfView.delegate = self;
    [problemView addSubview:problemTfView];
    [problemTfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(problemTitleLab.mas_bottom).offset(15);
        make.left.mas_equalTo(problemTitleLab.mas_left);
        make.right.mas_equalTo(problemView.mas_right).offset(-10);
        make.bottom.mas_equalTo(problemView.mas_bottom).offset(-150);
    }];
    
    
    
    _limitLabel = [UnityLHClass masonryLabel:@"0/500" font:14.0 color:[UIColor colorWithRed:0.78 green:0.78 blue:0.80 alpha:1.00]];
    _limitLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:_limitLabel];
    [_limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bgView.mas_right).offset(-10);
        make.bottom.mas_equalTo(bgView.mas_bottom);
        make.top.mas_equalTo(problemTfView.mas_bottom);
    }];
    
    addPhoto = [[SelectedPhotoView alloc]initWithFrame:CGRectMake(10,0, DEF_SCREEN_WIDTH-10*2, 100)];
    addPhoto.maxColumn=4;
    addPhoto.maxImageCount=3;
    [problemView addSubview:addPhoto];
    [addPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(problemTfView.mas_left);
        make.top.mas_equalTo(bgView.mas_bottom).offset(10);
        make.right.mas_equalTo(problemTfView.mas_right);
        make.height.mas_equalTo(100);
        make.bottom.mas_equalTo(problemView.mas_bottom).offset(-10);
    }];
    
    UILabel *botoomLab = [UnityLHClass masonryLabel:@"提交服务单后，售后专员可能与您电话沟通，请保持手机畅通" font:14.0 color:BM_GRAY];
    botoomLab.textAlignment = NSTextAlignmentCenter;
    botoomLab.numberOfLines = 0;
    [self.contentView addSubview:botoomLab];
    [botoomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.centerX.mas_equalTo(problemTfView.mas_centerX);
        make.top.mas_equalTo(problemView.mas_bottom).offset(15);
    }];
    
    //提交
    submitBtn = [UnityLHClass masonryButton:@"提交" font:15.0 color:BM_WHITE];
    submitBtn.backgroundColor = BM_Color_Blue;
    submitBtn.layer.cornerRadius = 3.0;
    [submitBtn addTarget:self action:@selector(sumbitHandle) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH/2.0);
        make.top.mas_equalTo(botoomLab.mas_bottom).offset(20);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
    }];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.text.length + text.length > 500) {
        NSString *allText = [NSString stringWithFormat:@"%@%@",textView.text,text];
        textView.text = [allText substringToIndex:500];
        [UnityLHClass showHUDWithStringAndTime:@"输入不能超过500个字"];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    _limitLabel.text = [NSString stringWithFormat:@"%ld/500",(unsigned long)textView.text.length ];
}

-(void)sumbitHandle
{
    if (typeView.typeStr.length == 0 || packageDescView.typeStr.length == 0 || pickwareTypeView.typeStr.length == 0)
    {
        [UnityLHClass showAlertView:@"请完善信息"];
        return;
    }
    if (problemTfView.text.length == 0)
    {
        [UnityLHClass showAlertView:@"请填写问题描述"];
        return;
    }
    /*
     jdOrderId     是     string     京东订单号
     customerExpect     是     string     客户预期 必填，退货(10)、换货(20)、维修(30)
     questionDesc     是     string     产品问题描述
     isHasPackage     是     string     是否有包装 0否 1是
     packageDesc     是     string     包装描述 0 无包装 10 包装完整 20 包装破损
     pickwareType     是     string     取件方式 4 上门取件 7 客户送货 40客户发货
     skuId     是     string     sku
     skuNum     是     string     数量
     */
    [UserServices jdAfterSellApplyAddApplyWithJdOrderId:self.orderData[@"jdOrderId"]
                                         customerExpect:typeView.typeStr
                                           questionDesc:problemTfView.text
                                           isHasPackage:[packageDescView.typeStr integerValue] > 0 ? @"1" : @"0"
                                            packageDesc:packageDescView.typeStr
                                           pickwareType:pickwareTypeView.typeStr
                                                  skuId:self.orderData[@"sku"]
                                                 skuNum:self.orderData[@"num"]
                                             imagesPath:addPhoto.images
                                        completionBlock:^(int result, id responseObject)
    {
        if (result == 0)
        {
            [UnityLHClass showHUDWithStringAndTime:@"申请成功"];
            [self sendObject:@"reload"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
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
