//
//  AllFunctionReusableView.h
//  LankeProject
//
//  Created by Rocky Young on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllFunctionHeaderView : UICollectionReusableView

- (void) configureHeaderViewWithData:(id)data;
+ (NSString *) reuseIdentifier;
@end

@interface AllFunctionFooterView : UICollectionReusableView

+ (NSString *) reuseIdentifier;
@end
