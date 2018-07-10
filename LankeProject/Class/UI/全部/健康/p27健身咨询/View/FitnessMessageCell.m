//
//  FitnessMessageCell.m
//  LankeProject
//
//  Created by Rocky Young on 2017/3/16.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "FitnessMessageCell.h"
#import "FitnessMessage.h"
#import "UIImage+MHImageWithColor.h"

@interface FitnessMessageCell ()

@property (nonatomic ,strong) FitnessMessage * message;

@end
@implementation FitnessMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.iconImageView = [[LKNetworkImageView alloc] init];
        self.iconImageView.placeholderImage = [UIImage imageNamed:@"detault_user_icon"];
        self.iconImageView.layer.cornerRadius = 25.0f;
        self.iconImageView.clipsToBounds = YES;
        [self.contentView addSubview:self.iconImageView];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = [UIColor colorWithHexString:@"454545"];
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.nameLabel];
        
        self.messageContentView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.messageContentView];
        
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.messageContentView addSubview:self.messageLabel];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    // 首先计算文本宽度和高度
    CGRect rec = [self.message.message boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil];
    UIImage *image = nil;
    
    // 模拟左边
    if (self.message.isRobot)
    {
        // 当输入只有一个行的时候高度就是20多一点
        self.iconImageView.frame = CGRectMake(10, 0, 50, 50);
        self.messageContentView.frame = CGRectMake(60, 25, rec.size.width + 20, rec.size.height + 20);
        image = [UIImage imageNamed:@"robot_bubble"];
    }
    else // 模拟右边
    {
        self.iconImageView.frame = CGRectMake(width - 60, 0, 50, 50);
        self.messageContentView.frame = CGRectMake(width - 60 - rec.size.width - 20, 25, rec.size.width + 20, rec.size.height + 20);
        image = [UIImage imageNamed:@"user_bubble"];
    }
    // 拉伸图片 参数1 代表从左侧到指定像素禁止拉伸，该像素之后拉伸，参数2 代表从上面到指定像素禁止拉伸，该像素以下就拉伸
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    self.messageContentView.image = image;
    // 文本内容的frame
    self.messageLabel.frame = CGRectMake(self.message.isRobot ? 13 : 8, 10, rec.size.width, rec.size.height);
    self.nameLabel.frame = CGRectMake(self.message.isRobot ? 60:width - 100 - 50 - 10, 0, 100, 15);
    self.nameLabel.textAlignment = self.message.isRobot ? NSTextAlignmentLeft: NSTextAlignmentRight;
}

#pragma mark -
#pragma mark LKCellProtocol

+ (NSString *)cellIdentifier{
 
    return NSStringFromClass([self class]);
}

- (void)configCellWithData:(FitnessMessage *)message{

    self.message = message;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:message.iconImage] placeholderImage:[UIImage imageNamed:@"detault_user_icon"]];
    self.nameLabel.text = message.name;
    self.messageLabel.text = message.message;
}

+ (CGFloat)cellHeightWithData:(FitnessMessage *)message{

    
    CGRect rec =  [message.message boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil];
    return rec.size.height + 50;
}
@end
