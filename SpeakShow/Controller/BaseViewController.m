//
//  BaseViewController.m
//  SpeakShow
//
//  Created by tindle on 15/11/10.
//  Copyright (c) 2015年 tindle. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark - util

- (BOOL)filterError:(NSError *)error {
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:nil message:error.description delegate:nil
                                  cancelButtonTitle   :@"确定" otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}

@end
