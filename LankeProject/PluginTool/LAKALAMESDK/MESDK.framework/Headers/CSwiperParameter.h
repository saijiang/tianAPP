     //
//  CSwiperParameter.h
//  LakalaCore
//
//  Created by Michael Ge on 14-7-23.
//
//

#ifndef LakalaCore_CSwiperParameter_h
#define LakalaCore_CSwiperParameter_h

/*!
 @enum
 @abstract 刷卡驱动的内部运行状态
 @constant CSwiperReadModelMagneticCard 磁条卡读卡模式
 @constant CSwiperReadModelICCard IC卡读卡模式
 */
typedef enum {
    CSwiperReadModelMagneticCard = 0x01,
    CSwiperReadModelICCard = 0x02
} CSwiperReadModel;

@interface CSwiperParameter : NSObject
{
    NSDate *_time;
}
//读卡模式
@property (nonatomic, assign) CSwiperReadModel readModel;
//配合 setStartParameter 方法使用，该属性相当于 data 参数。
@property (nonatomic, strong) id content;
//定义IC卡 98583 交易类型（参考银联规范，例：余额查询为 0x31）
@property (nonatomic) int tradeType98583;
//定义内部自定义交易码（参考新大陆MPOS规范，例：标准pboc流程为 0x01)
@property (nonatomic) int tradeTypeCUS;
//是否强制联机交易
@property (nonatomic) BOOL forceOnline;
//判断当前参数组合是否为IC卡启动参数
@property (nonatomic, readonly) BOOL isEmvParam;
/**
 *  静态构造方法
 *
 *  @param content 配合 setStartParameter 方法使用，该属性相当于 data 参数。
 *
 *  @return 实例
 */
+ (id)parameterWithContent:(id)content;

/**
 *  静态构造方法，用些方法创建时 readModel 参数值等于 CSwiperReadModelMagneticCard
 *
 *  @param content 配合 setStartParameter 方法使用，该属性相当于 data 参数。
 *
 *  @return 实例
 */
+ (id)magneticCardParameterWitContent:(id)content;

/**
 *  设置关键启动参数
 *
 *  @param tradeType98583   定义IC卡 98583 交易类型（参考银联规范，例：余额查询为 0x31）
 *  @param tradeTypeCUS     定义内部自定义交易码（参考新大陆MPOS规范，例：标准pboc流程为 0x01)
 *  @param forceOnline      是否强制联机交易
 */
- (void)setEmvParamsWithTradeType98583:(int)tradeType98583
                          tradeTypeCUS:(int)tradeTypeCUS
                           forceOnline:(BOOL)forceOnline;
@end

#endif
