//
//  MyOrderViewController.h
//  Candy Cart
//
//  Created by Mr Kruk (kruk8989@gmail.com)  http://codecanyon.net/user/kruk8989 on 8/18/13.
//  Copyright (c) 2013 kruk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGScrollView.h"
#import "MGTableBoxStyled.h"
#import "MGLineStyled.h"
#import "OrderViewController.h"
#import "GeneralPopTableView.h"

@interface MyOrderViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate,GeneralPopTableViewDelegate,MBProgressHUDDelegate>
{
    CGPoint initialContentOffset;
    CGPoint svos;
    CGRect currentRect;
    MGScrollView *scroller;
    MBProgressHUD *HUD;
    UIButton *btnFilter;
    FPPopoverController *popover;
    UIActivityIndicatorView *myActivityView;
}

- (void) listOrder;

@end
