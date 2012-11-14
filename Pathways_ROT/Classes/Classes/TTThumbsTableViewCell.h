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

#import "TTTableViewCell.h"

@protocol TTPhoto, TTThumbsTableViewCellDelegate;
@class TTThumbView;

@interface TTThumbsTableViewCell : TTTableViewCell {
  id<TTThumbsTableViewCellDelegate> _delegate;
  id<TTPhoto> _photo;
  NSMutableArray* _thumbViews;
  CGFloat _thumbSize;
  CGPoint _thumbOrigin;
  NSInteger _columnCount;
}

@property(nonatomic,retain) id<TTPhoto> photo;
@property(nonatomic,assign) id<TTThumbsTableViewCellDelegate> delegate;
@property(nonatomic) CGFloat thumbSize;
@property(nonatomic) CGPoint thumbOrigin;
@property(nonatomic) NSInteger columnCount;

- (void)suspendLoading:(BOOL)suspended;

@end

@protocol TTThumbsTableViewCellDelegate

- (void)thumbsTableViewCell:(TTThumbsTableViewCell*)cell didSelectPhoto:(id<TTPhoto>)photo;

@end