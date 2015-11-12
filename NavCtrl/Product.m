//
//  Product.m
//  NavCtrl
//
//  Created by Robert Baghai on 10/6/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//

#import "Product.h"

@implementation Product

-(void)dealloc
{
    [_productName release];
    [_productLogo release];
    [_productURL release];
    [super dealloc];
}

@end
