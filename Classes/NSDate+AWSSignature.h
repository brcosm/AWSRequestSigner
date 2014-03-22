//
//  NSDate+AWSSignature.h
//  
//
//  Created by Brandon Smith on 3/22/14.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (AWSSignature)

+ (instancetype)aws_date:(NSString *)dateString;

- (NSString *)aws_scopeString;

- (NSString *)aws_iso8601String;

@end
