//
//  PropertyRepairZoneView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/15.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PropertyRepairZoneView.h"
#import "DQAlertSheetController.h"

@interface PropertyRepairZoneItemView : UIView<LKCustomViewProtocol>
@property (nonatomic ,strong) UILabel * displayTitleLabel;

@property (nonatomic ,assign) NSInteger index;

@property (nonatomic ,strong) UIButton * leftButton;
@property (nonatomic ,strong) UIButton * rightButton;
@property (nonatomic ,strong) NSArray * buttons;

@end
@implementation PropertyRepairZoneItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.displayTitleLabel = [UnityLHClass masonryLabel:@"报修区域" font:17 color:[UIColor blackColor]];
        [self addSubview:self.displayTitleLabel];
        
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.leftButton.tag = 1010 + 0;
        [self.leftButton setTitle:@"xxxxx" forState:UIControlStateNormal];
        [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [self.leftButton addTarget:self action:@selector(buttonDidselected:) forControlEvents:UIControlEventTouchUpInside];
        [self.leftButton setImage:[UIImage imageNamed:@"circle_choose_off"] forState:UIControlStateNormal];
        [self.leftButton setImage:[UIImage imageNamed:@"circle_choose_on"] forState:UIControlStateSelected];
        [self addSubview:self.leftButton];
        
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
        self.rightButton.tag = 1010 + 1;
        [self.rightButton setTitle:@"xxxxx" forState:UIControlStateNormal];
        [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [self.rightButton addTarget:self action:@selector(buttonDidselected:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightButton setImage:[UIImage imageNamed:@"circle_choose_off"] forState:UIControlStateNormal];
        [self.rightButton setImage:[UIImage imageNamed:@"circle_choose_on"] forState:UIControlStateSelected];
        [self addSubview:self.rightButton];
        self.buttons = @[self.leftButton,self.rightButton];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat height = CGRectGetHeight(self.bounds)/2;
    
    [self.displayTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(0);
    }];

    [self.leftButton mas_updateConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.displayTitleLabel.mas_bottom);
        make.height.mas_equalTo(height);
    }];
    [self.rightButton mas_updateConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.leftButton.mas_right).mas_offset(30);
        make.centerY.mas_equalTo(self.leftButton.mas_centerY);
        make.height.mas_equalTo(self.leftButton.mas_height);
    }];
}

- (void) buttonDidselected:(UIButton *)sender{
    NSInteger indexx=sender.tag - 1010;
    if (self.index==indexx) {
        return;
    }
    for (UIButton * button in self.buttons) {
        button.selected = sender == button;
    }
    self.index = sender.tag - 1010;
//    repairArea 	是 	string 	报修区域（01：住宅区域 ，02：科研办公区域）
//    repairTypeFirst 	是 	string 	报修类型（01：公共报修， 02：室内报修）
    if (self.index==0) {
        [self sendObject:@"01"];
    }
    else{
        [self sendObject:@"02"];

    }
}

- (void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(rect)/2;
    CGFloat margin_v = 10;
    {
        CGPoint startPoint_v = CGPointMake(0,height);
        CGPoint stopPoint_v = CGPointMake(width,height);
        zone_drawLineWithContext(context, startPoint_v, stopPoint_v);
    }
    {
        CGPoint startPoint_h = CGPointMake(margin_v,height * 2);
        CGPoint stopPoint_h = CGPointMake(width - margin_v,height * 2);
        zone_drawLineWithContext(context, startPoint_h, stopPoint_h);
    }
}

void zone_drawLineWithContext(CGContextRef context, CGPoint start_point, CGPoint stop_point){
    
    CGPoint lines[] = {
        start_point,
        stop_point
    };
    CGContextAddLines(context, lines, sizeof(lines)/sizeof(lines[0]));
    CGContextSetLineWidth(context, 1/[UIScreen mainScreen].scale);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"#DFDFDF"].CGColor);
    
    CGContextStrokePath(context);
};

+(instancetype)view{
    
    return [[self alloc] init];
}

- (void)config:(NSArray *)data{

    for (NSInteger index = 0; index < data.count; index ++) {
        UIButton * button = self.buttons[index];
        NSString * title = data[index];
        button.selected = index == 0;
        [button setTitle:title forState:UIControlStateNormal];
    }
}

@end

