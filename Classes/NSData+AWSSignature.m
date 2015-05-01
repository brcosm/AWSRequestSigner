//
//  NSData+AWSSignature.m
//  
//
//  Created by Brandon Smith on 3/22/14.
//
//

#import "NSData+AWSSignature.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSData (AWSSignature)

- (NSData *)aws_SHA256 {
    uint8_t hash[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(self.bytes, self.length, hash);
    return [NSData dataWithBytes:hash length:CC_SHA256_DIGEST_LENGTH];
}

- (NSData *)aws_SHA256:(NSData *)key {
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};    
    CCHmac(kCCHmacAlgSHA256, key.bytes, key.length, self.bytes, self.length, digest);
    NSData *hash = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    return hash;
}

- (NSString *)aws_hexEncodedString {
    NSMutableString *hexString = [NSMutableString stringWithCapacity:self.length*2];
    const char *bytes = self.bytes;
    for (int i = 0; i < self.length; i++) {
        [hexString appendFormat:@"%02x", (unsigned char)bytes[i]];
    }
    return hexString;
}

@end