//
//  Word+Dex.h
//  DexWordOfTheDay
//
//  Created by Florin Munteanu on 9/3/13.
//  Copyright (c) 2013 Florin Munteanu. All rights reserved.
//

#import "Word.h"
#import "RssWord.h"

@interface Word (Dex)

+ (Word *)fromRssWord:(RssWord *)word inManagedObjectContext:(NSManagedObjectContext *)context;

@end
