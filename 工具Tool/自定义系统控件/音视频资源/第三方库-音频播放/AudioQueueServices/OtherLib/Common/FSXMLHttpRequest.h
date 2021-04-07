/*
 * This file is part of the FreeStreamer project,
 * (C)Copyright 2011-2014 Matias Muhonen <mmu@iki.fi>
 * See the file ''LICENSE'' for using the code.
 *
 * https://github.com/muhku/FreeStreamer
 */

#import <Foundation/Foundation.h>

#include <libxml/parser.h>

/**
 * XML HTTP request error status.
 */
typedef enum {
    FSXMLHttpRequestError_NoError = 0,
    FSXMLHttpRequestError_Connection_Failed,
    FSXMLHttpRequestError_Invalid_Http_Status,
    FSXMLHttpRequestError_XML_Parser_Failed
} FSXMLHttpRequestError;

/**
 * FSXMLHttpRequest is a class for retrieving data in the XML
 * format over a HTTP or HTTPS connection. It provides
 * the necessary foundation for parsing the retrieved XML data.
 * This class is not meant to be used directly but subclassed
 * to a specific requests.
 *
 * The usage pattern is the following:
 *
 * 1. Specify the URL with the url property.
 * 2. Define the onCompletion and onFailure handlers.
 * 3. Call the start method.
 */
@interface FSXMLHttpRequest : NSObject<NSURLConnectionDelegate> {
    NSURLConnection *_connection;
    NSInteger _httpStatus;
    NSMutableData *_receivedData;
    xmlDocPtr _xmlDocument;
    NSDateFormatter *_dateFormatter;
}

/**
 * The URL of the request.
 */
@property (nonatomic,copy) NSURL *url;
/**
 * Called upon completion of the request.
 */
@property (copy) void (^onCompletion)();
/**
 * Called upon a failure.
 */
@property (copy) void (^onFailure)();
/**
 * If the request fails, contains the latest error status.
 */
@property (readonly) FSXMLHttpRequestError lastError;

/**
 * Starts the request.
 */
- (void)start;
/**
 * Cancels the request.
 */
- (void)cancel;

/**
 * Performs an XPath query on the parsed XML data.
 * Yields a parseXMLNode method call, which must be
 * defined in the subclasses.
 *
 * @param query The XPath query to be performed.
 */
- (NSArray *)performXPathQuery:(NSString *)query;
/**
 * Retrieves content for the given XML node.
 *
 * @param node The node for content retreval.
 */
- (NSString *)contentForNode:(xmlNodePtr)node;
/**
 * Retrieves content for the given XML node attribute.
 *
 * @param node The node for content retrieval.
 * @param attr The attribute from which the content is retrieved.
 */
- (NSString *)contentForNodeAttribute:(xmlNodePtr)node attribute:(const char *)attr;
/**
 * Retrieves date from the given XML node.
 *
 * @param node The node for retrieving the date.
 */
- (NSDate *)dateFromNode:(xmlNodePtr)node;

@end