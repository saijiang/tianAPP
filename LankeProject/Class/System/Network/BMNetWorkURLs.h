//
//  BMNetWorkURLs.h
//  BlueMobiProject
//
//  Created by 朱 亮亮 on 14-5-12.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//


#ifndef BlueMobiProject_BMNetWorkURLs_h
#define BlueMobiProject_BMNetWorkURLs_h

//Code=-1001 "The request timed out."
//Code=-1009 "The Internet connection appears to be offline."
//Code=-1004 "Could not connect to the server."

/**
 *  超时错误序号 －1001
 */
#define API_COULD_NOT_CONNECT_ERROR -1001
/**
 * Ashi地址服务器
 */
//#define API_SEVERID  @"http://10.58.203.40:8080"


#ifdef DEBUG

/**
 * 测试地址服务器
 */
//#define API_SEVERID @"http://175.102.18.12:8083"

/**
 *   客户生产环境服务器
 */
#define API_SEVERID @"http://139.159.218.169:8080"

#define API_THREPAYSEVERID @"http://159.226.55.111:8080"//疗养券

#else

/**
 *   客户生产环境服务器
 */
#define API_SEVERID @"http://139.159.218.169:8080"
#define API_THREPAYSEVERID @"http://159.226.55.111:8080"//疗养券
///**
// * 测试地址服务器
// */
//#define API_SEVERID @"http://175.102.18.12:8083"

#endif



/**
 *  服务器
 */
#define API_HOST [NSString stringWithFormat:@"%@/zhsq/api", API_SEVERID]

/* 疗养券 */
#define API_THYHOST [NSString stringWithFormat:@"%@/api/ly/ye", API_THREPAYSEVERID]
/* 疗养券消费 */
#define API_THYUSERHOST [NSString stringWithFormat:@"%@/api/ly/xf", API_THREPAYSEVERID]

/// 请在此定义请求URL

#pragma mark－－－－－－－－－－－－－－－－－－－登录注册－－－－－－－－－－－－－－－－－－
/** 获取用户权限 */
#define HK_zkUser_getUserAuthority      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/getUserAuthority"]
/** 启动广告跳转 */
#define HK_zkguang_gao      [NSString stringWithFormat:@"%@%@",API_HOST,@"/version/getAppAdvert"]


/** 登录 */
#define HK_zkUser_login      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/login.do"]
/** 登出 */
#define HK_zkUser_logout      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/logout.do"]
/** 发送验证码 */
#define HK_zkUser_sendAuthCode      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/sendAuthCode.do"]
/** 找回密码 */
#define HK_zkUser_getBackPassword      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/getBackPassword.do"]
/** 注册 */
#define HK_zkUser_register      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/register.do"]
/** 注册-下一步 */
#define HK_zkUser_nextStep      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/nextStep.do"]

/** 首页广告列表 */
#define HK_advert_advertList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/advert/advertList"]
/** 首页广告详情 */
#define HK_advert_advertDetail      [NSString stringWithFormat:@"%@%@",API_HOST,@"/advert/advertDetail"]

#pragma mark－－－－－－－－－－－－－－－－－－－订餐模块－－－－－－－－－－－－－－－－－－

/** 订餐广告列表 */
#define HK_restaurantAdvert_advertList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/restaurantAdvert/advertList"]
/** 订餐广告详情 */
#define HK_restaurantAdvert_advertDetail      [NSString stringWithFormat:@"%@%@",API_HOST,@"/restaurantAdvert/advertDetail"]
/** 餐厅或者食堂列表 */
#define HK_restaurant_restaurantList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/restaurant/restaurantList"]
/** 餐厅或者食堂详情 */
#define HK_restaurant_restaurantDetail      [NSString stringWithFormat:@"%@%@",API_HOST,@"/restaurant/restaurantDetail"]

#define HK_restaurant_restaurantClass      [NSString stringWithFormat:@"%@%@",API_HOST,@"/restaurant/restaurantClass"]

