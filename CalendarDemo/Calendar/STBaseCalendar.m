//
//  STBaseCalendar.m
//  ShiftTable
//
//  Created by 独自一人 on 14-6-20.
//  Copyright (c) 2014年 www.mylonly.com All rights reserved.
//  负责单个月份日历的显示

#define CELLRECTWIDTH 41.9
#define CELLRECTHEIGHT 42.5
#define CELLSTARTORGIN_Y 85.5
#define CELLTAGSTART 1000

#import "STBaseCalendar.h"
#import "STCalendarCell.h"
#import <EventKit/EventKit.h>
@interface STBaseCalendar()
{
    //当前需要显示的日期
    NSDate* currentDate;
    UILabel *dateLabel;
    NSInteger month;
    NSInteger year;
    
    //已经被选中的单元
    UIButton* m_selected;
    
    EKEventStore *eventStore;
    EKCalendar *defaultCalendar;
}
@end

@implementation STBaseCalendar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        m_selected = nil;
        eventStore = [[EKEventStore alloc] init];
        
        UIImageView *backgroudView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 302, 350)];
        [backgroudView setImage:[UIImage imageNamed:@"background.png"]];
        [self addSubview:backgroudView];
        
        UIButton *preButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 12, 20)];
        [preButton setImage:[UIImage imageNamed:@"leftArrow.png"] forState:UIControlStateNormal];
        [preButton addTarget:self action:@selector(prePressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:preButton];
        
        UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 30, 12, 20)];
        [nextButton setImage:[UIImage imageNamed:@"rightArrow.png"] forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(nextPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextButton];
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 20, 150, 40)];
        [dateLabel setText:@"2014年6月"];
        [dateLabel setTextColor:[UIColor whiteColor]];
        [dateLabel setFont:[UIFont systemFontOfSize:14]];
        [dateLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:dateLabel];
        [self initDayCells];
        
    }
    return self;
}

- (void)initDayCells
{
    CGRect cellRect;
    cellRect.size.height = CELLRECTHEIGHT;
    cellRect.size.width = CELLRECTWIDTH;
    
    for (int i = 0; i < 6; i++)
    {
        for (int j = 0; j < 7; j++)
        {
            cellRect.origin.x = cellRect.size.width*j + 4;
            cellRect.origin.y = cellRect.size.height*i + CELLSTARTORGIN_Y;
            STCalendarCell *cell = [[STCalendarCell alloc] initWithFrame:cellRect];
            [cell setTag:CELLTAGSTART+10*i+j];
            [cell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cell.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [cell addTarget:self action:@selector(cellPressed:) forControlEvents:UIControlEventTouchUpInside];
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellLongPressed:)];
            [cell addGestureRecognizer:longPressGesture];
            [self addSubview:cell];
        }
    }
}

- (void)setDate:(NSDate*)date
{
    currentDate = date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy年-MM月"];
    NSString* dateStr = [dateFormat stringFromDate:currentDate];
    [dateLabel setText:dateStr];
    
    //绘制日历
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:currentDate];
    [comp setDay:1];
    month = [comp month];
    year = [comp year];
    
    NSDate *firstDayDate = [cal dateFromComponents:comp];
    NSRange daysOfMonth = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:firstDayDate];//获得该月的天数
    NSDateComponents *weekDayComp = [cal components:NSWeekdayCalendarUnit fromDate:firstDayDate];
    NSInteger startWeekDay = [weekDayComp weekday];   //这个月1号是星期几？sunday为1，一直到星期六
    [self drawCalendar:daysOfMonth startWeekDay:startWeekDay];
    
}

- (void)drawCalendar:(NSRange)days startWeekDay:(NSInteger)start
{
    
    NSInteger dayInMonth = 1;
    for (int i = 0; i < 6; i++)
    {
        for (int j = 0; j < 7; j++)
        {
            STCalendarCell *cell = (STCalendarCell*) [self viewWithTag:CELLTAGSTART + 10*i + j];
            [cell setHidden:YES];
            [cell setBackgroundImage:nil forState:UIControlStateNormal];
            
            if ((i ==0) && (j < start - 1))
            {
                continue;
            }
            if (dayInMonth > days.length)
            {
                continue;
            }
            
            [cell setTitle:[NSString stringWithFormat:@"%d",dayInMonth] forState:UIControlStateNormal];
            [cell setHidden:NO];
            
            //判断这一天是否为当前日期
            if ([self CheckIsToday:dayInMonth cell:cell])
            {
                [cell setBackgroundImage:[UIImage imageNamed:@"greenCell.png"] forState:UIControlStateHighlighted];
                cell.highlighted = YES;
            }
            dayInMonth = dayInMonth+1;
            
        }
    }
}

- (BOOL)CheckIsToday:(NSInteger)day cell:(STCalendarCell*)cell
{
    NSDate *current = [NSDate date];
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:current];
    if (year == [comp year] && month == [comp month] && day == [comp day])
    {
        return YES;
    }
    return NO;
}



- (void)prePressed
{
    if ([_delegate respondsToSelector:@selector(prePressed:month:)])
    {
        [_delegate prePressed:year month:month];
    }
}

- (void)nextPressed
{
    if([_delegate respondsToSelector:@selector(nextPressed:month:)])
    {
        [_delegate nextPressed:year month:month];
    }
}

- (void)cellPressed:(UIButton*)sender
{
    if (m_selected)
    {
        [m_selected setBackgroundImage:nil forState:UIControlStateNormal];
        m_selected.highlighted = YES;
    }
    [sender setBackgroundImage:[UIImage imageNamed:@"redCell.png"] forState:UIControlStateNormal];
    m_selected = sender;
    
    NSInteger selectedDay = [sender.titleLabel.text intValue];
    if ([_delegate respondsToSelector:@selector(cellPressed:year:month:day:)])
    {
        [_delegate cellPressed:sender year:year month:month day:selectedDay];
    }
}

- (void)cellLongPressed:(UILongPressGestureRecognizer*)gesture
{
    NSInteger selectedDay = [((UIButton*)gesture.view).titleLabel.text intValue];
    if ([_delegate respondsToSelector:@selector(longCellPressed:year:month:day:)])
    {
        [_delegate longCellPressed:(UIButton*)gesture.view year:year month:month day:selectedDay];
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
