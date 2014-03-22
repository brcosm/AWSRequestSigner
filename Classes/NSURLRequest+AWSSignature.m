//
//  NSURLRequest+AWSSignature.m
//  
//
//  Created by Brandon Smith on 3/22/14.
//
//

#import "NSURLRequest+AWSSignature.h"
#import "NSDate+AWSSignature.h"
#import "NSData+AWSSignature.h"

@implementation NSURLRequest (AWSSignature)

#pragma mark - Private

- (NSString *)aws_canonicalURI {
    return self.URL.path.length == 0 ? @"/" : [self.URL.path stringByStandardizingPath];
}

- (NSString *)aws_canonicalQueryString {
    NSString *urlString = @"";
    NSArray *params = [self.URL.query componentsSeparatedByString:@"&"];
    if (params.count > 0) {
        NSMutableDictionary *paramDictionary = [NSMutableDictionary dictionary];
        for (NSString *param in params) {
            NSArray *paramSet = [param componentsSeparatedByString:@"="];
            NSMutableArray *vals = [NSMutableArray array];
            if ([paramDictionary objectForKey:[paramSet objectAtIndex:0]]) {
                vals = [paramDictionary objectForKey:[paramSet objectAtIndex:0]];
            }
            if (paramSet.count > 1) {
                [vals addObject:[paramSet objectAtIndex:1]];
            } else {
                [vals addObject:@""];
            }
            [paramDictionary setObject:vals forKey:[paramSet objectAtIndex:0]];
        }
        NSMutableString *newString = [NSMutableString string];
        int i = [[paramDictionary allKeys] count];
        NSArray *sortedKeys = [[paramDictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *a, NSString *b) {
            return [a compare:b options:NSLiteralSearch];
        }];
        for (NSString *key in sortedKeys) {
            NSArray *vals =
            [[paramDictionary valueForKey:key] sortedArrayUsingComparator:^NSComparisonResult(NSString *a, NSString *b) {
                return [a compare:b options:NSLiteralSearch];
            }];
            for (NSString *val in vals) {
                // AFNetworking URL encoding does not encode commas
                [newString appendFormat:@"%@=%@", key , [val stringByReplacingOccurrencesOfString:@"," withString:@"%2C"]];
                if (val != [vals lastObject]) {
                    [newString appendFormat:@"&"];
                }
            }
            --i > 0 ? [newString appendFormat:@"&"] : nil;
        }
        urlString = [NSString stringWithString:newString];
    }
    return urlString;
}

- (NSString *)aws_canonicalHeaderString {
    NSMutableArray *sortedHeaders = [NSMutableArray arrayWithArray:self.allHTTPHeaderFields.allKeys];
    [sortedHeaders sortUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableString *headerString = [NSMutableString string];
    for (NSString *header in sortedHeaders) {
        [headerString appendString:[header lowercaseString]];
        [headerString appendString:@":"];
        [headerString appendString:[self.allHTTPHeaderFields valueForKey:header]];
        [headerString appendString:@"\n"];
    }
    
    NSCharacterSet *whitespaceChars = [NSCharacterSet whitespaceCharacterSet];
    NSPredicate *noEmptyStrings     = [NSPredicate predicateWithFormat:@"SELF != ''"];
    
    NSArray *parts = [headerString componentsSeparatedByCharactersInSet:whitespaceChars];
    NSArray *nonWhitespace = [parts filteredArrayUsingPredicate:noEmptyStrings];
    return [nonWhitespace componentsJoinedByString:@" "];
}

- (NSString *)aws_headerSignature {
    NSMutableArray *sortedHeaders = [NSMutableArray arrayWithArray:self.allHTTPHeaderFields.allKeys];
    [sortedHeaders sortUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableString *headerString = [NSMutableString string];
    for (NSString *header in sortedHeaders) {
        if ([headerString length] > 0) {
            [headerString appendString:@";"];
        }
        [headerString appendString:[header lowercaseString]];
    }
    return headerString;
}

- (NSString *)aws_payloadHash {
    NSData *payload = self.HTTPBody ? self.HTTPBody : [@"" dataUsingEncoding:NSUTF8StringEncoding];
    return [[payload aws_SHA256] aws_hexEncodedString];
}

#pragma mark - Public

- (NSString *)aws_canonicalRequestString {
    return [@[
        [self HTTPMethod],
        [self aws_canonicalURI],
        [self aws_canonicalQueryString],
        [self aws_canonicalHeaderString],
        [self aws_headerSignature],
        [self aws_payloadHash]]
    componentsJoinedByString:@"\n"];
}

@end