/** 省市区 */
#define HK_TrendRegion_getAreaInfo      [NSString stringWithFormat:@"%@%@",API_HOST,@"/TrendRegion/getAreaInfo"]
/** 每周菜谱 */
#define HK_weekMenuDetail_weekMenuDetail      [NSString stringWithFormat:@"%@%@",API_HOST,@"/weekMenuDetail/weekMenuDetail"]
/** 菜品详情 */
#define HK_dishes_dishes      [NSString stringWithFormat:@"%@%@",API_HOST,@"/dishes/dishes"]
/** 菜品评价列表 */
#define HK_evaluationList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/dishesEvaluation/evaluationList"]
/** 提交评价 */
#define HK_dishesEvaluation_saveEvaluation      [NSString stringWithFormat:@"%@%@",API_HOST,@"/dishesEvaluation/saveEvaluation"]
/** 菜品分类 */
#define HK_dishesClass_dishesClass      [NSString stringWithFormat:@"%@%@",API_HOST,@"/dishesClass/dishesClass"]
/** 外卖分类列表 */
#define HK_takeOutMenu_takeOutMenuList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/takeOutMenu/takeOutMenuList"]
/** 下周菜单 */
#define HK_weekMenuDetail_nextWeekMenuDetail      [NSString stringWithFormat:@"%@%@",API_HOST,@"/weekMenuDetail/nextWeekMenuDetail"]
/** 下周想吃 */
#define HK_weekEat_saveWeekEat      [NSString stringWithFormat:@"%@%@",API_HOST,@"/weekEat/saveWeekEat"]
/** 留言 */
#define HK_message_saveMessage      [NSString stringWithFormat:@"%@%@",API_HOST,@"/message/saveMessage"]
/** 在线订座 */
#define HK_order_orderReservation      [NSString stringWithFormat:@"%@%@",API_HOST,@"/order/orderReservation"]
/** 点菜列表 */
#define HK_dishesClass_dishesList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/dishesClass/dishesList"]
/** 购物车中商品总数量和总价格 */
#define HK_orderCart_totalInfo      [NSString stringWithFormat:@"%@%@",API_HOST,@"/orderCart/totalInfo"] 
/** 加入购物车 */
#define HK_orderCart_addOrderCart      [NSString stringWithFormat:@"%@%@",API_HOST,@"/orderCart/addCart"]
/** 购物车列表 */
#define HK_orderCart_orderCartList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/orderCart/orderCartList"]
/** 删除购物车商品 */
#define HK_orderCart_deleteOrderCart      [NSString stringWithFormat:@"%@%@",API_HOST,@"/orderCart/deleteOrderCart"]
/** 修改购物车商品数量 */
#define HK_orderCart_dishesNum      [NSString stringWithFormat:@"%@%@",API_HOST,@"/orderCart/dishesNum"]
/** 获取默认收货地址 */
#define HK_address_getDefaultAddress      [NSString stringWithFormat:@"%@%@",API_HOST,@"/address/getDefaultAddress"]
/** 获取JD默认收货地址 */
#define HK_JDaddress_getJDDefaultAddress      [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdAddress/getDefaultAddress"]
/** 获取运费 */
#define HK_goodsOrder_getPostFee      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goodsOrder/getPostFee"]   
/** 获取JD运费 */
#define HK_JDgoodsOrder_JDgetPostFee      [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdOrder/getFreight"]
/** 提交JD店商品订单 **/ //goodsOrder/addJdOrder  jdReturnOrder/getWareReturnJdComp
#define HK_goodsOrder_addJDGoodsOrder  [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdOrder/addJdOrder"]
/** 根据订单号、商品编号查询支持的商品返回京东方式**/ // jdReturnOrder/getWareReturnJdComp
#define HK_jdReturnOrder_getWareReturnJdComp  [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdReturnOrder/getWareReturnJdComp"]
/** 提交订座订单 */
#define HK_orderReservation_orderReservation      [NSString stringWithFormat:@"%@%@",API_HOST,@"/orderReservation/orderReservation"]
/** 提交外卖订单 */
#define HK_orderTakeOut_orderTakeOut      [NSString stringWithFormat:@"%@%@",API_HOST,@"/orderTakeOut/orderTakeOut"]
/** 钱包支付 */
#define HK_wallet_wallet      [NSString stringWithFormat:@"%@%@",API_HOST,@"/wallet/wallet"]
/**获取订餐和自营信息的价格体系接口 */
#define HK_goodsOrder_getCouponPriceInfo      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goodsOrder/getCouponPriceInfo"]

#pragma mark -    -------------------------------- 商城 ------------------------------------
/** 商城轮播图  **/ //mallAdvert/getMallAdvert
#define HK_Store_Wallet      [NSString stringWithFormat:@"%@%@",API_HOST,@"/mallAdvert/getMallAdvert"]

/** 推荐商品(自营) **/ //goods/getRecommendGoods
#define HK_Store_Recommend   [NSString stringWithFormat:@"%@%@",API_HOST,@"/goods/getRecommendGoods"]

/** 自营店铺列表 **/ //merchant/getMerchantInfo
#define HK_Store_MerchantInfo  [NSString stringWithFormat:@"%@%@",API_HOST,@"/merchant/getMerchantInfo"]

/** 商品搜索 **/ //goods/getSearchGoodsList
#define HK_Store_SearchGoodsList  [NSString stringWithFormat:@"%@%@",API_HOST,@"/goods/getSearchGoodsList"]

/** 商品分类 **/ //goods/getGoodsClassList
#define HK_Store_GoodsClassList  [NSString stringWithFormat:@"%@%@",API_HOST,@"/goods/getGoodsClassList"]

/** 商品评价列表 **/ //goods/getGoodsEvaluation
#define HK_Store_GoodsEvaluation  [NSString stringWithFormat:@"%@%@",API_HOST,@"/goods/getGoodsEvaluation"]

/** 加入购物车 **/ //goodsCart/addGoodsCart
#define HK_Store_AddGoodsCart  [NSString stringWithFormat:@"%@%@",API_HOST,@"/goodsCart/addGoodsCart"]

/** 提交自营商品订单 **/ //goodsOrder/addGoodsOrder
#define HK_goodsOrder_addGoodsOrder  [NSString stringWithFormat:@"%@%@",API_HOST,@"/goodsOrder/addGoodsOrder"]

/** 提交一号店商品订单 **/ //goodsOrder/addYhdGoodsOrder
#define HK_goodsOrder_addYhdGoodsOrder  [NSString stringWithFormat:@"%@%@",API_HOST,@"/goodsOrder/addYhdGoodsOrder"]

/** 购物车列表**/ //goodsCart/getGoodsCartList
#define HK_Store_GoodsCartList  [NSString stringWithFormat:@"%@%@",API_HOST,@"/goodsCart/getGoodsCartList"]

/** 删除购物车 **/ //goodsCart/delGoodsCart
#define HK_Store_DelGoodsCart  [NSString stringWithFormat:@"%@%@",API_HOST,@"/goodsCart/delGoodsCart"]

/** 购物车加减 **/ //goodsCart/updateGoodsCart
#define HK_Store_UpdateGoodsCart  [NSString stringWithFormat:@"%@%@",API_HOST,@"/goodsCart/updateGoodsCart"]

/** 提交订单 **/ //goodsOrder/addGoodsOrder
#define HK_Store_AddGoodsOrder  [NSString stringWithFormat:@"%@%@",API_HOST,@"/goodsOrder/addGoodsOrder"]

/** 钱包支付 **/ //wallet/QrCodeWallet
#define HK_wallet_QrCodeWallet  [NSString stringWithFormat:@"%@%@",API_HOST,@"/wallet/QrCodeWallet"]

/** 钱包支付 **/ //wallet/orderWallet
#define HK_Store_OrderWallet  [NSString stringWithFormat:@"%@%@",API_HOST,@"/wallet/orderWallet"]

