
#import <Foundation/Foundation.h>

@interface RssWord : NSObject

@property (nonatomic, strong) NSDate * day;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * definition;
@property (nonatomic, strong) NSData * image;
@property (nonatomic, strong) NSString * imageURL;
@property (nonatomic, strong) NSString * link;
@property (nonatomic, strong) NSString * htmlDefinition;

@end
