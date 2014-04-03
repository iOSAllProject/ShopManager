//
//  ToolClass.h
//  Candy Cart
//
//  Created by Mr Kruk (kruk8989@gmail.com)  http://codecanyon.net/user/kruk8989 on 7/6/13.
//  Copyright (c) 2013 kruk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolClass : NSObject
+ (ToolClass *) instance;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize source:(UIImage*)sourceImages;
-(UIImage*)cropRect:(CGRect)targetSize source:(UIImage*)sourceImages;
-(UIImage *) ChangeViewToImage : (UIView *) view;
- (NSString *)decodeHTMLCharacterEntities:(NSString*)str;
- (NSString *)stringForTimeIntervalSinceCreated:(NSDate *)dateTime serverTime:(NSDate *)serverDateTime;
- (BOOL) validateEmail: (NSString *) emailaddress;
- (NSDictionary *) indexKeyedDictionaryFromArray:(NSMutableArray *)array;
- (UIImage *)changeImageColor:(NSString *)name withColor:(UIColor *)color;
-(void)checkLink:(NSString*)str navigation:(UINavigationController*)nav;
@end
