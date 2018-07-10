//
//  ShoppingCarPopupContentView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/22.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "ShoppingCarPopupContentView.h"
#import "ShoppingCarCell.h"
#import "LKToolView.h"

@interface ShoppingCarPopupContentView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong) LKToolView * toolView;
@property (nonatomic ,strong) NSArray * goodsArray;
@property (nonatomic ,strong) UITableView * shoppingCarTableView;
@end

@implementation ShoppingCarPopupContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        LKWeakSelf
        self.toolView = [[LKToolView alloc] init];
        self.toolView.titleLabel.text = @"购物车";
        self.toolView.bSureHandle = ^(){
            LKStrongSelf
            [_self sureButtonHandle];
        };
        self.toolView.bCancelHandle = ^(){
            LKStrongSelf
            [_self cancelButtonHandle];
        };
        [self addSubview:self.toolView];
        
        self.shoppingCarTableView = [[UITableView alloc] init];
        self.shoppingCarTableView.dataSource = self;
        self.shoppingCarTableView.delegate = self;
        self.shoppingCarTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UIView * footerView = [[UIView alloc] init];
        footerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, 0.1);
        footerView.backgroundColor = [UIColor clearColor];
        self.shoppingCarTableView.tableFooterView = footerView;
        
        self.shoppingCarTableView.tableHeaderView = [UIView new];
        
        self.shoppingCarTableView.backgroundColor = [UIColor whiteColor];
        [self.shoppingCarTableView registerClass:[ShoppingCarCell class]
                          forCellReuseIdentifier:[ShoppingCarCell cellIdentifier]];
        [self addSubview:self.shoppingCarTableView];
        
    }
    return self;
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(50);
    }];
    
    [self.shoppingCarTableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(UIEdgeInsetsMake(50, 0, 0, 0));
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shoppingCarManager.goods.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ShoppingCarCell cellHeight];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return .1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingCarCell * cell = [tableView dequeueReusableCellWithIdentifier:[ShoppingCarCell cellIdentifier] forIndexPath:indexPath];

    LKGoodsItem * item = self.shoppingCarManager.goods[indexPath.row];
    
    [cell configCellWithData:item];
    LKWeakSelf
    cell.bCountChangeHandle = ^(BOOL add){
        LKStrongSelf
        if (add) {
            [_self.shoppingCarManager addCountForGoods:item.goodsInfo];
        }else{
            [_self.shoppingCarManager minusCountForGoods:item.goodsInfo];
        }
        [_self.shoppingCarTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
        if (self.bSureHandle) {
            self.bSureHandle(@"change");
        }

    };
    cell.bDeleteHandle = ^(){
        LKStrongSelf
        [_self.shoppingCarManager deleteGoods:item.goodsInfo complete:nil];
        [_self.shoppingCarTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        if (self.bSureHandle) {
            self.bSureHandle(@"delete");
        }

    };

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return;
    }
    //
}

#pragma mark -
#pragma mark Action M

- (void) cancelButtonHandle{
    
    [self sureButtonHandle];
}

- (void) sureButtonHandle{
    [self sendObject:@"sure"];
    if (self.bSureHandle) {
        self.bSureHandle(@"sure");
    }
    
    [self closePopup];
}

#pragma mark -
#pragma mark PopupContentViewDelegate

- (CGRect)showRect{
    
    CGFloat height = 0.0f;
    height += 50;
    height += 216;
    
    return CGRectMake(0, (DEF_SCREEN_HEIGHT - height) - 60, DEF_SCREEN_WIDTH, height);
}
// 点击空白区域
- (void)onTouchBlank
{
    [self sureButtonHandle];
}
-(BOOL)isAlert
{
    return YES;
}
@end
