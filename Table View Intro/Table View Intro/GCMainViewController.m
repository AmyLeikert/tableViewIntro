//
//  GCMainViewController.m
//  Table View Intro
//
//  Created by Thomas Crawford on 11/4/13.
//  Copyright (c) 2013 Thomas Crawford. All rights reserved.
//

#import "GCMainViewController.h"
#import "GCDetailViewController.h"
#import "Flavors.h"
#import "InventoryItems.h"
#import "GCFlavorCell.h"

@interface GCMainViewController ()

@property (nonatomic,strong) NSArray    *flavorsArray;
@property (nonatomic,weak) IBOutlet UITableView *flavorsTableView;

@end

@implementation GCMainViewController

#pragma mark - Core Methods

- (void)fetchFlavors {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Flavors" inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"flavorName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error;
    NSArray *fetchResults = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    _flavorsArray = [NSMutableArray arrayWithArray:fetchResults];
    NSLog(@"Fetched %i Flavors",[_flavorsArray count]);
}

- (float)totalInventoryForFlavor:(Flavors *)flavor {
    float totalInGallons = 0.0;
    NSArray *flavorInventoryArray = [[flavor relationshipFlavorInventoryItems] allObjects];
    for (InventoryItems *inventoryItem in flavorInventoryArray) {
        totalInGallons = totalInGallons + [[inventoryItem sizeInGallons] floatValue];
    }
    return totalInGallons;
}

#pragma mark - Interactivity Methods

- (IBAction)editButtonPressed:(id)sender {
    if (![_flavorsTableView isEditing]) {
        [_flavorsTableView setEditing:YES animated:YES];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
    } else {
        [_flavorsTableView setEditing:NO animated:YES];
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
    }
    [_flavorsTableView reloadData];
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_flavorsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _flavorsTableView) {
        static NSString *CellIdentifier = @"iCell";
        GCFlavorCell *iCell = (GCFlavorCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        UITableViewCell *iCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (iCell == nil) {
            /*
            iCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            iCell.textLabel.textColor = [UIColor blueColor];
            UIFont *regularFont = [UIFont fontWithName:@"Helvetica" size:18.0];
            UIFont *boldFont = [UIFont fontWithName:@"Helvetica-Bold" size:25.0];
            iCell.textLabel.font = boldFont;
            iCell.detailTextLabel.font = regularFont;
            */
            iCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        Flavors *currentFlavor = [_flavorsArray objectAtIndex:[indexPath row]];
        iCell.flavorNameLabel.text = [currentFlavor flavorName];
        iCell.flavorRankingLabel.text = [NSString stringWithFormat:@"Ranking: %i",[[currentFlavor flavorRating] intValue]];
        iCell.flavorImageView.image = [UIImage imageNamed:[currentFlavor flavorImage]];
        /*
        iCell.textLabel.text = [currentFlavor flavorName];
        iCell.detailTextLabel.text = [NSString stringWithFormat:@"Ranking: %i",[[currentFlavor flavorRating] intValue]];
        iCell.imageView.image = [UIImage imageNamed:[currentFlavor flavorImage]];
        */
        
        if (_flavorsTableView.editing) {
            iCell.flavorImageView.hidden = YES;
        } else {
            iCell.flavorImageView.hidden = NO;
        }
        return iCell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellHeight = 44.0;
    if (tableView == _flavorsTableView) {
        cellHeight = 60.0;
    }
    return cellHeight;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _flavorsTableView) {
        Flavors *currentFlavor = [_flavorsArray objectAtIndex:[indexPath row]];
        NSLog(@"Tapped row %i %@",[indexPath row],[currentFlavor flavorName]);
        [self performSegueWithIdentifier:@"flavorsToDetailSegue" sender:self];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString: @"flavorsToDetailSegue"]) {
        NSIndexPath *indexPath = [_flavorsTableView indexPathForSelectedRow];
        Flavors *selectedFlavor = [_flavorsArray objectAtIndex:[indexPath row]];
        GCDetailViewController *destController = [segue destinationViewController];
        [destController setSelectedFlavor:selectedFlavor];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _flavorsTableView) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSLog(@"Move From %i to %i",[sourceIndexPath row],[destinationIndexPath row]);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _flavorsTableView) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"Delete: %i",[indexPath row]);
        [self editButtonPressed:self];
    }
}

#pragma mark - System Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self fetchFlavors];
    for (Flavors *flavor in _flavorsArray) {
        NSLog(@"Flavor: %@ Gallons: %.2f",[flavor flavorName],[self totalInventoryForFlavor:flavor]);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
