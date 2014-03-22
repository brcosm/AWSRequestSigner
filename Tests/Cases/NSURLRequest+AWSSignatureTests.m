//
//  NSURLRequest+AWSSignatureTests.m
//  Tests
//
//  Created by Brandon Smith on 3/22/14.
//
//

#import <XCTest/XCTest.h>
#import <AWSRequestSigner/NSURLRequest+AWSSignature.h>

@interface NSURLRequest_AWSSignatureTests : XCTestCase

@end

static NSURL *U(NSString *url) {
    return [NSURL URLWithString:url];
}

@implementation NSURLRequest_AWSSignatureTests

- (void)testRequest {
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:U(@"http://host")];
    [req setValue:@"host" forHTTPHeaderField:@"Host"];
    [req setValue:@"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" forHTTPHeaderField:@"x-amz-content-sha256"];
    
    NSString *canon = @"GET\n/\n\nhost:host\nx-amz-content-sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855\n\nhost;x-amz-content-sha256\ne3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";
    XCTAssertEqualObjects([req aws_canonicalRequestString], canon);
    
    NSString *headerSig = @"host;x-amz-content-sha256";
    XCTAssertEqualObjects([req aws_headerSignature], headerSig);
}

- (void)testRequestWithTrailingSlash {
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:U(@"http://host/")];
    NSString *canon = @"GET\n/\n\n\n\ne3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";
    XCTAssertEqualObjects([req aws_canonicalRequestString], canon);
}

- (void)testRequestWithQueryParams {
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:U(@"http://host/resource?prefix=somePrefix&marker=someMarker&max-keys=20")];
    NSString *canon = @"GET\n/resource\nmarker=someMarker&max-keys=20&prefix=somePrefix\n\n\ne3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";
    XCTAssertEqualObjects([req aws_canonicalRequestString], canon);
}

- (void)testRequestWithSubResource {
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:U(@"http://host/resource?subResource")];
    NSString *canon = @"GET\n/resource\nsubResource=\n\n\ne3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";
    XCTAssertEqualObjects([req aws_canonicalRequestString], canon);
}

@end