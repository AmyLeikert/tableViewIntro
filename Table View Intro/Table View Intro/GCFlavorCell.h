//
//  GCFlavorCell.h
//  Table View Intro
//
//  Created by Thomas Crawford on 3/6/14.
//  Copyright (c) 2014 Thomas Crawford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GCFlavorCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *flavorNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *flavorRankingLabel;
@property (nonatomic, strong) IBOutlet UIImageView *flavorImageView;

@end
