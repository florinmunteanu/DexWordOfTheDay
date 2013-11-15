//
//  RssParser.h
//  DexWordOfTheDay
//
//  Created by Florin Munteanu on 12/11/13.
//  Copyright (c) 2013 Florin Munteanu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RssParser : NSObject <NSXMLParserDelegate>

- (NSArray*)parseContent:(NSString*) content;

@end
