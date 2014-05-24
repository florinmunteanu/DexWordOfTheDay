//
//  WordsManager.h
//  DexWordOfTheDay
//
//  Created by Florin Munteanu on 05/05/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Word.h"

@interface WordsManager : NSObject

+ (WordsManager *)sharedInstance;

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;

- (Word *)wordAtIndexPath:(NSIndexPath *)indexPath;

- (NSUInteger)numberOfWords;

@end
