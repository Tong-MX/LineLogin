# LineLogin
Line登录
Line登录集成
1.申请Line账号
2.创建应用
3.获取应用编号
4.配置相关信息
5.xcode配置
6.代码集成

一、创建应用
1.需要登录Line开发者平台申请 https://developers.line.biz/en/
2.然后添加iOS平台 - 填写应用名称 - 创建应用编号 - 为应用添加产品，然后到设置中完善相关信息，然后保存，配置Bundle ID，这些都是按照流程一步步填写就可以了
这里主要获取channel id
![image.png](https://upload-images.jianshu.io/upload_images/1954867-f429e81fb506f92c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

3.配置完成之后你就可以得到xcode中info.plist文件中的配置信息
info.plist填写分成二部分
第一部分填写
URL types copy填写就行 ->可以参考源码
![image.png](https://upload-images.jianshu.io/upload_images/1954867-dca29c9c7ab246de.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
第二部分填写 
白名单
![image.png](https://upload-images.jianshu.io/upload_images/1954867-9ecf16bbadff4a71.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

第三部分填写配置 把申请的channel id 填写上 ->可以参考源码
![image.png](https://upload-images.jianshu.io/upload_images/1954867-7371d9e21935cae6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
二、xcode配置（接入SDK）
加载安装包  pod 'LineSDKSwift', '~> 5.5.0' （这里之前接入过oc的但是后来发现Line的oc版本一直更新不下来也没找到文档是不是废弃了所以更新了Swift的版本的 如果不习惯Swift可以试试 pod 'LineSDK' ）

三、代码集成
这里封装了Swift的版本的LineLogin
1.LineLogin ->源码在下边
```
@objc enum LoginResultStatus: NSInteger {
    case error
    case cancelled
    case success
}

class LineLogin: NSObject {
    private static var manager: LineLogin?
    @objc class func getSharedInstance() -> LineLogin {
        guard let instance = manager else {
            manager = LineLogin()
            return manager!
        }
        return instance
    }
    
    @objc class func registerLine() {
        LoginManager.shared.setup(channelID: "Your channelID", universalLinkURL: nil)
    }
    
    @objc class func applicationOpenurl(_ app: UIApplication,
                                           open url: URL?) -> Bool {
        return LoginManager.shared.application(app, open: url)
    }
    
    @objc class func application(
        _ application: UIApplication,
        continueWithUserActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
            return LoginManager.shared.application(application, open: continueWithUserActivity.webpageURL)
        }
    
    @objc func loginLine(fromController: UIViewController, completeWithError: @escaping (_ loginStatus: LoginResultStatus, _ token: String?, _ email: String? , _ error: Error?) -> Void) {
        var param = LoginManager.Parameters.init()
        param.allowRecreatingLoginProcess = true
        LoginManager.shared.login(permissions: [.openID, .profile], in: fromController, parameters: param) { (result) in
            switch result {
            case .success(let loginResult):
                if let _ = loginResult.accessToken.IDTokenRaw {
                    completeWithError(.success, loginResult.accessToken.value, nil, nil)
                } else {
                    completeWithError(.success, "", nil, nil)
                }
            case .failure(let error):
                print(error)
                completeWithError(.cancelled, "", nil, nil)
            }
        }
        
    }
    
    @objc class func destroyLine() {
        LineLogin.manager = nil
    }
}
```
2.Appdelegate中
```
#import "LineLogin-Swift.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [LineLogin registerLine];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.scheme isEqualToString:@"line3rdp.yourbundleid"]) {
        return [LineLogin applicationOpenurl:app open:url];
    }
    return false;
}
```
3.登录调用
```
    LineLogin *line = [LineLogin getSharedInstance];
    [line loginLineFromController:self completeWithError:^(LoginResultStatus loginStatus, NSString * _Nullable token, NSString * _Nullable emali, NSError * _Nullable error) {
        if (loginStatus == LoginResultStatusSuccess) {
            
        } else if (loginStatus == LoginResultStatusCancelled) {
            
        } else if (loginStatus == LoginResultStatusError) {
            
        }
    }];
```

以上是集成的方法。到这里基本集成完成如果你的ChannelId没问题就好唤起 Line 登录
简书传送
https://www.jianshu.com/p/352010fa0356

