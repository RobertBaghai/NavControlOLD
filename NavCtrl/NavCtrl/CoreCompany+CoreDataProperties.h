//
//  CoreCompany+CoreDataProperties.h
//  NavCtrl
//
//  Created by Robert Baghai on 10/29/15.
//  Copyright © 2015 Aditya Narayan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CoreCompany.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreCompany (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *companyName;
@property (nullable, nonatomic, retain) NSString *stockCode;
@property (nullable, nonatomic, retain) NSString *companyLogo;
@property (nullable, nonatomic, retain) NSSet<CoreProduct *> *prod;

@end

@interface CoreCompany (CoreDataGeneratedAccessors)

- (void)addProdObject:(CoreProduct *)value;
- (void)removeProdObject:(CoreProduct *)value;
- (void)addProd:(NSSet<CoreProduct *> *)values;
- (void)removeProd:(NSSet<CoreProduct *> *)values;

@end

NS_ASSUME_NONNULL_END
