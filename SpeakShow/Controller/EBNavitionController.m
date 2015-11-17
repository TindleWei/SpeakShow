//
//  EBNavitionController.m
//  EBDropMenu
//
//  Created by edwin bosire on 30/05/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import "EBNavitionController.h"
#import "EBMenuController.h"
#import "EBMenuItem.h"
#import "UIColor+FlatColors.h"
#import "InitialViewController.h"
#import "SpeakViewController.h"
#import "MainViewController.h"

@interface EBNavitionController ()

@property (nonatomic) EBMenuController *menu;
@end

@implementation EBNavitionController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
	self.navigationBar.shadowImage = [UIImage new];
	self.navigationBar.translucent = YES;
	
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
	
	EBMenuItem *initialItem = [EBMenuItem initWithTitle:@"Initial" withColourScheme:[UIColor flatEmeraldColor]];
    
    EBMenuItem *speakItem = [EBMenuItem initWithTitle:@"Speak" withColourScheme:[UIColor flatAlizarinColor]];
	
	UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	
	InitialViewController *politicsInitialView = [storyBoard instantiateViewControllerWithIdentifier:@"Initial"];
	politicsInitialView.menuItem = initialItem;
	self.viewControllers = @[politicsInitialView];

	initialItem.completionBlock = ^{
		
		self.viewControllers = @[politicsInitialView];
	};
    
    __weak typeof(EBMenuItem) *weakCulture = speakItem;
    speakItem.completionBlock = ^{
        
        SpeakViewController *culture = [storyBoard instantiateViewControllerWithIdentifier:@"Speaker"];
        culture.menuItem = weakCulture;
        self.viewControllers = @[culture];
    };
	
	NSArray *menuItems = @[initialItem, speakItem];
    self.menu = [[EBMenuController alloc] initWithMenuItems:menuItems forViewController:self];
}

- (void)showMenu {
    
    [self.menu showMenu];
}



@end
