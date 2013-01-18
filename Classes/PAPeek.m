//
//  PAPeek.m
//  PAPeek
//
//  Created by Daniel Dengler on 17.01.13.
//  Copyright (c) 2013 doPanic GmbH. All rights reserved.
//

#import "PAPeek.h"
#import "MBProgressHUD.h"

@interface PAPeek () {
	UIScrollView *scrollView;
//    MBProgressHUD *_progressHUD;
}

@end

@implementation PAPeek

@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    scrollView = [[UIScrollView alloc] init];
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bouncesZoom = YES;
    scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.userInteractionEnabled = YES;
    scrollView.scrollsToTop = YES;
    scrollView.backgroundColor = [UIColor blackColor];
    self.wantsFullScreenLayout = YES;
    self.view = scrollView;
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                          initWithTarget:self
                                                          action:@selector(handleSingleTap:)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImageView *imageView;
    
    for (int i = 0; i < [self numberOfImages]; i++) {
        imageView = [[UIImageView alloc] initWithImage:[self imageAtIndex:i]];
        imageView.frame = CGRectMake(scrollView.frame.size.width * i, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        [scrollView addSubview:imageView];
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [self numberOfImages], scrollView.frame.size.height);
    
    [scrollView scrollRectToVisible:CGRectMake(scrollView.frame.size.width * [self index], 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Delegate

- (NSUInteger)numberOfImages
{
    return [[self delegate] numberOfImagesInPeek: self];
}

- (UIImage*)imageAtIndex:(NSUInteger)index
{
    return [[self delegate] peek:self imageAtIndex:index];
}

- (void)didSelectItemAtIndex:(NSUInteger)index
{
    [[self delegate] peek:self didSelectItemAtIndex:index];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer 
{
    [self didSelectItemAtIndex:(scrollView.contentOffset.x / scrollView.frame.size.width)];
}

#pragma mark - UIScrollViewDelegate

//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    return imageView;
//}

@end
