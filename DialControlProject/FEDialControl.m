//
//  FEDialControl.m
//
//  Created by Brad Eaton on 10/21/12.
//  Copyright (c) 2012 Brad Eaton. All rights reserved.
//

#import "FEDialControl.h"
#import <QuartzCore/QuartzCore.h>


#pragma mark - Private Methods
@interface FEDialControl()
- (void)initializeDial;
- (UIImageView *)addSectionToContainerNum:(NSInteger)value withImage:(UIImage *)image;
- (float)calculateDistanceFromCenter:(CGPoint)point;
- (void)buildSectorsEven;
- (void)buildSectorsOdd;
- (void)setHomePosition:(FEDialControlHomePosition)home forView:(UIView *)view;
- (UIImageView *)getSectionByValue:(int)value;
- (NSInteger)positionForCurrentSection;
- (void)setSelectedImageForSection:(int)value;
- (void)buttonPressed;

@end

@implementation FEDialControl

@synthesize delegate, numberOfSections, sections, currentSection, rotationalComponent, centerButton;

#pragma mark - Initialization

-(id) initWithFrame:(CGRect)frame delegate:(id)del homePosition:(FEDialControlHomePosition)home centerOfRotation:(CGPoint)center  {
    if ((self = [super initWithFrame:frame])) {
        
        // Save properties
        self.delegate = del;
        homePosition = home;
        centerOfRotation = center;
        
        // Setup the dial
        [self initializeDial];
        
        // currentSection is where we are on the dial currently.
        currentSection = 0;
        [self setSelectedImageForSection:0];
    }
    
    // Default to a dial numbering scheme.  This allows the control to report the correct
    // postion depending on whether the control mimics a dial turning or an indicator turning over fixed
    // dial positions.  The current position is inverse between the two.
    self.rotationalComponent = FEDialControlRotatingComponentDial;
    
    return self;
}

- (void)initializeDial {
    // Get the number of sections from the delegate
    numberOfSections = [self.delegate numberOfSectionsInDial:self];
    
    // Initialize the array we'll use to store images and section positions
    self.sections = [NSMutableArray arrayWithCapacity:numberOfSections];

    // Setup an array of section objects that will help us determine which section is active given the current rotation of the container view.  Much thanks to Cesare Rocchi's tutorial
    // http://www.raywenderlich.com/9864/how-to-create-a-rotating-wheel-control-with-uikit
    if (numberOfSections % 2 == 0) {
        [self buildSectorsEven];
    } else {
        [self buildSectorsOdd];
    }
    
    // Get the background image from the delegate
    if ([self.delegate respondsToSelector:@selector(backgroundImageForDialControl:)]) {
        UIImageView *bg = [[UIImageView alloc] initWithFrame:self.frame];
        UIImage *image = [self.delegate backgroundImageForDialControl:self];
        if (image) {
            bg.image = image;
            [self addSubview:bg];
        }
    }
        
    // be rotated to achieve the dial effect.
    rotatingView = [[UIView alloc] initWithFrame:self.frame];
    
    // ImageView
    UIImageView *imageView;
    
	// For every section in the dail, get the graphics from the delegate.
	for (int i = 0; i < numberOfSections; i++) {
        // Get the background image of the dial section from the delegate.
        UIImage *sectionImage = [self.delegate dialControl:self imageForSection:i];
        
        // Add a new section to the container view using the obtained image
        imageView = [self addSectionToContainerNum:i withImage:sectionImage];

        // Add the section to  array so that we can get to it later to hide / show as appropriate
        FEDialControlSection *section = [self.sections objectAtIndex:i];
        section.view = imageView;

        // If the delegate gives us an image for the selected state of a section, add it.
        if ([self.delegate respondsToSelector:@selector(dialControl:imageForSelectedSection:)]) {
            // Get the background image of the dial section from the delegate.
            UIImage *sectionImageSelected = [self.delegate dialControl:self imageForSelectedSection:i];
            
            // Add a new selected section to the container view using obtained image
            imageView = [self addSectionToContainerNum:i withImage:sectionImageSelected];
            
            // Hide the selectsion version of the view
            imageView.hidden = YES;
            
            // Add the section to  array so that we can get to it later to hide / show as appropriate
            section.selectedView = imageView;

        }
	}
    
    // Now that we're done filling the section container, let's add it as a subview.
    rotatingView.userInteractionEnabled = NO;
    [self addSubview:rotatingView];
    // In case our background or foreground graphic's center of rotation isn't the same as the center of the view, let's set it explicitly from the value passed in the init.
    rotatingView.center = centerOfRotation;

    // Get the foreground image from the delegate (optional).  This would likely be a partially transparent graphic that acts as the pointer for the dial.
    if ([self.delegate respondsToSelector:@selector(foregroundImageForDialControl:)]) {
        UIImage *fgImage = [self.delegate foregroundImageForDialControl:self];
        if (fgImage) {
            UIImageView *fg = [[UIImageView alloc] initWithImage:fgImage];
            [self addSubview:fg];
        }
    }
    
    // Button images
    // If the delegate will return us an image, create the button
    if ([self.delegate respondsToSelector:@selector(buttonImageForDialControl:)]) {
        UIImage *buttonImage = [self.delegate buttonImageForDialControl:self];
        UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
        [b setImage:buttonImage forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(buttonImageDepressedForDialControl:)]) {
            UIImage *buttonImageDepressed = [self.delegate buttonImageDepressedForDialControl:self];
            [b setImage:buttonImageDepressed forState:UIControlStateHighlighted];
        }
        [self addSubview:b];
        b.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
        b.layer.position = centerOfRotation;
        [b addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    }

    
    // Tell our delegate what the dial position is...
    [self.delegate dialDidChangeValue:[self positionForCurrentSection]];
}

