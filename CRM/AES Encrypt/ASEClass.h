//
//  ASEClass.h
//  Arkangel
//
//  Created by Vikash on 04/01/13.
//  Copyright (c) 2013 Manish Verma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASEClass : NSObject
+ (NSData *)encryptedDataForData:(NSData *)data
                        password:(NSString *)password
                              iv:(NSData **)iv
                            salt:(NSData **)salt
                           error:(NSError **)error;

+ (NSData *)randomDataOfLength:(size_t)length ;

+ (NSData *)AESKeyForPassword:(NSString *)password
                         salt:(NSData *)salt;
@end
