//
//  OrderViewController.h
//  Candy Cart
//
//  Created by Mr Kruk (kruk8989@gmail.com)  http://codecanyon.net/user/kruk8989 on 8/13/13.
//  Copyright (c) 2013 kruk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGScrollView.h"
#import "MGTableBoxStyled.h"
#import "MGLineStyled.h"
#import "MyCartBox.h"
#import "PaymentWebViewController.h"
#import "OrderNotesViewController.h"
#import "GeneralPopTableView.h"

@interface OrderViewController : UIViewController<UIScrollViewDelegate,MBProgressHUDDelegate,GeneralPopTableViewDelegate>

{
    CGPoint initialContentOffset;
    CGPoint svos;
    CGRect currentRect;
    MGScrollView *scroller;
    MBProgressHUD *HUD;
    UIButton *payBtn;
    UIBarButtonItem *payBtnItem;
    BOOL noCloseBtn;
    UIButton *orderNotes;
    UIBarButtonItem *orderNotesBtnItems;
    FPPopoverController *popover;
}

@property (unsafe_unretained) id parent;

-(void)refreshOrderPaymentSuccessful;
-(void)refreshOrderFailed;

//UI Modified
-(void)noCloseBtn;
@end