/** 自营商品订单列表 **/ //goodsOrder/getGoodsOrderList
#define HK_Store_GetGoodsOrderList  [NSString stringWithFormat:@"%@%@",API_HOST,@"/goodsOrder/getGoodsOrderList"]

/** 自营商品订单详情接口 **/ //goodsOrder/getGoodsOrderDetail
#define HK_Store_GetGoodsOrderDetail  [NSString stringWithFormat:@"%@%@",API_HOST,@"/goodsOrder/getGoodsOrderDetail"]

/** 团购列表接口 **/ //groupGoods/getGroupGoods
#define HK_groupGoods_getGroupGoods  [NSString stringWithFormat:@"%@%@",API_HOST,@"/groupGoods/getGroupGoods"]

/** 团购详情接口 **/ //groupGoods/getGroupGoodsDetail
#define HK_groupGoods_getGroupGoodsDetail  [NSString stringWithFormat:@"%@%@",API_HOST,@"/groupGoods/getGroupGoodsDetail"]

/** 提交订单并支付 **/ //groupGoods/addGroupGoodsOrder
#define HK_groupGoods_addGroupGoodsOrder [NSString stringWithFormat:@"%@%@",API_HOST,@"/groupGoods/addGroupGoodsOrder"]

/** 团购订单列表接口 **/ //groupGoods/getGroupGoodsOrderList
#define HK_groupGoods_getGroupGoodsOrderList  [NSString stringWithFormat:@"%@%@",API_HOST,@"/groupGoods/getGroupGoodsOrderList"]

/** 团购订单详情接口 **/ //groupGoods/getGroupGoodsOrderDetail
#define HK_groupGoods_getGroupGoodsOrderDetail  [NSString stringWithFormat:@"%@%@",API_HOST,@"/groupGoods/getGroupGoodsOrderDetail"]

/** 修改订单状态接口 **/ //groupGoods/changeGroupOrderStatus
#define HK_groupGoods_changeGroupOrderStatus  [NSString stringWithFormat:@"%@%@",API_HOST,@"/groupGoods/changeGroupOrderStatus"]


#pragma mark－－－－－－－－－－－－－－－－－－－健康模块－－－－－－－－－－－－－－－－－－

/** 轮播图 */
#define HK_healthNotice_gethealthNoticeList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/healthAdvert/healthAdvertList"]
/** 轮播图详情 */
#define HK_healthNotice_gethealthNoticeDetail      [NSString stringWithFormat:@"%@%@",API_HOST,@"/healthNotice/gethealthNoticeDetail"]

/** 健康咨询分类接口 */
#define HK_healthAdvice_healthAdviceClass      [NSString stringWithFormat:@"%@%@",API_HOST,@"/healthAdvice/healthAdviceClass"]
/** 资讯列表 */
#define HK_healthAdvice_healthAdviceList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/healthAdvice/healthAdviceList"]
/** 资讯详情 */
#define HK_healthAdvice_healthAdviceDetail      [NSString stringWithFormat:@"%@%@",API_HOST,@"/healthAdvice/healthAdviceDetail"]

/** 健身榜 */
#define HK_fitness_getFitnessPlanList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/fitness/getFitnessPlanList"]
/** 健身榜历史数据 */
#define HK_fitness_getFitnessPlanHistory      [NSString stringWithFormat:@"%@%@",API_HOST,@"/fitness/getFitnessPlanHistory"]

/** 关注好友 */
#define HK_fitness_attentFriend      [NSString stringWithFormat:@"%@%@",API_HOST,@"/fitness/attentFriend"]
/** 取消关注好友 */
#define HK_fitness_cancelAttentFriend      [NSString stringWithFormat:@"%@%@",API_HOST,@"/fitness/cancelAttentFriend"]

/** 用户点赞 */
#define HK_fitness_addClick      [NSString stringWithFormat:@"%@%@",API_HOST,@"/fitness/addClick"]
/** 取消用户点赞 */
#define HK_fitness_cancelClick      [NSString stringWithFormat:@"%@%@",API_HOST,@"/fitness/cancelClick"]

#pragma mark－－－－－－－－－－－－－－－－－－－用户中心－－－－－－－－－－－－－－－－－－

/** 个人中心 */
#define HK_zkUser_getUserInfo      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/getUserInfo.do"]
/** 新增地址 */
#define HK_address_addAddress      [NSString stringWithFormat:@"%@%@",API_HOST,@"/address/addAddress.do"]
/** 京东新增地址 */
#define HK_JDaddress_addJDAddress      [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdAddress/addAddress"]
/** 地址列表 */
#define HK_address_getAddressList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/address/getAddressList.do"]

/** 京东地址列表 */
#define HK_JDaddress_getJDAddressList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdAddress/getAddressList"]
/** JD编辑地址 */
#define HK_JDaddress_JDeditAddress      [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdAddress/editAddress"]
/** JD删除地址 */
#define HK_JDaddress_JDdeleteAddress      [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdAddress/deleteAddress"]
/** 设为JD默认地址 */
#define HK_JDaddress_JDsetDefaultAddress      [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdAddress/setDefaultAddress"]

/** 编辑地址 */
#define HK_address_editAddress      [NSString stringWithFormat:@"%@%@",API_HOST,@"/address/editAddress.do"]
/** 删除地址 */
#define HK_address_deleteAddress      [NSString stringWithFormat:@"%@%@",API_HOST,@"/address/deleteAddress.do"]
/** 设为默认地址 */
#define HK_address_setDefaultAddress      [NSString stringWithFormat:@"%@%@",API_HOST,@"/address/setDefaultAddress.do"]
/** 更新用户信息 */
#define HK_zkUser_updateUserInfo      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/updateUserInfo.do"]
/** 修改昵称 */
#define HK_zkUser_updateNickName      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/updateNickName.do"]
/** 变更手机号 */
#define HK_zkUser_updateMobileNum      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/updateMobileNum.do"]
/** 订餐外卖订单列表 */
#define HK_goodsOrder_getGoodsOrderList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goodsOrder/getGoodsOrderList.do"]
/** 订餐外卖订单列表 */
#define HK_zkUser_getMealOrderList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/getMealOrderList.do"]
/** 订餐订单详情 */
#define HK_zkUser_getReservationOrderDetail      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/getReservationOrderDetail.do"]
/** 外卖订单详情  §*/
#define HK_zkUser_getTakeOutOrderDetail      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/getTakeOutOrderDetail.do"]
/** 删除订单 */
#define HK_zkUser_cancelMealOrder      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/cancelMealOrder.do"]
/** 疗养券 */
#define HK_zkUser_getTherapayBalance      [NSString stringWithFormat:@"%@",API_THYHOST]
/* 疗养券消费 */
#define HK_zkUser_getTherapayDetail      [NSString stringWithFormat:@"%@",API_THYUSERHOST]

