
#import <Foundation/Foundation.h>
#import "Word.h"

@interface WordsManager : NSObject

+ (WordsManager *)sharedInstance;

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;

- (Word *)wordAtIndexPath:(NSIndexPath *)indexPath;

- (NSUInteger)numberOfWords;

- (void)refreshInBackgroundIfNecessary:(void (^)(BOOL))completionBlock;

- (Word *)lastWord;

- (void)deleteAllWords;

@end
