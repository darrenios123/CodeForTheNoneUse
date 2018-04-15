//
//  GuidePagesViewController ViewController.m
//  HelloCordova
//
//  Created by Darren on 2018/4/15.
//

#import "GuidePagesViewController.h"
#import "MainViewController.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

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
        _mainScrollV.contentSize = CGSizeMake(self.images.count * ScreenWidth, ScreenHeight);
        [self addSubImageViews];
    }
    return _mainScrollV;
}
-(NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
        NSArray * imageNames = @[@"u1.jpeg",@"u2.jpg",@"u3.jpeg"];
        for (NSString * name in imageNames) {
            [self.images addObject:[UIImage imageNamed:name]];
        }
    }
    return _images;
}
- (void)addSubImageViews{
    for (int i = 0; i < self.images.count; i++) {
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(i * ScreenWidth, 0, ScreenWidth, ScreenHeight)];
        imageV.image = self.images[i];
        [_mainScrollV addSubview:imageV];
        if (i == self.images.count - 1){//最后一张图片时添加点击进入按钮
            imageV.userInteractionEnabled = YES;
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(ScreenWidth * 0.5 - 80, ScreenHeight * 0.7, 160, 40);
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
    [UIApplication sharedApplication].keyWindow.rootViewController = [[MainViewController alloc] init];
}
-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(ScreenWidth/self.images.count, ScreenHeight * 15/16.0, ScreenWidth/self.images.count, ScreenHeight/16.0)];
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
    self.pageControl.currentPage = (NSInteger)self.mainScrollV.contentOffset.x/ScreenWidth;
}

@end
