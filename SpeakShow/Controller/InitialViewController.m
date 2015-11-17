//
//  PoliticsViewController.m
//  EBDropMenu
//
//  Created by edwin bosire on 31/05/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import "InitialViewController.h"
#import "ConsoleCell.h"

#define RGB(R, G, B) [UIColor colorWithRed : (R) / 255.0f green : (G) / 255.0f blue : (B) / 255.0f alpha : 1.0f]
#define COMMON_BG RGB(10, 10, 10)

@interface InitialViewController () <UITableViewDataSource, UITableViewDelegate, AVIMClientDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) ConsoleCell *cell;
@property (nonatomic, strong) NSMutableDictionary *textViews;

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    _textViews = [NSMutableDictionary dictionaryWithCapacity:10];
    
    [self initTableView];
    
    [_dataArray addObject:@"[admin ~]$ hi, welcome to speak show"];
    [_dataArray addObject:@"[admin ~]$ please input your name here:"];
    [_tableView reloadData];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

#pragma mark - tableView init

- (void)initTableView {
    [self.tableView setBackgroundColor:COMMON_BG];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"ConsoleCell";
    ConsoleCell *cell    = (ConsoleCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
    cell                 = (ConsoleCell *)[[[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil] lastObject];
    cell.backgroundColor = [UIColor clearColor];
    }
    
    NSString *message = self.dataArray[indexPath.row];
    UIColor *fontColor;
    if (indexPath.row%2==0) {
        fontColor = [UIColor greenColor];
    } else {
        fontColor = [UIColor greenColor];
    }
    cell.contentLabel.textColor = fontColor;
    cell.contentLabel.text      = [NSString stringWithFormat:@"%@", message];
    cell.contentLabel.font      = [UIFont fontWithName:@"Lato-Heavy" size:13.0f];
    cell.contentLabel.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [_textViews setObject:cell.contentLabel forKey:indexPath];
    [cell.contentLabel setDelegate:self];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self textViewHeightForRowAtIndexPath:indexPath];
}

- (CGFloat)textViewHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITextView *calculationView = [_textViews objectForKey:indexPath];
    CGFloat textViewWidth = calculationView.frame.size.width;
    
    if (calculationView==NULL||calculationView.text.length==0){
        NSLog(@"return 40");
        return 40;
    }
    
    CGSize textSize = [calculationView sizeThatFits:CGSizeMake(textViewWidth, MAXFLOAT)];
    NSLog(@"return %f", 16+textSize.height);
    return 16+textSize.height;
//    if (calculationView.attributedText){
//        //    [calculationView setAttributedText:@"loading"];
//        CGSize size = [calculationView sizeThatFits:CGSizeMake(300.0, FLT_MAX)];
//        return size.height;
//    } else{
//        return UITableViewAutomaticDimension;
//    }

    
//    CGFloat textViewWidth = calculationView.frame.size.width;
//    if (!calculationView.attributedText) {
//        calculationView = [[UITextView alloc] init];
//    
//        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
//        [paragraph setAlignment:NSTextAlignmentCenter];
//        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Light" size:12.0f],
//                                     NSForegroundColorAttributeName : [UIColor whiteColor],
//                                     NSParagraphStyleAttributeName : paragraph,
//                                     NSKernAttributeName : @2};
//        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"loading..." attributes:attributes];
//        calculationView.attributedText = attrString;// get the text from your datasource add attributes and insert here
//        textViewWidth = 290.0;
//    }
//    CGSize size = [calculationView sizeThatFits:CGSizeMake(textViewWidth, FLT_MAX)];
//    return size.height;
}


- (void)textViewDidChanged:(UITextView *)textView {
    
    [self.tableView beginUpdates]; // This will cause an animated update of
    [self.tableView endUpdates];   // the height of your UITableViewCell
    
    // If the UITextView is not automatically resized (e.g. through autolayout
    // constraints), resize it here
    
    [self scrollToCursorForTextView:textView]; // OPTIONAL: Follow cursor
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self scrollToCursorForTextView:textView];
}

- (void)scrollToCursorForTextView: (UITextView*)textView {
    
    CGRect cursorRect = [textView caretRectForPosition:textView.selectedTextRange.start];
    
    cursorRect = [self.tableView convertRect:cursorRect fromView:textView];
    
    if (![self rectVisible:cursorRect]) {
        cursorRect.size.height += 8; // To add some space underneath the cursor
        [self.tableView scrollRectToVisible:cursorRect animated:YES];
    }
}

- (BOOL)rectVisible: (CGRect)rect {
    CGRect visibleRect;
    visibleRect.origin = self.tableView.contentOffset;
    visibleRect.origin.y += self.tableView.contentInset.top;
    visibleRect.size = self.tableView.bounds.size;
    visibleRect.size.height -= self.tableView.contentInset.top + self.tableView.contentInset.bottom;
    
    return CGRectContainsRect(visibleRect, rect);
}

#pragma mark - keyboard

- (void)keyboardWillShow:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, kbSize.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, 0.0, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    [UIView commitAnimations];
}

#pragma mark - scroll

- (void)scrollToLast {
    if (self.dataArray.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    if ([self.inputTextField isFirstResponder]) {
//        [self.inputTextField resignFirstResponder];
//    }
}

@end
