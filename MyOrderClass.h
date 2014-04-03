//
//  MyOrderClass.h
//  Candy Cart
//
//  Created by Mr Kruk (kruk8989@gmail.com)  http://codecanyon.net/user/kruk8989 on 8/13/13.
//  Copyright (c) 2013 kruk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderClass : NSObject
{
    NSDictionary *myOrder;
    NSDictionary *listOfMyOrder;
}
+ (MyOrderClass *) instance;
-(void)setMyOrder:(NSDictionary*)myOrderEx;
-(NSDictionary*)getMyOrder;

-(void)setListOfMyOrder:(NSDictionary*)listOfMyOrders;
-(NSDictionary*)getListOfMyOrder;
@end
