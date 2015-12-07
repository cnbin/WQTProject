//
//  LoginViewController.h
//  waiqintong
//
//  Created by Apple on 11/10/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  LoginViewController;

@protocol LoginViewControllerDelegate <NSObject>

-(void)LoginViewController:(LoginViewController *)loginViewController;

@end

@interface LoginViewController : UIViewController<NSURLConnectionDelegate>

@property (weak, nonatomic) id<LoginViewControllerDelegate> delegate;

@end
