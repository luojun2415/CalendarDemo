//
//  STCalendarView.h
//  ShiftTable
//
//  Created by 独自一人 on 14-6-19.
//  Copyright (c) 2014年 www.mylonly.com All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol STCalendarViewDelegate<NSObject>

//某一天被单击
- (void)cellPressed:(UIButton*)cell year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
@optional
//cell单元长按操作
- (void)longCellPressed:(UIButton*)cell year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

@end

@interface STCalendarView : UIView

@property (nonatomic,weak) id<STCalendarViewDelegate> delegate;

@end
