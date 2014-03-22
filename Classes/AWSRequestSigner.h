//
//  AWSRequestSigner.h
//  
//
//  Created by Brandon Smith on 3/22/14.
//
//

#import <Foundation/Foundation.h>

@interface AWSRequestSigner : NSObject

@property (nonatomic, copy) NSString *region;

@property (nonatomic, copy) NSString *service;

+ (instancetype)signerWithAccessKey:(NSString *)accessKey secretKey:(NSString *)secretKey;

- (void)sign:(NSMutableURLRequest *)request;

@end