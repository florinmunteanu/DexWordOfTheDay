//
//  RssWord.h
//  DexWordOfTheDay
//
//  Created by Florin Munteanu on 15/11/13.
//  Copyright (c) 2013 Florin Munteanu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RssWord : NSObject

@property (nonatomic, weak) NSDate * day;
@property (nonatomic, weak) NSString * title;
@property (nonatomic, weak) NSString * definition;
@property (nonatomic, weak) NSData * image;
@property (nonatomic, weak) NSString * imageURL;
@property (nonatomic, weak) NSString * link;

@end
