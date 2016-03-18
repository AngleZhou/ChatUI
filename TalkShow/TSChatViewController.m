//
//  ViewController.m
//  TalkShow
//
//  Created by ZhouQian on 16/2/16.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "TSChatViewController.h"
#import "TSToolbarTextView.h"
#import "TSDateTimeCell.h"
#import "TSSave.h"
#import "TalkCell.h"
#import "TSTextCell.h"
#import "TSVoiceCell.h"
#import "TSImageCell.h"
#import "TSMultiInputView.h"
#import "TSEmojiView.h"
#import "TSImagePicker.h"
#import <AVFoundation/AVFoundation.h>

#import <Masonry.h>

#define toolBarMinHeight 50
#define textViewHeight 36
#define actionButtonHeight 30
#define actionButtonTopMargin (toolBarMinHeight - actionButtonHeight)/2
#define buttonMargin 10
#define messageFontSize 19

#define topBarHeight self.navigationController.navigationBar.height - [UIApplication sharedApplication].statusBarFrame.size.height

#define btnVoiceTag  156
#define btnEmojiTag  157
#define btnAddTag    158
#define btnNormalTag 999


@interface TSChatViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, AVAudioRecorderDelegate, TSTextViewDelegate, TSImagePickerDelegate, TSEmojiViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) TSToolbarTextView *textView;
@property (nonatomic, strong) NSString *txtContent;
@property (nonatomic, strong) UIButton *btnVoice;
@property (nonatomic, strong) UILabel *btnKeyboard;
//@property (nonatomic, strong) UILabel *btnAdd;
@property (nonatomic, strong) UIButton *btnAdd;
@property (nonatomic, strong) UIButton *btnEmoji;
@property (nonatomic, strong) TSMultiInputView *inputPlugInView;
@property (nonatomic, strong) TSEmojiView *emojiView;

@property (nonatomic, strong) NSMutableArray *talks;
@end

