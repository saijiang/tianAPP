//
//  UserInfoViewController.m
//  LankeProject
//
//  Created by Justin on 2016/12/13.
//  Copyright © 2016年 张涛. All rights reserved.
//

#import "UserInfoViewController.h"
#import "ModifyPasswordViewController.h"
//修改手机号
#import "ChangePhoneNumberFirstViewController.h"
#import "ChangePhoneNumberSecondViewController.h"
#import "LKBottomButton.h"
#import "AddressViewController.h"
#import "ModyNickNameViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <ImageIO/ImageIO.h>


@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSArray *tableArray;
    NSArray *tableArray1;
    
}
@property (nonatomic, strong) UITableView *tableCtrl;

@property (nonatomic ,strong) id personInfo;

@end

@implementation UserInfoViewController


-(void)getUserInfo
{
    [UserServices
     getUserInfoWithuserId:[KeychainManager readUserId]
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             NSDictionary *data=responseObject[@"data"];
             self.personInfo = data;
             tableArray1 = @[@[data[@"headImage"]],@[data[@"userName"],data[@"nickName"],data[@"mobileNum"],@"",@"",]];
             [self.tableCtrl reloadData];
         }
         
         
     }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    tableArray = @[@[@"用户头像"],@[@"姓名",@"昵称",@"已绑定手机号",@"修改密码",@"收货地址管理",]];
    tableArray1 = @[@[[KeychainManager readHeadImage]],@[[KeychainManager readUserName],[KeychainManager readNickName],[KeychainManager readMobileNum],@"",@"",]];
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [self showNavBarCustomByTitle:@"个人信息"];
    [self.view addSubview:self.tableCtrl];
}

-(UITableView *)tableCtrl
{
    if (!_tableCtrl)
    {
        self.tableCtrl = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEF_SCREEN_WIDTH, DEF_CONTENT) style:UITableViewStyleGrouped];
        self.tableCtrl.delegate = self;
        self.tableCtrl.dataSource = self;
        self.tableCtrl.tableFooterView = [self tableFooterView];

    }
    return _tableCtrl;
}

- (UIView *) tableFooterView{
    
    CGFloat height = 150.0f;
    
    UIView * footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    footerView.frame = CGRectMake(0, 0, DEF_SCREEN_WIDTH, height);
   
    LKBottomButton * button = [LKBottomButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonHandle) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.mas_equalTo(45);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(height/4);
    }];
    return footerView;
}

