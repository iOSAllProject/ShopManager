//
//  MyCartClass.h
//  Candy Cart
//
//  Created by Mr Kruk (kruk8989@gmail.com)  http://codecanyon.net/user/kruk8989 on 8/7/13.
//  Copyright (c) 2013 kruk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
@interface MyCartClass : NSObject
{
    NSMutableArray *globalcart;
    NSDictionary *serverCart;
    NSMutableArray *counponCode;
    NSString *orderNotes;
}
+ (MyCartClass *) instance;
-(void)initMyCart;
-(void)addToCart:(NSString*)productType productID:(NSString*)productID productQuantity:(NSString*)quantity fullProductInfo:(NSDictionary*)productInfo ifVariableParentInfo:(NSMutableDictionary*)array;
-(BOOL)checkInCart:(NSString*)productID;
-(int)productQuantityInsideCart:(NSString*)productID; //0 is not exist
-(NSMutableArray*)getMyCartArray;
-(int)countProduct;
-(float)getTotalCartPrice;
-(NSString*)productIDToJsonString;
-(void)countCartTabBar;
-(NSArray*)getProductInCartInfo:(NSString*)productID;
-(NSDictionary*)getServerCart;
-(void)setOrderNotes:(NSString*)note;
-(NSString*)getOrderNotes;

//Coupon
-(void)addCoupon:(NSString*)couponCode;
-(NSMutableArray*)getCouponCode;
-(NSString*)couponToJsonString;

//Server Cart
-(void)setServerCart:(NSDictionary*)serverCartP;
-(NSString*)getProductCartInServerAttribute:(NSString*)objectKey productID:(NSString*)productID;
-(NSString*)getProductCartInServerPrice:(NSString*)productID;
-(NSString*)getProductCartInServerTotalPrice:(NSString*)productID;
-(BOOL)checkServerHasTax;
-(NSString*)getServerCartValueByObjectKey:(NSString*)objectKey;
-(void)removeCartByProductID:(NSString*)productID;
-(int)findCouponIndex:(NSString*)couponCode;
-(void)removeCouponByCouponCode:(NSString*)couponCode;
@end