@implementation TSChatViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [TSImagePicker sharedInstance].delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initUI {
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGRect rect = [UIScreen mainScreen].bounds;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height - toolBarMinHeight) style:(UITableViewStylePlain)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[TalkCell class] forCellReuseIdentifier:@"TalkCell"];
    [self.tableView registerClass:[TSDateTimeCell class] forCellReuseIdentifier:TIMECELL];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissInput)];
    [self.tableView addGestureRecognizer:tap];
    
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kTSScreenHeight - toolBarMinHeight, kTSScreenWidth, toolBarMinHeight)];
    self.toolBar.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.toolBar];
    
    ______WS();
    
    self.inputPlugInView = [[TSMultiInputView alloc] init];
    [self.view addSubview:self.inputPlugInView];
    
    self.emojiView = [[TSEmojiView alloc] init];
    self.emojiView.delegate = self;
    [self.view addSubview:self.emojiView];
    
    
    self.btnVoice = [[UIButton alloc] init];
    self.btnVoice.tag = btnNormalTag;
    [self.btnVoice setBackgroundImage:[UIImage imageNamed:@"chat_setmode_voice_btn_normal"] forState:UIControlStateNormal];
    [self.btnVoice sizeToFit];
    [[[self.btnVoice rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        wSelf.btnVoice.tag == btnNormalTag ? [wSelf voiceToggled] : [wSelf keyboardToggled];
        
    }];
    [self.toolBar addSubview:self.btnVoice];
    [self.btnVoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(wSelf.toolBar).with.offset(kTSSideX);
        make.top.equalTo(wSelf.toolBar).with.offset(actionButtonTopMargin);
        make.size.mas_equalTo(CGSizeMake(actionButtonHeight, actionButtonHeight));
    }];
    
    
    self.btnAdd = [[UIButton alloc] init];
    [self.btnAdd setBackgroundImage:[UIImage imageNamed:@"chat_setmode_add_btn_normal"] forState:UIControlStateNormal];
    [self.toolBar addSubview:self.btnAdd];
    [self.btnAdd sizeToFit];
    [self.btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(wSelf.toolBar).with.offset(-kTSSideX);
        make.top.equalTo(wSelf.toolBar).with.offset(actionButtonTopMargin);
        make.size.mas_equalTo(CGSizeMake(actionButtonHeight, actionButtonHeight));
    }];
    [[[self.btnAdd rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        //多种输入的选择view
        if (wSelf.btnAdd.tag == btnAddTag) {
            [wSelf textViewEditMode];
            wSelf.btnAdd.tag = btnNormalTag;
            wSelf.inputPlugInView.top = kTSScreenHeight;
        }
        else {
            [wSelf showPlugInView];
            [wSelf textViewNormalState];
            [wSelf btnVoiceOriginalState];
        }
        
    }];
    
    self.btnEmoji = [[UIButton alloc] init];
    [self.btnEmoji setBackgroundImage:[UIImage imageNamed:@"chatting_biaoqing_btn_normal"] forState:UIControlStateNormal];
    [self.toolBar addSubview:self.btnEmoji];
    [self.btnEmoji sizeToFit];
    [self.btnEmoji mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(wSelf.btnAdd.mas_leading).with.offset(-buttonMargin);
        make.top.equalTo(wSelf.toolBar).with.offset(actionButtonTopMargin);
        make.size.mas_equalTo(CGSizeMake(actionButtonHeight, actionButtonHeight));
    }];
    [[[self.btnEmoji rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        if (wSelf.btnEmoji.tag == btnEmojiTag) {
            [wSelf textViewEditMode];
            [wSelf btnEmojiOriginalState];
        }
        else {
            [wSelf showEmojiView];
            [wSelf textViewNormalState];
            [wSelf btnVoiceOriginalState];
        }
    }];
    
    self.btnKeyboard = [TSTools iconfontLabel:@"\U0000e602" size:30];
    self.btnKeyboard.hidden = YES;
    self.btnKeyboard.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapk = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardToggled)];
    [self.btnKeyboard addGestureRecognizer:tapk];
    [self.toolBar addSubview:self.btnKeyboard];
    [self.btnKeyboard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(wSelf.toolBar).with.offset(kTSSideX);
        make.top.equalTo(wSelf.toolBar).with.offset(actionButtonTopMargin);
        make.size.mas_equalTo(CGSizeMake(actionButtonHeight, actionButtonHeight));
    }];
    
    self.textView = [[TSToolbarTextView alloc] init];
    self.textView.font = [UIFont systemFontOfSize:messageFontSize];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.textContainerInset = UIEdgeInsetsMake(7, 3, 7, 3);//top left bottom right
    self.textView.layer.borderColor = [UIColor blackColor].CGColor;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.cornerRadius = 5;
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.delegate = self;
    self.textView.delegatets = self;
    [self.toolBar addSubview:self.textView];
    [[RACSignal combineLatest:@[RACObserve(self, textView.text)]] subscribeNext:^(id x) {
        [wSelf.emojiView sendButtonHighlighted:(wSelf.textView.text.length > 0)];
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(wSelf.btnVoice.mas_trailing).with.offset(buttonMargin);
        make.trailing.equalTo(wSelf.btnEmoji.mas_leading).with.offset(-buttonMargin);
        make.top.equalTo(wSelf.toolBar).with.offset((toolBarMinHeight - textViewHeight)/2);
        make.bottom.equalTo(wSelf.toolBar).with.offset(-(toolBarMinHeight - textViewHeight)/2);
    }];
    
  
}


- (void)textViewEditMode {
    [self.textView becomeFirstResponder];
}

#pragma mark - States

- (void)btnAddOriginalState {
    self.btnAdd.tag = btnNormalTag;
    self.inputPlugInView.top = kTSScreenHeight;
}
- (void)btnEmojiOriginalState {
    self.btnEmoji.tag = btnNormalTag;
    self.emojiView.top = kTSScreenHeight;
    [self.btnEmoji setBackgroundImage:[UIImage imageNamed:@"chatting_biaoqing_btn_normal"] forState:UIControlStateNormal];
}
- (void)btnVoiceOriginalState {
    self.btnVoice.tag = btnNormalTag;
    [self.btnVoice setBackgroundImage:[UIImage imageNamed:@"chat_setmode_voice_btn_normal"] forState:UIControlStateNormal];
}
- (void)textViewNormalState {
    self.textView.editable = YES;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.textAlignment = NSTextAlignmentLeft;
    self.textView.tsState = TSTextViewStateNormal;
    self.textView.selectable = YES;
    self.textView.text = self.txtContent;
}
- (void)textViewButtonState {
    self.textView.editable = NO;
    self.textView.userInteractionEnabled = YES;
    self.textView.backgroundColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:0.1];
    self.textView.text = @"按住 说话";
    self.textView.textAlignment = NSTextAlignmentCenter;
    self.textView.tsState = TSTextViewStateButton;
    self.textView.selectable = NO;
}

