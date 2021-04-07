/*
 * This file is part of the FreeStreamer project,
 * (C)Copyright 2011-2014 Matias Muhonen <mmu@iki.fi>
 * See the file ''LICENSE'' for using the code.
 *
 * https://github.com/muhku/FreeStreamer
 */

#import "FSParseRssPodcastFeedRequest.h"
#import "FSPlaylistItem.h"

static NSString *const kXPathQueryItems = @"/rss/channel/item";

@interface FSParseRssPodcastFeedRequest (PrivateMethods)
- (void)parseItems:(xmlNodePtr)node;
@end

@implementation FSParseRssPodcastFeedRequest

- (void)parseItems:(xmlNodePtr)node
{
    FSPlaylistItem *item = [[FSPlaylistItem alloc] init];
    
    for (xmlNodePtr n = node->children; n != NULL; n = n->next) {
        NSString *nodeName = @((const char *)n->name);
        if ([nodeName isEqualToString:@"title"]) {
            item.title = [self contentForNode:n];
        } else if ([nodeName isEqualToString:@"enclosure"]) {
            item.url = [self contentForNodeAttribute:n attribute:"url"];
        } else if ([nodeName isEqualToString:@"link"]) {
            item.originatingUrl = [self contentForNode:n];
        }
    }
    
    if (nil == item.url &&
        nil == item.originatingUrl) {
        // Not a valid item, as there is no URL. Skip.
        return;
    }
    
    [_playlistItems addObject:item];
}

- (void)parseResponseData
{
    if (!_playlistItems) {
        _playlistItems = [[NSMutableArray alloc] init];
    }
    [_playlistItems removeAllObjects];
    
    // RSS feed publication date format:
    // Sun, 22 Jul 2012 17:35:05 GMT
    [_dateFormatter setDateFormat:@"EEE, dd MMMM yyyy HH:mm:ss V"];
    [_dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"]];
    
    [self performXPathQuery:kXPathQueryItems];
}

- (void)parseXMLNode:(xmlNodePtr)node xPathQuery:(NSString *)xPathQuery
{
    if ([xPathQuery isEqualToString:kXPathQueryItems]) {
        [self parseItems:node];
    }
}

- (NSArray *)playlistItems
{
    return _playlistItems;
}

@end