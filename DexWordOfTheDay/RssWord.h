//
//  RssWord.h
//  DexWordOfTheDay
//
//  Created by Florin Munteanu on 15/11/13.
//  Copyright (c) 2013 Florin Munteanu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RssWord : NSObject

@property (nonatomic, strong) NSDate * day;
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * definition;
@property (nonatomic, strong) NSData * image;
@property (nonatomic, strong) NSString * imageURL;
@property (nonatomic, strong) NSString * link;

@end
