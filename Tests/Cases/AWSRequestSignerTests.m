//
//  AWSRequestSignerTests.m
//  Tests
//
//  Created by Brandon Smith on 3/22/14.
//
//

#import <XCTest/XCTest.h>
#import <AWSRequestSigner/AWSRequestSigner.h>

@interface AWSRequestSignerTests : XCTestCase

@end

@implementation AWSRequestSignerTests

- (void)testGET {
    
    AWSRequestSigner *signer = [AWSRequestSigner signerWithAccessKey:@"AKIAIOSFODNN7EXAMPLE" secretKey:@"wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"];
    signer.service = @"s3";
    signer.region = @"us-east-1";
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://examplebucket.s3.amazonaws.com/test.txt"]];
    [req addValue:@"examplebucket.s3.amazonaws.com" forHTTPHeaderField:@"host"];
    [req addValue:@"bytes=0-9" forHTTPHeaderField:@"range"];
    [req addValue:@"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855" forHTTPHeaderField:@"x-amz-content-sha256"];
    [req addValue:@"20130524T000000Z" forHTTPHeaderField:@"x-amz-date"];
    
    NSString *expected = @"AWS4-HMAC-SHA256 Credential=AKIAIOSFODNN7EXAMPLE/20130524/us-east-1/s3/aws4_request,SignedHeaders=host;range;x-amz-content-sha256;x-amz-date,Signature=f0e8bdb87c964420e857bd35b5d6ed310bd44f0170aba48dd91039c6036bdb41";
    
    [signer sign:req];
    
    XCTAssertEqualObjects([req valueForHTTPHeaderField:@"Authorization"], expected);
}

@end
