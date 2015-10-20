//
//  Product.h
//  NavCtrl
//
//  Created by Robert Baghai on 10/6/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject<NSCoding>
@property (nonatomic,retain) NSString *productName;
@property (nonatomic,retain) NSString *productLogo;

@property (nonatomic, retain) NSString *productURL;


@end
