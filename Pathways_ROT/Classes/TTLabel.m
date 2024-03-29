//
// Copyright 2009 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "TTLabel.h"

#import "TTGlobalCore.h"
#import "TTDefaultStyleSheet.h"

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TTLabel

@synthesize font = _font, text = _text;

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithText:(NSString*)text {
  if (self = [self init]) {
    self.text = text;
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _text = nil;
    _font = nil;
  }
  return self;
}

- (void)dealloc {
  TT_RELEASE_SAFELY(_text);
  TT_RELEASE_SAFELY(_font);
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIView

- (void)drawRect:(CGRect)rect {
  TTStyleContext* context = [[[TTStyleContext alloc] init] autorelease];
  context.delegate = self;
  context.frame = self.bounds;
  context.contentFrame = context.frame;
  context.font = _font;

  [self.style draw:context];
  if (!context.didDrawContent) {
    [self drawContent:self.bounds];
  }
}

- (CGSize)sizeThatFits:(CGSize)size {
  TTStyleContext* context = [[[TTStyleContext alloc] init] autorelease];
  context.delegate = self;
  context.font = _font;
  context.frame = CGRectMake(0, 0, size.width, size.height);
  context.contentFrame = context.frame;
  return [_style addToSize:CGSizeZero context:context];
}


//////////////////////////////////////////////////////////////////////////////////////////////////
// UIAccessibility

- (BOOL)isAccessibilityElement {
  return YES;
}

- (NSString *)accessibilityLabel {
  return _text;
}

- (UIAccessibilityTraits)accessibilityTraits {
  return [super accessibilityTraits] | UIAccessibilityTraitStaticText;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTStyleDelegate

- (NSString*)textForLayerWithStyle:(TTStyle*)style {
  return self.text;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// public

- (UIFont*)font {
  if (!_font) {
    _font = [TTSTYLEVAR(font) retain];
  }
  return _font;
}

- (void)setFont:(UIFont*)font {
  if (font != _font) {
    [_font release];
    _font = [font retain];
    [self setNeedsDisplay];
  }
}

- (void)setText:(NSString*)text {
  if (text != _text) {
    [_text release];
    _text = [text copy];
    [self setNeedsDisplay];
  }
}

@end
