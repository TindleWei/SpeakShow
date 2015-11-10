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
#import "PoliticsViewController.h"
#import "ViewController.h"

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
	
	EBMenuItem *politics = [EBMenuItem initWithTitle:@"Politics" withColourScheme:[UIColor flatEmeraldColor]];
	
	UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	
	PoliticsViewController *politicsInitialView = [storyBoard instantiateViewControllerWithIdentifier:@"Politics"];
	politicsInitialView.menuItem = politics;
	self.viewControllers = @[politicsInitialView];

	politics.completionBlock = ^{
		
		self.viewControllers = @[politicsInitialView];
	};

	
	NSArray *menuItems = @[politics];
    self.menu = [[EBMenuController alloc] initWithMenuItems:menuItems forViewController:self];
}

- (void)showMenu {
    
    [self.menu showMenu];
}



@end
