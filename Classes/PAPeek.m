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
    NSOperationQueue *queue;
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
    scrollView.delegate = self;
    self.wantsFullScreenLayout = YES;
    self.view = scrollView;
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                          initWithTarget:self
                                                          action:@selector(handleSingleTap:)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
    queue = [NSOperationQueue new];
    queue.maxConcurrentOperationCount = 1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImageView *imageView;
    
    for (int i = 0; i < [self numberOfImages]; i++) {
        imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(scrollView.frame.size.width * i, 0, scrollView.frame.size.width, scrollView.frame.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.userInteractionEnabled = YES;
        [scrollView addSubview:imageView];
    }
    
    [self queueLoadImageForViewAtIndex:[self index]];
    
    if ([self index] > 0) {
        [self queueLoadImageForViewAtIndex:[self index] - 1];
    }
    
    if ([self index] < [self numberOfImages] - 1) {
        [self queueLoadImageForViewAtIndex:[self index] + 1];
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [self numberOfImages], scrollView.frame.size.height);
    
    [scrollView scrollRectToVisible:CGRectMake(scrollView.frame.size.width * [self index], 0, scrollView.frame.size.width, scrollView.frame.size.height) animated:NO];
}

- (void)queueLoadImageForViewAtIndex:(NSUInteger)index{
    NSInvocationOperation *operation;
    operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                     selector:@selector(loadImageForViewAtIndex:)
                                                       object:[[NSNumber alloc] initWithInt:index]];
    [queue addOperation:operation];
}

- (void)loadImageForViewAtIndex:(NSNumber *)index {
    // TODO: replace unsafe UIImage use with CGImage
    UIImageView *imageView = (UIImageView*)[scrollView.subviews objectAtIndex:[index integerValue]];
    if(imageView.image == nil) {
        UIImage *image = [self imageAtIndex:[index integerValue]];
        [imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // load first image
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [queue cancelAllOperations];
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)currentScrollView
{
    // TODO: remove hack of scroll view width and react to orientation change
    int index = floor(currentScrollView.contentOffset.x / [[UIScreen mainScreen] bounds].size.height);
    
    // just in case
    UIImageView *imageView;
    for (int i = 0; i < [self numberOfImages]; i++) {
        imageView = (UIImageView*)[[scrollView subviews] objectAtIndex:i];
        if (i < index - 1){
            imageView.image = nil;
        } else if (i > index + 1) {
            imageView.image = nil;
        }
    }
    [queue cancelAllOperations];
    [self queueLoadImageForViewAtIndex:index];
    
    if (index > 0) {
        [self queueLoadImageForViewAtIndex:index - 1];
    }
    
    if (index < [self numberOfImages] - 1) {
        [self queueLoadImageForViewAtIndex:index + 1];
    }
    

}

@end
