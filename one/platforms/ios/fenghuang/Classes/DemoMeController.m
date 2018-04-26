//
//  DemoMeController.m
//  XBSettingControllerDemo
//
//  Created by XB on 15/9/23.
//  Copyright © 2015年 XB. All rights reserved.
//

#import "DemoMeController.h"
#import "XBMeHeaderView.h"
#import "XBConst.h"
#import "XBSettingCell.h"
#import "XBSettingItemModel.h"
#import "XBSettingSectionModel.h"
#import <AVFoundation/AVFoundation.h>
#import <UShareUI/UShareUI.h>
#import "LoginViewController.h"
#import "ZYQAssetPickerController.h"

@interface DemoMeController ()<XBMeHeaderViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL isOpen;
    XBMeHeaderView *header;
}


@property (nonatomic,strong) NSArray  *sectionArray; /**< section模型数组*/
@end

@implementation DemoMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton* rightBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"登录"] forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem* rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationItem setRightBarButtonItem:rightBtnItem animated:YES];
    
    self.view.backgroundColor = XBMakeColorWithRGB(234, 234, 234, 1);
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self setupSections];
    
    header= [[[NSBundle mainBundle]loadNibNamed:@"XBMeHeaderView" owner:nil options:nil] firstObject];
    header.delegate = self;
    header.header.image = [UIImage imageNamed:@"touxiang.jpg"];
    self.tableView.tableHeaderView = header;
}

-(void)rightAction:(id)sender{
    if ([AVUser currentUser]==nil) {
        [self presentViewController:[[LoginViewController alloc]init] animated: YES completion:^{}];
    }else{
        [self showAlert:@"登录" andMessage:@"您已经登录或自动登录了"];
    }
}

- (void)setupSections
{
    
    //************************************section1
    XBSettingItemModel *item1 = [[XBSettingItemModel alloc]init];
    item1.funcName = @"给我们打分";
    item1.executeCode = ^{
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:APPSTOREURL]];
    };
    item1.img = [UIImage imageNamed:@"icon-list01"];
    item1.detailText = @"跳转到APP STORE";
    item1.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    
    XBSettingItemModel *item2 = [[XBSettingItemModel alloc]init];
    item2.funcName = @"手电筒";
    item2.img = [UIImage imageNamed:@"icon-list01"];
    item2.accessoryType = XBSettingAccessoryTypeSwitch;
    item2.switchValueChanged = ^(BOOL isOn)
    {
        Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
        if (captureDeviceClass != nil) {
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            if ([device hasTorch]) { // 判断是否有闪光灯
                [device lockForConfiguration:nil];
                if (isOpen == 0) {
                    isOpen = 1;
                    [device setTorchMode:AVCaptureTorchModeOn]; // 手电筒开
                }else{
                    isOpen = 0;
                    [device setTorchMode:AVCaptureTorchModeOff]; // 手电筒关
                }
                // 请求解除独占访问硬件设备
                [device unlockForConfiguration];
            }
        }
    };
    
    XBSettingItemModel *item3 = [[XBSettingItemModel alloc]init];
    item3.funcName = @"退出登录";
    item3.img = [UIImage imageNamed:@"icon-list01"];
    item3.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item3.executeCode = ^{
        if ([AVUser currentUser] !=nil) {
            [AVUser logOut];
            [self showAlert:@"退出登录" andMessage:@"退出登录成功！"];
        }else{
            [self showAlert:@"退出登录" andMessage:@"您还未登录！可以点击右上角登录"];
        }
    };
    
    XBSettingItemModel *item4 = [[XBSettingItemModel alloc]init];
    item4.funcName = @"分享应用";
    item4.img = [UIImage imageNamed:@"icon-list01"];
    item4.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    item4.executeCode = ^{
        
        /* 设置友盟appkey */
        [[UMSocialManager defaultManager] setUmSocialAppkey:@"5adb3f6d8f4a9d4a500000d0"];
        
        [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxfb1760dbff68b1fa" appSecret:@"3e2f98d9cb6ce4d927ec69dda6bc3da6" redirectURL:nil];
        [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
            // 根据获取的platformType确定所选平台进行下一步操作
            //创建分享消息对象
            UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
            [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
            
            messageObject.title = @"凤凰古镇";
            messageObject.text = @"什么？你还不知道我们的应用，太OUT了，快来下载加入吧。";
            
            //分享消息对象设置分享内容对象
            messageObject.shareObject = nil;
            //调用分享接口
            [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
                if (error) {
                    UMSocialLogInfo(@"************Share fail with error %@*********",error);
                }else{
                    if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                        UMSocialShareResponse *resp = data;
                        //分享结果消息
                        UMSocialLogInfo(@"response message is %@",resp.message);
                        //第三方原始返回的数据
                        UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                        
                    }else{
                        UMSocialLogInfo(@"response data is %@",data);
                    }
                }
                NSLog(@"!!!!!!!!!!!!!!!!!!error");
            }];
        }];
    };
    
    XBSettingSectionModel *section1 = [[XBSettingSectionModel alloc]init];
    section1.sectionHeaderHeight = 18;
    section1.itemArray = @[item1,item2,item3,item4];
    
    XBSettingItemModel *item5 = [[XBSettingItemModel alloc]init];
    item5.funcName = @"帮助中心";
    item5.img = [UIImage imageNamed:@"icon-list01"];
    item5.executeCode = ^{
        NSLog(@"帮助中心");
    };
    item5.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingItemModel *item6 = [[XBSettingItemModel alloc]init];
    item6.funcName = @"清除缓存";
    item6.img = [UIImage imageNamed:@"icon-list01"];
    item6.executeCode = ^{
        [self showAlert:@"清除缓存" andMessage:@"清除缓存成功！"];
    };
    item6.accessoryType = XBSettingAccessoryTypeDisclosureIndicator;
    
    XBSettingSectionModel *section2 = [[XBSettingSectionModel alloc]init];
    section2.sectionHeaderHeight = 18;
    section2.itemArray = @[item5,item6];
    
    self.sectionArray = @[section1,section2];
}

