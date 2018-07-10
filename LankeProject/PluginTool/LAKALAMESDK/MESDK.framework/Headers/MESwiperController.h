//
//  MESwiperController.h
//  MTypeSDK
//
//  Created by su on 14-2-10.
//  Copyright (c) 2014年 suzw. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @header MESwiperController.h
 @abstract MESwiperController是MSR驱动程序的核心类。在外部程序实现CSwiperControllerDelegate后，并将委托对象交给MESwiperController，将获得运行过程信息的反馈。
 @version 1.00 2012/04/20 Creation (此文档的版本信息)
 */
#import <Foundation/Foundation.h>
#import <MESDK/NLEmvControllerListener.h>
#import <MESDK/NLEmvLevel2ControllerExtListener.h>
#import <MESDK/NLEmvModule.h>
#import <MESDK/NLICCardModule.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "CSwiperParameter.h"

#define  ERROR -1
#define  ERROR_FAIL_TO_START -2
#define  ERROR_FAIL_TO_GET_KSN  -3
#define  ERROR_DUPLICATE_SWIPER -4
#define  ERROR_AUDIO_INITIALIZATION_FAIL -5
#define  ERROR_AUDIO_SESSION_SET_FAIL -6

/*!
 @enum
 @abstract 刷卡驱动的内部运行状态
 @constant CSwiperControllerStateIdle 闲置状态
 @constant CSwiperControllerStateWaitingForDevice 等待设备就绪状态
 @constant CSwiperControllerStateRecording 录音状态
 @constant CSwiperControllerStateDecoding 解码状态
 */
typedef enum {
    CSwiperControllerStateIdle,
    CSwiperControllerStateWaitingForDevice,
    CSwiperControllerStateRecording,
    CSwiperControllerStateDecoding
} CSwiperControllerState;

/*!
 @enum
 @abstract 刷卡驱动解码失败原因
 @constant CSwiperControllerDecodeResultSwipeFail 刷卡失败
 @constant CSwiperControllerDecodeResultCRCError CRC校验错误
 @constant CSwiperControllerDecodeResultCommError 通信错误
 @constant CSwiperControllerDecodeResultUnknownError 位置错误
 @constant CSwiperControllerDecodeResultSwipeIC 不允许刷复合卡
 */
typedef enum {
    CSwiperControllerDecodeResultSwipeFail,
    CSwiperControllerDecodeResultCRCError,
    CSwiperControllerDecodeResultCommError,
    CSwiperControllerDecodeResultUnknownError,
    CSwiperControllerDecodeResultSwipeIC
} CSwiperControllerDecodeResult;

#pragma mark - ME30E enum type
/*!
 @enum
 @abstract 交易显示类型定义
 @constant CSwiperParameterTypeNone 不设置任何参数
 @constant CSwiperParameterTypeSerial 下发约定交易序号
 @constant CSwiperParameterTypeCharsets 下发自定义字符(150字符集内)
 @constant CSwiperParameterTypeCustom 下发自定义字符(150字符集内)，调整全屏显示
 */
typedef enum {
    CSwiperParameterTypeNone,
    CSwiperParameterTypeSerial,
    CSwiperParameterTypeCharsets,
    CSwiperParameterTypeCustom
} CSwiperParameterType;
/*!
 @enum
 @abstract 打印机状态
 @constant CSwiperPrinterStatusNormal 正常
 @constant CSwiperPrinterStatusOutOfPaper 缺纸
 @constant CSwiperPrinterStatusHeatLimited 超温
 @constant CSwiperPrinterStatusFlashReadWriteError 闪存读写错误
 @constant CSwiperPrinterStatusBusy 打印机忙
 @constant CSwiperPrinterStatusNotSupported 不支持打印
 */
typedef enum {
    CSwiperPrinterStatusNormal,
    CSwiperPrinterStatusOutOfPaper,
    CSwiperPrinterStatusHeatLimited,
    CSwiperPrinterStatusFlashReadWriteError,
    CSwiperPrinterStatusBusy,
    CSwiperPrinterStatusNotSupported
} CSwiperPrinterStatus;
/*!
 @enum
 @abstract
 @constant CSwiperStorageResultCmdSuccess 成功
 @constant CSwiperStorageResultCmdSystemFailed 文件系统错误
 @constant CSwiperStorageResultCmdContentExceed 内容长度超限
 @constant CSwiperStorageResultCmdUnknown 未知错误
 */
