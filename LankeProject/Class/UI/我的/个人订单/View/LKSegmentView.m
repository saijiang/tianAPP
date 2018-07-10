//
//  LKSegmentView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "LKSegmentView.h"

#define kSegmentItemScale 0.45


@implementation LKSegmentItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

@end

@interface LKSegmentView ()

@property (readwrite) NSMutableArray * segmentItems;
@end
@implementation LKSegmentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _segmentItems = [NSMutableArray array];
    }
    return self;
}


- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.segmentItems enumerateObjectsUsingBlock:^(LKSegmentItem * segmentItem, NSUInteger index, BOOL * _Nonnull stop) {
       
        CGFloat width = CGRectGetWidth(self.bounds) / self.segmentItems.count;
        
        [segmentItem mas_makeConstraints:^(MASConstraintMaker *make){
            make.height.mas_equalTo(self.mas_height);
            make.width.mas_equalTo(width);
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(index * width);
        }];
    }];
}

- (void) defaultSelectedFirstItem{

    [self performSelector:@selector(segmentItemSelectedHandle:)
               withObject:self.segmentItems[0]
               afterDelay:0];
}

- (void) configSegmentViewWithItems:(NSArray <NSString *>*)items{

    if (items && items.count) {
        
        for (NSString * item in items) {
            
            LKSegmentItem * segmentItem = [[LKSegmentItem alloc] init];
            [segmentItem setTitle:item forState:UIControlStateNormal];
            [segmentItem setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
            [segmentItem setTitle:item forState:UIControlStateSelected];
            [segmentItem setTitleColor:self.selectColor forState:UIControlStateSelected];
            
            [segmentItem setImage:self.normalImage forState:UIControlStateNormal];
            [segmentItem setImage:self.selectImage forState:UIControlStateSelected];
            
            CGFloat imageWidth = segmentItem.imageView.image.size.width+1;
            CGFloat labelWidth = [segmentItem.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:segmentItem.titleLabel.font}].width+1;
            segmentItem.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageWidth, 0.0, imageWidth);
            segmentItem.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
            
            [segmentItem addTarget:self action:@selector(segmentItemSelectedHandle:) forControlEvents:UIControlEventTouchUpInside];
            [segmentItem setNeedsLayout];
            [self addSubview:segmentItem];

            [self.segmentItems addObject:segmentItem];
        }
        [self setNeedsDisplay];
    }
}

- (void) updateSegmentViewWithItems:(NSArray <NSString *>*)items{

    for (NSInteger index = 0; index < items.count; index ++) {
        
        NSString * item = items[index];

        LKSegmentItem * segmentItem = self.segmentItems[index];
        [segmentItem setTitle:item forState:UIControlStateNormal];
        [segmentItem setTitle:item forState:UIControlStateSelected];

        CGFloat imageWidth = segmentItem.imageView.image.size.width+1;
        CGFloat labelWidth = [item sizeWithAttributes:@{NSFontAttributeName:segmentItem.titleLabel.font}].width+1;
        segmentItem.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageWidth, 0.0, imageWidth);
        segmentItem.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth, 0, -labelWidth);
        [segmentItem setNeedsLayout];
    }
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark Action M

- (void) segmentItemSelectedHandle:(LKSegmentItem *)segmentItem{
    
    NSInteger selectedIndex = 0;
    for (NSInteger index = 0; index < self.segmentItems.count; index ++) {
        
        LKSegmentItem * _segmentItem = self.segmentItems[index];
        
        if (segmentItem == _segmentItem) {
            _segmentItem.selected = YES;
            selectedIndex = index;
        }else{
            _segmentItem.selected = NO;
        }
    }
    if (self.bSegmentViewDidSelectedItem) {
        self.bSegmentViewDidSelectedItem(selectedIndex);
    }
}
@end
