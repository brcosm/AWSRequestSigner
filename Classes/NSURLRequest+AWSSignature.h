//
//  NSURLRequest+AWSSignature.h
//  
//
//  Created by Brandon Smith on 3/22/14.
//
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (AWSSignature)

- (NSString *)aws_canonicalRequestString;

- (NSString *)aws_headerSignature;

@end