typedef enum {
    CSwiperStorageResultCmdSuccess,
    CSwiperStorageResultCmdSystemFailed,
    CSwiperStorageResultCmdContentExceed,
    CSwiperStorageResultCmdUnknown
} CSwiperStorageResult;
/*!
 @enum
 @abstract
 @constant CSwiperQPKeyModeKeyA_Ox60
 @constant CSwiperQPKeyModeKeyA_Ox00
 @constant CSwiperQPKeyModeKeyB_Ox61
 @constant CSwiperQPKeyModeKeyB_Ox01
 */
typedef enum {
    CSwiperQPKeyModeKeyA_Ox60,
    CSwiperQPKeyModeKeyA_Ox00,
    CSwiperQPKeyModeKeyB_0x61,
    CSwiperQPKeyModeKeyB_0x01
} CSwiperQPKeyMode;
/*!
 @enum
 @abstract 非接卡类型
 @constant CSwiperQPCardTypeACard
 @constant CSwiperQPCardTypeBCard
 @constant CSwiperQPCardTypeM1Card
 */
typedef enum {
    CSwiperQPCardTypeACard,
    CSwiperQPCardTypeBCard,
    CSwiperQPCardTypeM1Card
} CSwiperQPCardType;

/*!
 @enum
 @abstract ICCard 接口类型
 @constant CSwiperICCardSlotIC1
 @constant CSwiperICCardSlotIC2
 @constant CSwiperICCardSlotIC3
 @constant CSwiperICCardSlotSAM1
 @constant CSwiperICCardSlotSAM2
 @constant CSwiperICCardSlotSAM3
 */
typedef enum {
    CSwiperICCardSlotIC1,
    CSwiperICCardSlotIC2,
    CSwiperICCardSlotIC3,
    CSwiperICCardSlotSAM1,
    CSwiperICCardSlotSAM2,
    CSwiperICCardSlotSAM3
} CSwiperICCardSlot;

/*!
 @enum
 @abstract ICCard 状态
 @constant CSwiperICCardSlotStateNoCard 未插卡
 @constant CSwiperICCardSlotStateCardInserted 卡已经插入
 @constant CSwiperICCardSlotStateCardPowered 卡已经上电
 */
typedef enum {
    CSwiperICCardSlotStateNoCard,
    CSwiperICCardSlotStateCardInserted,
    CSwiperICCardSlotStateCardPowered
} CSwiperICCardSlotState;


/*!
 @enum
 @abstract IC卡类型
 @constant CSwiperICCardTypeCPUCARD
 @constant CSwiperICCardTypeAT24CXX
 @constant CSwiperICCardTypeSLE44X2
 @constant CSwiperICCardTypeSLE44X8
 @constant CSwiperICCardTypeAT88SC102
 @constant CSwiperICCardTypeAT88SC1604
 @constant CSwiperICCardTypeAT88SC1608
 */
typedef enum {
    CSwiperICCardTypeCPUCARD,
    CSwiperICCardTypeAT24CXX,
    CSwiperICCardTypeSLE44X2,
    CSwiperICCardTypeSLE44X8,
    CSwiperICCardTypeAT88SC102,
    CSwiperICCardTypeAT88SC1604,
    CSwiperICCardTypeAT88SC1608
} CSwiperICCardType;

/*!
 @abstract CSwiperCardDataKey
 @constant CSwiperCardDataKeyExpiryDate 4位有效期
 @refence type NSString
 */
extern NSString *const CSwiperCardDataKeyExpiryDate;
/*!
 @abstract CSwiperCardDataKey
 @discussion 当3位服务代码的第一位的值为“2”或者“6” 时表示该卡可能存在IC卡
 @constant CSwiperCardDataKeyServiceCode 3位服务代码
 @refence type NSString
 */
extern NSString *const CSwiperCardDataKeyServiceCode;

@class CSwiperParameter;
@class CSwiperConnectParams;
@class UIImage;
@protocol CSwiperDeviceInfo;
@protocol CSwiperControllerDelegate;
@protocol CSwiperControllerEmvOperator;
@protocol CSwiperControllerQPCardOperator;
@protocol CSwiperControllerPrintOperator;
@protocol CSwiperControllerStorageOperator;
@protocol CSwiperControllerBluetoothOperator;
@protocol CSwiperControllerDeviceStateListener;
@protocol CSwiperICCardOperator;
@protocol CSwiperControllerEmvLevel2Operator;
@protocol CSwiperDeviceManage;

