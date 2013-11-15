//
//  RssParser.m
//  DexWordOfTheDay
//
//  Created by Florin Munteanu on 12/11/13.
//  Copyright (c) 2013 Florin Munteanu. All rights reserved.
//

#import "RssParser.h"
#import "RssWord.h"

@interface RssParser()
{
    NSString* currentElement;
    RssWord* currentWord;
    
    NSMutableString* day;
    NSMutableString* title;
    NSMutableString* definition;
    NSMutableString* link;
    
    NSDateFormatter* dateFormatter;
    
    NSXMLParser* parser;
}

@property (nonatomic, strong) NSMutableArray* words; // Of type RssWord

@end

@implementation RssParser

- (NSArray *)parseContent:(NSString *)content
{
    self.words = [[NSMutableArray alloc] init];
    if ([content length] == 0)
    {
        return self.words;
    }
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, d MM yyyy HH:mm:ss"];
    
    parser = [[NSXMLParser alloc] initWithData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
    return self.words;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    currentElement = elementName;
    
    if ([currentElement isEqualToString:@"item"])
    {
        currentWord = [[RssWord alloc] init];
        
        day = [[NSMutableString alloc] init];
        title = [[NSMutableString alloc] init];
        definition = [[NSMutableString alloc] init];
        link = [[NSMutableString alloc] init];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([currentElement isEqualToString:@"title"])
    {
        [title appendString:string];
    }
    else if ([currentElement isEqualToString:@"pubDate"])
    {
        [day appendString:string];
    }
    else if ([currentElement isEqualToString:@"link"])
    {
        [link appendString:string];
    }
    else if ([currentElement isEqualToString:@"description"])
    {
        [definition appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"])
    {
        currentWord.title = [NSString stringWithString:title];
        currentWord.definition = definition;
        currentWord.link = link;
        
        currentWord.day = [dateFormatter dateFromString:day];
        
        if (currentWord.day == nil)
        {
            currentWord.day = [NSDate date];
        }
        
        [self.words addObject:[currentWord copy]];
    }
}

-(NSString*)getPictureLink:(NSString *)definition
{
    NSRange r1 = [definition rangeOfString:@"src=\""];
    NSRange r2 = [definition rangeOfString:@".jpg\""];
    
    if (r1.location == NSNotFound || r2.location == NSNotFound)
    {
        return @"";
    }
    else
    {
        return [definition substringWithRange:NSMakeRange(r1.location + r1.length, r2.location + r2.location)];
    }
}

@end
