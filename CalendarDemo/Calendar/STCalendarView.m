//
//  STCalendarView.m
//  ShiftTable
//
//  Created by 独自一人 on 14-6-19.
//  Copyright (c) 2014年 www.mylonly.com All rights reserved.
//  控制单个月份日历(STBaseCalendar)的显示

#define CALENDARRECT CGRectMake(0,0,302,350)

#import "STCalendarView.h"
#import "STBaseCalendar.h"


@interface STCalendarView()<STBaseCalendarDelegate>
{
    //当前保存的日历视图
    STBaseCalendar *currentView;
}
@end

@implementation STCalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        STBaseCalendar *baseCalendar = [[STBaseCalendar alloc] initWithFrame:CALENDARRECT];
        [baseCalendar setDate:[NSDate date]];
        [self addSubview:baseCalendar];
        baseCalendar.delegate = self;
        currentView = baseCalendar;
    }
    return self;
}


- (void)prePressed:(NSInteger)year month:(NSInteger)month
{
    if (month > 1)
    {
        month --;
    }
    else
    {
        month = 12;
        year -- ;
    }
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setDay:1];
    [comp setMonth:month];
    [comp setYear:year];
    NSDate *preDate = [cal dateFromComponents:comp];
    
    STBaseCalendar *newCalendar = [[STBaseCalendar alloc] initWithFrame:CALENDARRECT];
    newCalendar.delegate = self;
    [newCalendar setDate:preDate];
    
    [UIView beginAnimations:@"preView" context:nil];
    [UIView
     setAnimationDuration:0.5f];
    [UIView
     setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self cache:YES];
    [currentView removeFromSuperview];
    [self addSubview:newCalendar];
    currentView = newCalendar;
    [UIView commitAnimations];
    
}
- (void)nextPressed:(NSInteger)year month:(NSInteger)month
{
    if (month < 12)
    {
        month++;
    }
    else
    {
        month = 1;
        year ++;
    }
    
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setDay:1];
    [comp setMonth:month];
    [comp setYear:year];
    
    NSDate *nextDate = [cal dateFromComponents:comp];
    STBaseCalendar *newCalendar = [[STBaseCalendar alloc] initWithFrame:CALENDARRECT];
    newCalendar.delegate = self;
    [newCalendar setDate:nextDate];
    
    //开始动画
    [UIView beginAnimations:@"nextView" context:nil];
    [UIView
     setAnimationDuration:0.5f];
    [UIView
     setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self cache:YES];
    [currentView removeFromSuperview];
    [self addSubview:newCalendar];
    currentView = newCalendar;
    [UIView commitAnimations];


}

- (void)cellPressed:(UIButton*)cell year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    if ([_delegate respondsToSelector:@selector(cellPressed:year:month:day:)])
    {
        [_delegate cellPressed:cell year:year month:month day:day];
    }
}

- (void)longCellPressed:(UIButton*)cell year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    if ([_delegate respondsToSelector:@selector(longCellPressed:year:month:day:)])
    {
        [_delegate longCellPressed:cell year:year month:month day:day];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
