//
//  AXRatingView.h
//

#import <UIKit/UIKit.h>

@interface AXRatingView : UIControl {
  CALayer *_starMaskLayer;
  CALayer *_highlightLayer;
  UIImage *_markImage;
}
/** 总的个数 */
@property (nonatomic) IBInspectable NSUInteger numberOfStar;

/** 使用unicode 字符来表示控件的显示样式 */
@property (copy, nonatomic  ) IBInspectable NSString *markCharacter;
/** 设置使用markCharacter时候的字体 */
@property (strong, nonatomic) IBInspectable UIFont   *markFont;

/** 使用图片来表示控件的显示样式 */
@property (strong, nonatomic) IBInspectable UIImage  *markImage;

/** 未被选中的时候的颜色 */
@property (strong, nonatomic) IBInspectable UIColor  *baseColor;
/** 被选中的时候的颜色 */
@property (strong, nonatomic) IBInspectable UIColor  *highlightColor;

/** 用于获得当前控件的值 */
@property (nonatomic) IBInspectable float value;
/** 设置滑动的时候改变的个数，不设置的时候 为0*/
@property (nonatomic) IBInspectable float stepInterval;
/** 可以设置最小值 */
@property (nonatomic) IBInspectable float minimumValue;

/** 可以使用Block来捕获该控件的值改变，也可以使用UIEvent事件进行捕获 */
typedef void(^AXRatingViewHandle)(AXRatingView *ratingView);
@property (nonatomic ,copy) AXRatingViewHandle handle;

-(void)aXRatingViewHandle:(AXRatingViewHandle)handle;
@end
