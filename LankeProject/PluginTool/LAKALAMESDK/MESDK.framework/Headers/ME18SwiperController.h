//
//  ME18SwiperController.h
//  MTypeSDK
//
//  Created by wanglx on 15/4/17.
//  Copyright (c) 2015年 suzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MESwiperController.h"

/*!
 @class ME18SwiperController
 @abstract ME18SwiperController是MSR刷卡驱动的核心类。
 */
@interface ME18SwiperController : NSObject<CSwiperControllerBluetoothOperator, CSwiperControllerEmvOperator, CSwiperControllerQPCardOperator, CSwiperICCardOperator,CSwiperControllerEmvLevel2Operator> {
}
/*!
 @property delegate
 @abstract 要从MSR MESwiperController中获取通知信息如插入设备提示、卡信息回馈，需赋值delegate，实现CSwiperControllerDelegate的方法。
 */
@property (nonatomic, assign) NSObject<CSwiperControllerDelegate> *delegate;
/*!
 @property detectDeviceChange
 @abstract 设置是否响应onDevicePlugged和onDeviceUnPlugged事件
 */
@property (nonatomic, assign)BOOL detectDeviceChange;
/*!
 @property swipeTimeout
 @abstract 设置刷卡超时时间。单位为秒。
 */
@property (nonatomic, assign) double swipeTimeout;
/*!
 @property connectParams
 @abstract 设置连接参数。蓝牙为uuid。
 */
@property (nonatomic, strong) CSwiperConnectParams *connectParams;
/*!
 @method
 @abstract 获取实例对象
 @discussion 不要自己实例化该驱动对象，直接从这个方法获取实例对象。该实例对象是线程安全的。
 @result 返回实例对象
 */
+ (id)sharedInstance;
/*!
 @method
 @abstract 判断当前是否有设备
 @discussion 如果未插上设备或设备未插好，将返回NO，否则返回YES。只有YES的时候，程序才能进入正常刷卡流程。
 @result 是否检测到设备
 */
- (BOOL)isDevicePresent;
/*!
 @method
 @abstract 启动刷卡程序
 @discussion 启动刷卡程序，将进入刷卡流程如判断设备是否插上，启动是否成功等。
 */
- (void)startCSwiper;

/*!
 @method
 @abstract 停止刷卡程序
 @discussion 停止刷卡程序，使之暂停刷卡服务。
 */
- (void)stopCSwiper;

/*!
 @method
 @abstract 卸载刷卡驱动
 @discussion 卸载刷卡驱动，使之停止并移除刷卡服务。
 */
- (void)deleteCSwiper;

/*!
 @method
 @abstract 获取运行状态
 @discussion 获取当前刷卡程序内部运行状态。状态值范围定义在CSwiperControllerState枚举类型中。
 @result 运行状态
 */
- (CSwiperControllerState)getCSwiperState;

/*!
 @method
 @abstract 获得刷卡器系列号
 @discussion 刷卡器KSN中的左边14位BCD码，可以判断刷卡器是否合法设备
 刷卡器KeySet（4位BCD）＋10位系列号BCD码，共14个字符
 */
- (void)getCSwiperKsn;
/*!
 @method
 @abstract 获得当次刷卡扩展数据
 @discussion onDecodeCompleted方法回调期间调用有效，对应该次刷卡的扩展数据。不包含磁道等数据信息。onDecodeCompleted回调结束会被清掉，再次调用无效。外面如果要在其他地方使用，必须被copy或retain
 // @param isClean 是否调用后马上清除数据
 @return 刷卡扩展数据（key-value），如是否有IC卡isICCard。Key @reference CSwiperCardDataKey相关字符串常量定义
 */
- (NSDictionary*)getSwipeCardExtendData;
#pragma mark ME30E specify methods
/*!
 @method
 @abstract
 @discussion
 type=，可通过下发约定好的交易序号来定制交易类型显示
 eg：setStartParameter:@(1) type:CSwiperParameterTypeSerial; startCSwiperWithAmount:@"20.00";
 
 type=CSwiperParameterTypeCharsets，可通过下发自定义的字符(150字符集内)来定制交易类型显示
 eg：setStartParameter:@“自定义交易” type:CSwiperParameterTypeCharsets; startCSwiperWithAmount:@"20.00";
 
 type=，可通过下发自定义的字符(150字符集内)来调整全屏显示的信息
 eg：setStartParameter:“全屏交易测试\r\n欢迎使用拉卡拉收款宝\r\n交易金额:22.00” CSwiperParameterTypeCustom; startCSwiperWithAmount:@"";
 @param data 下发参数（NSNumber封装交易序号整数、NSString封装自定义字符串）
 @param type 交易类型显示
 @return
 */
- (BOOL)setStartParameter:(id)data type:(CSwiperParameterType)type;
/*!
 @method
 @abstract ME30E启动方式
 @discussion 启动后，会提示输入pin。30秒未完成pin输入，则发生pin输入超时
 */
- (void)startInputPIN;
/*!
 @method
 @abstract ME30E启动方式
 @discussion 启动时带入金额参数
 @param amount 金额，单位是分且无小数点
 */
- (void)startCSwiperWithAmount:(NSString*)amount;
/*!
 @method
 @abstract ME30E重置之前的操作
 @discussion 撤销前面的操作，回到欢迎界面
 */
- (void)resetScreen;
/*!
 @method
 @abstract ME30E关机
 @discussion 主动进行关机
 */
- (void)powerOff;
#pragma mark - device info
- (id<CSwiperDeviceInfo>)getDeviceInfo;

@end
