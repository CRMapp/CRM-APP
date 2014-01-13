//
//  AESEncryption.m
//  CRM
//
//  Created by Sheetal's iMac on 10/07/13.
//  Copyright (c) 2013 Sheetal's iMac. All rights reserved.
//

#import "AESEncryption.h"
#import "StringEncryption.h"
@implementation AESEncryption
/*changes made by narendra for encryption/decryption*/
#define klocalEncryption 1
#define klocalDecryption 1

#define kparseEncryption 1
#define kparseDecryption 1


#pragma mark- Encryption- Decryption Methods 
+ (NSString*)performEncryptionONString:(NSString*)strToBeEncrpypted withkey:(NSString*)key
{
	
	NSString *varKey				=	key;
	while (1)
	{
		if ([varKey length] > 0 && [varKey length] <= 32)
		{
			varKey = [varKey stringByAppendingString:varKey];
		}else
		{
			break;
		}
	}
	
	/*lenght > 32 make it to 32*/
	if ([varKey length] > 32)
	{
		varKey = [varKey substringToIndex:32];
		
		
	}
	
	key = varKey;
	
	NSString *encryptedString	=	[StringEncryption EncryptString:strToBeEncrpypted withKey:key];
	
	return (kparseEncryption)?encryptedString:strToBeEncrpypted;
}
// --------------------------------------
+ (NSString*)performEncryptionONString:(NSString*)strToBeEncrpypted
{
	NSString *encryptedString	=	[StringEncryption EncryptString:strToBeEncrpypted];
	
	return (klocalEncryption)?encryptedString:strToBeEncrpypted;
}


// --------------------------------------
+ (NSString*)performDecryptionONString:(NSString*)strToBeDecrpypted withKey:(NSString *)key
{
	
	NSString *varKey				=	key;
	while (1)
	{
		if ([varKey length] > 0 && [varKey length] <= 32)
		{
			varKey = [varKey stringByAppendingString:varKey];
		}else
		{
			break;
		}
	}
	
	/*lenght > 32 make it to 32*/
	if ([varKey length] > 32)
	{
		varKey = [varKey substringToIndex:32];
		
		
	}
	
	key = varKey;
	
	NSString *decryptedString	=	[StringEncryption DecryptString:strToBeDecrpypted withKey:key];
	
	return  (kparseDecryption)?decryptedString:strToBeDecrpypted;
}
// --------------------------------------


+ (NSString*)performDecryptionONString:(NSString*)strToBeDecrpypted
{
	NSString *decryptedString	=	[StringEncryption DecryptString:strToBeDecrpypted];
	
	return  (klocalDecryption)?decryptedString:strToBeDecrpypted;
}
@end