/** 钱包余额 */
#define HK_zkUser_getWalletBalance      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/getWalletBalance.do"]
/** 消费记录 */
#define HK_zkUser_getWalletDetail      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/getWalletDetail.do"]
/** 重置支付密码 */
#define HK_zkUser_updateWalletPassword      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/updateWalletPassword.do"]

/** 我的消息接口 */
#define HK_message_getMessageList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/message/getMessageList"]

/** 我的收藏（商品）接口 */
#define HK_zkUser_getGoodsCollect      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/getGoodsCollect"]
/** 我的收藏（JD商品）接口 */
#define HK_zkUser_getJDGoodsCollect      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/getJdGoodsCollect"]

/** 我的收藏（商家）接口 */
#define HK_zkUser_getMerchantInfoCollect      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/getMerchantInfoCollect"]

/** 我的收藏（资讯）接口 */
#define HK_zkUser_getHealthCollect      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/getHealthCollect"]

/** 查看物流接口 */
#define HK_zkUser_getLogisticsInfo      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/getLogisticsInfo.do"]

/** 获取积分明细接口 */
#define HK_zkUser_getIntegralDetail      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/getIntegralDetail"]

/** 兑换积分接口 */
#define HK_zkUser_getIntegraljifen     [NSString stringWithFormat:@"%@%@",API_HOST,@"/wallet/pointRate.do"]

/** 清空我的消息 */
#define HK_message_cleanMessage      [NSString stringWithFormat:@"%@%@",API_HOST,@"/message/cleanMessage"]

/** 消息标记为已读 */
#define HK_message_readMessage      [NSString stringWithFormat:@"%@%@",API_HOST,@"/message/getMessageDetail"]

/** 查看是否有新消息 */
#define HK_message_getMessageCount      [NSString stringWithFormat:@"%@%@",API_HOST,@"/message/getMessageCount"]

#pragma mark－－－－－－－－－－－－－－－－－－－收藏与取消收藏模块－－－－－－－－－－－－－－－－－－

/** 收藏 */
#define HK_collect_collectHealthAdvice      [NSString stringWithFormat:@"%@%@",API_HOST,@"/collect/collectHealthAdvice"]
/** 取消收藏 */
#define HK_collect_cancelHealthAdvice      [NSString stringWithFormat:@"%@%@",API_HOST,@"/collect/cancelHealthAdvice"]

#pragma mark－－－－－－－－－－－－－－－－－－－设置模块－－－－－－－－－－－－－－－－－－

/** 版本更新 */
#define HK_version_version      [NSString stringWithFormat:@"%@%@",API_HOST,@"/version/version"]
/** 提交意见反馈 */
#define HK_feedBack_feedBack      [NSString stringWithFormat:@"%@%@",API_HOST,@"/feedBack/feedBack"]


#pragma mark－－－－－－－－－－－－－－－－－－－第三方天气API－－－－－－－－－－－－－－－－－－

#define HK_current_weather      [NSString stringWithFormat:@"http://api.map.baidu.com/telematics/v3/weather"]
#define HK_weather_ak @"9G3zsrqeMKIE65rTGK4wv5FVzvjDqVhf"//@"com.HFLifeLiving.app"
#define HK_weather_mcode @"com.HFLifeLiving.app"

//#define HK_weather_ak @"4c1yLHx6B55vIk507p1lh4qfSSmNjEhU"//@"com.HangTian.app"
//#define HK_weather_mcode [[NSBundle mainBundle] bundleIdentifier]


#pragma mark－－－－－－－－－－－－－－－－－－－商城－－－－－－－－－－－－－－－－－－

/** 轮播图接口 */
#define HK_mallAdvert_getMallAdvert      [NSString stringWithFormat:@"%@%@",API_HOST,@"/mallAdvert/getMallAdvert"]

/** 自营店铺详情 */
#define HK_merchant_getMerchantDetailInfo      [NSString stringWithFormat:@"%@%@",API_HOST,@"/merchant/getMerchantDetailInfo"]

/** 自营-商品详情 */
#define HK_goods_getGoodsDetail      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goods/getGoodsDetail"]

/** 一号店-商品列表 */
#define HK_yhdProduct_getProductList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/yhdProduct/getProductList"]

/** 京东-商品列表 */
#define HK_jdProductDetail_productDetailList     [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdProductDetail/productDetailList"]

/** 一号店-商品详情 */
#define HK_yhdProduct_getProductDetail      [NSString stringWithFormat:@"%@%@",API_HOST,@"/yhdProduct/getProductDetail"]

/** 京东-商品详情 */
#define HK_yjdProductDetail_getProductDetail      [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdProductDetail/getProductDetail"]

/** 一号店-订单列表接口yhdOrder/getYhdOrderList */
#define HK_yhdOrder_getYhdOrderList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/yhdOrder/getYhdOrderList"]
/**JD-订单列表接口yhdOrder/getYhdOrderList */
#define HK_JDOrder_getJDOrderList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdOrder/getOrderList"]

