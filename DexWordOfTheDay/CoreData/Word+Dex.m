//
//  Word+Dex.m
//  DexWordOfTheDay
//
//  Created by Florin Munteanu on 9/3/13.
//  Copyright (c) 2013 Florin Munteanu. All rights reserved.
//

#import "Word+Dex.h"
#import "Word.h"
#import "RssWord.h"

@implementation Word (Dex)

+ (Word *)fromRssWord:(RssWord *)rssWord inManagedObjectContext:(NSManagedObjectContext *)context
{
    Word* word = nil;
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", rssWord.title];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (matches == nil || [matches count] > 1)
    {
        // fetch failed
        // handle error if any
        
    }
    else if ([matches count] == 0)
    {
        word = [NSEntityDescription insertNewObjectForEntityForName:@"Word" inManagedObjectContext:context];
        word.title = rssWord.title;
        word.day = rssWord.day;
        word.definition = rssWord.definition;
        word.imageURL = rssWord.imageURL;
        word.link = rssWord.link;
    }
    else
    {
        word = [matches lastObject];
    }
    
    return word;
}

@end