/*!
 @class MESwiperController
 @abstract MESwiperController是MSR刷卡驱动的核心类。
 */
@interface MESwiperController : NSObject<CSwiperControllerBluetoothOperator, CSwiperControllerEmvOperator, CSwiperControllerQPCardOperator, CSwiperControllerPrintOperator, CSwiperControllerStorageOperator, CSwiperICCardOperator,CSwiperControllerEmvLevel2Operator,CSwiperDeviceManage> {
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

/*!
 @protocol
 @abstract MESwiperController的protocol，用于获取MESwiperController运行过程的信息通知。
 @discussion MESwiperController运行过程中信息通知回馈外部程序的接口。通知信息的内容或时机包括检测设备的状态，内部运行状态，刷卡成功后的卡信息以及错误信息等。
 *注意*如果是ME18，请将NLEmvLevel2ControllerExtListener一并加入CSwiperControllerDelegate进行实现
 */
@protocol CSwiperControllerDelegate <NLEmvControllerListener, CSwiperControllerDeviceStateListener>

/*!
 @method
 @abstract 检测到刷卡动作
 @discussion 刷卡后将接收到该通知
 */
- (void)onCardSwipeDetected;

/*!
 @method
 @abstract 通知监听器解码刷卡器输出数据完毕。
 @discussion
 @param formatID
 @param ksn       	       刷卡器设备编码
 @param encTracks          加密的磁道资料。1，2，3的十六进制字符
 @param track1Length       磁道1的长度（没有加密数据为0）
 @param track2Length       磁道2的长度（没有加密数据为0）
 @param track3Length       磁道3的长度（没有加密数据为0）
 @param randomNumber
 @param maskedPANString    基本账号号码。
 卡号的一种格式“ddddddddXXXXXXXXdddd”(隐藏卡号的中间的几位数字)d 数字   X 影藏字符
 @param expiryDate         到期日，格式ＹＹＭＭ
 @param cardHolderName
 */
-(void) onDecodeCompleted:(NSString*)formatID
                      ksn:(NSString*)ksn
                encTracks:(NSString*)encTracks
             track1Length:(int)track1Length
             track2Length:(int)track2Length
             track3Length:(int)track3Length
             randomNumber:(NSString *)randomNumber
                maskedPAN:(NSString*)maskedPANString
              expiryDate :(NSString*)expiryDate
           cardHolderName:(NSString *)cardHolderName;

/*!
 @method
 @abstract 解码失败
 @discussion 刷卡及启动中解码出错
 @param decodeState 解码失败原因
 */
- (void)onDecodeError:(CSwiperControllerDecodeResult)decodeState;

/*!
 @method
 @abstract 解码开始
 @discussion 刷卡后开始解码
 */
- (void)onDecodingStart;

/*!
 @method
 @abstract 错误提示
 @discussion 出现错误。可能偶然的错误，设备与手机的适配问题，或者设备与驱动不符。
 @param errorCode 错误代码。
 @param errorMessage 错误信息。
 */
- (void)onError:(int)errorCode ErrorMessage:(NSString *)errorMessage;

/*!
 @method
 @abstract 中断提示
 @discussion 由于设备拔出或者其它错误导致刷卡器中断
 */
- (void)onInterrupted;

/*!
 @method
 @abstract 启动未检测到设备提示
 @discussion 在启动程序后指定时间内没有检测到刷卡器
 */
- (void)onNoDeviceDetected;

/*!
 @method
 @abstract 超时提示
 @discussion 主要针对刷卡指令，在特定的时间内未刷卡，该方法被调用。对于电池版本刷卡器，这可以避免刷卡器误用导致电池无谓损耗。
 */
- (void)onTimeout;

/*!
 @method
 @abstract 等待刷卡提示
 @discussion 已经检测到刷卡器，进入等待刷卡或者其它指令状态
 */
- (void)onWaitingForCardSwipe;

/*!
 @method
 @abstract 等待插入设备提示
 @discussion 设备未插入时启动刷卡器会得到这个事件通知
 */
- (void)onWaitingForDevice;

/*!
 @method
 @abstract 通知ksn
 @discussion 正常启动刷卡器后，将返回ksn
 @param ksn 取得的ksn
 */
- (void)onGetKsnCompleted:(NSString *)ksn;
#pragma mark
@optional
/*!
 @method
 @abstract 设备插入
 @discussion 刷卡设备准备就绪，提示用户已插入设备
 */
- (void)onDevicePlugged;

/*!
 @method
 @abstract 设备被拔出
 @discussion 刷卡中断，提示用户插入设备
 */
- (void)onDeviceUnplugged;

#pragma mark - ME30E specify apis
@optional
/*!
 @method
 @abstract 等待输入pin
 @discussion 等待输入pin，加密完回调onPinInputCompleted
 */
- (void)onWaitingForPinEnter;
/*!
 @method
 @abstract 输入PIN完成
 @discussion 输入PIN完成
 @param randomNumber		随机数，刷卡器硬件产生
 @param PIN				PIN密文
 @param length			PIN原文长度
 */
- (void)onPinInputCompleted:(NSString*)randomNumber pin:(NSString*)pin length:(int)length;
/*!
 @method
 @abstract 输入pin超时提示
 @discussion 主要针对pin输入指令，在特定的时间内未完成pin输入，该方法被调用。默认为30秒，不进行下电操作，需外部进行控制
 */
- (void)onPinInputTimeout;
/*!
 @method
 @abstract 成功撤销操作
 @discussion 成功撤销操作，回到欢迎界面
 */
- (void)onResetScreenCompleted;
/*!
 @method
 @abstract 关机操作完成
 @discussion 成功进行关机操作
 */
- (void)onPowerOffCompleted;
/**
 *  升级固件回调
 *
 *  @param progress 进度 0.0-1.0（1.0表示固件升级完成）
 *  @param err      不为空时表示升级出错
 */
- (void)onUpdateFirmwareProgress:(float)progress err:(NSError*)err;
/**
 *  升级NFC回调
 *
 *  @param progress 进度 0.0-1.0（1.0表示NFC升级完成）
 *  @param err      不为空时表示升级出错
 */
- (void)onUpdateNFCProgress:(float)progress err:(NSError *)err;
/**
 *  OTA升级回调
 *
 *  @param progress 进度 0.0-1.0（1.0表示OTA升级完成）
 *  @param err      不为空时表示升级出错
 */
- (void)onUpdateOTAProgress:(float)progress err:(NSError *)err;
@end


@protocol CSwiperControllerDeviceStateListener <NSObject>
@optional
/**
 * 当设备连接上时响应
 */
- (void)onDeviceConnected;
/**
 * 当设备中断连接时响应
 */
- (void)onDeviceDisconnected;
/**
 *MT100设备连接状态响应
 * state 0表示主动断开成功，1表示链接成功，2，表示被动断开成功，3表示重连失败，4表示重连成功 ,5表示超时 ，6表示连接失败
 */
- (void)onDeviceConnectedState:(NSString*)state;
/**
 *MT100 ancs配对状态
 *1表示配对成功，0表示配对失败
 */
- (void)onDeviceANCSState:(NSString*)state;
@end

@protocol CSwiperControllerBluetoothOperator <NSObject>

/**
 * 连接蓝牙设备
 */
- (BOOL)connect;
/**
 * 断开蓝牙设备连接
 */
- (void)disConnect;

@end


@protocol CSwiperControllerEmvOperator <NSObject>
/**
 * 结束emv pboc交易流程
 *  @param isSuccess 交易成功或失败
 */
- (void)emvFinish:(BOOL)isSuccess;
/**
 * 清理一个rid以下全部的全部公钥
 *
 * @param rid 认证中心(应用提供方)标识.(Registered Application Provider Identifier)
 */
- (void)clearAllCAPublicKey:(NSData*)rid;

/**
 * 删除一个rid以下某个索引对应公钥<p>
 *
 * @param rid 认证中心(应用提供方)标识.(Registered Application Provider Identifier)
 * @param index 对应的公钥索引
 */
- (void)deleteCAPublicKey:(NSData*)rid index:(int)index;

/**
 * 增加一组公钥
 *
 * @param capk 被导入的公钥
 */
- (void)addCAPublicKey:(NLCAPublicKey*)capk rid:(NSData*)rid;

/**
 * 清理所有应用配置参数
 */
- (void)clearAllAID;


/**
 * 增加一个应用配置参数
 *
 * @param aid 应用标识(Application Identifier)
 * @param appConfig 应用配置参数
 */
- (void)addAID:(NLAIDConfig*)aidConfig;


/**
 * 删除一个应用配置参数
 *
 * @param aid 应用标识(Application Identifier)
 */
- (void)deleteAID:(NSData*)aid;

/**
 * 设置终端参数 <p>
 *
 * @param trmnlConfig 对应的终端参数配置
 */
- (void)setTrmnlParams:(NLTerminalConfig*)trmnlConfig;

/**
 * 联机pin参数设置<p>
 *
 * @param onlinePinConfig 联机pin参数
 */
- (void)setOnlinePinConfig:(NLOnlinePinConfig*)onlinePinConfig;
/**
 * 交易二次授权<p>
 *
 * @param tlvPackage 二次授权
 * @return
 */
- (NLEmvTransInfo*)secondIssuance:(NLSecondIssuanceRequest*)request;
@end


@protocol CSwiperControllerPrintOperator <NSObject>
/**
 * 打印机状态<p>
 *
 * return CSwiperPrinterStatus枚举定义
 */
- (CSwiperPrinterStatus)printerStatus;
/**
 * 打印文本<p>
 *
 * @param string 待打印文本
 */
- (void)printWithString:(NSString*)string;
/**
 * 打印图片<p>
 *
 * @param string 待打印图片
 */
- (void)printWithBitmap:(UIImage*)bitmap;
@end

@protocol CSwiperControllerStorageOperator <NSObject>
/**
 *  初始化存储记录
 *
 *  @param recordName   记录名
 *  @param recordLen    每条记录长度
 *  @param field1Offset 检索字段 1 在记录中的 偏移
 *  @param field1Len    检索字段 1 的长度
 *  @param field2Offset 检索字段 2 在记录中的 偏移
 *  @param field2Len    检索字段 2 的长度
 *  @return 初始化是否成功
 */
-(BOOL)initializeRecord:(NSString *)recordName recordLen:(int)recordLen field1Offset:(int)field1Offset field1Len:(int)field1Len field2Offset:(int)field2Offset field2Len:(int)field2Len;
/**
 *  获取存储记录数
 *
 *  @param recordName 记录名
 *
 *  @return 记录数
 *  @since 1.0.8
 */
-(int)fetchRecordCountWithRecordName:(NSString *)recordName;
/**
 *  增加存储记录
 *
 *  @param recordName    记录名
 *  @param recordContent 记录内容
 *
 *  @return 执行结果 -1:未知错误 0:成功 1:文件系统错误 2:内容长度受限
 */
-(CSwiperStorageResult)addRecordWithRecordName:(NSString *)recordName contentData:(NSData *)recordContent;
/**
 *  更新存储记录
 *
 *  @param recordName     记录名
 *  @param recordNo       记录号
 *  @param field1         检索字段 1
 *  @param field2         检索字段 2
 *  @param getStoreRecord 记录内容
 *
 *  @return 执行结果 -1:未知错误 0:成功 1:文件系统错误 2:内容长度受限
 */
-(CSwiperStorageResult)updateRecordWithRecordName:(NSString *)recordName recordNo:(int)recordNo field1:(NSString *)field1 field2:(NSString *)field2 contentData:(NSData *)recordContent;
/**
 *  获取存储记录
 *
 *  @param recordName     记录名
 *  @param recordNo       记录号
 *  @param field1         检索字段 1
 *  @param field2         检索字段 2
 *
 *  @return nil:失败 recordContent
 */
-(NSData *)fetchRecordDataWithRecordName:(NSString *)recordName recordNo:(int)recordNo field1:(NSString *)field1 field2:(NSString *)field2;
@end


@protocol CSwiperQPResult;
@protocol CSwiperControllerQPCardOperator <NSObject>
/**
 * 寻卡上电
 *
 * @param qPCardType
 *            卡类型，可为空
 * @param timeout
 *            超时时间
 * @return
 */
- (id<CSwiperQPResult>)powerOnWithCardType:(CSwiperQPCardType)qPCardType timeout:(int)timeout;
/**
 * 下电
 *
 * @param timeout
 *            超时时间
 */
- (void)powerOffWithTimeout:(int)timeout;
/**
 * 非接CPU卡通讯
 *
 * @param req
 *            APDU数据
 * @param timeout
 *            等待超时时间
 * @return
 */
- (NSData*)callWithReq:(NSData*)req timeout:(NSTimeInterval)timeout;
/**
 * 存储密钥
 *
 * @param qpKeyMode
 *            KEY模式
 * @param keyIndex
 *            密钥存储区(接口芯片中)
 * @param key
 *            密钥
 */
- (void)storeKeyWithKeyMode:(CSwiperQPKeyMode)qpKeyMode keyIndex:(int)keyIndex key:(NSData*)key;
/**
 * 加载密钥
 *
 * @param qpKeyMode
 *            KEY模式
 * @param keyIndex
 *            密钥存储区(接口芯片中)
 */
- (void)loadKeyWithKeyMode:(CSwiperQPKeyMode)qpKeyMode keyIndex:(int)keyIndex;
/**
 * 使用加载的密钥进行认证
 *
 * @param qpKeyMode
 *            KEY模式
 * @param SNR
 * @param blockNo
 *            要认证的块号
 */
- (void)authenticateByLoadedKeyWithKeyMode:(CSwiperQPKeyMode)qpKeyMode SNR:(NSData*)SNR blockNo:(int)blockNo;
/**
 * 使用外部的密钥进行认证
 *
 * @param qpKeyMode
 *            KEY模式
 * @param SNR
 * @param blockNo
 *            要认证的块号
 * @param key
 *            外部密钥
 */
- (void)authenticateByExtendKeyWithKeyMode:(CSwiperQPKeyMode)qpKeyMode SNR:(NSData*)SNR blockNo:(int)blockNo key:(NSData*)key;
/**
 * 读块数据
 *
 * @param blockNo
 *            块号
 * @return
 */
- (NSData*)readDataBlock:(int)blockNo;
/**
 * 写块数据
 *
 * @param blockNo
 *            块号
 * @param data
 *            块数据
 */
- (void)writeDataBlock:(int)blockNo data:(NSData*)data;
/**
 * 增量操作
 *
 * @param blockNo 块号
 * @param data 值
 */
- (void)incrementOperationWithBlockNo:(int)blockNo data:(NSData*)data;
/**
 * 减量操作
 *
 * @param blockNo 块号
 * @param data 值
 */
- (void)decrementOperationWithBlockNo:(int)blockNo data:(NSData*)data;
@end

@protocol CSwiperICCardOperator <NSObject>
/**
 *  获取到icCardModule
 *
 *  @return
 */
- (id<NLICCardModule>)icCardModule;
/*!
 @method
 @abstract 设置当前的IC卡类型<p>
 @param cardType IC卡卡类型
 @param slot IC卡卡槽
 @return
 */
- (void)setICCardType:(CSwiperICCardType)cardType slot:(CSwiperICCardSlot)slot;
/*!
 @method
 @abstract 获取当前IC卡状态<p>
 @return 当前各个IC卡槽状态 NSDictionary<CSwiperICCardSlot, CSwiperICCardSlotState>
 */
- (NSDictionary*)checkSlotState;
/*!
 @method
 @abstract 卡槽上电<p>
 @param slot IC卡卡槽
 @param cardType IC卡卡类型
 @return ATR
 */
- (NSData*)powerOnWithSlot:(CSwiperICCardSlot)slot cardType:(CSwiperICCardType)cardType;
/*!
 @method
 @abstract 卡槽下电<p>
 @param slot IC卡卡槽
 @param cardType IC卡卡类型
 */
- (void)powerOffWithSlot:(CSwiperICCardSlot)slot cardType:(CSwiperICCardType)cardType;
/*!
 @method
 @abstract 发起一个IC卡通信请求<p>
 @param slot IC卡卡槽
 @param cardType IC卡卡类型
 @param req 请求
 @param timeout 超时时间
 @return 返回调用后的IC卡响应
 */
- (NSData*)callWithSlot:(CSwiperICCardSlot)slot cardType:(CSwiperICCardType)cardType req:(NSData*)req timeout:(NSTimeInterval)timeout;
/*!
 @method
 @abstract IC卡通信认证
 @param phoneNum 手机号
 @param sn SN码
 @param err
 */
- (void)authority:(NSString*)phoneNum sn:(NSString*)sn error:(NSError**)err;
@end

@protocol CSwiperControllerEmvLevel2Operator <NSObject>
-(NLEmvCardInfo *)getCardInfo;
/**
 *  获取交易日志
 *
 *  @return NSArray (NLPbocLogDetail)
 */
-(NSArray *)getPbocLog;
/**
 *  EMV交易
 *
 *  @param amount              金额
 *  @param processingCode      交易码
 *  @param innerProcessingCode 内部交易码
 *  @param isForceOnline       是否强制联机
 */
-(void)icTransferWithAmout:(NSString*)amount
            processingCode:(int)processingCode
       innerProcessingCode:(int)innerProcessingCode
             isForceOnline:(BOOL)isForceOnline;
/**
 *  @author wanglx
 *
 *  设置商户名
 *
 *  @param merchantName 商户名
 *
 *  @return 返回设置成功或失败
 */
-(BOOL)setMerchantName:(NSString *)merchantName;

@end


/**
 *  设备管理
 */
@protocol CSwiperDeviceManage <NSObject>
/**
 *  设置系统时间
 *
 *  @param date 日期时间
 */
-(void)setSysTime:(NSDate *)date;

/**
 *  获取系统时间
 *
 *  @return 日期时间
 */
-(NSDate *)sysTime;
/**
 *  设置系统待机、休眠、关机时间
 *
 *  @param suspendTime  待机时长（秒）
 *  @param dormantTime  休眠时长（秒）
 *  @param shutdownTime 关机时长（秒）
 */
-(void)setSysSuspendTime:(NSInteger)suspendTime dormantTime:(NSInteger)dormantTime shutdownTime:(NSInteger)shutdownTime;
/**
 *  恢复出厂设置
 *
 *  @param types NLRestoreType 数组
 */
-(void)restoreFactory:(NSArray *)types;
/**
 *  设备关闭、休眠、重启
 *
 *  @param operation NLDeviceBehavior_CLOSE 关闭 NLDeviceBehavior_SLEEP 休眠 NLDeviceBehavior_CREBOOT 重启
 */
-(void)shutdownDevice:(NLDeviceBehavior)operation;
/**
 *  获取电池电量
 *
 *  @return 电池电量百分比
 */
-(NSInteger)battery;
/**
 *  获取随机数
 *
 *  @return
 */
-(NSData *)random;
/**
 *  绑定设备
 *
 *  @param data
 *
 *  @return
 */
-(BOOL)deviceBinding:(NSData*)data;
/**
 *  升级固件
 *
 *  @param path 固件路径
 */
-(void)updateFirmware:(NSString *)path;
/**
 *  升级NFC
 *
 *  @param path 固件NFC
 */
-(void)updateNFC:(NSString *)path;
/**
 *  进入OTA模式
 *
 *  @param param 参数（预留）（传0x00）
 *
 *  @return 是否设置成功
 */
-(BOOL)turnToOTA:(Byte)param;
/**
 *  蓝牙参数设置
 *
 *  @param reConnectParam 重连参数 （0x00:断开重连后生效 0x01:直接生效）
 *  @param modelParam     模式参数 （0x00:低速模式 0x01:高速模式）
 *  @return 是否设置成功
 */
-(BOOL)bluetoothSetting:(Byte)reConnectParam model:(Byte)modelParam;
/**
 *  OTA升级
 *
 *  @param path 路径
 *  @param uuid 要升级的设备的uuid
 */
-(void)updateOTA:(NSString *)path uuid:(NSString *)uuid;
@end

/*!
 @enum
 @abstract 刷卡驱动的内部运行状态
 @constant CSwiperReadModelMagneticCard 磁条卡读卡模式
 @constant CSwiperReadModelICCard IC卡读卡模式
 */
//typedef enum {
//    CSwiperReadModelMagneticCard = 0x01,
//    CSwiperReadModelICCard = 0x02
//} CSwiperReadModel;

//@interface CSwiperParameter : NSObject
//{
//    NSDate *_time;
//}
//@property (nonatomic, assign) CSwiperReadModel readModel;
//@property (nonatomic, strong) id content;
//@property (nonatomic) int tradeType98583;
//@property (nonatomic) int tradeTypeCUS;
//@property (nonatomic) BOOL forceOnline;
//@property (nonatomic, readonly) BOOL isEmvParam;
//+ (id)parameterWithContent:(id)content;
//+ (id)magneticCardParameterWitContent:(id)content;
//- (void)setEmvParamsWithTradeType98583:(int)tradeType98583 tradeTypeCUS:(int)tradeTypeCUS forceOnline:(BOOL)forceOnline;
//@end

@interface CSwiperConnectParams : NSObject
@property (nonatomic, strong) NSString *uuid;
//@property (nonatomic, strong) CBPeripheral *per;
+ (id)paramsWithUuid:(NSString*)uuid;
//+ (id)paramsWithPer:(CBPeripheral*)per;
@end

/*!
 @protocol DeviceInfo设备信息
 @abstract 设备信息
 @discussion 对于满足规范的设备，均必须遵循给定接口返回设备信息
 */
@protocol CSwiperDeviceInfo <NSObject>
/*!
 @method 获得设备唯一硬件编号
 @abstract 若该设备的硬件编号需要保护，该方法可以返回为空
 @return 厂商硬件编号
 */
- (NSString*)sn;
/*!
 @method
 @abstract 保留字段
 @return
 */
- (NSData*)reserve;
/*!
 @method
 @abstract 设备状态
 @return
 */
- (NLDeviceState)deviceState;
/*!
 @method 获得当前安全设备固件版本
 @abstract
 @return 固件版本
 */
- (NSString*)firmwareVersion;
/*!
 @method 获得设备应用版本号
 @abstract
 @return appVer
 */
- (NSString*)appVer;
/*!
 @method 获得客户定义的设备序列号CSN
 @abstract
 @return CSN
 */
- (NSString*)CSN;
/*!
 @method 密钥序列号（KSN）
 @abstract
 @return ksn
 */
- (NSString*)ksn;
/*!
 @method 产品ID
 @abstract
 @return
 */
- (NLProductID)productId;
/*!
 @method 厂商ID
 @abstract
 @return
 */
- (NLManufacturerID)manufacturerId;
/*!
 @method 拉卡拉生产SN号
 @abstract
 @return
 */
- (NSString*)lakalaSn;
/*!
 @method 厂商自定义信息
 @abstract
 @return
 */
- (NSData*)manufacturerUserDefined;
/*!
 @method 配置文件版本
 @abstract
 @return
 */
- (NSData*)profileVersion;
/*!
 @since 1.0.6
 @method 获得PID的数值，如果无法获取到对应的设备类型，可以尝试获取该对象匹配具体的产品类型。
 @abstract
 @return
 */
- (NSData*)pidNums;
/**
 * 生产配置
 *  生产规则：8 个字节的设备能力+两个 0x00(RFU)总 共 10 个字节 设备能力见最新版《拉卡拉产品配置表》
 * @return
 */
- (NSData*)productConfigures;
///**
// * 判断设备是否支持音频
// * @return
// */
//- (BOOL)isSupportAudio;
///**
// * 判断设备是否支持蓝牙
// * @return
// */
//- (BOOL)isSupportBlueTooth;
///**
// * 判断设备是否支持USB
// * @return
// */
//- (BOOL)isSupportUSB;
///**
// * 判断设备是否支持磁条卡
// * @return
// */
//- (BOOL)isSupportMagCard;
///**
// * 判断设备是否支持接触式IC卡
// * @return
// */
//- (BOOL)isSupportICCard;
///**
// * 判断设备是否支持非接触IC卡
// * @return
// */
//- (BOOL)isSupportQuickPass;
///**
// * 判断设备是否支持打印
// * @return
// */
//- (BOOL)isSupportPrint;
///**
// * 判断设备是否支持屏幕显示
// * @return
// */
//- (BOOL)isSupportLCD;
@end

@protocol CSwiperQPResult <NSObject>
/**
 * 非接ic卡类型
 */
@property (nonatomic, readonly) CSwiperQPCardType qpCardType;
/**
 * 卡内部序列号
 */
@property (nonatomic, strong, readonly) NSData *cardSerialNo;
/**
 * ATQA 当卡类型为m1时存在
 */
@property (nonatomic, strong, readonly) NSData *ATQA;
- (NSString*)qpCardName;
@end
