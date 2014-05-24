//
//  SettingsViewController.h
//  DexWordOfTheDay
//
//  Created by Florin Munteanu on 07/12/13.
//  Copyright (c) 2013 Florin Munteanu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController2 : UIViewController

@property (weak, nonatomic) IBOutlet UISwitch *autoSyncSwitch;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
