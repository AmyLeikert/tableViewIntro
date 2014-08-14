//
//  Flavors.h
//  Table View Intro
//
//  Created by Thomas Crawford on 11/4/13.
//  Copyright (c) 2013 Thomas Crawford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class InventoryItems;

@interface Flavors : NSManagedObject

@property (nonatomic, retain) NSString * flavorName;
@property (nonatomic, retain) NSDecimalNumber * flavorRating;
@property (nonatomic, retain) NSString * flavorImage;
@property (nonatomic, retain) NSString * flavorDescription;
@property (nonatomic, retain) NSDate * dateEntered;
@property (nonatomic, retain) NSDate * dateUpdated;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSNumber * flavorOrder;
@property (nonatomic, retain) NSSet *relationshipFlavorInventoryItems;
@end

@interface Flavors (CoreDataGeneratedAccessors)

- (void)addRelationshipFlavorInventoryItemsObject:(InventoryItems *)value;
- (void)removeRelationshipFlavorInventoryItemsObject:(InventoryItems *)value;
- (void)addRelationshipFlavorInventoryItems:(NSSet *)values;
- (void)removeRelationshipFlavorInventoryItems:(NSSet *)values;

@end
