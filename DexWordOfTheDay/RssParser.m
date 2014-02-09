//
//  RssParser.m
//  DexWordOfTheDay
//
//  Created by Florin Munteanu on 12/11/13.
//  Copyright (c) 2013 Florin Munteanu. All rights reserved.
//
#import <Foundation/NSValue.h>
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
    [dateFormatter setDateFormat:@"EEE, dd MM yyyy HH:mm:ss"];
    
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
        currentWord.htmlDefinition = [NSString stringWithString:definition];
        //currentWord.definition = [self clearHtmlTags:definition];
        currentWord.link = [NSString stringWithString:link];
        currentWord.imageURL = [self getImageURL:definition];
        
        NSString* trimmedDay = [day stringByReplacingOccurrencesOfString:@"EEST" withString:@""];
        trimmedDay = [trimmedDay stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        trimmedDay = [trimmedDay stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        day = [NSMutableString stringWithString:trimmedDay];
        
        currentWord.day = [dateFormatter dateFromString:day];
        if (currentWord.day == nil)
        {
            currentWord.day = [NSDate date];
        }
        
        [self.words addObject:currentWord];
    }
}

-(NSString *)getImageURL:(NSString *)wordDefinition
{
    NSRange src = [wordDefinition rangeOfString:@"src=\""];
    NSRange ext = [wordDefinition rangeOfString:@".jpg\""];
    
    if (src.length == 0)
    {
        return @"";
    }
    else if (ext.length == 0)
    {
        ext = [wordDefinition rangeOfString:@".jpeg\""];
        
        if (ext.length == 0)
        {
            return @"";
        }
    }
    
    return [wordDefinition substringWithRange:NSMakeRange(src.location + src.length, ext.location + ext.length - src.location - src.length - 1)];
}

/*
-(NSString *)getShortDefinition:(NSString *)wordDefinition
{
    NSRange prefix = [wordDefinition rangeOfString:@"<b>1.</b>"];
    
    if (prefix.length > 0)
    {
        NSUInteger start = prefix.location + prefix.length;
        
        // Search the first occurence of '<' character after "<b>1.</b>".
        NSRange end = [wordDefinition rangeOfString:@"<" options:NSLiteralSearch range:NSMakeRange(start, wordDefinition.length - prefix.location + prefix.length)];
        if (end.length > 0)
        {
            NSUInteger length = end.location - prefix.location - prefix.length;
            
            return [wordDefinition substringWithRange:NSMakeRange(start, length)];
        }
    }
    return nil;
}

-(NSArray *)getHtmlTags:(NSString *)wordDefinition
{
    NSMutableArray* tags = [[NSMutableArray alloc] initWithCapacity:12];
    
    NSUInteger startTagPosition = 0;
    NSUInteger endTagPosition = 0;
    BOOL startTagFound = FALSE;
    BOOL endTagFound = FALSE;
    
    // http://cocoadevcentral.com/articles/000082.php
    NSRange range = {0, [wordDefinition length]};
    
    unichar buffer[range.length];
    
    [wordDefinition getCharacters:buffer range:range];
    
    for (unsigned i = 0; i < range.length; i++)
    {
        unichar c = buffer[i];
        switch (c)
        {
            case '<':
            {
                if (startTagFound == FALSE)
                {
                    startTagPosition = i;
                    startTagFound = TRUE;
                }
                break;
            }
            case '/':
            {
                endTagFound = TRUE;
                break;
            }
            case '>':
            {
                if (endTagFound == TRUE)
                {
                    endTagPosition = i;
                    // reset tags
                    endTagFound = FALSE;
                    startTagFound = FALSE;
                    
                    NSRange tag = NSMakeRange(startTagPosition, endTagPosition - startTagPosition + 1);
                    [tags addObject:[NSValue valueWithRange:tag]];
                }
                break;
            }
            default:
                break;
        }
    }
    
    return tags;
}

-(NSString *)clearHtmlTags:(NSString *)wordDefinition
{
    NSArray* tags = [self getHtmlTags:wordDefinition];
    for (NSValue * tag in tags)
    {
        NSRange range = [tag rangeValue];
        NSString * replacement = [@"" stringByPaddingToLength:range.length withString:@" " startingAtIndex:0];
        wordDefinition = [wordDefinition stringByReplacingCharactersInRange:range withString:replacement];
    }
    
    return wordDefinition;
}
*/

@end
