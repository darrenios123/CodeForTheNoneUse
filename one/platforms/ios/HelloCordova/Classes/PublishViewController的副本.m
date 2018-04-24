//
//  PostFiendViewController.m
//  mytest
//
//  Created by 易云时代 on 2017/7/20.
//  Copyright © 2017年 笑伟. All rights reserved.
//

#import "PublishViewController.h"
#import "ZYQAssetPickerController.h"
#import "LoginViewController.h"
#import "SVProgressHUD.h"

@interface PublishViewController ()<ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    UIView               *_editv;
    UIButton             *_addPic;
    NSMutableArray       *_imageArray;
    NSArray *arr;
    UIButton *button;
    
    UIScrollView * scroll;
}

@property(nonatomic,strong)UITextView * freekTextView;
@property(nonatomic,strong)UILabel * numberOfWord;

@end

@implementation PublishViewController


#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString: @"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if (str.length > 250)
    {
        textView.text = [textView.text substringToIndex:250];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    //把空字符串替换掉,空格不许提交
    NSString *feedbackString = [self.freekTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    if ([feedbackString length] > 0) {
    //        self.navigationItem.rightBarButtonItem.enabled = YES;
    //    }else
    //    {
    //        self.navigationItem.rightBarButtonItem.enabled = NO;
    //    }
    
    
    
    
    
    
    if (textView.text.length > 250)
    {
        textView.text = [textView.text substringToIndex:250];
    }
    self.numberOfWord.text = [NSString stringWithFormat:@"还可输入%lu字",250-textView.text.length];
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    if ([AVUser currentUser]!=nil) {
        
    }else{
        [self presentViewController:[[LoginViewController alloc]init] animated: YES completion:^{
            
        }];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scroll = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scroll.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:scroll];
    
    
    self.freekTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, SCREEN_HEIGHT/3)];
    self.freekTextView.delegate = self;
    self.freekTextView.backgroundColor = [UIColor clearColor];
    self.freekTextView.layer.borderWidth = 0.5f;
    self.freekTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [scroll addSubview:self.freekTextView];
    
    
    self.numberOfWord = [[UILabel alloc]initWithFrame: CGRectMake(SCREEN_WIDTH-150-20, SCREEN_HEIGHT/3-20, 150, 20)];
    self.numberOfWord.textColor = [UIColor lightGrayColor];
    self.numberOfWord.text = @"还可以输入250字";
    self.numberOfWord.font = [UIFont systemFontOfSize:14.0f];
    self.numberOfWord.textAlignment = NSTextAlignmentRight;
    [self.freekTextView addSubview:self.numberOfWord];
    
    _imageArray = [NSMutableArray array];
    _editv = [[UIView alloc] initWithFrame:CGRectMake(10, 20+SCREEN_HEIGHT/3, SCREEN_WIDTH-20, 0)];
    _editv.layer.borderWidth = 0.5f;
    _editv.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _addPic = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addPic setImage:[UIImage imageNamed:@"AlbumAddBtn"] forState:UIControlStateNormal];
    _addPic.frame = CGRectMake(15, 10, 60, 60);
    [_addPic addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    _editv.frame = CGRectMake(15, 20+SCREEN_HEIGHT/3, SCREEN_WIDTH-15*2, CGRectGetMaxY(_addPic.frame)+20);
    [_editv addSubview:_addPic];
    
    [scroll addSubview:_editv];
    
    button=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120)/2, SCREEN_HEIGHT/3+50+CGRectGetMaxY(_addPic.frame)+20, 120, 40)];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    button.layer.cornerRadius = button.frame.size.height*0.5;
    button.backgroundColor = RGBCOLOR(238, 59, 59);
    [button addTarget:self action:@selector(pushSec) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:button];
    
}
-(void)pushSec{
    AVObject * object = [AVObject objectWithClassName:@"userTimeLine"];
    [object setObject:[AVUser currentUser] forKey:@"owner"];
    [object setObject:self.freekTextView.text forKey:@"abs"];
    [SVProgressHUD showWithStatus:@"正在发表"];
    NSMutableArray * array = [NSMutableArray array];
    for (UIImage *image in _imageArray) {
        NSData * data = nil;
        if (UIImagePNGRepresentation(image)) {
            //返回为png图像。
            data = UIImagePNGRepresentation(image);
        }else {
            //返回为JPEG图像。
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        AVFile *file = [AVFile fileWithData:data];
        
        [file uploadWithCompletionHandler:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:file.url,@"image_url",image.size.width,@"image_width",image.size.height,@"image_height", nil];
                [array addObject:dic];
            }else{
                [SVProgressHUD showErrorWithStatus:error.description];
            }
        }];
    }
    [object setObject:array forKey:@"imageArray"];
    
    [object saveEventually:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [SVProgressHUD showSuccessWithStatus:@"发表成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:error.description];
        }
    }];
}
-(void)click{
    
    ZYQAssetPickerController *pickerController = [[ZYQAssetPickerController alloc] init];
    pickerController.maximumNumberOfSelection = 8;
    //    pickerController.nowCount = _imageArray.count;
    pickerController.assetsFilter = ZYQAssetsFilterAllAssets;
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
                               }
                               if(_imageArray.count >8){
                                   NSLog(@"超了");
                               }else{
                                   [_imageArray addObject:result];
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [self nineGrid];
                                   });
                               }
                               
                               NSLog(@"---%ld",_imageArray.count);
                               
                               
                           }];
                           
                       }
                       NSLog(@"现在剩余是多少%ld",_imageArray.count);
                   });
}
// 删除照片
- (void)deleteEvent:(UIButton *)sender
{
    UIButton *btn = (UIButton *)sender;
    [_imageArray removeObjectAtIndex:btn.tag-10];
    
    [self nineGrid];
    
    if (_imageArray.count == 0)
    {
        _addPic.frame = CGRectMake(15, 10, 60, 60);
        _editv.frame = CGRectMake(15, 20+SCREEN_HEIGHT/3, SCREEN_WIDTH-15*2, CGRectGetMaxY(_addPic.frame)+20);
        button.frame = CGRectMake((SCREEN_WIDTH-120)/2, SCREEN_HEIGHT/3+50+CGRectGetMaxY(_addPic.frame)+20, 120, 40);
    }
}
// 9宫格图片布局
- (void)nineGrid
{
    NSLog(@"九宫格%ld",_imageArray.count);
    for (UIImageView *imgv in _editv.subviews)
    {
        if ([imgv isKindOfClass:[UIImageView class]]) {
            [imgv removeFromSuperview];
        }
    }
    
    CGFloat width = 60;
    CGFloat widthSpace = (SCREEN_WIDTH - 15*4 - 60*4) / 3.0;
    CGFloat heightSpace = 10;
    
    NSInteger count = _imageArray.count;
    _imageArray.count > 9 ? (count = 9) : (count = _imageArray.count);
    
    for (int i=0; i<count; i++)
    {
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(15+(width+widthSpace)*(i%4), (i/4)*(width+heightSpace) + 10, width, width)];
        imgv.image = _imageArray[i];
        imgv.userInteractionEnabled = YES;
        [_editv addSubview:imgv];
        
        UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
        delete.frame = CGRectMake(width-16, -5, 16, 16);
        //        delete.backgroundColor = [UIColor greenColor];
        [delete setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [delete addTarget:self action:@selector(deleteEvent:) forControlEvents:UIControlEventTouchUpInside];
        delete.tag = 10+i;
        [imgv addSubview:delete];
        
        if (i == _imageArray.count - 1)
        {
            if (_imageArray.count % 4 == 0) {
                _addPic.frame = CGRectMake(15, CGRectGetMaxY(imgv.frame) + heightSpace, 60, 60);
            } else {
                _addPic.frame = CGRectMake(CGRectGetMaxX(imgv.frame) + widthSpace, CGRectGetMinY(imgv.frame), 60, 60);
            }
            
            _editv.frame = CGRectMake(15, 20+SCREEN_HEIGHT/3, SCREEN_WIDTH-15*2, CGRectGetMaxY(_addPic.frame)+20);
            button.frame = CGRectMake((SCREEN_WIDTH-120)/2, SCREEN_HEIGHT/3+50+CGRectGetMaxY(_addPic.frame)+20, 120, 40);
        }
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
