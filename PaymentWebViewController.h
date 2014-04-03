//
//  PaymentWebViewController.h
//  Candy Cart
//
//  Created by Mr Kruk (kruk8989@gmail.com)  http://codecanyon.net/user/kruk8989 on 8/14/13.
//  Copyright (c) 2013 kruk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderViewController;
@interface PaymentWebViewController : UIViewController<UIWebViewDelegate,MBProgressHUDDelegate>
{
    UIWebView *webViewSe;
    NSString *urls;
    CGPoint initialContentOffset;
    MBProgressHUD *HUD;
    OrderViewController*order;
}
-(void)loadUrlInWebView:(NSString*)url;
-(void)setOrderViewController:(OrderViewController *)orders;
@end
