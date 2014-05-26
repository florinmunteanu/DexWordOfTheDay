
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Word : NSManagedObject

@property (nonatomic, retain) NSDate * day;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * htmlDefinition;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * link;

@end
