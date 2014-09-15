//
//  STBaseCalendar.h
//  ShiftTable
//
//  Created by 独自一人 on 14-6-20.
//  Copyright (c) 2014年 www.mylonly.com All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STBaseCalendarDelegate <NSObject>

@optional

//上一个月份
- (void)prePressed:(NSInteger)year month:(NSInteger)month;

//下一个月份
- (void)nextPressed:(NSInteger)year month:(NSInteger)month;

//某一天被单击
- (void)cellPressed:(UIButton*)cell year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

@optional
//cell单元长按操作
- (void)longCellPressed:(UIButton*)cell year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

@end

@interface STBaseCalendar : UIView

@property (nonatomic,weak) id<STBaseCalendarDelegate> delegate;

- (void)setDate:(NSDate*)date;

@end