- (void)showAlert:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}


- (void)XBMeHeaderViewBtnClicked:(XBMeHeaderViewButtonType)type{
        if ([AVUser currentUser] !=nil) {
            ZYQAssetPickerController *pickerController = [[ZYQAssetPickerController alloc] init];
            pickerController.maximumNumberOfSelection = 1;
            //    pickerController.nowCount = _imageArray.count;
            pickerController.assetsFilter = ZYQAssetsFilterAllPhotos;
            pickerController.showEmptyGroups=NO;
            pickerController.delegate=self;
            pickerController.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                if ([(ZYQAsset*)evaluatedObject mediaType]==ZYQAssetMediaTypeVideo) {
                    NSTimeInterval duration = [(ZYQAsset*)evaluatedObject duration];
                    return duration >= 5;
                } else {
                    return YES;
                }
            }];
            
            
            [self presentViewController:pickerController animated:YES completion:nil];
        }else{
            [self presentViewController:[[LoginViewController alloc]init] animated: YES completion:^{
                
            }];
        }
}

- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
                       for (int i=0; i<assets.count; i++)
                       {
                           
                           ZYQAsset *asset = assets[i];
                           
                           [asset setGetFullScreenImage:^(UIImage *result){
                               
                               if (result == nil) {
                                   NSLog(@"空空以控控");
                               }else{
                                   header.header.image = [self OriginImage:result scaleToSize:header.header.frame.size];
                                   NSData * data = nil;
                                   if (UIImagePNGRepresentation(header.header.image)) {
                                       //返回为png图像。
                                       data = UIImagePNGRepresentation(header.header.image);
                                   }else {
                                       //返回为JPEG图像。
                                       data = UIImageJPEGRepresentation(header.header.image, 1.0);
                                   }
                                   AVFile *file = [AVFile fileWithData:data];
                                   AVObject  *object = [AVObject objectWithClassName:@"User"];
                                   [object setObject:file forKey:@"touxiang"];
                                   [object saveInBackground];
                                   [file uploadWithCompletionHandler:^(BOOL succeeded, NSError *error) {
                                       NSLog(file.url);//返回一个唯一的 Url 地址
                                   }];

                               }
                           }];
                           
                       }

                   });
}

-(void)viewWillAppear:(BOOL)animated{
    AVUser *currentUser = [AVUser currentUser];
    if (currentUser != nil) {
        AVQuery *query = [AVQuery queryWithClassName:@"File"];
        [query getObjectInBackgroundWithId:currentUser.objectId block:^(AVObject *object, NSError *error) {
            
        }];
    } else {
        //缓存用户对象为空时，可打开用户注册界面…
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    XBSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.itemArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"setting";
    XBSettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    XBSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    
    XBSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[XBSettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.item = itemModel;
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    XBSettingSectionModel *sectionModel = self.sectionArray[section];
    return sectionModel.sectionHeaderHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XBSettingSectionModel *sectionModel = self.sectionArray[indexPath.section];
    XBSettingItemModel *itemModel = sectionModel.itemArray[indexPath.row];
    if (itemModel.executeCode) {
        itemModel.executeCode();
    }
}
//uitableview处理section的不悬浮，禁止section停留的方法，主要是这段代码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    XBSettingSectionModel *sectionModel = [self.sectionArray firstObject];
    CGFloat sectionHeaderHeight = sectionModel.sectionHeaderHeight;

    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}
@end