/** 1号店-订单详情接口yhdOrder/getYhdOrderDetail */
#define HK_yhdOrder_getYhdOrderDetail      [NSString stringWithFormat:@"%@%@",API_HOST,@"/yhdOrder/getYhdOrderDetail"]

/** JD-订单详情接口yhdOrder/getYhdOrderDetail */
#define HK_JDOrder_getJDOrderDetail      [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdOrder/getOrderDetail"]


/** 1号店-取消订单接口yhdOrder/cancelOrder */
#define HK_yhdOrder_cancelOrder      [NSString stringWithFormat:@"%@%@",API_HOST,@"/yhdOrder/cancelOrder"]


/** JD-取消订单接口yhdOrder/cancelOrder */
#define HK_JDOrder_cancelJDOrder      [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdOrder/cancelJdOrder"]

/** 1号店-删除订单接口yhdOrder/deleteOrder */
#define HK_yhdOrder_deleteOrder      [NSString stringWithFormat:@"%@%@",API_HOST,@"/yhdOrder/deleteOrder"]

//JD-删除JD订单接口y/jdOrder/deleteJdOrder
#define HK_JDOrder_deleteOrder      [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdOrder/deleteJdOrder"]



/** 1号店-订单物流信息接口yhdOrder/getYhdLogisticsInfo */
#define HK_yhdOrder_getYhdLogisticsInfo      [NSString stringWithFormat:@"%@%@",API_HOST,@"/yhdOrder/getYhdLogisticsInfo"]

/** 立即支付前调用，判断订单是否取消接口，若订单已取消，则不需要调用支付接口yhdOrder/checkOrderStatus */
#define HK_yhdOrder_checkOrderStatus      [NSString stringWithFormat:@"%@%@",API_HOST,@"/yhdOrder/checkOrderStatus"]

// JD立即支付前调用，判断订单是否取消接口，若订单已取消，则不需要调用支付接口/jdOrder/checkBeforeDoOrder
#define HK_JDOrder_checkOrderStatus      [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdOrder/checkBeforeDoOrder"]


/** 1号店1级商品分类列表接口yhdCategory/getFirstCategoryList */
#define HK_yhdCategory_getFirstCategoryList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/yhdCategory/getFirstCategoryList"]


/** 1号店2级以及3级商品分类列表接口yhdCategory/getSecondCategoryList */
#define HK_yhdCategory_getSecondCategoryList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/yhdCategory/getSecondCategoryList"]

/** 本店主打商品接口 */
#define HK_goods_getGoodsOurMain      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goods/getGoodsOurMain"]

#define HK_goods_getGoodsByMerchant      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goods/getGoodsByMerchant"]


/** 商品评价接口 */
#define HK_goods_getGoodsEvaluation      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goods/getGoodsEvaluation"]

/** 商品分类接口 */
#define HK_goods_getGoodsClassList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goods/getGoodsClassList"]

/** 推荐商品接口goods/getRecommendGoods */
#define HK_goods_getRecommendGoods      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goods/getRecommendGoods"]

/** 商品搜索接口goods/getSearchGoodsList */
#define HK_goods_getSearchGoodsList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goods/getSearchGoodsList"]

/** 自营店铺列表接口merchant/getMerchantInfo */
#define HK_merchant_getMerchantInfo      [NSString stringWithFormat:@"%@%@",API_HOST,@"/merchant/getMerchantInfo"]

/** 获取商品一级分类接口goods/getGoodsClassFirst */
#define HK_goods_getGoodsClassFirst      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goods/getGoodsClassFirst"]

/** 自营商品订单详情接口goodsOrder/getGoodsOrderDetail */
#define HK_goodsOrder_getGoodsOrderDetail      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goodsOrder/getGoodsOrderDetail"]

/** 更新订单状态goodsOrder/changeOrderStatus */
#define HK_goodsOrder_changeOrderStatus      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goodsOrder/changeOrderStatus"]

/** 申请退款接口goodsOrder/returnOrder */
#define HK_goodsOrder_returnOrder      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goodsOrder/returnOrder"]

/** 商品评价接口goodsOrder/addGoodsEvaluate */
#define HK_goodsOrder_addGoodsEvaluate      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goodsOrder/addGoodsEvaluate"]

/** 退款订单列表接口goodsOrder/getReturnOrder */
#define HK_goodsOrder_getReturnOrder      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goodsOrder/getReturnOrder"]

/** 删除售后订单记录接口goodsOrder/deleteReturnOrder */
#define HK_goodsOrder_deleteReturnOrder      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goodsOrder/deleteReturnOrder"]

/** 填写快递单号信息接口goodsOrder/updateReturnOrder */
#define HK_goodsOrder_updateReturnOrder      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goodsOrder/updateReturnOrder"]

/** 获取购物车总数量接口goodsCart/getGoodsCartNum */
#define HK_goodsCart_getGoodsCartNum      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goodsCart/getGoodsCartNum"]

/** 品牌接口goods/getBrandList */
#define HK_goods_getBrandList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goods/getBrandList"]
/** JD获取品牌信息goods/getBrandList */
#define HK_goods_getJDBrandList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdProductCategory/getBrandName"]
/** 获取品牌分类接口goods/getBrandList */
#define HK_goods_getCategoryName      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goods/getCategoryName"]



#pragma mark－－－－－－－－－－－－－－－－－－－车辆限号接口－－－－－－－－－－－－－－－－－－
/** 车辆限号接口zkUser/getLimitLicense */
#define HK_zkUser_getLimitLicense      [NSString stringWithFormat:@"%@%@",API_HOST,@"/zkUser/getLimitLicense"]


#pragma mark－－－－－－－－－－－－－－－－－－－健康模块－－－－－－－－－－－－－－－－－－

/** 症状自测接口*/
#define HK_symptomsClass_getSymptomsList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/symptomsClass/getSymptomsList"]

/** 可能患病列表接口*/
#define HK_symptomsClass_getDiseaseInfo      [NSString stringWithFormat:@"%@%@",API_HOST,@"/symptomsClass/getDiseaseInfo"]

