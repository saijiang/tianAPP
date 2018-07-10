//
//  SelectedPhotoView.m
//  图片选择
//
//  Created by itman on 15/10/19.
//  Copyright (c) 2015年 zhangtao. All rights reserved.
//
#define kmarginX    15 //第一张图片坐标
#define kmarginy    10 //第一张图片坐标
#define deleImageWH 25 //删除按钮的宽高
#define kAdeleImage @"shopping_delete" //删除按钮图片
#define kAddImage @"photo_add" //添加按钮图片

#import "SelectedPhotoView.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "UIButton+WebCache.h"
@interface SelectedPhotoView()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    // 标识被编辑的按钮 -1 为添加新的按钮
    NSInteger editTag;
    //
    
}
@end

@implementation SelectedPhotoView

#pragma mark---图片浏览功能
-(instancetype)initWithFrame:(CGRect)frame withImageArr:(NSArray*)imageArr
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.images=[imageArr mutableCopy];
        for (int i=0; i<self.images.count; i++)
        {
            
            UIButton *btn = [self createButtonWithImage:imageArr[i] andSelector:@selector(photoScan:)];
            [self addSubview:btn];
        }
        
        
    }
    return self;
}
// 根据图片url或者图片创建一个新的显示控件
- (UIButton *)createButtonWithImage:(id)imageNameOrImage andSelector : (SEL)selector
{
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.layer.cornerRadius = 5.0;
    addBtn.layer.masksToBounds = YES;
    if ([imageNameOrImage isKindOfClass:[UIImage class]])
    {
        
        [addBtn setImage:imageNameOrImage forState:UIControlStateNormal];
    }
    else
    {
        [addBtn sd_setImageWithURL:[NSURL URLWithString:imageNameOrImage] forState:UIControlStateNormal];
    }
    
    [addBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    addBtn.tag = self.subviews.count;
    return addBtn;
}

-(void)photoScan:(UIButton *)btn
{
    [self scanPhotoWithImageUrlArr:self.images withCurrentPhotoIndex:btn.tag];
}

#pragma mark---图片选择上传功能
- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        UIButton *btn = [self createButtonWithImage:kAddImage andSeletor:@selector(addNew:)];
        [self addSubview:btn];
        if (![QBImagePickerController isAccessible]) {
            NSLog(@"Error: Source is not accessible.");
        }
        
    }
    return self;
}
#pragma mark--回调图片数组
-(void)selectedPhotoArrBlock:(selectedPhotoBlock )imageArrayBlock
{
    self.selectedPhoto=[imageArrayBlock copy];
}
#pragma mark--图片浏览
-(void)scanPhotoWithImageUrlArr:(NSArray*)imageArr withCurrentPhotoIndex:(int)currentPhotoIndex
{
    NSMutableArray *broArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [imageArr count]; i++) {
        MJPhoto *photo = [[MJPhoto alloc]init];
        UIButton *btn=(UIButton*)self.subviews[i];
        photo.image = btn.imageView.image;
        photo.srcImageView = btn.imageView;
        [broArray addObject:photo];
    }
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = currentPhotoIndex; // 弹出相册时显示的第一张图片是？
    browser.photos = broArray; // 设置所有的图片
    [browser show];
    
}
-(NSMutableArray *)images
{
    if (_images == nil)
    {
        _images = [NSMutableArray array];
        
    }
    return _images;
}
-(int)maxColumn
{
    if (!_maxColumn)
    {
        _maxColumn=3;
    }
    return _maxColumn;
}
-(int)maxImageCount
{
    if (!_maxImageCount)
    {
        _maxImageCount=9;
    }
    return _maxImageCount;
}
// 添加新的控件
- (void)addNew:(UIButton *)btn
{
    // 标识为添加一个新的图片
    
    if (![self deleClose:btn])
    {
        editTag = -1;
        [self callImagePicker];
        
    }
}
// 修改旧的控件
- (void)changeOld:(UIButton *)btn
{
    // 标识为修改(tag为修改标识)
    if (![self deleClose:btn])
    {
        editTag = btn.tag;
        [self callImagePicker];
        
    }
}
// 删除"删除按钮"
- (BOOL)deleClose:(UIButton *)btn
{
    if (btn.subviews.count == 2)
    {
        [[btn.subviews lastObject] removeFromSuperview];
        [self stop:btn];
        
        return YES;
        
    }
    
    return NO;
}
// 调用图片选择器
- (void)callImagePicker
{
    
    if (editTag!=-1)
    {
        if (self.images.count==0)
        {
            UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照替换",@"从手机相册替换",@"预览", nil];
            [actionSheet showInView:self];
        }
        else
        {
            UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照替换",@"从手机相册替换",@"预览", nil];
            
            [actionSheet showInView:self];
        }
      
        
        
    }
    else
    {
        if (self.images.count<self.maxImageCount)
        {
            
            UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
              actionSheet.tag=100;
            [actionSheet showInView:self];
            
            
        }
        else
        {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"最多只能可以上传%ld张图片！",(long)self.maxImageCount] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            
        }
        
    }
    
}
//从相册选择
-(void)LocalPhoto
{
    
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = self.maxImageCount-(self.images.count);
    if (editTag!=-1)
    {
        imagePickerController.maximumNumberOfSelection=1;
    }
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self.window.rootViewController presentViewController:navigationController animated:YES completion:NULL];
}
//拍照
-(void)takePhoto
{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        
        [self.window.rootViewController presentViewController:picker animated:YES completion:^(void){}];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"摄像机不可用！"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
#pragma mark - QBImagePickerControllerDelegate

#pragma mark---单张选择
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    [imagePickerController.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark---多张选择
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    
    [imagePickerController.navigationController dismissViewControllerAnimated:YES completion:NULL];
    for (int i=0; i<assets.count; i++) {
        UIImage *getimage=  [self fullResolutionImageFromALAsset:assets[i]];
        if (editTag == -1)
        {
            // 创建一个新的控件
            UIButton *btn = [self createButtonWithImage:getimage andSeletor:@selector(changeOld:)];
            UIButton *btn1 = (UIButton *)[self.subviews lastObject];
            btn.frame=btn1.frame;
            [self insertSubview:btn atIndex:self.subviews.count - 1];
            [self.images addObject:getimage];
            if (self.subviews.count - 1 == self.maxImageCount)
            {
                [[self.subviews lastObject] setHidden:YES];
                
            }
        }
        else
        {
            // 根据tag修改需要编辑的控件
            UIButton *btn = (UIButton *)[self viewWithTag:editTag];
            NSInteger index = [self.images indexOfObject:[btn imageForState:UIControlStateNormal]];
            [self.images removeObjectAtIndex:index];
            [btn setImage:getimage forState:UIControlStateNormal];
            [self.images insertObject:getimage atIndex:index];
        }
        
    }
    
    
    if ([self.delegate respondsToSelector:@selector(selectedImageArrayWith:)]) {
        
        [self.delegate selectedImageArrayWith:self.images];
    }
    
    if (self.selectedPhoto )
    {
        self.selectedPhoto(self.images);
    }
    
}
- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [imagePickerController.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
- (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset
{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef
                                       scale:assetRep.scale
                                 orientation:(UIImageOrientation)assetRep.orientation];
    return img;
}
#pragma mark---压缩图片

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

#pragma mark---- UIActionSheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;
{
    if (actionSheet.tag==100)
    {
        switch (buttonIndex)
        {
            case 0:
            {
                //拍照
                [self takePhoto];
            }
                break;
            case 1:
            {
                //从本地获取
                [self LocalPhoto];
                
            }
                break;
            default:
                break;
        }

    }
    else
    {
        switch (buttonIndex)
        {
            case 0:
            {
                //拍照
                [self takePhoto];
            }
                break;
            case 1:
            {
                //从本地获取
                [self LocalPhoto];
                
            }
                break;
            case 2:
            {
                //预览
                if (self.images.count==0)
                {
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"请选择图片后预览！"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                {
                    if (editTag == -1)
                    {
                        [self scanPhotoWithImageUrlArr:self.images withCurrentPhotoIndex:0];
                    }
                    else
                    {
                        [self scanPhotoWithImageUrlArr:self.images withCurrentPhotoIndex:(editTag-1)];
                    }
                    
                    
                }
            }
                break;
            default:
                break;
        }

    }
}

// 根据图片名称或者图片创建一个新的显示控件
- (UIButton *)createButtonWithImage:(id)imageNameOrImage andSeletor : (SEL)selector
{
    UIImage *addImage = nil;
    if ([imageNameOrImage isKindOfClass:[NSString class]])
    {
        addImage = [UIImage imageNamed:imageNameOrImage];
        
    }
    else if([imageNameOrImage isKindOfClass:[UIImage class]])
    {
        addImage = imageNameOrImage;
        
    }
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [addBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    addBtn.tag = self.subviews.count;
    // 添加长按手势,用作删除.加号按钮不添加
    if(addBtn.tag != 0)
    {
        [addBtn setImage:addImage forState:UIControlStateNormal];
        UILongPressGestureRecognizer *gester = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [addBtn addGestureRecognizer:gester];
    }
    else
    {
        [addBtn setBackgroundImage:addImage forState:UIControlStateNormal];
    }
    return addBtn;
}
// 长按添加删除按钮
- (void)longPress : (UIGestureRecognizer *)gester
{
    if (gester.state == UIGestureRecognizerStateBegan)
    {
        UIButton *btn = (UIButton *)gester.view;
        UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
        dele.bounds = CGRectMake(0, 0, deleImageWH, deleImageWH);
        [dele setImage:[UIImage imageNamed:kAdeleImage] forState:UIControlStateNormal];
        [dele addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
        dele.frame = CGRectMake(btn.frame.size.width - dele.frame.size.width, 0, dele.frame.size.width, dele.frame.size.height);
        [btn addSubview:dele];
        [self start : btn];
    }
}
// 长按开始抖动
- (void)start : (UIButton *)btn
{
    double angle1 = -5.0 / 180.0 * M_PI;
    double angle2 = 5.0 / 180.0 * M_PI;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.values = @[@(angle1),  @(angle2), @(angle1)];
    anim.duration = 0.25;
    // 动画的重复执行次数
    anim.repeatCount = MAXFLOAT;
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [btn.layer addAnimation:anim forKey:@"shake"];
}
// 停止抖动
- (void)stop : (UIButton *)btn
{
    [btn.layer removeAnimationForKey:@"shake"];
    
}
// 删除图片
- (void)deletePic : (UIButton *)btn
{
    [self.images removeObject:[(UIButton *)btn.superview imageForState:UIControlStateNormal]];
    [btn.superview removeFromSuperview];
    if ([[self.subviews lastObject] isHidden])
    {
        [[self.subviews lastObject] setHidden:NO];
    }
}
// 对所有子控件进行布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger count = self.subviews.count;
    
    if (self.maxImageCount==self.images.count)
    {
        count=count-1;
    }
    
    float imageH=(self.frame.size.width-15*(self.maxColumn+1))/self.maxColumn;
    float imageW=imageH;
    
    CGFloat btnW = imageW;
    CGFloat btnH = imageH;
    int maxColumn = self.maxColumn > self.frame.size.width / imageW ? self.frame.size.width / imageW : self.maxColumn;
    CGFloat marginX = kmarginX;
    CGFloat marginY = kmarginX;
    [UIView animateWithDuration:0.5 animations:^{
        for (int i = 0; i < count; i++)
        {
            UIButton *btn = self.subviews[i];
            CGFloat btnX = (i % maxColumn) * (marginX + btnW) + marginX;
            CGFloat btnY = (i / maxColumn) * (marginY + btnH) + marginY;
            btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            self.frame= CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,btnY+btnH+marginY);
            
        }
        
    }];
    
    
}
#pragma mark - UIImagePickerController 代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (editTag == -1)
    {
        // 创建一个新的控件
        UIButton *btn = [self createButtonWithImage:image andSeletor:@selector(changeOld:)];
        UIButton *btn1 = (UIButton *)[self.subviews lastObject];
        btn.frame=btn1.frame;
        [self insertSubview:btn atIndex:self.subviews.count - 1];
        [self.images addObject:image];
        if (self.subviews.count - 1 == self.maxImageCount)
        {
            [[self.subviews lastObject] setHidden:YES];
            
        }
    }
    else
    {
        // 根据tag修改需要编辑的控件
        UIButton *btn = (UIButton *)[self viewWithTag:editTag];
        NSInteger index = [self.images indexOfObject:[btn imageForState:UIControlStateNormal]];
        [self.images removeObjectAtIndex:index];
        [btn setImage:image forState:UIControlStateNormal];
        [self.images insertObject:image atIndex:index];
    }
    // 退出图片选择控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(selectedImageArrayWith:)]) {
        
        [self.delegate selectedImageArrayWith:self.images];
    }
    
}
@end

@implementation DisplayImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        maxImagesCount = 9;
        self.maxColumn = 3;
        images = [NSMutableArray array];
        
        for (NSInteger index = 0; index < maxImagesCount; index ++) {
            LKNetworkImageView * image = [[LKNetworkImageView alloc] init];
            image.placeholderImage = [UIImage imageNamed:@"default_dishes"];
            [images addObject:image];
            [self addSubview:image];
        }
    }
    return self;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    CGFloat width = (CGRectGetWidth(self.bounds) - (self.maxColumn - 1) * self.margin_h)/self.maxColumn;
    
    for (NSInteger index = 0; index < maxImagesCount; index ++) {

        UIView * imageView = [images objectAtIndex:index];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make){
//            make.left.mas_equalTo(15);
        }];
    }
}

- (void)configImages:(NSArray *)images{

    
    
}

@end
