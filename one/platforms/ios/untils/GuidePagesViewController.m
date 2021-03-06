//
//  GuidePagesViewController ViewController.m
//  fenghuang
//
//  Created by Darren on 2018/4/15.
//

#import "MainViewController.h"
#import "DemoMeController.h"
#import "GuidePagesViewController.h"
#import "PublishViewController.h"
#import "HotViewController.h"
#import "UIView+JM.h"
#import "JMTabBarController.h"
#import "JMConfig.h"
#import "ZipArchive.h"

@interface GuidePagesViewController ()<UIScrollViewDelegate>{
    UIView * view;
}

@property(nonatomic ,strong) UIScrollView * mainScrollV;
@property(nonatomic ,strong) UIPageControl * pageControl;
@property(nonatomic ,strong) NSMutableArray * images;

@end

@implementation GuidePagesViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.mainScrollV];
    [self.view addSubview:self.pageControl];
    
}
-(UIScrollView *)mainScrollV{
    if (!_mainScrollV) {
        _mainScrollV = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _mainScrollV.bounces = NO;
        _mainScrollV.pagingEnabled = YES;
        _mainScrollV.showsHorizontalScrollIndicator = NO;
        _mainScrollV.delegate = self;
        _mainScrollV.contentSize = CGSizeMake(self.images.count * SCREEN_WIDTH, SCREEN_HEIGHT);
        [self addSubImageViews];
    }
    return _mainScrollV;
}
-(NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
        NSArray * imageNames = nil;
        if(!ISIPHONEX){
            imageNames = @[@"yindaoye1242*2208-1",@"yindaoye1242*2208-2",@"yindaoye1242*2208-3"];
        }else{
            imageNames = @[@"yindaoye1125*2436-1",@"yindaoye1125*2436-2",@"yindaoye1125*2436-3"];
        }
        for (NSString * name in imageNames) {
            [self.images addObject:[UIImage imageNamed:name]];
        }
    }
    return _images;
}
- (void)addSubImageViews{
    for (int i = 0; i < self.images.count; i++) {
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageV.image = self.images[i];
        [_mainScrollV addSubview:imageV];
        if (i == self.images.count - 1){//最后一张图片时添加点击进入按钮
            imageV.userInteractionEnabled = YES;
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(SCREEN_WIDTH * 0.5 - 80, SCREEN_HEIGHT * 0.85, 160, 40);
            [btn setTitle:@"跳过" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor darkGrayColor];
            btn.layer.cornerRadius = 20;
            [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
            [imageV addSubview:btn];
        }
    }
}
//点击按钮保存第一次登录的标记到本地并且跳入登录界面
- (void)btnClick{
    [self initWWWFolder];
}
-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/self.images.count, SCREEN_HEIGHT * 15/16.0, SCREEN_WIDTH/self.images.count, SCREEN_HEIGHT/16.0)];
        //设置总页数
        _pageControl.numberOfPages = self.images.count;
        //设置分页指示器颜色
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        //设置当前指示器颜色
        _pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.enabled = NO;
    }
    return _pageControl;
}
#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.pageControl.currentPage = (NSInteger)self.mainScrollV.contentOffset.x/SCREEN_WIDTH;
}


-(void)initWWWFolder{
    //此处只在初次登陆的时候显示“初始化”
    NSError * error ;
    NSString * string = [NSString string];
    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/Caches/First.txt"];
    BOOL haveFile = NO;
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        haveFile = YES;
    }
    
    if (!haveFile) {
        [self indicateProgressByProceedName:@"copy"];
        //改变首次登录标记
        string = @"1";
        [string writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:&error];
        if ([error description].length > 2) {
            NSLog(@"%@",[error description]);
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self initSourceFilesAndCallback:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"删除进度条....");
                [self stopIndicateInstallProgress];
                [self showHomeVC];
            });
        }];
    });
}

-(void)initSourceFilesAndCallback:(void (^)())callback{
    NSString * docPath = [[NSBundle mainBundle] pathForResource:@"wwwtest" ofType:nil];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *path = [NSString stringWithFormat:@"%@%@",docDir,@"/www"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error = nil;
    
    [fileManager copyItemAtPath:docPath toPath:path error:&error];
    
    if([error description].length>2){
        NSLog(@"压缩包拷贝错误：%@",[error description]);
    }
    
    NSLog(@"压缩包拷贝完成");
    
    //解压拷贝的文件
    
    [self unzipWWWFolderToPath:path];
    
    [fileManager removeItemAtPath:[path stringByAppendingPathComponent:@"www.zip"] error:&error];
    
    if([error description].length>2){
        NSLog(@"压缩包删除错误：%@",[error description]);
    }
    NSLog(@"删除完成");
    callback();
}

-(void)unzipWWWFolderToPath:(NSString *)path{
    
    NSString *unZipPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"/www.zip"]];
    
    ZipArchive *zip = [[ZipArchive alloc] init];
    
    
    
    NSLog(@"zippath:%@",unZipPath);
    
    if ([zip UnzipOpenFile:unZipPath]) {
        
        BOOL result;
        
        result = [zip UnzipFileTo:path overWrite:YES];//解压文件
        
        if (!result) {
            
            //解压失败
            
            NSLog(@"拷贝的www解压失败................");
            
        }else {
            
            //解压成功,删除掉zip包
            
            NSLog(@"拷贝的www解压成功..............");
            
        }
        
        [zip UnzipCloseFile];//关闭
        
    }else{
        NSLog(@"解压文件未打开，by gm");
    }
}

