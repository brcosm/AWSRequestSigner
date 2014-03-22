//
//  NSDate+AWSSignatureTests.m
//  Tests
//
//  Created by Brandon Smith on 3/22/14.
//
//

#import <XCTest/XCTest.h>
#import <AWSRequestSigner/NSDate+AWSSignature.h>

@interface NSDate_AWSSignatureTests : XCTestCase

@end

@implementation NSDate_AWSSignatureTests


- (void)testScopeString {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
    NSString *scopeString = [date aws_scopeString];
    XCTAssertEqualObjects(scopeString, @"19700101");
}

- (void)testISO8601String {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
    NSString *scopeString = [date aws_iso8601String];
    XCTAssertEqualObjects(scopeString, @"19700101T000000Z");
}

@end
