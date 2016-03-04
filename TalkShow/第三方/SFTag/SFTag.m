//
// Created by shiweifu on 12/9/14.
// Copyright (c) 2014 shiweifu. All rights reserved.
//

#import "SFTag.h"


@implementation SFTag
{

}

- (instancetype)initWithText:(NSString *)text
{
  self = [super init];
  if (self)
  {
    _text          = text;
//    self.font  = CTFontNotPoint;
//    self.textColor = HEXCOLOR(0x9C8884);
    self.bgColor   = [UIColor whiteColor];
//      self.borderColor = CTColorOther;
      self.borderWidth = 0.5;
  }

  return self;
}

+ (instancetype)tagWithText:(NSString *)text
{
  return [[self alloc] initWithText:text];
}


@end