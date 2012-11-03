//
//  FEDialControl.h
//
//  Created by Brad Eaton on 10/21/12.
//  Copyright (c) 2012 Brad Eaton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FEDialControlProtocol.h"
#import "FEDialControlSection.h"

typedef enum _FEDialControlRotatingComponent {
    FEDialControlRotatingComponentDial = 0,
    FEDialControlRotatingComponentIndicator = 1
} FERotatingComponent;

typedef enum _SMHomePosition {
    FEDialControlHomePositionTop = 0,
    FEDialControlHomePositionBottom = 1,
    FEDialControlHomePositionLeft = 2,
    FEDialControlHomePositionRight = 3
} FEDialControlHomePosition;


@interface FEDialControl : UIControl {
    CGFloat startAngle;
    UIView *rotatingView;
    CGAffineTransform startTransform;
    CGPoint centerOfRotation;
    FEDialControlHomePosition homePosition;
}

@property (weak) id <FEDialControlProtocol> delegate;
@property (readonly) NSInteger numberOfSections;
// This is a public property so that there is access to the regular and selected UIImageView instances for each of the dial sections.
@property (nonatomic, strong) NSMutableArray *sections;
@property (readonly) NSInteger currentSection;
@property FERotatingComponent rotationalComponent;
// This is a public property so that there is access to the button its self and it's various image properites that could be changed at runtime.
@property (nonatomic, strong) UIButton *centerButton;

// Initializer
- (id) initWithFrame:(CGRect)frame delegate:(id)del homePosition:(FEDialControlHomePosition)home centerOfRotation:(CGPoint)center;

// Sets the dial to a specific section and animates the rotation to it.
- (void)rotateDialToSection:(int)value;

@end
 