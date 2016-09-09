//
//  KeychainWrapper.h
//  MyNote
//
//  Created by CMB on 16/9/5.
//  Copyright © 2016年 CMB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainWrapper : NSObject

- (id)initWithAccount:(NSString *)account;
- (void)savePassword:(NSString *)p;
- (id)loadPassword;
- (void)deleteKeychain;
@end

