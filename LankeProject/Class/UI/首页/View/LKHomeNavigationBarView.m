//
//  LKHomeNavigationBarView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/14.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "LKHomeNavigationBarView.h"

@interface LKHomeNavigationBarView ()

@property (nonatomic ,strong) UIButton * locationButton;

@property (nonatomic ,strong) UIImageView * titleViewImageView;

@property (nonatomic ,strong) UIButton * messageButton;

@property (nonatomic ,strong) UIView * dotView;

@end

@implementation LKHomeNavigationBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        UIImage * locationImage = [[UIImage imageNamed:@"navigation_bar_location"] tintedGradientImageWithColor:[UIColor whiteColor]];
        _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_locationButton setTitle:@" 上海市" forState:UIControlStateNormal];
        _locationButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_locationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_locationButton setImage:locationImage forState:UIControlStateNormal];
        [_locationButton addTarget:self action:@selector(locationButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_locationButton];
        
        _titleViewImageView = [[UIImageView alloc] init];
        _titleViewImageView.contentMode = UIViewContentModeCenter;
        _titleViewImageView.image = [UIImage imageNamed:@"navigation_home_page_title_view"];
        [self addSubview:_titleViewImageView];
        
        _messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_messageButton setImage:[UIImage imageNamed:@"navigation_bar_message"] forState:UIControlStateNormal];
        [_messageButton addTarget:self action:@selector(messageButtonHandle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_messageButton];
        
        _dotView = [[UIView alloc] init];
        _dotView.backgroundColor = [UIColor redColor];
        _dotView.layer.cornerRadius = 2.5;
        _dotView.layer.masksToBounds = YES;
        _dotView.hidden=YES;
        [self addSubview:_dotView];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [_titleViewImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.6);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [_locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(_titleViewImageView.mas_centerY);
    }];
    [_messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_titleViewImageView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.mas_equalTo(self.mas_right).mas_offset(0);
    }];
    [_dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 5));
        make.top.mas_equalTo(_messageButton.mas_top).mas_offset(15);
        make.right.mas_equalTo(_messageButton.mas_right).mas_offset(-15);
    }];
}


- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    //当事件是传递给此View内部的子View时，让子View自己捕获事件，如果是传递给此View自己时，放弃事件捕获
    UIView* __tmpView = [super hitTest:point withEvent:event];
    if (__tmpView == self) {
        return nil;
    }
    return __tmpView;
}

- (void) configNavigationBarWithData:(id)data{

    if (data)
    {
        [_locationButton setTitle:data[@"city"] forState:UIControlStateNormal];
 
    }
    
}

-(void)updateMessageCount
{
    [UserServices
     getMessageCount:[KeychainManager readUserId]
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             if ([responseObject[@"data"] integerValue]>0)
             {
                 _dotView.hidden=NO;
             }
             else
             {
                 _dotView.hidden=YES;
             }
         }
     }];
}

#pragma mark -
#pragma mark Action M

- (void) locationButtonHandle:(UIButton *)button{
    
    if (self.bLocationButtonHandle) {
        
        self.bLocationButtonHandle();
    }
}
- (void) messageButtonHandle:(UIButton *)button{
    
    if (self.bMessageButtonHandle) {
        
        self.bMessageButtonHandle();
    }
}

@end
