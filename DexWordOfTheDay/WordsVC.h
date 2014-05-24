//
//  WordsVC.h
//  DexWordOfTheDay
//
//  Created by Florin Munteanu on 15/05/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordsVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;

@end
