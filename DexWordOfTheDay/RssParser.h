
#import <Foundation/Foundation.h>

@interface RssParser : NSObject <NSXMLParserDelegate>

- (NSArray*)parseContent:(NSString*) content;

@end
