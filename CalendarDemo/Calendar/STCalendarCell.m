//
//  STCalendarCell.m
//  ShiftTable
//
//  Created by 独自一人 on 14-8-28.
//  Copyright (c) 2014年 www.mylonly.com All rights reserved.
//

#import "STCalendarCell.h"
@interface STCalendarCell()
{
    UIImageView* redPoint;
    UIImageView* greenPoint;
}
@end
@implementation STCalendarCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        redPoint = [[UIImageView alloc] initWithFrame:CGRectMake(11, 30, 7.5, 7.5)];
        [redPoint setImage:[UIImage imageNamed:@"redPoint.png"]];
        [self addSubview:redPoint];
        [redPoint setHidden:YES];
      
        
        greenPoint = [[UIImageView alloc] initWithFrame:CGRectMake(23, 30, 7.5, 7.5)];
        [greenPoint setImage:[UIImage imageNamed:@"greenPoint.png"]];
        [self addSubview:greenPoint];
        [greenPoint setHidden:YES];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)showRedPoint
{
    [redPoint setHidden:NO];
}
- (void)hideRedPoint
{
    [redPoint setHidden:YES];
}

- (void)showGreenPoint
{
    [greenPoint setHidden:NO];
}
- (void)hideGreenPoint
{
    [greenPoint setHidden:YES];
}
@end
