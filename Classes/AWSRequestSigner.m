//
//  AWSRequestSigner.m
//
//
//  Created by Brandon Smith on 3/22/14.
//
//

#import "AWSRequestSigner.h"
#import "NSData+AWSSignature.h"
#import "NSDate+AWSSignature.h"
#import "NSURLRequest+AWSSignature.h"

static NSString * const kAWSV4SigDescription = @"AWS4-HMAC-SHA256";

static NSString * const kAWSV4SigScope = @"aws4_request";

static NSString * Scope(NSDate *date, NSString *region, NSString *service) {
    return [@[
              [date aws_scopeString],
              region,
              service,
              kAWSV4SigScope]
            componentsJoinedByString:@"/"];
};

static NSString * SHA256HEX(NSString *canon) {
    return [[[canon dataUsingEncoding:NSUTF8StringEncoding] aws_SHA256] aws_hexEncodedString];
};

@interface AWSRequestSigner()
@property (nonatomic, copy) NSString *accessKey;
@property (nonatomic, copy) NSString *secretKey;
@property (nonatomic, strong) NSDate *date;
@end

@implementation AWSRequestSigner

+ (instancetype)signerWithAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey {
    return [[self alloc] initWithAccessKey:accessKey secretKey:secretKey];
}

- (id)initWithAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey {
    self = [super init];
    if (self) {
        self.accessKey = accessKey;
        self.secretKey = secretKey;
        self.region = @"us-east-1";
        self.service = @"s3";
    }
    return self;
}

- (id)init {
    return [self initWithAccessKey:nil secretKey:nil];
}

- (NSData *)signingKey {
    NSData *key           = [[NSString stringWithFormat:@"AWS4%@", self.secretKey] dataUsingEncoding:NSUTF8StringEncoding];
    NSData *signedScope   = [[[self.date aws_scopeString] dataUsingEncoding:NSUTF8StringEncoding] aws_SHA256:key];
    NSData *signedRegion  = [[self.region dataUsingEncoding:NSUTF8StringEncoding] aws_SHA256:signedScope];
    NSData *signedService = [[self.service dataUsingEncoding:NSUTF8StringEncoding] aws_SHA256:signedRegion];
    return [[kAWSV4SigScope dataUsingEncoding:NSUTF8StringEncoding] aws_SHA256:signedService];
}

- (NSString *)stringToSign:(NSURLRequest *)request {
    return [@[
        kAWSV4SigDescription,
        [self.date aws_iso8601String],
        Scope(self.date, self.region, self.service),
        SHA256HEX([request aws_canonicalRequestString])]
    componentsJoinedByString:@"\n"];
}

- (NSString *)signatureForRequest:(NSURLRequest *)request {
    // Generate the signing key
    NSData *signingKey = [self signingKey];
    
    // Generate the string that will be signed
    NSString *stringToSign = [self stringToSign:request];
    
    // Generate the signature
    NSData *signature = [[stringToSign dataUsingEncoding:NSUTF8StringEncoding] aws_SHA256:signingKey];
    
    // Generate the authorization header
    return [NSString stringWithFormat:@"%@ Credential=%@/%@,SignedHeaders=%@,Signature=%@",
        kAWSV4SigDescription,
        self.accessKey,
        Scope(self.date, self.region, self.service),
        [request aws_headerSignature],
        [signature aws_hexEncodedString]];
}

- (void)sign:(NSMutableURLRequest *)request {
    
    // Get/set date
    if ([request valueForHTTPHeaderField:@"x-amz-date"]) {
        self.date = [NSDate aws_date:[request valueForHTTPHeaderField:@"x-amz-date"]];
    } else {
        self.date = [NSDate date];
        [request setValue:[self.date aws_iso8601String] forHTTPHeaderField:@"x-amz-date"];
    }
    
    // Add host
    if (! [request valueForHTTPHeaderField:@"host"]) {
        [request setValue:request.URL.host forHTTPHeaderField:@"host"];
    }
    
    [request setValue:[self signatureForRequest:request] forHTTPHeaderField:@"Authorization"];
}

@end