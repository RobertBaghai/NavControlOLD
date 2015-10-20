//
//  Company.h
//  NavCtrl
//
//  Created by Robert Baghai on 10/6/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//
#import "Product.h"
#import <Foundation/Foundation.h>

@interface Company : NSObject<NSCoding>

@property (nonatomic,retain) NSString *companyName;
@property (nonatomic,retain) NSString *companyLogo;
@property (nonatomic,retain) NSString *stockCode;


@property (nonatomic,retain) NSMutableArray *products;

@property (nonatomic,retain) NSString *stockPrice;


//- (id)initWithCompanyName:(NSString *)companyName stockCode:(NSString *)stockCode;

@end
