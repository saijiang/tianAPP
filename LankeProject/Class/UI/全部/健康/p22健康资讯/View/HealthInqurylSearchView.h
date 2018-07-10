//
//  HealthInqurylSearchView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/16.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HealthSearchBar;
@interface HealthInqurylSearchView : UIView<UISearchBarDelegate>

@property (nonatomic ,strong) HealthSearchBar * searchBar;

@property (nonatomic ,copy) void (^bSearchBarSearchButtonDidClicked)(NSString *content);

- (void) autoResignFirstResponder;
@end


@interface HealthSearchBar : UISearchBar


@end
