//
//  GCDetailViewController.m
//  Table View Intro
//
//  Created by Thomas Crawford on 11/4/13.
//  Copyright (c) 2013 Thomas Crawford. All rights reserved.
//

#import "GCDetailViewController.h"

@interface GCDetailViewController ()

@property (nonatomic, strong) IBOutlet UITextField      *flavorNameTextField;

@end

@implementation GCDetailViewController

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
    _flavorNameTextField.text = [_selectedFlavor flavorName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
