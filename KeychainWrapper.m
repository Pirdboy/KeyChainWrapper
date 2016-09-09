//
//  KeychainWrapper.m
//  MyNote
//
//  Created by CMB on 16/9/5.
//  Copyright © 2016年 CMB. All rights reserved.
//

#import "KeychainWrapper.h"

static const NSString *service = @"com.cmbchina.TestCoreData";
@interface KeychainWrapper ()
@property (strong, nonatomic) NSMutableDictionary *kcQuery;
@end

@implementation KeychainWrapper
# pragma mark - public method
- (id)initWithAccount:(NSString *)account {
    if(self = [super init]) {
        _kcQuery = [NSMutableDictionary dictionaryWithDictionary:@{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                                                                   (__bridge id)kSecAttrService: service,
                                                                   (__bridge id)kSecAttrAccount: account,
                                                                   (__bridge id)kSecAttrAccessible: (__bridge id)kSecAttrAccessibleAfterFirstUnlock,
                                                                   }];
    }
    return self;
}
- (void)savePassword:(NSString *)p {
    if(p == nil || [p length]==0)
        return;
    id oldpwd = [self loadPassword];
    if(oldpwd != nil) {
        NSDictionary *updateDict = @{(__bridge id)kSecValueData: [NSKeyedArchiver archivedDataWithRootObject:p]};
        [_kcQuery removeObjectForKey:(__bridge id)kSecMatchLimit];
        [_kcQuery removeObjectForKey:(__bridge id)kSecReturnData];
        // update时,只能设置需要更新的属性
        SecItemUpdate((__bridge CFDictionaryRef)_kcQuery, (__bridge CFDictionaryRef)updateDict);
    }
    else {
        [_kcQuery removeObjectForKey:(__bridge id)kSecMatchLimit];
        [_kcQuery removeObjectForKey:(__bridge id)kSecReturnData];
        [_kcQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:p] forKey:(__bridge id)kSecValueData];
        SecItemAdd((__bridge CFDictionaryRef)_kcQuery,NULL);
    }
}
- (id)loadPassword {
    id value = nil;
    CFDataRef passwordData = NULL;
    [_kcQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [_kcQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    if(SecItemCopyMatching((__bridge CFDictionaryRef)_kcQuery, (CFTypeRef *)&passwordData) == noErr) {
        value = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)passwordData];
    }
    if(passwordData)
        CFRelease(passwordData);
    return value;
}
- (void)deleteKeychain {
    [_kcQuery removeObjectForKey:(__bridge id)kSecMatchLimit];
    [_kcQuery removeObjectForKey:(__bridge id)kSecReturnData];
    SecItemDelete((__bridge CFDictionaryRef)_kcQuery);
}
@end
