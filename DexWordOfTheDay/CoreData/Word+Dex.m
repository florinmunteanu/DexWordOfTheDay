
#import "Word+Dex.h"
#import "Word.h"
#import "RssWord.h"

@implementation Word (Dex)

+ (Word *)fromRssWord:(RssWord *)rssWord inManagedObjectContext:(NSManagedObjectContext *)context saveError:(NSError **)saveError
{
    Word* word = nil;
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Word"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    request.predicate = [NSPredicate predicateWithFormat:@"title = %@", rssWord.title];
    
    NSError* error = nil;
    NSArray* matches = [context executeFetchRequest:request error:&error];
    
    if (matches == nil || [matches count] > 1)
    {
        // fetch failed
        // handle error if any
        *saveError = error;
        
    }
    else if ([matches count] == 0)
    {
        word = [NSEntityDescription insertNewObjectForEntityForName:@"Word" inManagedObjectContext:context];
        word.title = rssWord.title;
        word.day = rssWord.day;
        word.htmlDefinition = rssWord.htmlDefinition;
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
