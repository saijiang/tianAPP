//
//  JDFilterCell.m
//  LankeProject
//
//  Created by zhounan on 2017/12/21.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "JDFilterCell.h"

#import "SideChooseManager.h"

@interface JDFilterCell ()

@property (nonatomic ,strong) UILabel * itemLabel;

@end

@implementation JDFilterCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        
        self.backgroundColor = [UIColor clearColor];
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#Ffffff"];
        self.contentView.layer.borderColor = BM_Color_SeparatorColor.CGColor;
        self.contentView.layer.borderWidth = 1/[UIScreen mainScreen].scale;
        self.contentView.layer.cornerRadius = 5.0f;
        self.contentView.layer.masksToBounds = YES;
        
        if (!_itemLabel) {
            _itemLabel = [UnityLHClass masonryLabel:@"CCCC" font:14 color:[UIColor colorWithHexString:@"#666666"]];
            _itemLabel.textAlignment = NSTextAlignmentCenter;
            _itemLabel.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_itemLabel];
            [_itemLabel mas_makeConstraints:^(MASConstraintMaker *make){
                make.edges.mas_equalTo(UIEdgeInsetsMake(0, 5, 0, 5));
            }];
        }
    }
    return self;
}

#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *) cellIdentifier{
    
    return NSStringFromClass([self class]);
}

- (void) configCellWithData:(ChooseItem *)data{
    
    self.itemLabel.text = [NSString stringWithFormat:@"%@",data.item[@"name"]];
    if (data.isSelected) {
        self.contentView.layer.borderColor = BM_Color_Blue.CGColor;
        self.itemLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        self.contentView.backgroundColor = BM_Color_Blue;
    }else{
        self.contentView.layer.borderColor = BM_Color_SeparatorColor.CGColor;
        self.itemLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    }
}
@end
