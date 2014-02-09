//
//  SettingsViewController.m
//  DexWordOfTheDay
//
//  Created by Florin Munteanu on 07/12/13.
//  Copyright (c) 2013 Florin Munteanu. All rights reserved.
//

#import "SettingsViewController.h"
#import "WordsCDTVC.h"

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
    
    if (self.managedObjectContext == nil)
    {
        NSArray* vc = self.tabBarController.viewControllers;
        if ([vc[0] isKindOfClass:[UINavigationController class]])
        {
            UINavigationController* nc = (UINavigationController *)vc[0];
            WordsCDTVC* w = (WordsCDTVC *)[nc viewControllers][0];
        
            self.managedObjectContext = w.managedObjectContext;
        }
    }
    
    BOOL isOn = [[NSUserDefaults standardUserDefaults] boolForKey:AUTO_SYNC];
    [self.autoSyncSwitch setOn:isOn];
}

- (IBAction)changeAutoSync:(id)sender
{
    NSNumber* isOn =[NSNumber numberWithBool:self.autoSyncSwitch.on];
    
    [[NSUserDefaults standardUserDefaults] setObject:isOn forKey:AUTO_SYNC];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)deleteAllWords:(id)sender
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
    //request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"day" ascending:NO]];
    request.predicate = nil; // all words
    
    NSError* errors;
    NSArray* words = [self.managedObjectContext executeFetchRequest:request error:&errors];
    
    if (errors)
    {
        
    }
    else
    {
        for (id word in words)
        {
            [self.managedObjectContext deleteObject:word];
        }
    }
}

@end