#pragma mark - Action
- (void)voiceToggled {//dismiss keyboard
    ______WS();
    if (![self.textView isFirstResponder]) {
        [UIView animateWithDuration:0.3 animations:^{
            wSelf.toolBar.top = kTSScreenHeight - wSelf.toolBar.height;
        }];
    }
    
    [self.btnVoice setBackgroundImage:[UIImage imageNamed:@"chat_setmode_key_btn_normal"] forState:UIControlStateNormal];
    self.btnVoice.tag = btnVoiceTag;
    
    self.txtContent = self.textView.text;
    [self textViewButtonState];
    [self btnEmojiOriginalState];
    [self btnAddOriginalState];

    if (self.inputPlugInView.top < kTSScreenHeight) {
        [self hidePlugInView];
    }
    if (self.emojiView.top < kTSScreenHeight) {
        [self hideEmojiView];
    }
    self.tableView.height = kTSScreenHeight-toolBarMinHeight;
}

- (void)keyboardToggled {
    [self btnVoiceOriginalState];
    [self textViewNormalState];
    [self.textView becomeFirstResponder];
}

- (void)showPlugInView {
    [self.textView resignFirstResponder];
    ______WS();
    wSelf.btnAdd.tag = btnAddTag;
    [wSelf btnEmojiOriginalState];
    [UIView animateWithDuration:0.3 animations:^{
        wSelf.inputPlugInView.top = kTSScreenHeight - wSelf.inputPlugInView.height;
        wSelf.toolBar.top = kTSScreenHeight - wSelf.inputPlugInView.height - wSelf.toolBar.height;
    } completion:^(BOOL finished) {
        wSelf.emojiView.top = kTSScreenHeight;
    }];
    if (ceil(self.tableView.contentSize.height) >= ceil(kTSScreenHeight - toolBarMinHeight - self.inputPlugInView.size.height - topBarHeight)) {
        wSelf.tableView.height = kTSScreenHeight - toolBarMinHeight - wSelf.inputPlugInView.height;
        [self scrollToLastRow];
    }  
}

- (void)hidePlugInView {
    ______WS();
    [UIView animateWithDuration:0.3 animations:^{
        wSelf.inputPlugInView.top = kTSScreenHeight;
        wSelf.toolBar.top = kTSScreenHeight - wSelf.toolBar.height;
    }];
}

- (void)showEmojiView {
    ______WS();
    [wSelf.textView resignFirstResponder];
    wSelf.btnEmoji.tag = btnEmojiTag;
    [wSelf btnAddOriginalState];
    [wSelf.btnEmoji setBackgroundImage:[UIImage imageNamed:@"chat_setmode_key_btn_normal"] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3 animations:^{
        wSelf.emojiView.top = kTSScreenHeight - wSelf.emojiView.height;
        wSelf.toolBar.top = kTSScreenHeight - wSelf.emojiView.height - wSelf.toolBar.height;
    } completion:^(BOOL finished) {
        wSelf.inputPlugInView.top = kTSScreenHeight;
    }];
    if (ceil(self.tableView.contentSize.height) >= ceil(kTSScreenHeight - toolBarMinHeight - self.emojiView.size.height - topBarHeight)) {
        wSelf.tableView.height = kTSScreenHeight - toolBarMinHeight - wSelf.emojiView.height;
        [self scrollToLastRow];
    }
    
}
- (void)hideEmojiView {
    ______WS();
    [UIView animateWithDuration:0.3 animations:^{
        wSelf.emojiView.top = kTSScreenHeight;
        wSelf.toolBar.top = kTSScreenHeight - wSelf.toolBar.height;
    }];
}



- (void)keyboardShow:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    
    self.toolBar.frame = CGRectMake(0,
                                    kTSScreenHeight - keyboardFrame.size.height - self.toolBar.height,
                                    self.toolBar.width,
                                    self.toolBar.height);
    self.tableView.height = kTSScreenHeight - toolBarMinHeight - keyboardFrame.size.height;
    if (ceil(self.tableView.contentSize.height) >= ceil(kTSScreenHeight - toolBarMinHeight - keyboardFrame.size.height - topBarHeight)) {
        [self scrollToLastRow];
    }
    
    [UIView commitAnimations];
}
- (void)keyboardHide:(NSNotification *)note {
    NSDictionary *userInfo = note.userInfo;
    NSTimeInterval animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];

    if (self.emojiView.top == kTSScreenHeight && self.inputPlugInView.top == kTSScreenHeight) {
        self.toolBar.frame = CGRectMake(0,
                                        kTSScreenHeight-self.toolBar.height,
                                        self.toolBar.width,
                                        self.toolBar.height);
        self.tableView.height = kTSScreenHeight - toolBarMinHeight;
        [self scrollToLastRow];
    }
    
    [UIView commitAnimations];

}

- (void)dismissInput {
    [self.textView resignFirstResponder];
    if (self.emojiView.top < kTSScreenHeight) {
        [self hideEmojiView];
        [self btnEmojiOriginalState];
    }
    if (self.inputPlugInView.top < kTSScreenHeight) {
        [self hidePlugInView];
        [self btnAddOriginalState];
    }
}
#pragma mark - TSTextView
- (void)TSTextViewAddAudio:(NSURL *)audioPath {
    [self addDataToTableView:audioPath];
}

