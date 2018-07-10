//
//  HealthInqurylSearchView.m
//  LankeProject
//
//  Created by Rocky Young on 2016/12/16.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "HealthInqurylSearchView.h"

@implementation HealthInqurylSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _searchBar = [[HealthSearchBar alloc] init];
        _searchBar.placeholder = @"输入关键词进行搜索";
        UIImage * searchImage = [UIImage imageNamed:@"search_icon"];
        [_searchBar setImage:searchImage
            forSearchBarIcon:UISearchBarIconSearch
                       state:UIControlStateNormal];
        _searchBar.layer.masksToBounds = YES;
        _searchBar.backgroundImage = [UIImage imageWithColorHexString:@"#DCDCDC"];
        _searchBar.tintColor = [UIColor whiteColor];
        _searchBar.translucent = NO;
        _searchBar.delegate = self;
        [self addSubview:_searchBar];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    CGFloat margin_v = 10.0f;
    _searchBar.layer.cornerRadius = (height - 2 * margin_v) / 2;
    CGFloat margin_h = width * 0.18;
    
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(margin_v);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-margin_v);
        make.left.mas_equalTo(margin_h);
        make.right.mas_equalTo(self.mas_right).mas_offset(-margin_h);
    }];
}

- (void) autoResignFirstResponder{

    [self.searchBar resignFirstResponder];
}
#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if (self.bSearchBarSearchButtonDidClicked) {
        self.bSearchBarSearchButtonDidClicked(searchBar.text);
    }
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    self.searchBar.text = nil;
    [searchBar resignFirstResponder];
}


@end

@implementation HealthSearchBar

- (void)drawRect:(CGRect)rect{

    [super drawRect:rect];
    
    UITextField * searchContentTextField = [self searchFieldInSubviews];
    
    searchContentTextField.textColor = [UIColor whiteColor];
    
    NSAttributedString * attPlaceholder = [[NSAttributedString alloc] initWithString:searchContentTextField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    searchContentTextField.attributedPlaceholder = attPlaceholder;
    
    searchContentTextField.backgroundColor = [UIColor clearColor];
}

- (UITextField *) searchFieldInSubviews{
    
    UIView * searchBarView = self.subviews[0];
    
    return searchBarView.subviews[[self indexOfSearchFieldInSubviews]];
}

- (NSInteger) indexOfSearchFieldInSubviews{
    
    NSInteger index = 0;
    UIView * searchBarView = self.subviews[0];
    
    for (NSInteger i=0; i< searchBarView.subviews.count; ++i) {
        
        if ([searchBarView.subviews[i] isKindOfClass: [UITextField class]]) {
            index = i;
            break;
        }
    }
    return index;
}

@end