/** 身体情况自测*/
#define HK_bodySelfCheck_saveBodySelfCheck      [NSString stringWithFormat:@"%@%@",API_HOST,@"/bodySelfCheck/saveBodySelfCheck"]

/** 开启健身计划*/
#define HK_fitnessPlan_saveFitnessPlan      [NSString stringWithFormat:@"%@%@",API_HOST,@"/fitnessPlan/saveFitnessPlan"]

/** 判断是否有未完成的健身计划*/
#define HK_fitnessPlan_getLastFitnessPlan      [NSString stringWithFormat:@"%@%@",API_HOST,@"/fitnessPlan/getLastFitnessPlan"]


/** 重置健身计划*/
#define HK_fitnessPlan_resetFitnessPlan      [NSString stringWithFormat:@"%@%@",API_HOST,@"/fitnessPlan/resetFitnessPlan"]

/** 健身计划详情*/
#define HK_fitness_getFitnessPlanDetail      [NSString stringWithFormat:@"%@%@",API_HOST,@"/fitness/getFitnessPlanDetail"]

/** 健身计划页面信息*/
#define HK_fitnessPlan_fitnessPlan      [NSString stringWithFormat:@"%@%@",API_HOST,@"/fitnessPlan/fitnessPlan"]

/** 每日健身情况接口*/
#define HK_fitness_getDayFitnessPlan      [NSString stringWithFormat:@"%@%@",API_HOST,@"/fitness/getDayFitnessPlan"]

/** 每日健身情况接口*/
#define HK_watchInfo_getStepNumList     [NSString stringWithFormat:@"%@%@",API_HOST,@"/watchInfo/getStepNumList"]

/** 获取用户健身情况列表*/
#define HK_fitness_getFitnessPlanDetailList     [NSString stringWithFormat:@"%@%@",API_HOST,@"/fitness/getFitnessPlanDetailList"]
/** 获取心率列表*/
#define HK_watchInfo_getHeartRateList     [NSString stringWithFormat:@"%@%@",API_HOST,@"/watchInfo/getHeartRateList"]

/** 删除今日健身智能计划*/

#define HK_sportsPlan_deleteSportsPlan      [NSString stringWithFormat:@"%@%@",API_HOST,@"/sportsPlan/deleteSportsPlan"]

#define HK_sportsPlan_deleteCustomSportsPlan      [NSString stringWithFormat:@"%@%@",API_HOST,@"/sportsPlan/deleteCustomSportsPlan"]

/** 手动添加今日消耗卡路里接口*/
#define HK_sportsPlan_insertSportsPlan      [NSString stringWithFormat:@"%@%@",API_HOST,@"/sportsPlan/insertSportsPlan"]

/** 历史健身*/
#define HK_fitnessPlan_getHistoryFitness      [NSString stringWithFormat:@"%@%@",API_HOST,@"/fitnessPlan/getHistoryFitness"]

/** 重置喜爱的运动*/
#define HK_bodySelfCheck_resetSports      [NSString stringWithFormat:@"%@%@",API_HOST,@"/bodySelfCheck/resetSports"]

/** 查看喜爱的运动*/
#define HK_bodySelfCheck_getBodyInfo      [NSString stringWithFormat:@"%@%@",API_HOST,@"/bodySelfCheck/getBodyInfo"]


/** 查看报告*/
#define HK_fitnessPlan_getFitnessDetail      [NSString stringWithFormat:@"%@%@",API_HOST,@"/fitnessPlan/getFitnessDetail"]

/** 判断是否有进行中的健身计划*/
#define HK_fitnessPlan_fitnessPlanIsExist      [NSString stringWithFormat:@"%@%@",API_HOST,@"/fitnessPlan/fitnessPlanIsExist"]

/** 新增健身计划详情信息（手环数据)*/
#define HK_fitness_saveFitnessPlanDetail      [NSString stringWithFormat:@"%@%@",API_HOST,@"/fitness/saveFitnessPlanDetail"]

/** 主题教学分类列表接口*/
#define HK_teach_getTeachVideoClass      [NSString stringWithFormat:@"%@%@",API_HOST,@"/teach/getTeachVideoClass"]

/** 主题教学列表接口*/
#define HK_teach_getTeachList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/teach/getTeachList"]

/**获取主题教学详情接口*/
#define HK_teach_getTeachDetail      [NSString stringWithFormat:@"%@%@",API_HOST,@"/teach/getTeachDetail"]

/**健身直播列表接口*/
#define HK_healthLive_getHealthFitnessNewList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/healthLive/getHealthFitnessNewList"]

#pragma mark－－－－－－－－－－－－－－－－－－－支付－－－－－－－－－－－－－－－－－－

/** 微信支付接口*/
#define HK_payMent_wxPayinfo      [NSString stringWithFormat:@"%@%@",API_HOST,@"/payMent/wxPayinfo"]

/**支付宝相关配置接口*/
#define HK_payMent_payInfoSetting      [NSString stringWithFormat:@"%@%@",API_HOST,@"/payMent/payInfoSetting"]

/**动态获取支付方式接口*/
#define HK_goodsOrder_getPayType      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goodsOrder/getPayType"]

/**订单确认页面享受优惠信息接口*/
#define HK_goodsOrder_getOrderPayType      [NSString stringWithFormat:@"%@%@",API_HOST,@"/goodsOrder/getOrderPayType"]


#pragma mark－－－－－－－－－－－－－－－－－－－社区－－－－－－－－－－－－－－－－－－

/**我的社群接口*/
#define HK_association_getAssociationUser     [NSString stringWithFormat:@"%@%@",API_HOST,@"/association/getAssociationUser"]

/**社群管理接口*/
#define HK_association_getMyAssociation     [NSString stringWithFormat:@"%@%@",API_HOST,@"/association/getMyAssociation"]

/**加入更多社群--分类接口*/
#define HK_association_getAssociationClass     [NSString stringWithFormat:@"%@%@",API_HOST,@"/association/getAssociationClass"]

