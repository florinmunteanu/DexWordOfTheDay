
#import "WordsManager.h"
#import "Word.h"
#import "Word+Dex.h"
#import "RssParser.h"
#import "RssWord.h"

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
            // retry?
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

- (Word *)lastWord
{
    if ([self numberOfWords] > 0)
    {
        return [self wordAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    return nil;
}

- (void)refreshData:(void (^)(BOOL success))completionBlock
{
    dispatch_queue_t fetchQ = dispatch_queue_create("RSS Fetch", NULL);
    dispatch_async(fetchQ, ^{
        NSError *error = nil;
        NSURL *rssUrl = [[NSURL alloc] initWithString:@"http://dexonline.ro/rss/cuvantul-zilei"];
        NSString *content = [[NSString alloc] initWithContentsOfURL:rssUrl encoding:NSUTF8StringEncoding error:&error];
        
        if (error == nil)
        {
            RssParser* parser = [[RssParser alloc] init];
            NSArray* rssWords = [parser parseContent:content];
            [self saveRssWordsInDatabase:rssWords completionBlock:completionBlock];
        }
        else
        {
            if (completionBlock)
            {
                // Dispatch to main queue
                dispatch_async(dispatch_get_main_queue(), ^{ completionBlock(NO); });
            }
        }
    });
}

- (void)saveRssWordsInDatabase:(NSArray *)rssWords
               completionBlock:(void (^)(BOOL success))completionBlock
{
    [self.managedObjectContext performBlock:
     ^{
         BOOL saveWasCompletelySuccessful = YES;
         for (RssWord *rssWord in rssWords)
         {
             NSError* error = nil;
             [Word fromRssWord:rssWord inManagedObjectContext:self.managedObjectContext saveError:&error];
             if (error)
             {
                 saveWasCompletelySuccessful = NO;
             }
         }
         if (completionBlock)
         {
             // Dispatch to main queue
             dispatch_async(dispatch_get_main_queue(), ^{ completionBlock(saveWasCompletelySuccessful); });
         }
     }];
}

- (void)deleteAllWords
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
    request.predicate = nil;
    
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

- (void)refreshInBackgroundIfNecessary:(void (^)(BOOL))completionBlock
{
    if ([self numberOfWords] == 0)
    {
        [self refreshData:completionBlock];
    }
    else
    {
        // Get the last word.
        // If it has the same date as today then do nothing.
        
        NSDateComponents* today = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        
        Word* lastWordEntry = [self lastWord];
        
        NSDateComponents* lastWordDay = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:lastWordEntry.day];
        
        if (today.day != lastWordDay.day || today.month != lastWordDay.month || today.year != lastWordDay.year)
        {
            [self refreshData:completionBlock];
        }
        else
        {
            if (completionBlock)
            {
                completionBlock(YES);
            }
        }
    }
}

@end
