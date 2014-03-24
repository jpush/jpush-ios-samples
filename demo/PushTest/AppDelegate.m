//
//  AppDelegate.m
//  PushTest
//
//  Created by LiDong on 12-8-15.
//  Copyright (c) 2012年 HXHG. All rights reserved.
//

#import "AppDelegate.h"
#import "APService.h"

#define HEIGHT_OF_KEYBOARD 300
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SDK_VERSION @"SDK Version 1.6.3"

@implementation AppDelegate

@synthesize window = _window;

@synthesize _deviceTokenLabel;
@synthesize _deviceTokenTextField;
@synthesize _messageInfoTextView;
@synthesize _connectedStatusLabel;
@synthesize _versionLabel;
@synthesize _appKeyInfoLabel;
@synthesize _bundleIDLabel;
@synthesize _setResultTextView;
@synthesize _setTagButton;
@synthesize _setAliasButton;
@synthesize _setTagsAndAliasButton;
@synthesize _tagTextField;
@synthesize _aliasTextField;

- (void)dealloc
{
    [_window release];
    [_deviceTokenLabel release];
    [_deviceTokenTextField release];
    [_messageInfoTextView release];
    [_connectedStatusLabel release];
    [_versionLabel release];
    [_appKeyInfoLabel release];
    [_bundleIDLabel release];
    [_setResultTextView release];
    [_setTagButton release];
    [_setAliasButton release];
    [_setTagsAndAliasButton release];
    [_tagTextField release];
    [_aliasTextField release];
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [application setStatusBarStyle:UIStatusBarStyleLightContent];

    [self initView];
    [self initAPServiceWithOptions:launchOptions];
    [self.window makeKeyAndVisible];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark ----处理apns接收消息（JPush SDK required）----

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 向服务器上报Device Token
    [APService registerDeviceToken:deviceToken];
    NSString* deviceTokenString = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    [_deviceTokenTextField setText:[@"" stringByAppendingFormat:@"%@",deviceTokenString]];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // 处理收到的APNS消息，向服务器上报收到APNS消息
    [APService handleRemoteNotification:userInfo];
}

//avoid compile error for sdk under 7.0
#ifdef __IPHONE_7_0
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNoData);
}
#endif

#pragma mark ----初始化图形界面，添加UI----

