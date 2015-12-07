//
//  ChangePwdViewController.m
//  waiqintong
//
//  Created by Apple on 11/18/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import "ChangePwdViewController.h"

@interface ChangePwdViewController ()

@property (strong, nonatomic) UILabel *oldPasswordLabel;
@property (strong, nonatomic) UILabel *passwordLabel;
@property (strong, nonatomic) UILabel *confirmPasswordLabel;

@property (strong, nonatomic) FUITextField *oldPasswordTextField;
@property (strong, nonatomic) FUITextField *passwordTextField;
@property (strong, nonatomic) FUITextField *confirmPasswordTextField;
@property (strong, nonatomic) FUIButton *submitButton;

@end

@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)buttonAction: (UIButton *)button {
    
    if (self.oldPasswordTextField.text.length == 0 || self.passwordTextField.text.length == 0 || self.confirmPasswordTextField.text.length == 0)
    {
        [self.view makeToast:@"密码不能为空" duration:1.0 position:@"center"];
    }
    
    if ([self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]== NO)
    {
         [self.view makeToast:@"新密码和确认密码不一致" duration:1.0 position:@"center"];
    }
}

- (void)dismissAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initView {
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor cloudsColor];
    
    //原密码
    self.oldPasswordLabel = [UILabel newAutoLayoutView];
    self.oldPasswordLabel.text = @"原密码:";
    self.oldPasswordLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [self.view addSubview:self.oldPasswordLabel];
    
    [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
        [self.oldPasswordLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];
    [self.oldPasswordLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:100];
    [self.oldPasswordLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:30];
    [self.oldPasswordLabel autoSetDimension:ALDimensionHeight toSize:40.0];
    [self.oldPasswordLabel autoSetDimension:ALDimensionWidth toSize:60.0];
    
    //输入新密码
    self.oldPasswordTextField =[FUITextField newAutoLayoutView];
    self.oldPasswordTextField.font = [UIFont flatFontOfSize:14];
    self.oldPasswordTextField.backgroundColor = [UIColor clearColor];
    self.oldPasswordTextField.edgeInsets = UIEdgeInsetsMake(4.0f, 15.0f, 4.0f, 15.0f);
    self.oldPasswordTextField.textFieldColor = [UIColor whiteColor];
    self.oldPasswordTextField.borderColor = [UIColor turquoiseColor];
    self.oldPasswordTextField.borderWidth = 2.0f;
    self.oldPasswordTextField.cornerRadius = 3.0f;
    self.oldPasswordTextField.placeholder = @"请输入原密码";
    [self.view addSubview:self.oldPasswordTextField];
    
    [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
        [self.oldPasswordTextField autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];
    [self.oldPasswordTextField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:100];
    [self.oldPasswordTextField autoSetDimension:ALDimensionHeight toSize:40.0];
    [self.oldPasswordTextField autoSetDimension:ALDimensionWidth toSize:180.0];
    [self.oldPasswordTextField autoPinEdge:ALEdgeLeading toEdge: ALEdgeTrailing ofView:self.oldPasswordLabel withOffset:20];
    
    //新密码
    self.passwordLabel = [UILabel newAutoLayoutView];
    self.passwordLabel.text = @"新密码:";
    self.passwordLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [self.view addSubview:self.passwordLabel];
    
    [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
        [self.passwordLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];
    [self.passwordLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:30];
    [self.passwordLabel autoSetDimension:ALDimensionHeight toSize:40.0];
    [self.passwordLabel autoSetDimension:ALDimensionWidth toSize:60.0];
    [self.passwordLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.oldPasswordLabel withOffset:20];
    
    //请输入新密码
    self.passwordTextField =[FUITextField newAutoLayoutView];
    self.passwordTextField.font = [UIFont flatFontOfSize:14];
    self.passwordTextField.backgroundColor = [UIColor clearColor];
    self.passwordTextField.edgeInsets = UIEdgeInsetsMake(4.0f, 15.0f, 4.0f, 15.0f);
    self.passwordTextField.textFieldColor = [UIColor whiteColor];
    self.passwordTextField.borderColor = [UIColor turquoiseColor];
    self.passwordTextField.borderWidth = 2.0f;
    self.passwordTextField.cornerRadius = 3.0f;
    self.passwordTextField.placeholder = @"请输入新密码";
    [self.view addSubview:self.passwordTextField];
    
    [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
        [self.passwordTextField autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];
    
    [self.passwordTextField autoPinEdge:ALEdgeLeading toEdge: ALEdgeTrailing ofView:self.passwordLabel withOffset:20];
    [self.passwordTextField autoSetDimension:ALDimensionHeight toSize:40.0];
    [self.passwordTextField autoSetDimension:ALDimensionWidth toSize:180.0];
    
    [self.passwordTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.oldPasswordTextField withOffset:20];
    
    //再次确认密码
    self.confirmPasswordLabel = [UILabel newAutoLayoutView];
    self.confirmPasswordLabel.text = @"再次确认密码:";
    self.confirmPasswordLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [self.view addSubview:self.confirmPasswordLabel];
    
    [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
        [self.confirmPasswordLabel autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];
    
    [self.confirmPasswordLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.passwordLabel withOffset:20];
    [self.confirmPasswordLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10];
    [self.confirmPasswordLabel autoSetDimension:ALDimensionHeight toSize:40.0];
    [self.confirmPasswordLabel autoSetDimension:ALDimensionWidth toSize:90.0];
    
    //确认新密码
    self.confirmPasswordTextField =[FUITextField newAutoLayoutView];
    self.confirmPasswordTextField.font = [UIFont flatFontOfSize:14];
    self.confirmPasswordTextField.backgroundColor = [UIColor clearColor];
    self.confirmPasswordTextField.edgeInsets = UIEdgeInsetsMake(4.0f, 15.0f, 4.0f, 15.0f);
    self.confirmPasswordTextField.textFieldColor = [UIColor whiteColor];
    self.confirmPasswordTextField.borderColor = [UIColor turquoiseColor];
    self.confirmPasswordTextField.borderWidth = 2.0f;
    self.confirmPasswordTextField.cornerRadius = 3.0f;
    self.confirmPasswordTextField.placeholder = @"确认新密码";
    [self.view addSubview:self.confirmPasswordTextField];
    
    [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
        [self.confirmPasswordTextField autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];
    [self.confirmPasswordTextField autoSetDimension:ALDimensionHeight toSize:40.0];
    [self.confirmPasswordTextField autoSetDimension:ALDimensionWidth toSize:180.0];
    [self.confirmPasswordTextField autoPinEdge:ALEdgeLeading toEdge: ALEdgeTrailing ofView:self.confirmPasswordLabel withOffset:10];
    [self.confirmPasswordTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.passwordTextField withOffset:20];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style: UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(dismissAction)];
    self.submitButton = [FUIButton newAutoLayoutView];
    self.submitButton.buttonColor = [UIColor turquoiseColor];
    self.submitButton.shadowColor = [UIColor greenSeaColor];
    self.submitButton.shadowHeight = 3.0f;
    self.submitButton.cornerRadius = 6.0f;
    self.submitButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.submitButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [self.submitButton setTitle:@"确认" forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
    
    [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
        [self.submitButton autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];
    
    [self.submitButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.confirmPasswordTextField withOffset:40];
    [self.submitButton autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:50];
    [self.submitButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:50];
    [self.submitButton autoSetDimension:ALDimensionHeight toSize:40.0];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

@end
