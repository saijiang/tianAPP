//
//  GroupBuyPayReuseView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/2/13.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupBuyPayHeaderView : UITableViewHeaderFooterView

+ (NSString *) identifier;
@end

@interface GroupBuyPayFooterView : UITableViewHeaderFooterView

+ (NSString *) identifier;
- (void) price:(CGFloat)price;
@end
