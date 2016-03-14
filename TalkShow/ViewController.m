//
//  ViewController.m
//  TalkShow
//
//  Created by ZhouQian on 16/2/16.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "ViewController.h"
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


@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, AVAudioRecorderDelegate, TSTextViewDelegate, TSImagePickerDelegate, TSEmojiViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) TSToolbarTextView *textView;
//@property (nonatomic, strong) UILabel *btnVoice;
@property (nonatomic, strong) UIButton *btnVoice;
@property (nonatomic, strong) UILabel *btnKeyboard;
//@property (nonatomic, strong) UILabel *btnAdd;
@property (nonatomic, strong) UIButton *btnAdd;
@property (nonatomic, strong) UIButton *btnEmoji;
@property (nonatomic, strong) TSMultiInputView *inputPlugInView;
@property (nonatomic, strong) TSEmojiView *emojiView;

@property (nonatomic, strong) NSMutableArray *talks;
@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [TSImagePicker sharedInstance].delegate = self;
}

- (void)initUI {
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.toolBar = [[UIToolbar alloc] init];
    self.toolBar.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.toolBar];
    
    ______WS();
    
    
    self.btnVoice = [[UIButton alloc] init];
    self.btnVoice.tag = 998;
    [self.btnVoice setBackgroundImage:[UIImage imageNamed:@"chat_setmode_voice_btn_normal"] forState:UIControlStateNormal];
    [self.btnVoice sizeToFit];
    [[[self.btnVoice rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        wSelf.btnVoice.tag == 998 ? [wSelf voiceToggled] : [wSelf keyboardToggled];
        
    }];
    [self.toolBar addSubview:self.btnVoice];
    [self.btnVoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(wSelf.toolBar).with.offset(kTSSideX);
        make.top.equalTo(wSelf.toolBar).with.offset(actionButtonTopMargin);
        make.size.mas_equalTo(CGSizeMake(actionButtonHeight, actionButtonHeight));
    }];
    
    self.inputPlugInView = [[TSMultiInputView alloc] init];
    [self.view addSubview:self.inputPlugInView];
//    [self.inputPlugInView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(wSelf.view.mas_bottom);
//        make.leading.equalTo(wSelf.view);
//        make.trailing.equalTo(wSelf.view);
//        make.height.mas_equalTo(wSelf.inputPlugInView.height);
//    }];
    
    self.emojiView = [[TSEmojiView alloc] init];
    self.emojiView.delegate = self;
    [self.view addSubview:self.emojiView];
    [self.emojiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.view.mas_bottom);
        make.leading.equalTo(wSelf.view);
        make.trailing.equalTo(wSelf.view);
        make.height.mas_equalTo(wSelf.emojiView.height);
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
        [wSelf showPlugInView];
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
        [wSelf showEmojiView];
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
//    [[self.textView rac_textSignal] subscribeNext:^(id x) {
//        [wSelf.emojiView sendButtonHighlighted:(wSelf.textView.text.length > 0)];
//    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(wSelf.btnVoice.mas_trailing).with.offset(buttonMargin);
        make.trailing.equalTo(wSelf.btnEmoji.mas_leading).with.offset(-buttonMargin);
        make.top.equalTo(wSelf.toolBar).with.offset((toolBarMinHeight - textViewHeight)/2);
        make.bottom.equalTo(wSelf.toolBar).with.offset(-(toolBarMinHeight - textViewHeight)/2);
    }];
    
    
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(wSelf.view);
        make.trailing.equalTo(wSelf.view);
        make.bottom.equalTo(wSelf.inputPlugInView.mas_top);
        make.height.mas_equalTo(toolBarMinHeight);
    }];
    
    
}

//- (void)loadView {
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    self.view = scrollView;
//}


- (void)voiceToggled {
//    self.btnVoice.hidden = YES;
//    self.btnKeyboard.hidden = NO;
    [self.btnVoice setBackgroundImage:[UIImage imageNamed:@"chat_setmode_key_btn_normal"] forState:UIControlStateNormal];
    self.btnVoice.tag = 997;
    
    self.textView.editable = NO;
    self.textView.userInteractionEnabled = YES;
    [self.textView resignFirstResponder];
    self.textView.backgroundColor = [UIColor colorWithRed:108/255.0 green:108/255.0 blue:108/255.0 alpha:0.1];
    self.textView.text = @"按住 说话";
    self.textView.textAlignment = NSTextAlignmentCenter;
    self.textView.tsState = TSTextViewStateButton;
    self.textView.selectable = NO;
}

- (void)keyboardToggled {
//    self.btnVoice.hidden = NO;
//    self.btnKeyboard.hidden = YES;
    self.btnVoice.tag = 998;
    [self.btnVoice setBackgroundImage:[UIImage imageNamed:@"chat_setmode_voice_btn_normal"] forState:UIControlStateNormal];
    self.textView.editable = YES;
    [self.textView becomeFirstResponder];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.text = @"";
    self.textView.textAlignment = NSTextAlignmentLeft;
    self.textView.tsState = TSTextViewStateNormal;
    self.textView.selectable = YES;
}


#pragma mark - Action

- (void)showPlugInView {
    self.textView.editable = NO;
    self.inputPlugInView.top = kTSScreenHeight;
    ______WS();
    [UIView animateWithDuration:0.3 animations:^{
        wSelf.inputPlugInView.top = kTSScreenHeight - wSelf.inputPlugInView.height;
        wSelf.toolBar.top = kTSScreenHeight - wSelf.inputPlugInView.height - wSelf.toolBar.height;
    } completion:^(BOOL finished) {

    }];
    
}

- (void)showEmojiView {
    [self.textView resignFirstResponder];
    ______WS();
    [UIView animateWithDuration:0.3 animations:^{
        wSelf.emojiView.top = kTSScreenHeight - wSelf.emojiView.height;
        wSelf.toolBar.top = kTSScreenHeight - wSelf.emojiView.height - wSelf.toolBar.height;
    }];
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
        
        textView.text = @"";
        [textView resignFirstResponder];
    }
    
    return YES;
}



#pragma mark - TSEmojiView

- (void)TSEmojiView:(TSEmojiView *)vEmoji emoji:(NSString *)emoji {
    self.textView.text = [self.textView.text stringByAppendingString:emoji];
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
}

#pragma mark - TableView

- (void)addDataToTableView:(id)item {
    NSDate *date = [NSDate date];
    __block NSDate *lastDate = nil;
    [self.talks enumerateObjectsWithOptions:(NSEnumerationReverse) usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDate class]]) {
            lastDate = obj;
        }
    }];

    NSTimeInterval duration = [date timeIntervalSinceDate:lastDate];
    if (duration/60 > 2 || lastDate == nil) {
        [self.talks addObject:date];
    }
    
    [self.talks addObject:item];
    [self.tableView reloadData];
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


#pragma mark - getter

- (NSMutableArray *)talks {
    if (!_talks) {
        _talks = [[NSMutableArray alloc] init];
    }
    return _talks;
}

@end
