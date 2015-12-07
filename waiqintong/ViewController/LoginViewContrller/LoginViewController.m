//
//  LoginViewController.m
//  waiqintong
//
//  Created by Apple on 11/10/15.
//  Copyright © 2015 cnbin. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+URLEncoding.h"
#import "HomeViewController.h"
#import "UserInformationModel.h"

static NSString * const loginSegueName = @"loginSegue";

@interface LoginViewController ()

@property (strong, nonatomic) FUIButton *loginButton;
@property (strong, nonatomic) FUITextField *userName;
@property (strong, nonatomic) FUITextField *passWord;
@property (strong, nonatomic) NSMutableDictionary *dict;
@property (strong, nonatomic) NSMutableData *receiveData;
@property (strong, nonatomic) NSMutableArray *jsonArray;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title = @"外勤通";
     self.view.backgroundColor = [UIColor cloudsColor];
    
     self.userName = [FUITextField newAutoLayoutView];
     self.userName.font = [UIFont flatFontOfSize:16];
     self.userName.backgroundColor = [UIColor clearColor];
     self.userName.edgeInsets = UIEdgeInsetsMake(4.0f, 15.0f, 4.0f, 15.0f);
     self.userName.textFieldColor = [UIColor whiteColor];
     self.userName.borderColor = [UIColor turquoiseColor];
     self.userName.borderWidth = 2.0f;
     self.userName.cornerRadius = 3.0f;
     self.userName.placeholder = @"用户名";
     self.userName.text =@"13642595821";
     [self.view addSubview:self.userName];
    
    [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
        [self.userName autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];
    
    [self.userName autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:150];
    [self.userName autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:50];
    [self.userName autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:50];
    [self.userName autoSetDimension:ALDimensionHeight toSize:40.0];
    
    self.passWord =[FUITextField newAutoLayoutView];
    self.passWord.font = [UIFont flatFontOfSize:16];
    self.passWord.backgroundColor = [UIColor clearColor];
    self.passWord.edgeInsets = UIEdgeInsetsMake(4.0f, 15.0f, 4.0f, 15.0f);
    self.passWord.textFieldColor = [UIColor whiteColor];
    self.passWord.borderColor = [UIColor turquoiseColor];
    self.passWord.borderWidth = 2.0f;
    self.passWord.cornerRadius = 3.0f;
    self.passWord.placeholder = @"密码";
    [self.view addSubview:self.passWord];
    
    [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
        [self.passWord autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];
    
    [self.passWord autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userName withOffset:20];
    [self.passWord autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:50];
    [self.passWord autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:50];
    [self.passWord autoSetDimension:ALDimensionHeight toSize:40.0];
    
    
    self.loginButton = [FUIButton newAutoLayoutView];
    self.loginButton.buttonColor = [UIColor turquoiseColor];
    self.loginButton.shadowColor = [UIColor greenSeaColor];
    self.loginButton.shadowHeight = 3.0f;
    self.loginButton.cornerRadius = 6.0f;
    self.loginButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.loginButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];

    [NSLayoutConstraint autoSetPriority:UILayoutPriorityRequired forConstraints:^{
        [self.loginButton autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
    }];
    
    [self.loginButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.passWord withOffset:20];
    [self.loginButton autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:50];
    [self.loginButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:50];
    [self.loginButton autoSetDimension:ALDimensionHeight toSize:40.0];
    
}

- (void)buttonAction:(UIButton *)button{
    
    [self setUpRequest];
}

- (void)setUpRequest {
    
    NSString *strURL = [[NSString alloc] initWithFormat:webserviceURL];
    
    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    
    NSString * envelopeText = [NSString stringWithFormat:@"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                               "<soap:Body>"
                               "<Login xmlns=\"http://tempuri.org/\">"
                               "<uname>%@</uname>"
                               "<pass>%@</pass>"
                               "</Login>"
                               "</soap:Body>"
                               "</soap:Envelope>",self.userName.text,self.passWord.text];
    
    NSData *envelope = [envelopeText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:envelope];
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[envelope length]] forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request delegate:self];
    
    
    
    
    if (connection) {
        
    }
    
//    NSError *error = nil;
//    NSHTTPURLResponse *response = nil;
//    
//    [NSURLConnection sendSynchronousRequest:request
//                          returningResponse: &response
//                                      error: &error];
//    

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"%@",[error localizedDescription]);
}

#pragma mark 接受到响应

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if (!self.receiveData) {
        self.receiveData = [NSMutableData data];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection*) connection {
    
    NSLog(@"请求完成...");
    
    NSString *receiveString = [[NSString alloc] initWithData:self.receiveData encoding:NSUTF8StringEncoding];
    NSString *str =@"<?xml version=\"1.0\" encoding=\"utf-8\"?>""<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\">""<soap:Body>""<LoginResponse xmlns=\"http://tempuri.org/\">""<LoginResult>";
    
    NSString *strhtml =[receiveString stringByReplacingOccurrencesOfString:str withString:@""];
    strhtml = [strhtml stringByReplacingOccurrencesOfString:@"</LoginResult>""</LoginResponse>""</soap:Body>""</soap:Envelope>" withString:@""];
    
    NSLog(@"string is %@", strhtml);
    
    NSError *error;
    NSData *data =[ strhtml dataUsingEncoding:NSUTF8StringEncoding];
    self.jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    if (self.jsonArray != nil && ![self.jsonArray isKindOfClass:[NSNull class]] && self.jsonArray.count != 0)
    {
        
    NSDictionary * userDict = [self.jsonArray objectAtIndex:0];
    NSLog(@"obj is %@",[self.jsonArray objectAtIndex:0]) ;

    UserInformationModel * userInformationObject = [UserInformationModel MR_createEntity];
        
    userInformationObject.idNumber  =  [userDict objectForKey:@"ID"];
    userInformationObject.userName  =  [userDict objectForKey:@"UserName"];
    userInformationObject.userPwd   =  [userDict objectForKey:@"UserPwd"];
    userInformationObject.trueName  =  [userDict objectForKey:@"TrueName"];
    userInformationObject.serils    =  [userDict objectForKey:@"Serils"];
    
    userInformationObject.department = [userDict objectForKey:@"Department"];
    userInformationObject.jiaoSe     = [userDict objectForKey:@"JiaoSe"];
    userInformationObject.groupName  = [userDict objectForKey:@"GroupName"];
    // userInformationObject.activeTime = [userDict objectForKey:@"ActiveTime"];
    userInformationObject.zhiWei     = [userDict objectForKey:@"ZhiWei"];
    
    userInformationObject.zaiGang   = [userDict objectForKey:@"ZaiGang"];
    userInformationObject.emailsStr = [userDict objectForKey:@"EmailStr"];
    userInformationObject.wzCJJG    = [userDict objectForKey:@"WZCJJG"];
    userInformationObject.poiFW     = [userDict objectForKey:@"POIFW"];
    userInformationObject.efence    = [userDict objectForKey:@"eFence"];
    userInformationObject.timestamp = [NSDate date];

    [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        
    NSLog(@"newrun is %@", userInformationObject);
        
   [self.view makeToast:@"登录成功" duration:1.0 position:@"center"];

   [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"key_isLogined"];

    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self.delegate LoginViewController:self];
        
    });
    }
    else {
        [self.view makeToast:@"账号或密码错误,请重新输入" duration:1.0 position:@"center"];

    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
