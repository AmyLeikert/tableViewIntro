//
//  InventoryItems.h
//  Table View Intro
//
//  Created by Thomas Crawford on 11/4/13.
//  Copyright (c) 2013 Thomas Crawford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Flavors;

@interface InventoryItems : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * sizeInGallons;
@property (nonatomic, retain) NSString * vendorName;
@property (nonatomic, retain) NSDate * dateInInventory;
@property (nonatomic, retain) NSDate * dateUseBy;
@property (nonatomic, retain) NSDate * dateEntered;
@property (nonatomic, retain) NSDate * dateUpdated;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSDate * dateOpened;
@property (nonatomic, retain) Flavors *relationshipInventoryItemFlavor;

@end
