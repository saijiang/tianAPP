//
//  JDInvoiceDetailViewController.m
//  LankeProject
//
//  Created by zhounan on 2018/1/15.
//  Copyright © 2018年 张涛. All rights reserved.
//

#import "JDInvoiceDetailViewController.h"
#import "JDInvoiceDetailCell.h"
#import <QuickLook/QuickLook.h>

@interface JDInvoiceDetailViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,NSURLSessionDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate>
/**总数据*/
@property(nonatomic,strong) NSMutableData *data;
/**总长度*/
@property(nonatomic,assign)NSInteger totalLength;
@property(nonatomic,assign)NSString*filename;
@property(nonatomic,strong)NSString*urlStr;
@property(nonatomic,strong)NSString*ivcNo;
// 浏览
@property (strong, nonatomic) QLPreviewController * qlpreView;
@property(nonatomic,strong)UITableView *tableCtrl;
@property(nonatomic,strong)NSMutableArray *arrayData;

@end

@implementation JDInvoiceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"发票";
    self.arrayData=[NSMutableArray array];
    [self createData];

}
-(void)createData
{
    //团购商品详情
    [UserServices
     jdgetInvoiceListDetailWithjdOrderId:self.jdOrderId
     completionBlock:^(int result, id responseObject)
     {
         if (result==0)
         {
             self.arrayData=responseObject[@"data"];
             [self.tableCtrl reloadData];
             
         }
     }];
}
-(void)createUI
{
    _tableCtrl = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, DEF_SCREEN_HEIGHT, DEF_CONTENT) style:UITableViewStylePlain];
    _tableCtrl.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableCtrl.delegate = self;
    _tableCtrl.dataSource = self;
    _tableCtrl.emptyDataSetSource = self;
    _tableCtrl.backgroundColor=self.contentView.backgroundColor;
    [self addSubview:_tableCtrl];
 
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data=self.arrayData[indexPath.row];
    JDInvoiceDetailCell *cell=[JDInvoiceDetailCell cellWithTableView:tableView];
   
    [cell loadCellWithDataSource:data];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self withUrlStr:self.arrayData[indexPath.row][@"fileUrl"] withIvcNo:self.arrayData[indexPath.row][@"ivcNo"]];
//    PDFInvoiceViewController*pdfVC=[[PDFInvoiceViewController alloc]init];
//    pdfVC.urlStr=self.arrayData[indexPath.row][@"fileUrl"];
//    pdfVC.ivcNo=self.arrayData[indexPath.row][@"ivcNo"];
//
//    [self.navigationController pushViewController:pdfVC animated:YES];
}
-(void)withUrlStr:(NSString*)urlStr withIvcNo:(NSString*)ivcNo
{
    self.ivcNo=ivcNo;
    self.urlStr=urlStr;
    NSString *str=@".pdf";
    self.filename=[NSString stringWithFormat:@"%@%@",self.ivcNo,str];
    
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:self.filename];
    
    if(![fileManager fileExistsAtPath:filePath])
    {
        NSLog(@"文件不存在");
    }else{
        NSLog(@"文件存在");
    }
    
    // 下载网址  我这个是假的
    NSURL *url = [NSURL URLWithString:self.urlStr];
    
    //创建管理类NSURLSessionConfiguration
    NSURLSessionConfiguration *config =[NSURLSessionConfiguration defaultSessionConfiguration];
    
    //初始化session并制定代理
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:url];
    
    // 开始
    [task resume];

}

#pragma mark ====  下载用到的 代理方法
#pragma mark *下载完成调用
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error{
    NSLog(@"%@",[NSThread currentThread]);
    //将下载后的数据存入文件(firstObject 无数据返回nil，不会导致程序崩溃)
    
    NSString *destPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *str=@".pdf";
    self.filename=[NSString stringWithFormat:@"%@%@",self.ivcNo,str];
    //destPath = [destPath stringByAppendingPathComponent:@"my.zip"];
    destPath = [destPath stringByAppendingPathComponent:self.filename];
    
    NSLog(@"ccc  %@",destPath);
    
    //将下载的二进制文件转成入文件
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDownLoad =  [manager createFileAtPath:destPath contents:self.data attributes:nil];
    
    if (isDownLoad) {
        NSLog(@"OK");
    }else{
        NSLog(@"Sorry");
    }
    //    NSLog(@"下载完成");
    [NSTimer scheduledTimerWithTimeInterval:0.01
     
                                    target:self
     
                                  selector:@selector(hideRightButton)
     
                                  userInfo:nil
     
                                   repeats:YES];
    self.qlpreView = [[QLPreviewController alloc]init];
    
    self.qlpreView.view.frame = self.view.bounds;
    self.qlpreView.delegate= self;
    
    self.qlpreView.dataSource = self;
    self.navigationController.navigationItem.leftBarButtonItem=nil;
    [self.navigationController pushViewController:self.qlpreView animated:YES];
}
- (void)hideRightButton{
    
    [[self.qlpreView navigationItem] setLeftBarButtonItem:nil animated:NO];
    
}

#pragma mark  ====  接收到数据调用
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
    //允许继续响应
    completionHandler(NSURLSessionResponseAllow);
    //获取文件的总大小
    self.totalLength = response.expectedContentLength;
}


#pragma mark  ===== 接收到数据调用
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    
    //将每次接受到的数据拼接起来
    [self.data appendData:data];
    //计算当前下载的长度
    NSInteger nowlength = self.data.length;
    //  可以用些 三方动画
    //    CGFloat value = nowlength*1.0/self.totalLength;
}



#pragma mark =======  QLPreviewController  代理
#pragma mark ==== 返回文件的个数
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1;
}

#pragma mark ==== 即将要退出浏览文件时执行此方法
- (void)previewControllerWillDismiss:(QLPreviewController *)controller {
}




#pragma mark ===== 在此代理处加载需要显示的文件
- (NSURL *)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    
    //    获取指定文件 路径
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSString *str=@".pdf";
    self.filename=[NSString stringWithFormat:@"%@%@",self.ivcNo,str];
    NSURL *storeUrl = [NSURL fileURLWithPath: [docDir stringByAppendingPathComponent:self.filename]];
    
    return storeUrl;
}


//懒加载
-(NSMutableData *)data{
    if (_data == nil) {
        _data = [NSMutableData data];
    }
    return _data;
}

#pragma mark DZNEmptyDataSetSource,DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    return [UIImage imageNamed:@"none_order_default"];
}

- (CGPoint) offsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    return CGPointMake(0, -100);
}

- (CGFloat) spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    
    return 30;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂无数据";
    return [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:18.0], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#545454"]}];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
