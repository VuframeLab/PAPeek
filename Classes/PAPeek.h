//
//  PAPeek.h
//  PAPeek
//
//  Created by Daniel Dengler on 17.01.13.
//  Copyright (c) 2013 doPanic GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

// Delgate
@class PAPeek;
@protocol PAPeekDelegate <NSObject>
- (NSUInteger)numberOfImagesInPeek:(PAPeek *)peek;
- (UIImage*)peek:(PAPeek *)peek imageAtIndex:(NSUInteger)index;

@optional
- (void)peek:(PAPeek *)peek didSelectItemAtIndex:(NSUInteger)index;
@end

// PAPeek
@interface PAPeek : UIViewController <UIScrollViewDelegate>
{
    id <PAPeekDelegate> delegate;
}

@property (retain) id delegate;
@property (nonatomic, assign) NSUInteger index;

@end