- (UIImageView *)addSectionToContainerNum:(NSInteger)value withImage:(UIImage *)image {

    // There are 2*pi radians in a circle. The angle size defines the size in radians
    // of each section of our dial.
    CGFloat angleSize = 2*M_PI/self.numberOfSections;
 
    // Create the UIImageView that will get added to our container
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    // Set their anchor positions based the specified home position (where's the dial marker?)
    [self setHomePosition:homePosition forView:imageView];
    
    // Align the anchor points with the center of the dial.
    imageView.layer.position = centerOfRotation;
    
    // Rotate the sections the appropriate amount for their positoin on the dial
    imageView.transform = CGAffineTransformMakeRotation(angleSize*value);
    
    // Tag it with its position on the dial
    imageView.tag = value;
    
    // Add the section to the container
    [rotatingView addSubview:imageView];
 
    return imageView;
}


#pragma mark - UIControl touch events


- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    // Set the selected state of sections to off
    [self setSelectedImageForSection:-1];

    // What are the coordinates of the user's first touch
    CGPoint touchPoint = [touch locationInView:self];
    
    // How far was this touch from the center?
    float dist = [self calculateDistanceFromCenter:touchPoint];
    // Don't respond to touches that falloutside the radius of our dial. We're assuming here that the radius of the dial is equal to half the width of the control.
    if (dist > self.frame.size.width/2) {
        return NO;
    }
    // calculate the difference for the x/y coordinates of the touch point and center.
    float dx = touchPoint.x - rotatingView.center.x;
    float dy = touchPoint.y - rotatingView.center.y;
    
    // Calculate the angle that that the center point and our touch creates
    startAngle = atan2(dy, dx);
    
    // Save the current state of the container view's transform
    startTransform = rotatingView.transform;
    
    return YES;
    
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint pt = [touch locationInView:self];
    float dx = pt.x - rotatingView.center.x;
    float dy = pt.y - rotatingView.center.y;
    float ang = atan2(dy,dx);
    float angleDifference = startAngle - ang;
    rotatingView.transform = CGAffineTransformRotate(startTransform, -angleDifference);
    return YES;
}


- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    // The the container's current rotation angle in radians
    CGFloat radians = atan2f(rotatingView.transform.b, rotatingView.transform.a);
    
    //  The newVal variabled will be used to calculate the angle in radians
    // that we need to rotate the continer to snap it to the center of the current section
    CGFloat newVal = 0.0;
    
    // Loop though each sector and determine which one is currently selected.
    for (FEDialControlSection *s in sections) {
        // This condition can occur with an even number of sectors on the dial
        if (s.minValue > 0 && s.maxValue < 0) {
            if (s.maxValue > radians || s.minValue < radians) {
                // Which side of the circle are we on?
                if (radians > 0) {
                    newVal = radians - M_PI;
                } else {
                    newVal = M_PI + radians;
                }
                currentSection = s.section;
                break;
            }
        }
        // Otherwise...
        else if (radians > s.minValue && radians < s.maxValue) {
            newVal = radians - s.midValue;
            currentSection = s.section;
            break;
        }
    }
    // Animate the rotation of the dial to the center
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    CGAffineTransform t = CGAffineTransformRotate(rotatingView.transform, -newVal);
    rotatingView.transform = t;
    [UIView commitAnimations];
    [self.delegate dialDidChangeValue:[self positionForCurrentSection]];

    [self setSelectedImageForSection:currentSection];

}

#pragma mark - Helper Methods



- (float)calculateDistanceFromCenter:(CGPoint)point {
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float dx = point.x - center.x;
    float dy = point.y - center.y;
    return sqrt(dx*dx + dy*dy);
}