#pragma mark - TSImagePicker
- (void)TSImagePicker:(TSImagePicker *)imagePicker didFinishedPickingImage:(UIImage *)image {
    NSURL *imgPath = [TSSave saveImage:image];
    [self addDataToTableView:imgPath];
}

#pragma mark - UITextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (textView.text.length > 0) {
            NSString *string = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (string.length > 0) {
                [self addDataToTableView:textView.text];
            }
        }
        self.textView.text = @"";
        self.txtContent = self.textView.text;
        return NO;
    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    self.txtContent = self.textView.text;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self btnEmojiOriginalState];
    [self btnAddOriginalState];
    return YES;
}
#pragma mark - TSEmojiView

- (void)TSEmojiView:(TSEmojiView *)vEmoji emoji:(NSString *)emoji {
    self.textView.text = [self.textView.text stringByAppendingString:emoji];
    self.txtContent = self.textView.text;
}

- (void)TSEmojiViewDeleteLast {
    if (self.textView.text.length > 0) {
        NSString *text = self.textView.text;
        NSRange range = [text rangeOfComposedCharacterSequenceAtIndex:text.length-1];
        text = [text substringToIndex:(text.length - range.length)];//index从1开始算起
        self.textView.text = text;
    }
}

- (void)TSEmojiViewSendButtonTapped {
    [self addDataToTableView:self.textView.text];
    self.textView.text = @"";
}

#pragma mark - TableView

- (void)addDataToTableView:(id)item {
    NSDate *date = [NSDate date];
    __block NSDate *lastDate = nil;
    for (int i=0; i<self.talks.count; i++) {
        if ([self.talks[i] isKindOfClass:[NSDate class]]) {
            lastDate = self.talks[i];
        }
    }

    NSTimeInterval duration = [date timeIntervalSinceDate:lastDate];
    if (duration/60 > 2 || lastDate == nil) {
        [self.talks addObject:date];
    }
    
    [self.talks addObject:item];
    [self.tableView reloadData];
    [self scrollToLastRow];
}

- (void)scrollToLastRow {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.talks.count-1) inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.talks.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:TIMECELL]) {
        return 44;
    }
    return cell.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id item = self.talks[indexPath.row];
    if ([item isKindOfClass:[NSDate class]]) {
        NSString *timeIdentifier = TIMECELL;
        TSDateTimeCell *cell = (TSDateTimeCell *)[tableView dequeueReusableCellWithIdentifier:timeIdentifier];
        if (!cell) {
            cell = [[TSDateTimeCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:timeIdentifier];
        }
        cell.currentDate = (NSDate *)item;
        return cell;
    }
    else {
        TalkCellType cellType = indexPath.row % 2 == 0 ? TalkCellTypeSend : TalkCellTypeReceived;
        if ([item isKindOfClass:[NSString class]]) {
            TSTextCell *cell = (TSTextCell *)[tableView dequeueReusableCellWithIdentifier:TalkCellContentTypeText];
            if (!cell) {
                cell = [[TSTextCell alloc] initWithType:cellType talkCellContentType:TalkCellContentTypeText];
            }
            cell.content = (NSString *)item;
            return cell;
        }
        if ([item isKindOfClass:[NSURL class]]) {
            //
            NSURL *url = item;
            NSString *fileName = [url.pathComponents lastObject];
            if ([fileName containsString:@".m4a"]) {
                TSVoiceCell *cell = (TSVoiceCell *)[tableView dequeueReusableCellWithIdentifier:TalkCellContentTypeAudio];
                if (!cell) {
                    cell = [[TSVoiceCell alloc] initWithType:cellType talkCellContentType:TalkCellContentTypeAudio];
                }
                cell.fileUrl = url;
                return cell;
            }
            
            if ([fileName containsString:@".jpg"]) {
                TSImageCell *cell = (TSImageCell *)[tableView dequeueReusableCellWithIdentifier:TalkCellContentTypeImage];
                if (!cell) {
                    cell = [[TSImageCell alloc] initWithType:cellType talkCellContentType:TalkCellContentTypeImage];
                }
                cell.fileUrl = url;
                return cell;
            }
            return nil;
        }
  
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //dismiss keyboard, emojiView, pluginView
    [self dismissInput];
}
#pragma mark - getter

- (NSMutableArray *)talks {
    if (!_talks) {
        _talks = [[NSMutableArray alloc] init];
    }
    return _talks;
}

@end
