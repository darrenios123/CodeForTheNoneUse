//
//  GuidePagesViewController ViewController.m
//  HelloCordova
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

@interface GuidePagesViewController ()<UIScrollViewDelegate>

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
    //保存标记到本地
    NSUserDefaults * userDef = [NSUserDefaults standardUserDefaults];
    [userDef setBool:YES forKey:@"isNotFirst"];
    [userDef synchronize];
    //切换视图控制器
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
    
    
    
    /**************************************** Key Code ****************************************/
    
    //初始化配置信息
    JMConfig *config = [JMConfig config];
    
    config.tabBarAnimType = JMConfigTabBarAnimTypeRotationY;
    
    
    NSMutableArray *titleArr = [NSMutableArray arrayWithObjects:@"首页",@"发布",@"热门",@"个人中心", nil];
    NSMutableArray *imageNormalArr = [NSMutableArray arrayWithObjects:@"tab1_nor",@"tab3_nor",@"tab2_nor",@"tab4_nor", nil];
    NSMutableArray *imageSelectedArr = [NSMutableArray arrayWithObjects:@"tab1_sel",@"tab3_sel",@"tab2_sel",@"tab4_sel", nil];
    NSMutableArray * controllersArr = [NSMutableArray arrayWithObjects:navC1,navC2,navC3,navC4, nil];
    
    JMTabBarController * tabBarVc = [[JMTabBarController alloc] initWithTabBarControllers:controllersArr NorImageArr:imageNormalArr SelImageArr:imageSelectedArr TitleArr:titleArr Config:config];
    
    
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;
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

@end
