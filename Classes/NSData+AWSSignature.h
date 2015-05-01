//
//  NSData+AWSSignature.h
//  
//
//  Created by Brandon Smith on 3/22/14.
//
//

#import <Foundation/Foundation.h>

@interface NSData (AWSSignature)

- (NSData *)aws_SHA256;

- (NSData *)aws_SHA256:(NSData *)key;

- (NSString *)aws_hexEncodedString;

@end
