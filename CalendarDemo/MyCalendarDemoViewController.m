//
//  MyCalendarDemoViewController.m
//  CalendarDemo
//
//  Created by 独自一人 on 14-9-15.
//  Copyright (c) 2014年 www.mylonly.com. All rights reserved.
//

#import "MyCalendarDemoViewController.h"
#import "STCalendarView.h"

#define IS_IOS7      [[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0
#define IS_IPHONE_5                (fabs([[UIScreen mainScreen] bounds].size.height - 568.f) < DBL_EPSILON)
#define RGBA(r,g,b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define RGB(r,g,b)     RGBA(r,g,b,1.0f)


@interface MyCalendarDemoViewController ()<STCalendarViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView* m_scrollView;
    UITableView* m_greenDetailGround;
}
@end

@implementation MyCalendarDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGB(29, 29, 41);
    
    m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, IS_IOS7?64:44, 320, IS_IPHONE_5?524:416)];
    m_scrollView.showsVerticalScrollIndicator = NO;
    m_scrollView.contentInset = UIEdgeInsetsMake(IS_IOS7?-20:0, 0, 0, 0);
    
    [self.view addSubview:m_scrollView];
    
    STCalendarView *myCalendar = [[STCalendarView alloc] initWithFrame:CGRectMake(10,20,300,350)];
    myCalendar.delegate = self;
    [m_scrollView addSubview:myCalendar];
    
    UIView *greenView = [[UIView alloc] initWithFrame:CGRectMake(10, 380, 300,343)];
    greenView.userInteractionEnabled = YES;
    [m_scrollView addSubview:greenView];
    
    UIImageView *greenBarGround = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 43)];
    [greenBarGround setImage:[UIImage imageNamed:@"greenBackground.png"]];
    [greenView addSubview:greenBarGround];
    
 
    
    UIButton *foldButton = [[UIButton alloc] initWithFrame:CGRectMake(260, 0, 40, 43)];
    [foldButton setImage:[UIImage imageNamed:@"rightArrow.png"] forState:UIControlStateNormal];
    [foldButton setImage:[UIImage imageNamed:@"downArrow.png"] forState:UIControlStateSelected];
    [foldButton addTarget:self action:@selector(greenExpand:) forControlEvents:UIControlEventTouchUpInside];
    [greenView addSubview:foldButton];
    
    m_greenDetailGround = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 300, 0)];
    [m_greenDetailGround setBackgroundColor:RGB(0, 156, 143)];
    m_greenDetailGround.layer.cornerRadius = 2.f;
    //[m_greenDetailGround setDelaysContentTouches:NO];
    m_greenDetailGround.dataSource = self;
    m_greenDetailGround.delegate = self;
    [greenView addSubview:m_greenDetailGround];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark self action
- (void)greenExpand:(UIButton*)sender
{
    CGRect frame = m_greenDetailGround.frame;
    sender.selected = !sender.selected;
    if (sender.selected)
    {
        frame.size.height = 150;
        [m_scrollView setContentSize:CGSizeMake(320, IS_IPHONE_5?524+150:416+150)];
    }
    else
    {
        frame.size.height = 0;
        [m_scrollView setContentSize:CGSizeMake(320, IS_IPHONE_5?524:416)];
    }
    [UIView animateWithDuration:0.3F animations:^
     {
         [m_greenDetailGround setFrame:frame];
     }];
}


#pragma mark STCalendar delegate
- (void)cellPressed:(UIButton *)cell year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSString* tips = [NSString stringWithFormat:@"%d年%d月%d日",year,month,day];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"单击手势" message:tips delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)longCellPressed:(UIButton *)cell year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSString* tips = [NSString stringWithFormat:@"%d年%d月%d日",year,month,day];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"长按手势" message:tips delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark tableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
