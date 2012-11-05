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

typedef enum _FEDialControlHomePosition {
    FEDialControlHomePositionTop = 0,
    FEDialControlHomePositionBottom = 1,
    FEDialControlHomePositionLeft = 2,
    FEDialControlHomePositionRight = 3
} FEDialControlHomePosition;

/** @discussion Presents a rotating dial control allowing the user to make a selection by rotating the dial to the desired section.

Custom images are provided for each FEDialControlSection of the dial via a FEDialControlProtocol method.  The FEDialControlProtocol informs the delegate when the current dial selection has changed.  In addition, an optional center button may be configured.  The delegate is notified when the button is pressed and which FEDialControlSection was active at the time.
 */
@interface FEDialControl : UIControl {
    CGFloat startAngle;
    UIView *rotatingView;
    CGAffineTransform startTransform;
    CGPoint centerOfRotation;
    FEDialControlHomePosition homePosition;
}

///---------------------------------------------------------------------------------------
/// @name Creating and Initializing Dial Controls
///---------------------------------------------------------------------------------------

/** Returns an initalized FEDialControl object given a frame, homePosition and centerOfRotation.
 
 @param frame The frame rectangle for the view, measured in points.  The origin of the frame is relative to the superview in which you plan to add it.
 @param del An object adopting the FEDialControlProtocol.
 @param home The FEDialControlHomePosition to be used for this dial.
 This enum indicates which cardinal position on the dial is considered the home position.  The position specified will dictate the orentation FEDialContol expects the section images to be in.  For example, a homePosition of FEDialControlHomePositionTop would assume that each image for each section of the dial was oriented as if it were positioned at the top of the dial.
 @param center The CGPoint specifying the point within the FEDialContol frame with which to rotate all the sections.  Depening on your background and foreground images, the center of rotation may or may not be equal to the center of the frame.
 */
- (id) initWithFrame:(CGRect)frame delegate:(id)del homePosition:(FEDialControlHomePosition)home centerOfRotation:(CGPoint)center;

///---------------------------------------------------------------------------------------
/// @name Configuring the Dial Control Rotation Mode
///---------------------------------------------------------------------------------------

/** Sets or returns whether the dial or the indicator should rotate.
 
 @discussion This property allows the FEDialControl to be configured for either the dial face to rotate or an indicator to rotate.  It only affects how the currentSection number is calculated.
 
 - FEDialControlRotatingComponentDial, This is the default value and indicates that the the images supplied by the dialControl:ImageForSection and dialControl:ImageForSelectedSection: methods of the FEDialControlProtocol will be used as the dial face which will rotate around the center of the FEDialControl.
 - FEDialControlRotatingComponentIndicator, This indicates that the graphics supplied to dialControl:ImageForSection and dialControl:ImageForSelectedSection: will be assumed to be markers or indicators rotating over the top of the background graphic which contains the actual section images.
 
 What's the difference you ask?  Only the way the currentSection is calculated.  With the former, the currentSection is considered which ever FEDialControlSection is located in the homePosition.  With the latter, the currentSection is whichever background position the FEDialControlSection(0) is positioned over.  _See the demo for an example of each._
 
 */
@property FERotatingComponent rotationalComponent;

///---------------------------------------------------------------------------------------
/// @name Defining the Delegate
///---------------------------------------------------------------------------------------

/** Defines the class responsible for implementing the delegate protocol. 
 
 @discussion Implementing this protocol is required.  Its methods obtain the number of sections in the grid and images used for the background, dial sections, foreground and center button.  In addition, methods also notify the delegate when the dial's selected section changes and when the center button has been tapped.
 */
@property (weak) id <FEDialControlProtocol> delegate;

///---------------------------------------------------------------------------------------
/// @name Working With Dial Sections
///---------------------------------------------------------------------------------------

/** Returns the number of sections in the dial control.
 
 @discussion Readonly property returns the number of sections in the dial control.  This property is set by the numberOfSectionsInDial method of the FEDialControlProtocol.
 */
@property (readonly) NSInteger numberOfSections;

/** Array of FEDialControlSection objects.
 
 @discussion Provides access to the FEDialControlSection objects that contain the provided regular and selected UIView instances for each section of the dial.
 */
@property (nonatomic, strong) NSMutableArray *sections;

/** Currently selected section of dial. */
@property (readonly) NSInteger currentSection;

///---------------------------------------------------------------------------------------
/// @name Accessing the Center Button Object
///---------------------------------------------------------------------------------------

/** UIButton control (if supplied) in the center of the dial.
 
 @discussion Returns or sets the UIButton control configured in the center of the dial.  This could be used to change the button graphics depending on the current section of the dial.
 */
@property (nonatomic, strong) UIButton *centerButton;

///---------------------------------------------------------------------------------------
/// @name Programatically Setting The Dial Control Position
///---------------------------------------------------------------------------------------

/** Sets the dial to a specific section and animates the rotation to it.
 
 @param value An NSInteger between 0 and numberOfSections -1 indicating the section of the dial to rotate to the homePosition (or in case of FEDialControlRotatingComponentIndicator, the section to rotate the indicator to).
 */
- (void)rotateDialToSection:(int)value;


@end
 