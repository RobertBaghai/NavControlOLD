//
//  CoreProduct+CoreDataProperties.h
//  NavCtrl
//
//  Created by Robert Baghai on 10/29/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CoreProduct.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreProduct (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *productURL;
@property (nullable, nonatomic, retain) NSString *productLogo;
@property (nullable, nonatomic, retain) NSString *productName;
@property (nullable, nonatomic, retain) CoreCompany *comp;

@end

NS_ASSUME_NONNULL_END
