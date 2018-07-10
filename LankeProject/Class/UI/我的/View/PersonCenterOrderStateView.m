//
//  PersonCenterOrderStateView.m
//  LankeProject
//
//  Created by 孟德初 on 2018/6/15.
//  Copyright © 2018年 张涛. All rights reserved.
//

#import "PersonCenterOrderStateView.h"

#define BUTTON_HEIGHT 30
#define TOP_MAGIN 10
#define LEFT_MAGIN (DEF_SCREEN_WIDTH-(_maxDisplayCount*_buttonWidth+((_maxDisplayCount-1)*(DEF_SCREEN_WIDTH/((_maxDisplayCount + 1)*(_maxDisplayCount + 1))))))/2
@interface PersonCenterOrderStateView ()

@property (nonatomic, strong) NSMutableArray *stateBtn;

@property (nonatomic, strong) UIButton *firstBtn;

@property (nonatomic) BOOL isChangeLine;


@end

@implementation PersonCenterOrderStateView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        //                [self initUI];
        
    }
    return self;
}

-(void)initUI{
    
    //    self.stateName = @[@"全部",@"代付款",@"待收货",@"已完成",@"已取消",@"测试1",@"测试2"];
    self.stateBtn = [NSMutableArray new];
    
    if(!_buttonWidth){
        _buttonWidth = DEF_SCREEN_WIDTH/(_maxDisplayCount + 1);
    }
    
    
    for (int i = 0; i < self.stateName.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.stateName[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(stateChange:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag  = i;
        //设置圆角的半径
        [btn.layer setCornerRadius:3];
        //切割超出圆角范围的子视图
        btn.layer.masksToBounds = YES;
        //设置边框的颜色
        [btn.layer setBorderColor:[UIColor grayColor].CGColor];
        //设置边框的粗细
        [btn.layer setBorderWidth:1.0];
        
        [self addSubview:btn];
        [self.stateBtn addObject:btn];
        [self layoutStateButton:btn withButtonIndex:i];
     
    }
}

-(void)setStateName:(NSArray *)stateName{
    _stateName = stateName;
    
}

-(void)setMaxDisplayCount:(NSInteger)maxDisplayCount{
    _maxDisplayCount = maxDisplayCount;
         [self initUI];
}

-(void)setButtonWidth:(NSInteger)buttonWidth{
    _buttonWidth = buttonWidth;
        for (int i = 0; i<self.stateBtn.count; i++) {
            UIButton *btn = self.stateBtn[i];
//            [self layoutStateButton:btn withButtonIndex:i];
            [self updataStateButton:btn withButtonIndex:i];
        }

    
}

-(void)updataStateButton:(UIButton*)btn withButtonIndex:(int)index{
    if (_isChangeLine) {
        
        [btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_buttonWidth);
            make.left.mas_equalTo(self).offset(LEFT_MAGIN);
        }];
        _firstBtn = btn;
        _isChangeLine = NO;
    }else{
        if(index == 0){
            btn.selected = YES;
            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(_buttonWidth);
                make.left.mas_equalTo(self).offset(LEFT_MAGIN);
            }];
            _firstBtn = btn;
        }else{
            UIButton *beforeBtn  = self.stateBtn[index-1];
            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(_buttonWidth);
                make.left.mas_equalTo(beforeBtn.mas_right).offset(DEF_SCREEN_WIDTH/((_maxDisplayCount + 1)*(_maxDisplayCount + 1)));
            }];

            [self setNeedsLayout];
            [self layoutIfNeeded];
            if(btn.frame.origin.x + btn.frame.size.width > _maxDisplayCount*DEF_SCREEN_WIDTH/(_maxDisplayCount + 1)){
                _isChangeLine = YES;
            }
            
//            if(btn.frame.origin.x + btn.frame.size.width +TOP_MAGIN > DEF_SCREEN_WIDTH){
//                _isChangeLine = YES;
//            }
            
        }
    }
}

-(void)layoutStateButton:(UIButton*)btn withButtonIndex:(int)index{
    if (_isChangeLine) {
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(_buttonWidth);
            make.left.mas_equalTo(self).offset(LEFT_MAGIN);
            make.top.mas_equalTo(_firstBtn.mas_bottom).offset(TOP_MAGIN);
            make.height.mas_equalTo(BUTTON_HEIGHT);
        }];
        _firstBtn = btn;
        _isChangeLine = NO;
    }else{
        if(index == 0){
            btn.selected = YES;
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(_buttonWidth);
                make.left.mas_equalTo(self).offset(LEFT_MAGIN);
                make.top.mas_equalTo(self).offset(TOP_MAGIN);
                make.height.mas_equalTo(BUTTON_HEIGHT);
            }];
            _firstBtn = btn;
        }else{
            UIButton *beforeBtn  = self.stateBtn[index-1];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(_buttonWidth);
                make.left.mas_equalTo(beforeBtn.mas_right).offset(DEF_SCREEN_WIDTH/((_maxDisplayCount + 1)*(_maxDisplayCount + 1)));
                make.top.mas_equalTo(beforeBtn.mas_top);
                make.height.mas_equalTo(BUTTON_HEIGHT);
            }];
            [self setNeedsLayout];
            [self layoutIfNeeded];
            if(btn.frame.origin.x + btn.frame.size.width > _maxDisplayCount*DEF_SCREEN_WIDTH/(_maxDisplayCount + 1)){
                _isChangeLine = YES;
            }
            
//            if(btn.frame.origin.x + btn.frame.size.width +TOP_MAGIN > DEF_SCREEN_WIDTH){
//                _isChangeLine = YES;
//            }
            
            
        }
    }
}



-(void)stateChange:(UIButton *)sender{
    for (int i = 0; i<self.stateBtn.count; i++) {
        UIButton *btn = self.stateBtn[i];
        btn.selected = NO;
    }
    sender.selected = YES;
    _stateBlock(sender.tag);
    
}
@end
