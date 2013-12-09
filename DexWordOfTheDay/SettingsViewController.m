//
//  SettingsViewController.m
//  DexWordOfTheDay
//
//  Created by Florin Munteanu on 07/12/13.
//  Copyright (c) 2013 Florin Munteanu. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

#define AUTO_SYNC @"AutoSync"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BOOL isOn = [[NSUserDefaults standardUserDefaults] boolForKey:AUTO_SYNC];
    [self.autoSyncSwitch setOn:isOn];
}

- (IBAction)changeAutoSync:(id)sender
{
    //[[NSUserDefaults standardUserDefaults] boolForKey:AUTO_SYNC];
    NSNumber* isOn =[NSNumber numberWithBool:self.autoSyncSwitch.on];
    
    [[NSUserDefaults standardUserDefaults] setObject:isOn forKey:AUTO_SYNC];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