- (void) buttonHandle{

    [UnityLHClass showHUDWithStringAndTime:@"保存用户信息成功"];
    NSLog(@"sb");
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 5;
    }else
    {
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 80;
    }else
    {
        return 50;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    BaseTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[BaseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        
        UILabel *leftLB = [UnityLHClass masonryLabel:tableArray[indexPath.section][indexPath.row] font:15.0 color:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
        [cell addSubview:leftLB];
        
        UIImageView *rightArrow = [[UIImageView alloc] init];
        rightArrow.image = [UIImage imageNamed:@"UserCenter-RightArrow"];
        [cell addSubview:rightArrow];
        
        [leftLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.left.mas_equalTo(cell.mas_left).offset(10);
            make.width.mas_equalTo(cell.mas_width).multipliedBy(0.3);
        }];
        
        [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.right.mas_equalTo(cell.mas_right).offset(-10);
            make.width.offset(8);
            make.height.offset(15);
        }];
        
        UIImageView *userImage = [[UIImageView alloc] init];
        userImage.layer.masksToBounds=YES;
        userImage.layer.cornerRadius=50/2.0;
        userImage.tag=10;
        [cell addSubview:userImage];
        [userImage sd_setImageWithURL:[NSURL URLWithString:[KeychainManager readHeadImage]] placeholderImage:[UIImage imageNamed:@"detault_user_icon"]];
        [userImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(rightArrow.mas_left).offset(-15);
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.height.and.width.mas_equalTo(50);
        }];
        
        UILabel *centerLB = [UnityLHClass masonryLabel:tableArray1[indexPath.section][indexPath.row] font:15.0 color:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]];
        centerLB.tag=11;
        [cell addSubview:centerLB];
        
        [centerLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.right.mas_equalTo(rightArrow.mas_left).offset(-10);
        }];
        
        userImage.hidden = indexPath.section != 0;
        centerLB.hidden = indexPath.section == 0;
        rightArrow.hidden = indexPath.section == 1 && indexPath.row == 0;

    }
    if (indexPath.section==0)
    {
        UIImageView *userImage=[cell viewWithTag:10];
        [userImage sd_setImageWithURL:[NSURL URLWithString:self.personInfo[@"headImage"]] placeholderImage:[UIImage imageNamed:@"detault_user_icon"]];

    }
    else
    {
        UILabel *info=[cell viewWithTag:11];
        info.text=tableArray1[indexPath.section][indexPath.row];

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    BOOL noHighLight = indexPath.section == 1 && indexPath.row == 0;
    if (noHighLight) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        //弹出ActionSheet
        
        UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [actionSheet showInView:self.view  withCompletionHandler:^(NSInteger buttonIndex)
        {
            if (buttonIndex == 0)
            {
                //判断相机是否可以使用
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    UIImagePickerController *picker =[[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    //设置是否允许编辑
                    picker.allowsEditing = YES;
                    [self presentViewController:picker animated:YES completion:^{
                        
                    }];
                }
            }
            if (buttonIndex == 1)
            {
                UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
                imagePC.allowsEditing = YES;
                imagePC.sourceType =UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                imagePC.delegate = self;
                [self presentViewController:imagePC animated:YES completion:nil];
                
            }

        }];
        
    }else
    {
        switch (indexPath.row)
        {
            case 0:
                {
                    //不可点击
                }
                break;
            case 1: //昵称
                {
                    ModyNickNameViewController *nickName = [[ModyNickNameViewController alloc] init];
                    [self.navigationController pushViewController:nickName animated:YES];
                }
                break;
            case 2: //已绑定手机号
                {
                    ChangePhoneNumberFirstViewController *change = [[ChangePhoneNumberFirstViewController alloc] init];
                    [self.navigationController pushViewController:change animated:YES];
                }
                break;
            case 3: //修改密码
                {
                    ModifyPasswordViewController *mody = [[ModifyPasswordViewController alloc] init];
                    [self.navigationController pushViewController:mody animated:YES];
                }
                break;
            case 4: //收货地址管理
                {
                    AddressViewController *address = [[AddressViewController alloc] init];
                    [self.navigationController pushViewController:address animated:YES];
                }
                break;

                
            default:
                break;
        }
    }
}
#pragma mark - 照片选取
//点击取消的时候调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //模态消失
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
//完成选择图片的时候调用的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image=[[UIImage alloc]init];
    if (picker.allowsEditing == YES) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }else
    {
        image=[info objectForKey:UIImagePickerControllerOriginalImage];
        
    }
    //对照片进行裁剪 防止照片过大
    UIGraphicsBeginImageContext(CGSizeMake(300,300));
    [image drawInRect:CGRectMake(0, 0, 300, 300)];
    image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"image.png"]];   // 保存文件的名称
    [UIImagePNGRepresentation(image)writeToFile: filePath  atomically:YES];
    //    [KAPPDELEGATE hiddenTabbar:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //调接口，更新用户头像
    //    headerImageView.image = image;
    
    NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:assetURL
             resultBlock:^(ALAsset *asset) {
                 NSDictionary* imageMetadata = [[NSMutableDictionary alloc] initWithDictionary:asset.defaultRepresentation.metadata];
                 
                 
                 NSDictionary *GPS = [imageMetadata objectForKey:(NSString *)kCGImagePropertyGPSDictionary];
                 NSLog(@"－－－－－－－－%@",GPS);//地理位置信息
                 NSLog(@"%@",imageMetadata);
                 
             }
            failureBlock:^(NSError *error) {
            }];
    
    [self updateHeaderImageWithImage:image];
    
}
#pragma mark -- 更新用户图像
-(void)updateHeaderImageWithImage:(UIImage *)image
{
   [UserServices
    updateUserInfoWithuserId:[KeychainManager readUserId]
    headImage:image
    nickName:[KeychainManager readNickName]
    completionBlock:^(int result, id responseObject)
    {
        if (result==0)
        {
            [self getUserInfo];
        }
        else
        {
            
            [UnityLHClass showHUDWithStringAndTime:responseObject[@"msg"]];
            
        }
       
   }];
}

@end
