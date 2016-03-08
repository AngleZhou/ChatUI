//
//  SFTagView.m
//  WrapViewWithAutolayout
//
//  Created by shiweifu on 12/9/14.
//  Copyright (c) 2014 shiweifu. All rights reserved.
//

#import "SFTagView.h"
#import "SFTag.h"
#import "SFTagButton.h"



@interface SFTagView ()

@property (nonatomic, strong) NSMutableArray *tags; //SFTagbuttons
@property (assign) CGFloat intrinsicHeight;

@end

@implementation SFTagView
{
}

-(CGSize)intrinsicContentSize {
  return CGSizeMake(self.frame.size.width, self.intrinsicHeight);
}

- (void)addTag:(SFTag *)tag
{

  SFTagButton *btn = [[SFTagButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    if (tag.text.length > 0) {
        [btn setTitle:tag.text forState:UIControlStateNormal];
    }
    if (tag.font) {
        [btn.titleLabel setFont:tag.font];
    }
    if (tag.image) {
        [btn setImage:tag.image forState:UIControlStateNormal];
        [btn setImageEdgeInsets:tag.imageInsets];
    }
    
    btn.titleLabel.backgroundColor = tag.bgColor;
  [btn setBackgroundColor:tag.bgColor];
  [btn setTitleColor:tag.textColor forState:UIControlStateNormal];
  [btn addTarget:tag.target action:tag.action forControlEvents:UIControlEventTouchUpInside];
    btn.checked = tag.bCheck ? YES : NO;
    btn.category = tag.category;
    
    CGSize size;

    
    if ((int)tag.size.height != 0 && (int)tag.size.width != 0) {
        size = tag.size;
    }
    else {
        CGSize constraintSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
#ifdef __IPHONE_7_0
        NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setAlignment:NSTextAlignmentLeft];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary* stringAttributes = @{NSFontAttributeName: tag.font,
                                           NSParagraphStyleAttributeName: paragraphStyle};
        size = [tag.text boundingRectWithSize: constraintSize
                                      options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                   attributes: stringAttributes
                                      context: nil].size;
#else
        size = [tag.text sizeWithFont: tag.font
                    constrainedToSize: constraintSize
                        lineBreakMode: NSLineBreakByWordWrapping];
#endif
        size.width  += tag.textToBorderX * 2;
        size.height += tag.textToBorderY * 2;
    }

    

  btn.layer.cornerRadius = tag.cornerRadius;
    btn.layer.borderWidth = tag.borderWidth;
    btn.layer.borderColor = tag.borderColor.CGColor;
  [btn.layer setMasksToBounds:YES];


//  CGSize size = btn.intrinsicContentSize;
  CGRect r = CGRectMake(0, 0, size.width, size.height);
  [btn setFrame:r];

  [self.tags addObject:btn];

  [self rearrangeTags];
}

#pragma mark - Tag removal

- (void)removeTagText:(NSString *)text
{
  SFTagButton *b = nil;
  for (SFTagButton *t in self.tags) {
    if([text isEqualToString:t.titleLabel.text])
    {
      b = t;
    }
  }

  if(!b)
  {
    return;
  }

  [b removeFromSuperview];
  [self.tags removeObject:b];
  [self rearrangeTags];
}

- (void)removeAllTags
{
  for (SFTagButton *t in self.tags) {
    [t removeFromSuperview];
  }
  [self.tags removeAllObjects];
  [self rearrangeTags];
}

- (void)rearrangeTags
{
  self.intrinsicHeight = 0;
    
  [self.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
      //把TagView清空
    [obj removeFromSuperview];
  }];
  __block float maxY = self.margin.top;
  __block float maxX = self.margin.left;
  __block CGSize size;
    
    //
  [self.tags enumerateObjectsUsingBlock:^(SFTagButton *obj, NSUInteger idx, BOOL *stop) {
    size = obj.frame.size;
      //得到最大的Y，最下方
    [self.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
      if ([obj isKindOfClass:[SFTagButton class]]) {
        maxY = MAX(maxY, obj.frame.origin.y);
      }
    }];
      
      //得到最大的X，最右
    [self.subviews enumerateObjectsUsingBlock:^(SFTagButton *obj, NSUInteger idx, BOOL *stop) {
      if ([obj isKindOfClass:[SFTagButton class]]) {
        if (floor(obj.frame.origin.y) == floor(maxY)) {
          maxX = MAX(maxX, obj.frame.origin.x + obj.frame.size.width);
        }
      }
    }];

    // Go to a new line if the tag won't fit
    if (size.width + maxX + self.insets > (self.frame.size.width - self.margin.right)) {
      maxY += size.height + self.lineSpace;
      maxX = self.margin.left;
    }
      
    obj.frame = (CGRect){maxX + self.insets, maxY, size.width, size.height};
//    NSLog(@"%@", NSStringFromCGRect(obj.frame));
      
    [self addSubview:obj];
  }];

  CGRect r = self.frame;
  CGFloat n = maxY + size.height + self.margin.bottom;
  self.intrinsicHeight = n > self.intrinsicHeight? n : self.intrinsicHeight;
    if (self.intrinsicHeight < r.size.height) {
        self.intrinsicHeight = r.size.height;
    }
  [self setFrame:CGRectMake(r.origin.x, r.origin.y, self.frame.size.width, self.intrinsicHeight)];
//  NSLog(@"%@", NSStringFromCGRect(self.frame));
//    NSLog(@"=================================");
    
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  [self rearrangeTags];
}

- (NSMutableArray *)tags
{
  if(!_tags)
  {
    _tags = [NSMutableArray array];
  }
  return _tags;
}

@end
