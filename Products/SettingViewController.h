//
//  SettingViewController.h
//  ShopManager
//
//  Created by Steven on 4/10/14.
//  Copyright (c) 2014 NhuanQuang. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    kProduct = 0,
    kCategory
};

@interface SettingViewController : UITableViewController {
    NSMutableArray *mainArray;
}

@end
