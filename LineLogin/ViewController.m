//
//  ViewController.m
//  LineLogin
//
//  Created by Tong on 2023/1/28.
//

#import "ViewController.h"
#import "LineLogin-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LineLogin registerLine];
    LineLogin *line = [LineLogin getSharedInstance];
    [line loginLineFromController:self completeWithError:^(LoginResultStatus loginStatus, NSString * _Nullable token, NSString * _Nullable emali, NSError * _Nullable error) {
        if (loginStatus == LoginResultStatusSuccess) {
            
        } else if (loginStatus == LoginResultStatusCancelled) {
            
        } else if (loginStatus == LoginResultStatusError) {
            
        }
    }];
}


@end