//初始化图形界面，添加UI组件以便于展示SDK功能
- (void)initView
{
    self.window.backgroundColor = [UIColor blackColor];


    _deviceTokenLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 10)];
    [_deviceTokenLabel setBackgroundColor:[UIColor grayColor]];
    [_deviceTokenLabel setTextColor:[UIColor colorWithRed:0.5 green:0.65 blue:0.75 alpha:1]];
    [_deviceTokenLabel setFont:[UIFont boldSystemFontOfSize:12]];
    _deviceTokenLabel.textAlignment =  NSTextAlignmentLeft;
    [_deviceTokenLabel setNumberOfLines:0];
    [_deviceTokenLabel setText:@"Device Token:"];
    [self.window addSubview:_deviceTokenLabel];
    
    _deviceTokenTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 30, 300, 30)];
    [_deviceTokenTextField setBackgroundColor:[UIColor grayColor]];
    [_deviceTokenTextField setTextColor:[UIColor colorWithRed:0.5 green:0.7 blue:0.75 alpha:1]];
    [_deviceTokenTextField setFont:[UIFont systemFontOfSize:18]];
    [_deviceTokenTextField setTextAlignment:NSTextAlignmentLeft];
    [_deviceTokenTextField setText:@"No device token"];
    _deviceTokenTextField.delegate = self;
    [_deviceTokenTextField setReturnKeyType:UIReturnKeyDone];

    [self.window addSubview:_deviceTokenTextField];
    
    _messageInfoTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 70, 300, 100)];
    [_messageInfoTextView setBackgroundColor:[UIColor grayColor]];
    [_messageInfoTextView setTextColor:[UIColor colorWithRed:0.5 green:0.65 blue:0.75 alpha:1]];
    [_messageInfoTextView setFont:[UIFont boldSystemFontOfSize:20]];
    _messageInfoTextView.textAlignment =  NSTextAlignmentLeft;
    [_messageInfoTextView setSelectable:NO];
    [_messageInfoTextView setText:@"无消息"];
    [self.window addSubview:_messageInfoTextView];
    
    _connectedStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, 60, 14)];
    [_connectedStatusLabel setBackgroundColor:[UIColor grayColor]];
    [_connectedStatusLabel setTextColor:[UIColor colorWithRed:0.5 green:0.65 blue:0.75 alpha:1]];
    [_connectedStatusLabel setFont:[UIFont boldSystemFontOfSize:12]];
    _connectedStatusLabel.textAlignment =  NSTextAlignmentLeft;
    [_connectedStatusLabel setNumberOfLines:0];
    [_connectedStatusLabel setText:@"未连接"];
    [self.window addSubview:_connectedStatusLabel];
    
    _versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 196, 110, 14)];
    [_versionLabel setBackgroundColor:[UIColor grayColor]];
    [_versionLabel setTextColor:[UIColor colorWithRed:0.5 green:0.7 blue:0.75 alpha:1]];
    [_versionLabel setFont:[UIFont systemFontOfSize:12]];
    [_versionLabel setTextAlignment:NSTextAlignmentLeft];
    [_versionLabel setText:SDK_VERSION];
    [self.window addSubview:_versionLabel];
    
    _appKeyInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(72, 180, 238, 14)];
    [_appKeyInfoLabel setBackgroundColor:[UIColor grayColor]];
    [_appKeyInfoLabel setTextColor:[UIColor colorWithRed:0.5 green:0.7 blue:0.75 alpha:1]];
    [_appKeyInfoLabel setFont:[UIFont systemFontOfSize:12]];
    [_appKeyInfoLabel setTextAlignment:NSTextAlignmentLeft];
    [self.window addSubview:_appKeyInfoLabel];
    NSDictionary *pushConfig = [[NSDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"PushConfig" ofType:@"plist"]];
    NSString *appKeyInfoLabel_content = [[NSString alloc]initWithFormat:@"AppKey:%@",[pushConfig objectForKey:@"APP_KEY"]];
    [_appKeyInfoLabel setText:appKeyInfoLabel_content];
    [pushConfig release];
    [appKeyInfoLabel_content release];

    
    _bundleIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(122, 196, 188, 14)];
    [_bundleIDLabel setBackgroundColor:[UIColor grayColor]];
    [_bundleIDLabel setTextColor:[UIColor colorWithRed:0.5 green:0.7 blue:0.75 alpha:1]];
    [_bundleIDLabel setFont:[UIFont systemFontOfSize:12]];
    [_bundleIDLabel setTextAlignment:NSTextAlignmentLeft];
    [self.window addSubview:_bundleIDLabel];
    NSString *bundleIDLabel_content = [[NSString alloc]initWithFormat:@"BundleID:%@",[[[NSBundle mainBundle] infoDictionary]objectForKey:(NSString *)kCFBundleIdentifierKey]];
    [_bundleIDLabel setText:bundleIDLabel_content];
    [bundleIDLabel_content release];
    

    _tagTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 220, 205, 30)];
    _tagTextField.delegate = self;
    _tagTextField.placeholder = @"Use \",\" to split tags.";
    [_tagTextField setBackgroundColor:[UIColor whiteColor]];
    [_tagTextField setReturnKeyType:UIReturnKeyDone];
    [self.window addSubview:_tagTextField];
    
    _setTagButton = [[UIButton alloc]initWithFrame:CGRectMake(225, 220, 85, 30)];
    [_setTagButton setBackgroundColor:[UIColor redColor]];
    [_setTagButton setTitle:@"Set tags" forState:UIControlStateNormal];
    [_setTagButton addTarget:self action:@selector(setTags) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:_setTagButton];
    
    
    _aliasTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 260, 205, 30)];
    _aliasTextField.delegate = self;
    _aliasTextField.placeholder = @"Alias";
    [_aliasTextField setBackgroundColor:[UIColor whiteColor]];
    [_aliasTextField setReturnKeyType:UIReturnKeyDone];
    [self.window addSubview:_aliasTextField];
    
    _setAliasButton = [[UIButton alloc]initWithFrame:CGRectMake(225, 260, 85, 30)];
    [_setAliasButton setBackgroundColor:[UIColor redColor]];
    [_setAliasButton setTitle:@"Set alias" forState:UIControlStateNormal];
    [_setAliasButton addTarget:self action:@selector(setAlias) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:_setAliasButton];
    
    _setTagsAndAliasButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 300, 300, 30)];
    [_setTagsAndAliasButton setBackgroundColor:[UIColor blueColor]];
    [_setTagsAndAliasButton setTitle:@"Set tags and alias" forState:UIControlStateNormal];
    [_setTagsAndAliasButton addTarget:self action:@selector(setTagsAndAlias) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:_setTagsAndAliasButton];
    
    _setResultTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 340, 300, SCREEN_HEIGHT-340-10)];
    [_setResultTextView setBackgroundColor:[UIColor grayColor]];
    [_setResultTextView setTextColor:[UIColor colorWithRed:0.5 green:0.7 blue:0.75 alpha:1]];
    [_setResultTextView setFont:[UIFont systemFontOfSize:18]];
    [_setResultTextView setTextAlignment:NSTextAlignmentLeft];
    [_setResultTextView setSelectable:NO];
    [_setResultTextView setText:@"No result."];
    [self.window addSubview:_setResultTextView];
}

#pragma mark ----初始化JPush SDK（JPush SDK required）----
//为消息监听方法注册监听器，注册apns类型，初始化SDK
- (void)initAPServiceWithOptions:(NSDictionary *)launchOptions
{
    //为消息监听方法注册监听器
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidSetup:) name:kAPNetworkDidSetupNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidClose:) name:kAPNetworkDidCloseNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidRegister:) name:kAPNetworkDidRegisterNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidLogin:) name:kAPNetworkDidLoginNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kAPNetworkDidReceiveMessageNotification object:nil];
    
    // 注册APNS类型
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    // 初始化
    [APService setupWithOption:launchOptions];
}

