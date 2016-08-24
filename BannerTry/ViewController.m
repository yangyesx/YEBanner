//
//  ViewController.m
//  BannerTry
//
//  Created by yangyunen on 16/5/18.
//  Copyright © 2016年 yangyunen. All rights reserved.
//

#import "ViewController.h"
#import "YEBannerViewController.h"
#import "YEBannerView.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) UIScrollView *bannerSV;
@property (strong, nonatomic) UIImageView *iv1;
@property (strong, nonatomic) UIImageView *iv2;
@property (strong, nonatomic) UIImageView *iv3;
@property (strong, nonatomic) UIPageControl *pc;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ViewController

static int counter = 2;
static bool dragged;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBannerScrollView];
    [self addPageControl];
    [self addImageViews];
    
    [self scrollViewDidEndDecelerating:self.bannerSV];
    
//    YEBannerViewController *yeb = [[YEBannerViewController alloc]initWithFrame:CGRectMake(0, 232, [UIScreen mainScreen].bounds.size.width, 200) andImages:[NSArray arrayWithObjects:@"1", @"2", @"3", nil]];
//    [self.view addSubview:yeb.view];
    
    YEBannerView *bannerView = [[YEBannerView alloc]initWithFrame:CGRectMake(0, 232, [UIScreen mainScreen].bounds.size.width, 200) andImages:[NSArray arrayWithObjects:@"1", @"2", @"3", nil]];
    [self.view addSubview:bannerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//初始化并向当前视图添加ScrollView
- (void)addBannerScrollView
{
    self.bannerSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 200)];
    self.bannerSV.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 3, 200);
    self.bannerSV.pagingEnabled = YES;
    self.bannerSV.delegate = self;
    [self.bannerSV setShowsHorizontalScrollIndicator:NO];
    
    [self.view addSubview:self.bannerSV];
}
//添加PageControl
- (void)addPageControl
{
    self.pc = [[UIPageControl alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 200) / 2.0, 200, 200, 10)];
    self.pc.numberOfPages = 3;
    self.pc.currentPage = 1;
    
    [self.view addSubview:self.pc];
}
//向ScrollView添加三个imageview作为banner的上一页、当前页和下一页，并设置初始的三页显示的image
- (void)addImageViews
{
    self.iv1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];
    self.iv2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"2"]];
    self.iv3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"3"]];
    self.iv1.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    self.iv2.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, 200);
    self.iv3.frame = CGRectMake(2 * [UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, 200);
    
    [self.bannerSV addSubview:self.iv1];
    [self.bannerSV addSubview:self.iv2];
    [self.bannerSV addSubview:self.iv3];
}

//开始timer组件，每隔一定时间就执行滚动方法
- (void)startTime
{
    self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(beginScroll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
    [self.timer fire];
}
//开始滚动
- (void)beginScroll
{
    //开始判断scrollview当前是否正在被拖动，如果拖动则不执行自动滚动
    if (!dragged) {
        [self.bannerSV setContentOffset:CGPointMake(self.bannerSV.contentOffset.x + [UIScreen mainScreen].bounds.size.width, 0) animated:YES];
        
        [self resetScrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self resetScrollView];
    
    [self startTime];
}
//每当时间到达滚动间隔，则根据计数器counter重置scrollview
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self resetScrollView];
}
//拖动开始，停止timer，并置拖动标记dragged为YES
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    dragged = YES;
}
//拖动停止，置拖动标记为NO
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self performSelector:@selector(resetDrag) withObject:nil afterDelay:2.0f];
}
//重置拖动标记方法(默认为NO,只有开始拖动和拖动结束这一段时间内为YES来避开计时拖动)
- (void)resetDrag
{
    dragged = NO;
}
//重置scrollview方法，来设置前一页、当前页和下一页应该现实的image序列
- (void)resetScrollView
{
    if (self.bannerSV.contentOffset.x == 0) {
        if (counter - 1 >= 1) {
            counter--;
        }else{
            counter = 3;
        }
    }else if (self.bannerSV.contentOffset.x == 2 * [UIScreen mainScreen].bounds.size.width){
        if (counter + 1 <= 3) {
            counter++;
        }else{
            counter = 1;
        }
    }
    
    self.bannerSV.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
    self.iv1.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", (counter - 1) >= 1 ? counter - 1 : 3]];
    self.iv2.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", counter]];
    self.iv3.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", (counter + 1) <= 3 ? counter + 1 : 1]];
    self.pc.currentPage = (counter - 1) % 3;
}


@end
