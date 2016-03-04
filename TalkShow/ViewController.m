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
#import "TSImagePicker.h"
#import <AVFoundation/AVFoundation.h>

#import <Masonry.h>
#import "IQKeyboardManager.h"

#define toolBarMinHeight 44
#define messageFontSize 17


@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, AVAudioRecorderDelegate, TSTextViewDelegate, TSImagePickerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) TSToolbarTextView *textView;
//@property (nonatomic, strong) UILabel *btnVoice;
@property (nonatomic, strong) UIButton *btnVoice;
@property (nonatomic, strong) UILabel *btnKeyboard;
//@property (nonatomic, strong) UILabel *btnAdd;
@property (nonatomic, strong) UIButton *btnAdd;
@property (nonatomic, strong) TSMultiInputView *inputPlugInView;

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
    [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[self class]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.toolBar = [[UIToolbar alloc] init];
    self.toolBar.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.toolBar];
    
    ______WS();
    
    
//    self.btnVoice = iconfontLabel(@"\U0000e606", 24);
    self.btnVoice = [[UIButton alloc] init];
    self.btnVoice.tag = 998;
    [self.btnVoice setBackgroundImage:[UIImage imageNamed:@"chat_setmode_voice_btn_normal"] forState:UIControlStateNormal];
    [[[self.btnVoice rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        wSelf.btnVoice.tag == 998 ? [wSelf voiceToggled] : [wSelf keyboardToggled];
        
    }];
//    self.btnVoice.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voiceToggled)];
//    [self.btnVoice addGestureRecognizer:tap];
    [self.toolBar addSubview:self.btnVoice];
    [self.btnVoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(wSelf.toolBar).with.offset(kTSSideX);
        make.top.equalTo(wSelf.toolBar).with.offset(8);
//        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    self.inputPlugInView = [[TSMultiInputView alloc] init];
    [self.view addSubview:self.inputPlugInView];
    [self.inputPlugInView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wSelf.view.mas_bottom);
        make.leading.equalTo(wSelf.view);
        make.trailing.equalTo(wSelf.view);
        make.height.mas_equalTo(wSelf.inputPlugInView.height);
    }];
    
    self.btnAdd = [[UIButton alloc] init];
    [self.btnAdd setBackgroundImage:[UIImage imageNamed:@"chat_setmode_add_btn_normal"] forState:UIControlStateNormal];
    [self.toolBar addSubview:self.btnAdd];
    [self.btnAdd sizeToFit];
    [self.btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(wSelf.toolBar).with.offset(-kTSSideX);
        make.top.equalTo(wSelf.toolBar).with.offset(8);
    }];
    [[[self.btnAdd rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        //多种输入的选择view
        [wSelf showPlugInView];
    }];
    
    
    self.btnKeyboard = [TSTools iconfontLabel:@"\U0000e602" size:24];
    self.btnKeyboard.hidden = YES;
    self.btnKeyboard.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapk = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardToggled)];
    [self.btnKeyboard addGestureRecognizer:tapk];
    [self.toolBar addSubview:self.btnKeyboard];
    [self.btnKeyboard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(wSelf.toolBar).with.offset(kTSSideX);
        make.top.equalTo(wSelf.toolBar).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    self.textView = [[TSToolbarTextView alloc] init];
    self.textView.font = [UIFont systemFontOfSize:messageFontSize];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.textContainerInset = UIEdgeInsetsMake(4, 3, 3, 3);
    self.textView.layer.borderColor = [UIColor blackColor].CGColor;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.cornerRadius = 5;
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.delegate = self;
    self.textView.delegatets = self;
    [self.toolBar addSubview:self.textView];
    
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(wSelf.btnVoice.mas_trailing).with.offset(kTSSideX);
        make.trailing.equalTo(wSelf.btnAdd.mas_leading).with.offset(-kTSSideX);
        make.top.equalTo(wSelf.toolBar).with.offset(kTSSideX);
        make.bottom.equalTo(wSelf.toolBar).with.offset(-kTSSideX);
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
    ______WS();
    [UIView animateWithDuration:0.3 animations:^{
        wSelf.inputPlugInView.top = kTSScreenHeight - wSelf.inputPlugInView.height;
        wSelf.toolBar.top = kTSScreenHeight - wSelf.inputPlugInView.height - wSelf.toolBar.height;
    } completion:^(BOOL finished) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [wSelf.toolBar mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.bottom.equalTo(wSelf.inputPlugInView.mas_top);
//            }];
//        });
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