- (void)indicateProgressByProceedName:(NSString *)proceedName{
    //显示安装进度
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*4/5, 60)];
    view.tag = 100001;
    view.center = self.view.center;
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 6;
    view.layer.borderColor = [UIColor grayColor].CGColor;
    view.layer.borderWidth = 0.5;
    
    //菊花指示图
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.backgroundColor=[UIColor clearColor];
    activityIndicatorView.activityIndicatorViewStyle=2;
    activityIndicatorView.frame = CGRectMake(0,0,40,40);
    [activityIndicatorView startAnimating];
    [view addSubview:activityIndicatorView];
    
    //插入提示框
    CGRect frame_label = CGRectMake(0, 0, SCREEN_WIDTH/2, 40);
    UILabel * promptLabel = [[UILabel alloc]initWithFrame:frame_label];
    promptLabel.font = [UIFont systemFontOfSize:15];
    promptLabel.backgroundColor = [UIColor blueColor];
    promptLabel.textColor = RGBCOLOR(48.0, 43.0, 51.0);
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.backgroundColor = [UIColor clearColor];
    if ([proceedName isEqualToString:@"copy"]) {
        promptLabel.text = @"正在初始化，请稍候...";
    } else if ([proceedName isEqualToString:@"unzip"]){
        promptLabel.text = @"正在解压，请稍候...";
    }
    
    [view addSubview:promptLabel];
    
    //设置布局
    activityIndicatorView.center = CGPointMake(view.frame.size.width/2 - promptLabel.frame.size.width/2, view.frame.size.height/2);
    promptLabel.center = CGPointMake(view.frame.size.width/2+activityIndicatorView.frame.size.width/2, view.frame.size.height/2);
    
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
}

- (void)stopIndicateInstallProgress{
    if (view.superview) {
        [view removeFromSuperview];
    }
}

-(void)showHomeVC{
    // Other code
    MainViewController *vc1 = [[MainViewController alloc] init];
    vc1.view.backgroundColor = [UIColor whiteColor];
    vc1.title = @"首页";
    vc1.tabBarItem.image = [UIImage imageNamed:@"tab1_nor"];
    vc1.tabBarItem.selectedImage = [UIImage imageNamed:@"tab1_sel"];
    
    PublishViewController *vc2 = [[PublishViewController alloc] init];
    vc2.view.backgroundColor = [UIColor whiteColor];
    vc2.title = @"发布";
    vc2.tabBarItem.image = [UIImage imageNamed:@"tab3_nor"];
    vc2.tabBarItem.selectedImage = [UIImage imageNamed:@"tab3_sel"];
    
    HotViewController *vc3 = [[HotViewController alloc] init];
    vc3.view.backgroundColor = [UIColor whiteColor];
    vc3.title = @"热门";
    vc3.tabBarItem.image = [UIImage imageNamed:@"tab2_nor"];
    vc3.tabBarItem.selectedImage = [UIImage imageNamed:@"tab2_sel"];
    
    DemoMeController *vc4 = [[DemoMeController alloc] init];
    vc4.view.backgroundColor = [UIColor whiteColor];
    vc4.title = @"我的";
    vc4.tabBarItem.image = [UIImage imageNamed:@"tab4_nor"];
    vc4.tabBarItem.selectedImage = [UIImage imageNamed:@"tab4_sel"];
    
    
    UINavigationController *navC1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    UINavigationController *navC2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    UINavigationController *navC3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    UINavigationController *navC4 = [[UINavigationController alloc] initWithRootViewController:vc4];
    
    
    navC1.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil];
    navC2.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil];
    navC3.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil];
    navC4.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil];
    
    navC1.navigationBar.barTintColor =RGBCOLOR(238, 59, 59);
    navC2.navigationBar.barTintColor =RGBCOLOR(238, 59, 59);
    navC3.navigationBar.barTintColor =RGBCOLOR(238, 59, 59);
    navC4.navigationBar.barTintColor =RGBCOLOR(238, 59, 59);
    
    
    navC1.navigationBar.translucent = NO;
    navC2.navigationBar.translucent = NO;
    navC3.navigationBar.translucent = NO;
    navC4.navigationBar.translucent = NO;
    
    
    
    
    
    /**************************************** Key Code ****************************************/
    
    //初始化配置信息
    JMConfig *config = [JMConfig config];
    
    config.tabBarAnimType = JMConfigTabBarAnimTypeRotationY;
    
    
    NSMutableArray *titleArr = [NSMutableArray arrayWithObjects:@"首页",@"发布",@"热门",@"个人中心", nil];
    NSMutableArray *imageNormalArr = [NSMutableArray arrayWithObjects:@"tab1_nor",@"tab3_nor",@"tab2_nor",@"tab4_nor", nil];
    NSMutableArray *imageSelectedArr = [NSMutableArray arrayWithObjects:@"tab1_sel",@"tab3_sel",@"tab2_sel",@"tab4_sel", nil];
    NSMutableArray * controllersArr = [NSMutableArray arrayWithObjects:navC1,navC2,navC3,navC4, nil];
    
    JMTabBarController * tabBarVc = [[JMTabBarController alloc] initWithTabBarControllers:controllersArr NorImageArr:imageNormalArr SelImageArr:imageSelectedArr TitleArr:titleArr Config:config];
    
    [UIApplication sharedApplication].delegate.window.rootViewController = tabBarVc;
    
    
    /******************************************************************************************/
}


@end