#pragma mark ----JPush应用内消息回调方法（JPush SDK required）----
- (void)networkDidSetup:(NSNotification *)notification {
    [_connectedStatusLabel setText:@"已连接"];
    NSLog(@"已连接");
}

- (void)networkDidClose:(NSNotification *)notification {
    [_connectedStatusLabel setText:@"未连接"];
    NSLog(@"未连接");
}

- (void)networkDidRegister:(NSNotification *)notification {
    [_connectedStatusLabel setText:@"已注册"];
    NSLog(@"已注册");
}

- (void)networkDidLogin:(NSNotification *)notification {
    [_connectedStatusLabel setText:@"已登录"];
    NSLog(@"已登录");
}

//收到消息的回调方法，收到消息之后此方法会执行
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *title = [userInfo valueForKey:@"title"];
    NSString *content = [userInfo valueForKey:@"content"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *showContent = [NSString stringWithFormat:@"收到消息\ndate:%@\ntitle:%@\ncontent:%@\n\n", [dateFormatter stringFromDate:[NSDate date]],title,content];
    if ([_messageInfoTextView.text isEqualToString:@"无消息"])
    {
        _messageInfoTextView.text = showContent;
    }
    else
    {
        _messageInfoTextView.text = [_messageInfoTextView.text stringByAppendingString:showContent];
    }
    [dateFormatter release];
}

//设置 tags 及 alias 的回调方法，需严格按此格式实现
/****************************************************************************
/
/   回调方法返回值iResCode对应错误代码及解释
/
/----------------------------------------------------------------------------
*   iResCode	描述	详细解释
*   6001	    无效的设置，tag/alias 不应参数都为 null
*   6002	    设置超时	建议重试
*   6003	    alias 字符串不合法	有效的别名、标签组成：字母（区分大小写）、数字、下划线、汉字。
*   6004	    alias超长。最多 40个字节	中文 UTF-8 是 3 个字节
*   6005	    某一个 tag 字符串不合法	有效的别名、标签组成：字母（区分大小写）、数字、下划线、汉字。
*   6006	    某一个 tag 超长。一个 tag 最多 40个字符	中文 UTF-8 是 3 个字节
*   6007	    tags 数量超出限制。最多 100个	这是一台设备的限制。一个应用全局的标签数量无限制。
*   6008	    tag/alias 超出总长度限制。总长度最多 1K 字节
******************************************************************************/
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
    NSString *tagsInString = [tags.allObjects componentsJoinedByString:@","];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *dateNow = [dateFormatter stringFromDate:[NSDate date]];
    NSString *labelText =nil;
    if ([[_setResultTextView text] isEqualToString:@"No result."])
    {
        labelText = [NSString stringWithFormat:@"%@\n设置结果\n返回状态:%d\nTags:%@\nAlias:%@\n", dateNow, iResCode, tagsInString, alias];
    }
    else
    {
        labelText = [[NSString stringWithFormat:@"%@\n设置结果\n返回状态:%d\nTags:%@\nAlias:%@\n", dateNow, iResCode, tagsInString, alias] stringByAppendingString:[_setResultTextView text]];
    }
    [_setResultTextView setText:labelText];
    [_setResultTextView scrollsToTop];
    [dateFormatter release];

}


#pragma mark ----------------------TextFieldDelegate---------------------------

- (void)textFieldDidBeginEditing:(UITextField *)textField           // became first responder
{
    CGRect changedFrame = self.window.frame;
    float y_offset = (textField.frame.origin.y + textField.frame.size.height) + HEIGHT_OF_KEYBOARD - SCREEN_HEIGHT;
    if (y_offset > 0) {
        changedFrame.origin.y = -y_offset;
    }
    [self.window setFrame:changedFrame];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
    CGRect changedFrame = self.window.frame;
    changedFrame.origin.y = 0;
    [self.window setFrame:changedFrame];
    
    return YES;
}

#pragma mark -------------Button Method（设置tags&&alias）-------------------

//设置tags
- (void)setTags
{
    [self textFieldShouldReturn:_tagTextField];
    NSString *tagString = _tagTextField.text;
    NSSet *tags = [NSSet setWithArray:[tagString componentsSeparatedByString:@","]];
    [APService setTags:tags callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}

//设置alias
- (void)setAlias
{
    [self textFieldShouldReturn:_aliasTextField];
    NSString *aliasString = _aliasTextField.text;
    [APService setAlias:aliasString callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];

}

//设置tag和alias
- (void)setTagsAndAlias
{
    [self textFieldShouldReturn:_aliasTextField];
    [self textFieldShouldReturn:_tagTextField];
    NSString *tagString = _tagTextField.text;
    NSString *aliasString = _aliasTextField.text;
    NSSet *tags = [NSSet setWithArray:[tagString componentsSeparatedByString:@","]];
    [APService setTags:tags alias:aliasString callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
}



@end
