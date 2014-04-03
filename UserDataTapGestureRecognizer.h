//
//  UserDataTapGestureRecognizer.h
//  Candy Cart
//
//  Created by Mr Kruk (kruk8989@gmail.com)  http://codecanyon.net/user/kruk8989 on 7/9/13.
//  Copyright (c) 2013 kruk. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class DetailViewController;
@interface UserDataTapGestureRecognizer : UITapGestureRecognizer
@property (nonatomic, strong) id userData;
@property (nonatomic, strong) UILabel *currentLabel;
//@property (nonatomic, strong) DetailViewController *parentDetail;
@property (nonatomic, strong) id openPopOver;
@end
