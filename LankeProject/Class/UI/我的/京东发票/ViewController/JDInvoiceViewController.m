//
//  JDInvoiceViewController.m
//  LankeProject
//
//  Created by fud on 2017/12/7.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDInvoiceViewController.h"
//发票类型
#import "InvoiceTypeView.h"
//发票抬头
#import "InvoiceHeaderView.h"
//收票人信息
#import "JDInvoicerInfoView.h"
//发票内容
#import "JDInvoicerContentView.h"

@interface JDInvoiceViewController ()
{
    UIView *_noticeView;//顶部提示语view
    UILabel *_noticeLab;
    
    InvoiceTypeView *_typeView;//发票类型
    
    InvoiceHeaderView *_headerView;//发票抬头
    
    JDInvoicerInfoView *_infoView;//收票人信息
    
    JDInvoicerContentView *_contentView;//发票内容
    
    UIButton *sureBtn;//确定
}
/*
 selectedInvoiceTitle     是     string     发票类型：4个人，5单位
 companyName     是     string     发票抬头 (如果selectedInvoiceTitle=5则此字段必须)
 invoiceContent     是     string     1:明细，3：电脑配件，19:耗材，22：办公用品 备注:若增值发票则只能选1 明细
 */
@property (nonatomic,strong)NSString *selectedInvoiceTitle;
@property (nonatomic,strong)NSString *companyName;
@property (nonatomic,strong)NSString *companyNum;

@property (nonatomic,strong)NSString *invoiceContent;

@end

@implementation JDInvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showNavBarCustomByTitle:@"发票信息"];
    
}

-(void)createUI
{
    _noticeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, 0)];
    _noticeView.backgroundColor = BM_RED;
    [self.contentView addSubview:_noticeView];
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    imgView.backgroundColor = BM_GREEN;
    [_noticeView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(_noticeView.mas_height);
    }];
    
//    _noticeLab = [UnityLHClass masonryLabel:@"部分地区仅提供电子普通发票，用户可自行打印，效力等同纸质普通发票，具体以实际出具为准" font:14.0 color:BM_WHITE];
//    _noticeLab.numberOfLines = 0;
//    [_noticeView addSubview:_noticeLab];
//    [_noticeLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(_noticeView.mas_centerY);
//        make.left.mas_equalTo(_noticeView.mas_left).offset(30);
//        make.right.mas_equalTo(_noticeView.mas_right).offset(-30);
//    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = BM_CYAN;
    [btn setImage:[UIImage imageWithColor:BM_GREEN] forState:UIControlStateNormal];
    [_noticeView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_noticeView.mas_centerY);
        make.right.mas_equalTo(_noticeView.mas_right);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(_noticeView.mas_height);
    }];
    [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^(id sender) {
        _noticeView.frame = CGRectMake(0, -50, DEF_SCREEN_WIDTH, 50);
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
        }];
    }];
    
    [self createTypeView];
    [self createHeaderView];
//    [self createInfoView]; 隐藏
    [self createContentView];
    
    self.contentView.contentSize = CGSizeMake(DEF_SCREEN_WIDTH, DEF_CONTENT-60);
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-60);
    }];
    
    sureBtn = [UnityLHClass masonryButton:@"确定" font:16.0 color:BM_WHITE];
    sureBtn.layer.cornerRadius = 2;
    sureBtn.backgroundColor = BM_Color_Blue;
    [sureBtn addTarget:self action:@selector(sureHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.45);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    if (_data)
    {
        _invoiceContent = _data[@"invoiceContent"];
        _selectedInvoiceTitle = _data[@"selectedInvoiceTitle"];
        _companyName = _data[@"companyName"];
        _companyNum = _data[@"regcode"];

        [_headerView configViewWithData:_data];
        [_contentView configViewWithData:_data];
    }
    else
    {
        _selectedInvoiceTitle = @"4";//默认个人
        _companyName = @"";
        _invoiceContent = @"1";//默认明细
        _companyNum=@"";
    }
}

