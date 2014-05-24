//
//  WordsManager.m
//  DexWordOfTheDay
//
//  Created by Florin Munteanu on 05/05/14.
//  Copyright (c) 2014 Florin Munteanu. All rights reserved.
//

#import "WordsManager.h"
#import "Word.h"

@interface WordsManager()

@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;

@end

@implementation WordsManager

+ (WordsManager *)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"day" ascending:NO]];
        request.predicate = nil; // all words
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        NSError* error;
        [self.fetchedResultsController performFetch:&error];
        if (error)
        {
            
        }
    }
    else
    {
        self.fetchedResultsController = nil;
    }
}

- (Word *)wordAtIndexPath:(NSIndexPath *)indexPath
{
    Word* word = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return word;
}

- (NSUInteger)numberOfWords
{
    return [[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects];
}
@end
