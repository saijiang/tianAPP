//
//  GroupBuyDeliverTypeView.m
//  LankeProject
//
//  Created by Rocky Young on 2017/2/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "GroupBuyDeliverTypeView.h"

@interface GroupBuyDeliverTypeView ()<UITableViewDataSource,UITableViewDelegate>

@property (readwrite) GroupBuyDeliverTypeItem * typeItem;

@property (nonatomic ,strong) UITableView * typeTableView;

@property (nonatomic ,strong) NSArray * typeOptionals;

@property (nonatomic ,strong) id addressData;

@property (nonatomic ,assign) BOOL finishPickAddress;
@end

@implementation GroupBuyDeliverTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.type = 0;
        
        self.backgroundColor = [UIColor whiteColor];
        
        _typeTableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];
        _typeTableView.dataSource = self;
        _typeTableView.delegate = self;
        _typeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_typeTableView registerClass:[GroupBuyDeliverTypeHeaderView class]
   forHeaderFooterViewReuseIdentifier:[GroupBuyDeliverTypeHeaderView identifier]];
        [_typeTableView registerClass:[GroupBuyDeliverTypeFooterView class]
   forHeaderFooterViewReuseIdentifier:[GroupBuyDeliverTypeFooterView identifier]];
        [_typeTableView registerClass:[GroupBuyDeliverTypeCell class] forCellReuseIdentifier:[GroupBuyDeliverTypeCell cellIdentifier]];
        [self addSubview:_typeTableView];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    [self.typeTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.typeOptionals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    GroupBuyDeliverTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:[GroupBuyDeliverTypeCell cellIdentifier] forIndexPath:indexPath];
    cell.lineView.hidden = YES;
    
    NSLog(@"%@",self.typeOptionals[indexPath.row]);
    
    [cell configCellWithData:self.typeOptionals[indexPath.row]];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [GroupBuyDeliverTypeCell configCellHeightWithData:self.typeOptionals[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.type = indexPath.row;
    self.typeItem = self.typeOptionals[indexPath.row];
    
    NSInteger index = 0;
    for (GroupBuyDeliverTypeItem * item in self.typeOptionals) {
        
        item.select = index == indexPath.row;
        
        index ++;
    }
    [self.typeTableView reloadData];
    
    if (self.bChooseTypeHandle) {
        
        self.bChooseTypeHandle(self.typeItem);
        
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 45.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 60.0f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    GroupBuyDeliverTypeHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[GroupBuyDeliverTypeHeaderView identifier]];
    
    return headerView;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    GroupBuyDeliverTypeFooterView * footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[GroupBuyDeliverTypeFooterView identifier]];
    
    [footerView config:self.addressData];
    
    footerView.bChooseAddressHandle = ^(){
        if (self.bOrderDeliveryTypeChooseAddressHandle) {
            self.bOrderDeliveryTypeChooseAddressHandle();
        }
    };

    return footerView;
}

#pragma mark -
#pragma mark API

- (void)updateAddress{
    
//    self.finishPickAddress = YES;
    
    [self requestDefaultAddress];
}

-(void) configDeliveyTypeForGroupBuyWithData:(id)data changeHeight:(void(^)(CGFloat))handle{
    
    NSArray * temp = @[@([data[@"selfDeliveryFlg"] boolValue]),
                       @([data[@"merchantDeliveryFlg"] boolValue]),
                       @([data[@"expressDeliveryFlg"] boolValue])];
    NSMutableArray * typeOptional = [NSMutableArray array];
    
    for (NSInteger index = 0; index < temp.count; index ++) {
        NSInteger num=0;
        if ([temp[0] intValue]==1) {
            num=0;
        }else if ([temp[1] intValue]==1){
             num=1;
        }else if ([temp[2] intValue]==1){
             num=2;
        }
            
        BOOL has = [temp[index] boolValue];
        if (has) {
            
            GroupBuyDeliverTypeItem * item = [[GroupBuyDeliverTypeItem alloc] initWithData:nil];
            
            item.select = index==num;
            item.price = index == 0 ? 0.0f : (index == 1 ? [data[@"merchantDeliveryFee"] floatValue] : [data[@"expressDeliveryFee"] floatValue]);
            item.flag = index == 0 ? @"01" :(index == 1 ? @"02" : @"03");
            item.title = index == 0 ? @"自提" :(index == 1 ? @"商家配送":@"快递配送");
            item.display = index == 0 ? data[@"ownDeliveryAddress"] :(index == 1 ? [NSString stringWithFormat:@"配送费%@元",data[@"merchantDeliveryFee"]] : [NSString stringWithFormat:@"快递费%@元",data[@"expressDeliveryFee"]]);
            [typeOptional addObject:item];
        }
    }
    self.typeOptionals = typeOptional;
    self.typeItem = typeOptional[0];
    
    [self.typeTableView reloadData];
    
    if (handle) {
        handle(98 + typeOptional.count * 45);
    }
    
    [self requestDefaultAddress];
}

- (void) requestDefaultAddress{
    
    if (self.finishPickAddress) {
        return;
    }
    [UserServices getDefaultAddressListWithuserId:[KeychainManager readUserId] restaurantId:nil completionBlock:^(int result, id responseObject) {
        
        if (result == 0) {
            id data = responseObject[@"data"];
            [self updateAddressInfoWithData:data];
        }else{
            // error handle here
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
        }
    }];
}