/**加入更多社群--列表接口*/
#define HK_association_getAssociationList     [NSString stringWithFormat:@"%@%@",API_HOST,@"/association/getAssociationList"]


/**查看成员--成员列表接口*/
#define HK_association_getMemberList     [NSString stringWithFormat:@"%@%@",API_HOST,@"/association/getAssociationUserList"]
/**查看成员--拉黑成员接口*/
#define HK_association_deleteMemberList     [NSString stringWithFormat:@"%@%@",API_HOST,@"/association/deleteUser"]
/**加入更多社群--列表接口*/
#define HK_association_addAssociation     [NSString stringWithFormat:@"%@%@",API_HOST,@"/association/addAssociation"]

/**加入社群接口*/
#define HK_association_addAssociation     [NSString stringWithFormat:@"%@%@",API_HOST,@"/association/addAssociation"]

/**社群管理接口*/
#define HK_association_getMyAssociation     [NSString stringWithFormat:@"%@%@",API_HOST,@"/association/getMyAssociation"]

/**添加编辑社群条款接口*/
#define HK_association_editAssociation     [NSString stringWithFormat:@"%@%@",API_HOST,@"/association/editAssociation"]

/**社群申请列表接口*/
#define HK_association_getAssociationUserApply     [NSString stringWithFormat:@"%@%@",API_HOST,@"/association/getAssociationUserApply"]

/**申请同意或拒绝接口*/
#define HK_association_applyAssociationUser     [NSString stringWithFormat:@"%@%@",API_HOST,@"/association/applyAssociationUser"]

/**社区活动接口*/
#define HK_community_getCommunityActiviy     [NSString stringWithFormat:@"%@%@",API_HOST,@"/community/getCommunityActiviy"]

/**社区活动详情接口*/
#define HK_community_getCommunityActiviyDetail     [NSString stringWithFormat:@"%@%@",API_HOST,@"/community/getCommunityActiviyDetail"]

/**在线报名接口*/
#define HK_community_communityActivityApply     [NSString stringWithFormat:@"%@%@",API_HOST,@"/community/communityActivityApply"]

/**发布话题接口*/
#define HK_topic_addTopic     [NSString stringWithFormat:@"%@%@",API_HOST,@"/topic/addTopic"]

/**话题列表接口*/
#define HK_topic_getTopicList     [NSString stringWithFormat:@"%@%@",API_HOST,@"/topic/getTopicList"]

/**话题详情接口*/
#define HK_topic_getTopicDetail     [NSString stringWithFormat:@"%@%@",API_HOST,@"/topic/getTopicDetail"]

/**话题评价列表接口*/
#define HK_topic_getTopicEvaluate     [NSString stringWithFormat:@"%@%@",API_HOST,@"/topic/getTopicEvaluate"]

/**发表评论接口*/
#define HK_topic_addTopicEvaluate     [NSString stringWithFormat:@"%@%@",API_HOST,@"/topic/addTopicEvaluate"]

/**删除话题接口*/
#define HK_topic_delTopic     [NSString stringWithFormat:@"%@%@",API_HOST,@"/topic/delTopic"]

/**删除用户评论接口*/
#define HK_topic_delTopicEvaluate     [NSString stringWithFormat:@"%@%@",API_HOST,@"/topic/delTopicEvaluate"]

/**拉黑用户接口*/
#define HK_topic_delAssociationUser     [NSString stringWithFormat:@"%@%@",API_HOST,@"/topic/delAssociationUser"]

/**添加编辑社群条款接口*/
#define HK_association_editAssociation     [NSString stringWithFormat:@"%@%@",API_HOST,@"/association/editAssociation"]

/**社群申请列表接口*/
#define HK_association_getAssociationUserApply     [NSString stringWithFormat:@"%@%@",API_HOST,@"/association/getAssociationUserApply"]

/**申请同意或拒绝接口*/
#define HK_association_applyAssociationUser     [NSString stringWithFormat:@"%@%@",API_HOST,@"/association/applyAssociationUser"]

/**我收藏的帖子接口*/
#define HK_topic_getCollectTopicList     [NSString stringWithFormat:@"%@%@",API_HOST,@"/topic/getCollectTopicList"]


#pragma mark－－－－－－－－－－－－－－－－－－－物业模块－－－－－－－－－－－－－－－－－－

/**根据省市区获取小区信息接口*/
#define HK_districtInfo_getDistrictList     [NSString stringWithFormat:@"%@%@",API_HOST,@"/districtInfo/getDistrictList"]

/**获取小区信息接口*/
#define HK_districtInfo_getDistrictInfo     [NSString stringWithFormat:@"%@%@",API_HOST,@"/districtInfo/getDistrictInfo"]

/**社区头条接口*/
#define HK_districtInfo_getNoticeAnnounce     [NSString stringWithFormat:@"%@%@",API_HOST,@"/districtInfo/getNoticeAnnounce"]

/**社区头条详情接口*/
#define HK_districtInfo_getNoticeAnnounceDetail     [NSString stringWithFormat:@"%@%@",API_HOST,@"/districtInfo/getNoticeAnnounceDetail"]

/**提交报修接口*/
#define HK_repair_addOrderRepair     [NSString stringWithFormat:@"%@%@",API_HOST,@"/repair/addOrderRepair"]

/**获取报修类型接口*/
#define HK_repair_getRepairType     [NSString stringWithFormat:@"%@%@",API_HOST,@"/repair/getRepairType"]

/**获取报修记录接口*/
#define HK_repair_getRepairRecord     [NSString stringWithFormat:@"%@%@",API_HOST,@"/repair/getRepairRecord"]

/**获取报修评价列表接口*/
#define HK_repair_getRepairEvaluation     [NSString stringWithFormat:@"%@%@",API_HOST,@"/repair/getRepairEvaluation"]

/**保修记录确认完成接口*/
#define HK_repair_confirmRepairRecord     [NSString stringWithFormat:@"%@%@",API_HOST,@"/repair/confirmRepairRecord"]

