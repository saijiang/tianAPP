//
//  HealthExamSectionHeaderReView.h
//  LankeProject
//
//  Created by Rocky Young on 2017/1/4.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthExamSectionHeaderReView : UICollectionReusableView

- (void) config:(id)data;
- (void) configForTCM:(NSString *)name;

+ (NSString *) reuseIdentifier;

+ (CGSize) headerReferenceSizeForTCM:(NSString *)name;
+ (CGSize) headerReferenceSizeWithData:(id)data;

@end

@interface HealthExamSectionFooterReView : UICollectionReusableView

+ (NSString *) reuseIdentifier;
@end
