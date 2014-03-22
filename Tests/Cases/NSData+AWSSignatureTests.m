//
//  NSData+AWSSignatureTests.m
//  Tests
//
//  Created by Brandon Smith on 3/22/14.
//
//

#import <XCTest/XCTest.h>
#import <AWSRequestSigner/NSData+AWSSignature.h>

@interface NSData_AWSSignatureTests : XCTestCase

@end

@implementation NSData_AWSSignatureTests

- (void)testSHA256WithEmptyData {
    NSString *expectedHex = @"<e3b0c442 98fc1c14 9afbf4c8 996fb924 27ae41e4 649b934c a495991b 7852b855>";
    NSData *data = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *hash = [data aws_SHA256];
    XCTAssertEqualObjects([hash description], expectedHex);
}

- (void)testSHA256WithEmptyDataAndEmptyKey {
    NSString *expectedHex = @"<b613679a 0814d9ec 772f95d7 78c35fc5 ff1697c4 93715653 c6c71214 4292c5ad>";
    NSData *data = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *hash = [data aws_SHA256:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
    XCTAssertEqualObjects([hash description], expectedHex);
}

- (void)testSHA256WithEmptyDataAndKey {
    NSString *expectedHex = @"<951b1837 c0c5281f bc1a0dde 967d1904 908c1b64 bfbcf9f3 c3a99822 0f2f4b31>";
    NSData *data = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *hash = [data aws_SHA256:[@"aKey" dataUsingEncoding:NSUTF8StringEncoding]];
    XCTAssertEqualObjects([hash description], expectedHex);
}

- (void)testSHA256WithKey {
    NSString *expectedHex = @"<d1fb39ec f754b629 33a51b25 87b6f076 dfdc6b80 8448b595 40bd25e5 88b6cc97>";
    NSData *data = [@"someData" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *hash = [data aws_SHA256:[@"aKey" dataUsingEncoding:NSUTF8StringEncoding]];
    XCTAssertEqualObjects([hash description], expectedHex);
}

- (void)testSHA256 {
    NSString *expectedHex = @"<8fe66dfe 080fa7fd 45d60a30 8097217a 92a85b1c 0ac02f31 b11572ea 0422514e>";
    NSData *data = [@"someData" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *hash = [data aws_SHA256];
    XCTAssertEqualObjects([hash description], expectedHex);
}

- (void)testHexEncodedString {
    NSString *expectedHex = @"736f6d6544617461";
    NSData *data = [@"someData" dataUsingEncoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects([data aws_hexEncodedString], expectedHex);
}

@end
