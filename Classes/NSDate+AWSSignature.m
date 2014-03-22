//
//  NSDate+AWSSignature.m
//  
//
//  Created by Brandon Smith on 3/22/14.
//
//

#import "NSDate+AWSSignature.h"

@implementation NSDate (AWSSignature)

- (NSString *)aws_scopeString {
    static NSDateFormatter *_fmt;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _fmt = [[NSDateFormatter alloc] init];
        _fmt.locale     = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        _fmt.timeZone   = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        _fmt.dateFormat = @"yyyyMMdd";
    });
    return [_fmt stringFromDate:self];
}

- (NSString *)aws_iso8601String {
    static NSDateFormatter *_fmt;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _fmt = [[NSDateFormatter alloc] init];
        _fmt.locale     = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        _fmt.timeZone   = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        _fmt.dateFormat = @"yyyyMMdd'T'HHmmss'Z'";
    });
    return [_fmt stringFromDate:self];
}

+ (instancetype)aws_date:(NSString *)dateString {
    static NSDateFormatter *_fmt;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _fmt = [[NSDateFormatter alloc] init];
        _fmt.locale     = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        _fmt.timeZone   = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        _fmt.dateFormat = @"yyyyMMdd'T'HHmmss'Z'";
    });
    
    return [_fmt dateFromString:dateString];
}

@end