@interface PropertyRepairZoneView ()
@property (nonatomic ,strong) PropertyRepairZoneItemView * topItemView;
@property (nonatomic ,strong) PropertyRepairZoneItemView * bottomItemView;
@property (nonatomic ,strong) UILabel * typeLabel;
@property (nonatomic ,strong) LocalhostImageView * arrowImageView;

@end
@implementation PropertyRepairZoneView


-(void)getRepairType
{
    //repairTypeFirst 	是 	string 	一级报修类型（01：公共报修， 02：室内报修）
    [UserServices
     getRepairTypeWithRepairTypeFirst:self.repairTypeFirst
     completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            NSArray *data=responseObject[@"data"];
            NSMutableArray * buttons=[[NSMutableArray alloc]init];
            for (NSDictionary *dic in data) {
                [buttons addObject:dic[@"repairTypeSecondName"]];
            }
            
            DQAlertSheetController * actionSheet = [[DQAlertSheetController alloc] initWithTitle:nil message:nil buttons:buttons cancelButton:@"取消" afterDismiss:^(DQAlertSheetController * alertSheet ,NSInteger buttonIndex) {
                self.repairTypeSecond=buttons[buttonIndex];
                self.typeLabel.text=self.repairTypeSecond;
                
            } cancel:nil];
            
            [actionSheet showSheet:self.topViewController];
        }
        else
        {
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

-(void)getRepairTypeOne:(NSString*)typeFirst
{
    //repairTypeFirst 	是 	string 	一级报修类型（01：公共报修， 02：室内报修）
    [UserServices
     getRepairTypeWithRepairTypeFirst:typeFirst
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             NSArray *data=responseObject[@"data"];
             NSMutableArray * buttons=[[NSMutableArray alloc]init];
             for (NSDictionary *dic in data) {
                 [buttons addObject:dic[@"repairTypeSecondName"]];
             }
             self.repairTypeSecond=buttons[0];
             self.typeLabel.text=self.repairTypeSecond;
         }
         else
         {
             [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
         }
     }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.topItemView = [PropertyRepairZoneItemView view];
        [self.topItemView config:@[@"   住宅区域",@"    科研办公区域"]];
        [self addSubview:self.topItemView];
        [self.topItemView receiveObject:^(id object) {
            self.repairArea=object;

        }];
        
        self.bottomItemView = [PropertyRepairZoneItemView view];
        self.bottomItemView.displayTitleLabel.text=@"报修类型";
        [self.bottomItemView config:@[@"    公共报修",@"    室内报修"]];
        [self addSubview:self.bottomItemView];
        self.typeLabel = [UnityLHClass masonryLabel:@"" font:17 color:[UIColor blackColor]];
        self.typeLabel.textAlignment = NSTextAlignmentRight;
        self.typeLabel.userInteractionEnabled=YES;
        [self addSubview:self.typeLabel];
         [self getRepairTypeOne:@"01"];
        [self.bottomItemView receiveObject:^(id object) {
            self.repairTypeFirst=object;
            [self getRepairTypeOne:self.repairTypeFirst];
            //            self.repairTypeSecond=@"请选择";
            //            self.typeLabel.text=self.repairTypeSecond;
        }];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self.typeLabel addGestureRecognizer:tap];
        
        self.arrowImageView = [[LocalhostImageView alloc] init];
        self.arrowImageView.image = [UIImage imageNamed:@"right_arrow"];
        [self addSubview:self.arrowImageView];
        
        self.repairArea=@"01";
        self.repairTypeFirst=@"01";
        self.repairTypeSecond=nil;

    }
    return self;
}
-(void)tapAction
{
    [self getRepairType];
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    CGFloat height = CGRectGetHeight(self.bounds) / 5;
    [self.topItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(height * 2);
    }];
    
    [self.bottomItemView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.topItemView.mas_left);
        make.top.mas_equalTo(self.topItemView.mas_bottom);
        make.right.mas_equalTo(self.topItemView.mas_right);
        make.height.mas_equalTo(self.topItemView.mas_height);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.bottomItemView.mas_bottom);
        make.height.mas_equalTo(height);
        make.right.mas_equalTo(self.mas_right).mas_offset(-30);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.typeLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.right.mas_equalTo(self.mas_right).mas_offset(-10);
    }];
}

+ (instancetype)view{

    return [[self alloc] init];
}


@end

