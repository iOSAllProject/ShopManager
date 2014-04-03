//
//  OrderNotesViewController.h
//  Candy Cart
//
//  Created by Mr Kruk (kruk8989@gmail.com)  http://codecanyon.net/user/kruk8989 on 8/18/13.
//  Copyright (c) 2013 kruk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGScrollView.h"
#import "MGTableBoxStyled.h"
#import "MGLineStyled.h"
@interface OrderNotesViewController : UIViewController<UIScrollViewDelegate>
{
    CGPoint initialContentOffset;
    CGPoint svos;
    CGRect currentRect;
    MGScrollView *scroller;
}
@end
