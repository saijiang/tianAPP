//
//  MallShopInfoDetailCCell.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/6.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "BaseCollectionCell.h"
#import "LKCellProtocol.h"

@interface MallShopInfoDetailContent : NSObject

@property (nonatomic ,strong) id data;// 富文本内容
@property (nonatomic ,assign) CGFloat contentHeight;

@end

@interface MallShopInfoDetailCCell : BaseCollectionCell<LKCellProtocol>

@property (nonatomic ,strong) UILabel * displayLabel;
@property (nonatomic ,strong) UIWebView * conentWebView;

@property (nonatomic ,strong) MallShopInfoDetailContent * content;

@property (nonatomic ,strong) id dataSource;

@property (nonatomic ,copy) void (^bCellHeightChangedBlock)();
@property (nonatomic, copy) void (^bLoadRequestBlock)(NSURLRequest *curRequest);

- (void) configCellForShopDetail:(id)data;;

//获取高度
+ (float)getCellHeightWithData:(id)data;

@end