- (void) buildSectorsOdd {
    // What is the angle width of a section  in radians
    CGFloat fanWidth = M_PI *2 / numberOfSections;
    // The mid variable will store the middle point of rotation of the section
    CGFloat mid = 0;
    // Create a sector object for ever section of the dial that has the middle and side angle positions
    for (int i = 0; i < numberOfSections; i++) {
        FEDialControlSection *sector = [[FEDialControlSection alloc] init];
        sector.midValue = mid;
        sector.minValue = mid - (fanWidth/2);
        sector.maxValue = mid + (fanWidth/2);
        sector.section = i;
        mid -= fanWidth;
        if (sector.minValue < - M_PI) {
            mid = -mid;
            mid -= fanWidth;
        }
        [sections addObject:sector];
    }
}

- (void) buildSectorsEven {
    // What is the angle width of a section  in radians
    CGFloat fanWidth = M_PI*2/numberOfSections;
    // The mid variable will store the middle point of rotation of the section
    CGFloat mid = 0;
    // Create a sector object for ever section of the dial that has the middle and side angle positions
    for (int i = 0; i < numberOfSections; i++) {
        FEDialControlSection *sector = [[FEDialControlSection alloc] init];
        sector.midValue = mid;
        sector.minValue = mid - (fanWidth/2);
        sector.maxValue = mid + (fanWidth/2);
        sector.section = i;
        if (sector.maxValue-fanWidth < - M_PI) {
            mid = M_PI;
            sector.midValue = mid;
            sector.minValue = fabsf(sector.maxValue);
        }
        mid -= fanWidth;
        [sections addObject:sector];
    }
}

- (UIImageView *)getSectionByValue:(int)value {
    UIImageView *res;
    NSArray *views = [rotatingView subviews];
    for (UIImageView *im in views) {
        if (im.tag == value)
            res = im;
    }
    return res;
}


- (void)rotateDialToSection:(int)value {
    // Find the center angle in radians of the current position
    CGFloat radians = atan2f(rotatingView.transform.b, rotatingView.transform.a);
    
    // Grab the sector object of the specified section
    FEDialControlSection *s = [sections objectAtIndex:value];
    
    // Find the difference between the two angles
    CGFloat newVal = 0.0;
    // This condition can occur with an even number of sectors on the dial
    if (s.minValue > 0 && s.maxValue < 0) {
            // Wich side of the circle are we on?
            if (radians > 0) {
                newVal = radians - M_PI;
            } else {
                newVal = M_PI + radians;
            }
            currentSection = s.section;
        //}
    }
    // Otherwise...
    else  {
        newVal = radians - s.midValue;
        currentSection = s.section;
    }
    
    // Animate the movment of the dial from its current position to the specified section center
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    CGAffineTransform t = CGAffineTransformRotate(rotatingView.transform, -newVal);
    rotatingView.transform = t;
    [UIView commitAnimations];
    [self.delegate dialDidChangeValue:[self positionForCurrentSection]];
    
    [self setSelectedImageForSection:currentSection];
}

-(NSInteger)positionForCurrentSection {
    
    NSInteger pos;
    
    if (self.rotationalComponent == FEDialControlRotatingComponentDial) {
        pos = self.currentSection;
    } else {
        if (self.currentSection > 0)
            pos =  numberOfSections - self.currentSection;
        else
            pos = 0;
    }
    return pos;
}

//
//  Based on the specified homePosition, set the anchor point of the section view.
//  Basically think of it like this: If our home position (or marker) is at the top
//  of the dial, then we'll anchor the bottom of the supplied view to the center of the dial
//  and rotate from there.  If the home position is at the bottom, we'll anchor the top center
//  of the view to the center of the dial and likewise with left and right.
//
- (void)setHomePosition:(FEDialControlHomePosition)home forView:(UIView *)view {
    switch (home) {
        case FEDialControlHomePositionTop:
            view.layer.anchorPoint = CGPointMake(0.5f,1.0);
            break;
        case FEDialControlHomePositionBottom:
            view.layer.anchorPoint = CGPointMake(0.5f,0.0);
            break;
        case FEDialControlHomePositionLeft:
            view.layer.anchorPoint = CGPointMake(1.0f,0.5);
            break;
        case FEDialControlHomePositionRight:
            view.layer.anchorPoint = CGPointMake(0.0f,0.5);
            break;
    }
}

- (void)setSelectedImageForSection:(int)value {
    FEDialControlSection *s;
    
    // Hide all selected versions of the images
    for (s in self.sections) {
        s.view.hidden = NO;
        s.selectedView.hidden = YES;
    }
        
    if (value > -1) {
        // Swap the images for the specified section
        s = [self.sections objectAtIndex:value];
        s.view.hidden = YES;
        s.selectedView.hidden = NO;
    }
}


// This is the target of the center button (if enabled).  We just notify the delegate of a button press event.
- (void)buttonPressed {
    if ([self.delegate respondsToSelector:@selector(dialControl:buttonPressedForSection:)]) {
        [self.delegate dialControl:self buttonPressedForSection:currentSection];
    }
}


@end