- (void) updateAddressInfoWithData:(id)data{
    
    self.finishPickAddress = YES;
    self.addressData = data;
    self.addressId = data[@"id"];
    
    [self.typeTableView reloadData];
}

@end


@implementation GroupBuyDeliverTypeItem

- (instancetype)initWithData:(id)data
{
    self = [super init];
    if (self) {
        self.select = NO;
    }
    return self;
}
@end


@implementation GroupBuyDeliverTypeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.selectImageView.image = [UIImage imageNamed:@"circle_choose_off"];
        self.selectImageView.highlightedImage = [UIImage imageNamed:@"circle_choose_on"];
        [self.contentView addSubview:self.selectImageView];
        
        self.typeLabel = [UnityLHClass masonryLabel:@"自提" font:15 color:BM_Color_BlackColor];
        self.typeLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.typeLabel];
        
        self.contentLabel = [UnityLHClass masonryLabel:@"上海市虹口区广济路838号" font:15 color:BM_BLACK];
        self.contentLabel.numberOfLines=0;
        [self addSubview:self.contentLabel];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = BM_Color_SeparatorColor;
        self.lineView.hidden = YES;
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(40);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.typeLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.mas_equalTo(10);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.typeLabel.mas_top);
        make.left.mas_equalTo(self.typeLabel.mas_right).offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
        make.bottom.mas_equalTo(self.typeLabel.mas_bottom);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-10);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark -
#pragma mark LKCellProtocol

- (void)configCellWithData:(GroupBuyDeliverTypeItem *)data{
   
        self.typeLabel.text = data.title;
        self.contentLabel.text = data.display;
        self.selectImageView.highlighted = data.select;
    
 
}
+ (CGFloat)configCellHeightWithData:(GroupBuyDeliverTypeItem *)data{
    
    CGFloat height=[UnityLHClass getHeight:data.display wid:DEF_SCREEN_WIDTH-120 font:15]+20;
    
    return height;
    
    
}
+ (NSString *)cellIdentifier{

    return @"typecell";
}

@end

@implementation GroupBuyDeliverTypeHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        
        self.displayLabel = [UnityLHClass masonryLabel:@"送货方式" font:16 color:BM_BLACK];
        [self.contentView addSubview:self.displayLabel];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = BM_Color_SeparatorColor;
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(15);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
}

+ (NSString *) identifier{
    
    return @"GroupBuyDeliverTypeHeaderView";
}


@end

@implementation GroupBuyDeliverTypeFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        
        _pickAddressNameLabel = [UnityLHClass masonryLabel:@"何方" font:13 color:BM_BLACK];
        [self.contentView addSubview:_pickAddressNameLabel];
        
        _pickAddressPhoneNumberLabel = [UnityLHClass masonryLabel:@"158686958578" font:13 color:BM_BLACK];
        [self.contentView addSubview:_pickAddressPhoneNumberLabel];
        
        _pickAddressLabel = [UnityLHClass masonryLabel:@"上海市宝山区人民路78号" font:13 color:BM_BLACK];
        _pickAddressLabel.numberOfLines = 0;

        [self.contentView addSubview:_pickAddressLabel];
        
        _defaultPickAddressLabel = [UnityLHClass masonryLabel:@"没有默认收货地址，点击添加一个" font:13 color:[UIColor colorWithHexString:@"999999"]];
        _defaultPickAddressLabel.backgroundColor = [UIColor whiteColor];
//        _defaultPickAddressLabel.userInteractionEnabled = YES;
        [self.contentView addSubview:_defaultPickAddressLabel];
        _defaultPickAddressLabel.hidden = YES;
        
        _arrowImageView = [[LocalhostImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"right_arrow"];
        [self.contentView addSubview:_arrowImageView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
 
    [self.pickAddressNameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(40);
    }];
    
    [self.pickAddressPhoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.pickAddressNameLabel.mas_top);
        make.left.mas_equalTo(self.pickAddressNameLabel.mas_right).mas_offset(20);
    }];
    
    [self.pickAddressLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(self.pickAddressNameLabel.mas_left);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-10);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-40);
    }];
    [self.defaultPickAddressLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.pickAddressNameLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-20);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_equalTo(self.defaultPickAddressLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.right.mas_equalTo(self.defaultPickAddressLabel.mas_right);
    }];
}

- (void) tapHandle:(UITapGestureRecognizer *)tap{
    
    if (self.bChooseAddressHandle) {
        self.bChooseAddressHandle();
    }
}

- (void)config:(id)data{

    self.pickAddressNameLabel.text = [NSString stringWithFormat:@"%@",data[@"receiveName"]];
    self.pickAddressPhoneNumberLabel.text = [NSString stringWithFormat:@"%@",data[@"receivePhone"]];
    //self.pickAddressLabel.text = [NSString stringWithFormat:@"%@ %@",data[@"areaInfo"],data[@"detailedAddress"]];
     self.pickAddressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@%@",data[@"province"],data[@"city"],data[@"county"],data[@"areaInfo"],data[@"detailedAddress"]];
    self.defaultPickAddressLabel.hidden = data[@"id"];
}

+ (NSString *) identifier{
    
    return @"GroupBuyDeliverTypeFooterView";
}


@end
