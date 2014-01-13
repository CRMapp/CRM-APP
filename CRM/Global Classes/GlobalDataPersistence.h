//
//  GlobalDataPersistence.h
//  FingerOlympic
//
//  Created by RahulSharma on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GlobalDataPersistence : NSObject
{
    
}
@property (nonatomic , retain) NSMutableArray* arrMyAddressBookData;
@property (nonatomic , retain) NSMutableDictionary* dictMyAddressBook;
@property (nonatomic , assign) BOOL isContactEditted;

//@property (nonatomic , copy) NSString* game_id;
//@property (nonatomic , copy) NSString* fb_id;
//@property (nonatomic , copy) NSString* user_email;
//@property (nonatomic , copy) NSString* user_id;
//@property (nonatomic , copy) NSString* user_image;
//@property (nonatomic , copy) NSString* username;
//@property (nonatomic , copy) NSString *secondPlayer_id;
//@property (nonatomic , copy) NSString *gameTurnNo;
//@property (nonatomic , copy) NSString *isTurnWin;
+ (GlobalDataPersistence *)sharedGlobalDataPersistence;
@end