#pragma mark -- 发票类型view
-(void)createTypeView
{
    _typeView = [[InvoiceTypeView alloc]init];
    _typeView.type = FapType;
    _typeView.dataArray = @[@"电子发票"];
    [self.contentView addSubview:_typeView];
    [_typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_noticeView.mas_bottom).offset(10);
        make.height.mas_equalTo(150);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
    }];
}

#pragma mark -- 发票抬头
-(void)createHeaderView
{
    _headerView = [[InvoiceHeaderView alloc]init];
    [self.contentView addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(_typeView.mas_width);
        if (_data && [_data[@"selectedInvoiceTitle"] integerValue] == 5)
        {
            _headerView.nameTf.hidden = NO;
            _headerView.numberTf.hidden=NO;
            make.height.mas_equalTo(190);
        }
        else
        {
            _headerView.nameTf.hidden = YES;
            _headerView.numberTf.hidden=YES;

            make.height.mas_equalTo(100);
        }
        make.top.mas_equalTo(_typeView.mas_bottom).offset(10);
    }];
    [_headerView receiveObject:^(id object) {
        if ([object isEqualToString:@"hide"])
        {
            //个人
            _selectedInvoiceTitle = @"4";
            [_headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(100);
            }];
        }
        else
        {
            //单位
            _selectedInvoiceTitle = @"5";
            [_headerView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(190);
            }];
        }
    }];
}
#pragma mark -- 收票人信息
-(void)createInfoView
{
    _infoView = [[JDInvoicerInfoView alloc]init];
    [self.contentView addSubview:_infoView];
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(_typeView.mas_width);
        make.top.mas_equalTo(_headerView.mas_bottom).offset(10);
        make.height.mas_equalTo(150);
    }];
}

#pragma mark -- 发票内容
-(void)createContentView
{
    _contentView = [[JDInvoicerContentView alloc]init];
    [self.contentView addSubview:_contentView];
    float height = _contentView.dataArray.count * 50 + 50;
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(DEF_SCREEN_WIDTH);
        make.height.mas_equalTo(height);
//        make.top.mas_equalTo(_infoView.mas_bottom).offset(10);
        make.top.mas_equalTo(_headerView.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

#pragma mark  ---- 逻辑处理
-(void)sureHandle:(UIButton *)sender
{
    /*
     selectedInvoiceTitle     是     string     发票类型：4个人，5单位
     companyName     是     string     发票抬头 (如果selectedInvoiceTitle=5则此字段必须)
     invoiceContent     是     string     1:明细，3：电脑配件，19:耗材，22：办公用品 备注:若增值发票则只能选1 明细
     */
    NSString *str0 = _contentView.typeStr;
    NSString *str1 = @"个人";
    if ([_selectedInvoiceTitle integerValue] == 5)
    {
        str1 = @"单位";
        _companyName = _headerView.nameTf.text;
        _companyNum=_headerView.numberTf.text;
        if ([_companyName length] == 0)
        {
            [UnityLHClass showHUDWithStringAndTime:@"请填写发票抬头"];
            return ;
        }
        if ([_companyNum length] == 0)
        {
            [UnityLHClass showHUDWithStringAndTime:@"请填纳税人识别号"];
            return ;
        }
    }
    
    _invoiceContent = _contentView.invoiceContentStr;
    
    if ([_invoiceContent length] == 0)
    {
        [UnityLHClass showHUDWithStringAndTime:@"请选择发票内容"];
        return ;
    }
    NSDictionary*dic=@{@"selectedInvoiceTitle":_selectedInvoiceTitle,
                       @"companyName":_companyName,
                       @"regcode":_companyNum,
                       @"invoiceContent":_invoiceContent,
                       @"title":[NSString stringWithFormat:@"%@-%@",str0,str1]};
    
    [self sendObject:dic];
    [self.navigationController popViewControllerAnimated:YES];
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
