//
//  ViewController.m
//  NSUrlProtocolTrick
//
//  Created by yxhe on 16/10/19.
//  Copyright © 2016年 tashaxing. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *jsonTextView;

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

// 点击请求数据
- (IBAction)loadJsonClicked:(id)sender
{
    // session api
//    NSString *httpUrl = @"http://www.qq.com";
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURL *url = [NSURL URLWithString:httpUrl];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if(!error)
//        {
//            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"%@", str);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.jsonTextView.text = str;
//            });
//        }
//        else
//        {
//            NSLog(@"%@", error.localizedDescription);
//        
//        }
//    }];
//    
//    [dataTask resume];
    
    // connection api
    NSString *httpUrl = @"http://www.qq.com";
    NSURL *url = [NSURL URLWithString:httpUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               if(connectionError)
                                   NSLog(@"Httperror: %@%ld", connectionError.localizedDescription, connectionError.code);
                               else
                               {
                                   
                                   NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   NSLog(@"%@", str);
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       self.jsonTextView.text = str;
                                   });
                                   
                                   
                               }
                           }];
}

// 点击加载网页
- (IBAction)loadWebClicked:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"http://weixin.qq.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