/**保修记录确认完成接口*/
#define HK_repair_submitRepairEvaluation     [NSString stringWithFormat:@"%@%@",API_HOST,@"/repair/submitRepairEvaluation"]

/**获取报修详情接口*/
#define HK_repair_getRepairRecordDetail     [NSString stringWithFormat:@"%@%@",API_HOST,@"/repair/getRepairRecordDetail"]

/**提交有话要说接口*/
#define HK_topicComplain_addTopicComplain     [NSString stringWithFormat:@"%@%@",API_HOST,@"/topicComplain/addTopicComplain"]

/**获取有话要说列表接口*/
#define HK_topicComplain_getTopicComplainList     [NSString stringWithFormat:@"%@%@",API_HOST,@"/topicComplain/getTopicComplainList"]

/**获取便民服务列表接口*/
#define HK_districtMerchant_getDistrictMerchantList     [NSString stringWithFormat:@"%@%@",API_HOST,@"/districtMerchant/getDistrictMerchantList"]

/**获取便民服务详情接口*/
#define HK_districtMerchant_getDistrictMerchantDetail     [NSString stringWithFormat:@"%@%@",API_HOST,@"/districtMerchant/getDistrictMerchantDetail"]

/**我的物业资料接口*/
#define HK_districtInfo_getMyproperty     [NSString stringWithFormat:@"%@%@",API_HOST,@"/districtInfo/getMyproperty"]

/**物业资料设置默认接口*/
#define HK_districtInfo_setDefaultPropery     [NSString stringWithFormat:@"%@%@",API_HOST,@"/districtInfo/setDefaultPropery"]

/**获取各类型需缴费的账单接口*/
#define HK_properytyBill_getPropertyBill     [NSString stringWithFormat:@"%@%@",API_HOST,@"/properytyBill/getPropertyBill"]

/**获取各类型缴费明细接口*/
#define HK_properytyBill_getPropertyBillDetail     [NSString stringWithFormat:@"%@%@",API_HOST,@"/properytyBill/getPropertyBillDetail"]

/**获取各类型缴费历史接口*/
#define HK_properytyBill_getPropertyBillRecord     [NSString stringWithFormat:@"%@%@",API_HOST,@"/properytyBill/getPropertyBillRecord"]

/**物业钱包支付*/
#define HK_wallet_propertyWallet     [NSString stringWithFormat:@"%@%@",API_HOST,@"/wallet/propertyWallet"]

/**获取用户选择的小区是否是默认小区接口*/
#define HK_districtInfo_getDefaultproperty     [NSString stringWithFormat:@"%@%@",API_HOST,@"/districtInfo/getDefaultproperty"]

/**获取问卷信息接口*/
#define HK_question_getQuestionInfo     [NSString stringWithFormat:@"%@%@",API_HOST,@"/question/getQuestionInfo"]

/**提交问卷接口*/
#define HK_question_submitQuestionInfo     [NSString stringWithFormat:@"%@%@",API_HOST,@"/question/submitQuestionInfo"]

/**获取收藏社区头条信息接口*/
#define HK_districtInfo_getCollectNoticeAnnounce     [NSString stringWithFormat:@"%@%@",API_HOST,@"/districtInfo/getCollectNoticeAnnounce"]


#pragma mark－－－－－－－－－－－－－－－－－－－京东模块－－－－－－－－－－－－－－－－－－
/**获取物流信息*/
#define HK_JD_jdOrder_orderTrack   [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdOrder/orderTrack"]
/**京东商品评价*/
#define HK_JD_jdGoodsEvaluate_addGoodsEvaluate  [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdGoodsEvaluate/addGoodsEvaluate"]
/**售后申请列表*/
#define HK_JD_jdAfterSellApply_getOrderList  [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdAfterSellApply/getOrderList"]
/**提交售后申请*/
#define HK_JD_jdAfterSellApply_addApply  [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdAfterSellApply/addApply"]

/** 售后记录列表*/
#define HK_jdAfterSellApply_getJdAfterSellApplyList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdAfterSellApply/getJdAfterSellApplyList"]

/** 获取京东售后详情*/
#define HK_jdAfterSellApply_getJdAfterSellApplyDetail      [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdAfterSellApply/getJdAfterSellApplyDetail"]
/** 获取京东发票详情*/
#define HK_jdOrder_ggetInvoiceList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdOrder/getInvoiceList"]
/** JD1级商品分类列表接口/jdProductCategory/getCategory */
#define HK_JDCategory_getFirstCategoryList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdProductCategory/getCategory"]

/**根据订单号、商品编号查询支持的商品返回京东方式*/
#define HK_JD_jdReturnOrder_getWareReturnJdComp  [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdReturnOrder/getWareReturnJdComp"]

/**根据订单号、商品编号查询支持的服务类型*/
#define HK_JD_jdReturnOrder_getCustomerExpectComp  [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdReturnOrder/getCustomerExpectComp"]

/** JD2级以及3级商品分类列表接口 */
#define HK_JDCategory_getSecondCategoryList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdProductCategory/getCategorySecond"]
/** JD广告列表 jdAdvert/advertList*/
#define HK_JDadvert_advertList      [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdAdvert/advertList"]

/**获取商品评价列表 */
#define HK_jdGoodsEvaluate_goodsEvaluationList     [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdGoodsEvaluate/goodsEvaluationList"]

/** 取消服务单/客户放弃 */
#define HK_jdAfterSellApply_auditCancel     [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdAfterSellApply/auditCancel"]

/** 填写客户发运信息 */
#define HK_jdAfterSellApply_updateSendSku    [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdAfterSellApply/updateSendSku"]

/** 修改订单状态接口 **/ //groupGoods/changeGroupOrderStatus
#define HK_jdOrder_confirmReceived [NSString stringWithFormat:@"%@%@",API_HOST,@"/jdOrder/confirmReceived"]

#endif
