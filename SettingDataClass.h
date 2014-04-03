//
//  SettingDataClass.h
//  Candy Cart
//
//  Created by Mr Kruk (kruk8989@gmail.com)  http://codecanyon.net/user/kruk8989 on 8/14/13.
//  Copyright (c) 2013 kruk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingDataClass : NSObject
{
    NSDictionary *settings;
}
+ (SettingDataClass *) instance;
-(void)setSetting:(NSDictionary*)set;
-(NSDictionary*)getSetting;
-(NSString*)getCurrencySymbol;
-(NSString*)get_instagram_client_id;
-(BOOL)getEnableAutoHideSetting;
-(void)autoHideGlobal:(UIScrollView*)scroll navigationView:(UINavigationController*)nav contentOffset:(CGPoint)offset;
@end
