//
//  HeadlthInqurylCell.m
//  LankeProject
//
//  Created by Justin on 2016/12/15.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "HeadlthInqurylCell.h"

@interface HeadlthInqurylCell ()


@end
@implementation HeadlthInqurylCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = BM_WHITE;
        
        self.BigTitle = [UnityLHClass masonryLabel:@"**" font:16.0 color:[UIColor colorWithRed:0.03 green:0.03 blue:0.03 alpha:1]];
        [self.contentView addSubview:self.BigTitle];
        
        self.timeLB = [UnityLHClass masonryLabel:@"****-**-**" font:13.0 color:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]];
        [self.contentView addSubview:self.timeLB];
        
        self.detailLB = [UnityLHClass masonryLabel:@"******" font:15.0 color:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1]];
        self.detailLB.numberOfLines = 0;
        //self.detailLB.lineBreakMode = 0;
        [self.contentView addSubview:self.detailLB];
        
        self.headImage = [[UIImageView alloc] init];
        self.headImage.clipsToBounds = YES;
        self.headImage.contentMode = UIViewContentModeScaleAspectFill;
        self.headImage.image = [UIImage imageNamed:@"Health-headImage"];
        [self.contentView addSubview:self.headImage];
        
        self.imageIcon = [[UIImageView alloc] init];
        self.imageIcon.image = [UIImage imageNamed:@"Health-videoicon"];
       [self.headImage addSubview:self.imageIcon];
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    [self.BigTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(10);
        make.height.mas_equalTo(20);
        make.right.offset(-10);
    }];
    
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.mas_equalTo(self.BigTitle.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
        make.right.offset(-10);
    }];
    
    
    [self.detailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.mas_equalTo(self.timeLB.mas_bottom).mas_offset(5);
        make.right.offset(-15);
        //make.height.offset(60);
    }];
    
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.BigTitle.mas_left);
        make.top.mas_equalTo(self.detailLB.mas_bottom).offset(10);
        make.right.offset(-15);
        make.height.offset(140);
    }];
    
    [self.imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.headImage.mas_centerX);
        make.centerY.mas_equalTo(self.headImage.mas_centerY);
        make.width.and.height.offset(30);
    }];
}
-(void)loadCellWithDataSource:(id)dataSource
{
    id data=dataSource;
    NSString *type=data[@"teachingType"];
    self.BigTitle.text = [NSString stringWithFormat:@"%@",data[@"title"]];
    self.timeLB.text = [[NSString stringWithFormat:@"%@",data[@"createDate"]] stringformatterDate:@"YYYY-MM-dd"];
    self.detailLB.text = [NSString stringWithFormat:@"%@",data[@"underdraw"]];
    NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",data[@"healthImageList"]]];
    [self.headImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"Health-headImage"]];
    if ([type isEqualToString:@"01"]) {
        
   
        self.imageIcon.hidden =NO ;
    }else{
        
        
        self.imageIcon.hidden = YES;
    }
//    if ([type isEqualToString:@"01"]) {
//        
//        AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL URLWithString:data[@"videoFile"]]];
//        [self thumbnailImageForVideo:asset atTime:1];
//        self.imageIcon.hidden =NO ;
//    }else{
//        
//        NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",data[@"healthImageList"]]];
//        [self.headImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"Health-headImage"]];
//        self.imageIcon.hidden = YES;
//    }
    
    
}

#pragma mark -
#pragma mark LKCellProtocol

- (void)configCellWithData:(id)data{

    self.BigTitle.text = [NSString stringWithFormat:@"%@",data[@"title"]];
    self.timeLB.text = [[NSString stringWithFormat:@"%@",data[@"createDate"]] stringformatterDate:@"YYYY-MM-dd"];
    self.detailLB.text = [NSString stringWithFormat:@"%@",data[@"underdraw"]];
    
    NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",data[@"healthImageList"]]];
    [self.headImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"Health-headImage"]];
    
//    if (![data[@"type"] isEqualToString:@"01"]) {
//        
//        AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL URLWithString:data[@"videoFile"]]];
//        
//        [self thumbnailImageForVideo:asset atTime:1];
//    }else{
//    
//        NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",data[@"healthImageList"]]];
//        [self.headImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"Health-headImage"]];
//    }
    
    self.imageIcon.hidden = [data[@"type"] isEqualToString:@"01"];
}

+ (CGFloat)cellHeightWithData:(id)data{

    CGFloat rowHeight = 0.0f;
    CGFloat height = [UnityLHClass getHeight:data[@"underdraw"] wid:DEF_SCREEN_WIDTH - 30 font:15.0];
    
    rowHeight += 10;
    rowHeight += 20;
    rowHeight += 5;
    rowHeight += 20;
    rowHeight += 5;
    rowHeight += height;
    rowHeight += 10;
    rowHeight += 140;
    rowHeight += 10;
    
    return rowHeight;
}
+ (NSString *) cellIdentifier{
    
    return @"HeadlthInqurylCell";
}

- (void) thumbnailImageForVideo:(AVURLAsset *)asset atTime:(NSTimeInterval)time {
    
    NSParameterAssert(asset);
    
    dispatch_queue_t getThumbnailQueue = dispatch_queue_create("com.ht.fetchfeed.fetchfeed", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(getThumbnailQueue, ^{
        
        AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
        assetImageGenerator.appliesPreferredTrackTransform = YES;
        assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
        
        CGImageRef thumbnailImageRef = NULL;
        CFTimeInterval thumbnailImageTime = time;
        NSError *thumbnailImageGenerationError = nil;
        thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
        
        if(!thumbnailImageRef)
            NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
        
        UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            self.displayImageView.image = thumbnailImage;
            [self.headImage sd_setImageWithURL:nil placeholderImage:thumbnailImage];
        });
    });
}
@end
