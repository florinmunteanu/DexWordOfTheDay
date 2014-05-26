
#import "Word.h"
#import "RssWord.h"

@interface Word (Dex)

+ (Word *)fromRssWord:(RssWord *)word inManagedObjectContext:(NSManagedObjectContext *)context saveError:(NSError **)saveError;

@end
