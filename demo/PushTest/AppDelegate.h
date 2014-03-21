//
//  AppDelegate.h
//  PushTest
//
//  Created by LiDong on 12-9-20.
//  Copyright (c) 2012年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITextFieldDelegate> {
    UILabel                 *_deviceTokenLabel;
    UITextField             *_deviceTokenTextField;
    UITextView              *_messageInfoTextView;
    UILabel                 *_connectedStatusLabel;
    UILabel                 *_versionLabel;
    UILabel                 *_appKeyInfoLabel;
    UILabel                 *_bundleIDLabel;
    UITextView              *_setResultTextView;
    UITextField             *_tagTextField;
    UITextField             *_aliasTextField;
    UIButton                *_setTagButton;
    UIButton                *_setAliasButton;
    UIButton                *_setTagsAndAliasButton;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic)     UILabel                 *_deviceTokenLabel;
@property (strong, nonatomic)     UITextField             *_deviceTokenTextField;
@property (strong, nonatomic)     UITextView              *_messageInfoTextView;
@property (strong, nonatomic)     UILabel                 *_connectedStatusLabel;
@property (strong, nonatomic)     UILabel                 *_versionLabel;
@property (strong, nonatomic)     UILabel                 *_appKeyInfoLabel;
@property (strong, nonatomic)     UILabel                 *_bundleIDLabel;
@property (strong, nonatomic)     UITextView              *_setResultTextView;
@property (strong, nonatomic)     UITextField             *_tagTextField;
@property (strong, nonatomic)     UITextField             *_aliasTextField;
@property (strong, nonatomic)     UIButton                *_setTagButton;
@property (strong, nonatomic)     UIButton                *_setAliasButton;
@property (strong, nonatomic)     UIButton                *_setTagsAndAliasButton;

@end
