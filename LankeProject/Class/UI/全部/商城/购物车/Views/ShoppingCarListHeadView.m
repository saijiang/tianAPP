//
//  ShoppingCarListHeadView.m
//  LankeProject
//
//  Created by Justin on 2017/1/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ShoppingCarListHeadView.h"

@implementation ShoppingCarListHeadView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.chooseBtn = [[UIButton alloc] init];
        [self.chooseBtn setImage:[UIImage imageNamed:@"choose-off"] forState:UIControlStateNormal];
        [self.chooseBtn setImage:[UIImage imageNamed:@"choose-on"] forState:UIControlStateSelected];
        [self.chooseBtn addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.chooseBtn];
        
        self.merchantName = [UnityLHClass masonryLabel:@"" font:14.0 color:BM_BLACK];
        [self.contentView addSubview:self.merchantName];
        self.startSendMoney = [UnityLHClass masonryLabel:@"" font:14.0 color:BM_Color_huiColor];
        [self.contentView addSubview:self.startSendMoney];
        //右侧小箭头
        self.rightImage = [[LocalhostImageView alloc] init];
        self.rightImage.image = [UIImage imageNamed:@"ShopCar_RightArrow"];
        [self.contentView addSubview:self.rightImage];
        self.rightImage.hidden = YES;
        
        self.lineView = [UIView new];
        self.lineView.backgroundColor = BM_Color_SeparatorColor;
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(5);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.and.height.mas_equalTo(self.contentView.mas_height).multipliedBy(0.7);
    }];
    
    [self.merchantName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.chooseBtn.mas_right).offset(0);
        make.centerY.mas_equalTo(self.chooseBtn.mas_centerY);
        make.height.mas_equalTo(20);

    
    }];

    
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.mas_equalTo(self.chooseBtn.mas_centerY);
        make.width.offset(8);
        make.height.offset(8);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

- (void)chooseAction:(UIButton *)sender
{
    if (self.HShoppingCarHeadChooseHandle)
    {
        self.HShoppingCarHeadChooseHandle(sender);
    }
}


#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
    
    return NSStringFromClass([self class]);
}

- (void) configCellWithData:(ChooseSection *)dataSource{
    if ([self.isTypeShop isEqualToString:@"JD"]) {
        self.merchantName.text=[NSString stringWithFormat:@"%@",@"京东自营店"];

    }else{
        self.merchantName.text = dataSource.section[@"merchantName"];
        if ([dataSource.section[@"startSendFlg"] integerValue]>0) {
            
            self.startSendMoney.text =[NSString stringWithFormat:@"(满%@元配送)",dataSource.section[@"startSendMoney"]];
            CGFloat bigwidth=[UnityLHClass getWidth:dataSource.section[@"merchantName"] wid:20 font:14]+[UnityLHClass getWidth:[NSString stringWithFormat:@"(满%@元配送)",dataSource.section[@"startSendMoney"]] wid:20 font:14]+50;
            if (bigwidth>DEF_SCREEN_WIDTH) {
                [self.startSendMoney mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.chooseBtn.mas_right).offset(0);
                    make.top.mas_equalTo(self.merchantName.mas_bottom);
                    make.bottom.mas_equalTo(self.mas_bottom);
                    
                }];
                
                [self.chooseBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(-10);
                }];
                
            }else{
                
                [self.startSendMoney mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.merchantName.mas_right).offset(10);
                    make.centerY.mas_equalTo(self.chooseBtn.mas_centerY);
                    
                }];
            }
            
        }else{
            
            self.startSendMoney.text =@"";
        }
        

    }
    
       self.chooseBtn.selected = dataSource.isAllItemsSelected;
}

+ (CGFloat) cellHeightWithData:(id)data{

    ChooseSection*dataSource=data;
    CGFloat bigwidth=[UnityLHClass getWidth:dataSource.section[@"merchantName"] wid:20 font:14]+[UnityLHClass getWidth:[NSString stringWithFormat:@"(满%@元配送)",dataSource.section[@"startSendMoney"]] wid:20 font:14]+50;
    if (bigwidth>DEF_SCREEN_WIDTH) {
        
        return 60;
    }else{
        
         return 50;
    }
  
}
@end
