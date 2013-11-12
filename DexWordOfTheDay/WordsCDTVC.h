//
//  WordsCDTVC.h
//  DexWordOfTheDay
//
//  Created by Florin Munteanu on 9/3/13.
//  Copyright (c) 2013 Florin Munteanu. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface WordsCDTVC : CoreDataTableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
