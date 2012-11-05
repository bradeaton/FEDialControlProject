//
//  FEDialControlProtocol.h
//
//  Created by Brad Eaton on 10/21/12.
//  Copyright (c) 2012 Brad Eaton. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FEDialControl;

/** @discussion The delegate of an FEDialControl object must adopt the FEDialControlProtocol.  Through the protocol, the delegate will specify the number of sections in the dial and the graphics which will be used to display the dial's sections.  Optional methods allow the delegate to specify background and foreground images as well as images for an optional center button.
 
  */
@protocol FEDialControlProtocol <NSObject>

///---------------------------------------------------------------------------------------
/// @name Configuring the Dial
///---------------------------------------------------------------------------------------


/** Obtains the number of sections in the dial from the delegate
 
 @discussion The delegate should return the number of sections that will appear in the dial control.
 
 @param dialControl The dial control object requesting the number of sections.
 @return An NSInteger that specifies the number of sections in the dial.
 */
- (NSInteger)numberOfSectionsInDial:(FEDialControl *)dialControl;

/** Obtains the section image or icon for the specified section from the delegate
 
 @discussion The FEDialControl object will request a UIImage object for each section of the dial control.  The image returned should be oriented according to the homePosition parameter specified in the FEDialControl initializer.  _See the demo for examples of different home positions._

 @param dialControl The dial control object requesting the image.
 @param section The section for which the control is requesting the image.
 @return A UIImage object containing the regular image for the specified section.
 */
- (UIImage *) dialControl:(FEDialControl *)dialControl imageForSection:(NSInteger)section;

@optional

/** Obtains the selected version of the section image for the specified section from the delegate
 
 @discussion The FEDialControl object will request a UIImage object for each section of the dial control to be used as the selected image.  It will be displayed whenever the FEDialControlSection is in the home position.  The image returned should be oriented according to the homePosition parameter specified in the FEDialControl initializer.  _See the demo for examples of different home positions._
 
 @param dialControl The dial control object requesting the image.
 @param section The section for which the control is requesting the image.
 @return A UIImage object containing the selected image for the specified section.
 */
- (UIImage *) dialControl:(FEDialControl *)dialControl imageForSelectedSection:(NSInteger)section;

/** Obtains the non-rotating interface image of the dial (in font of all other views)
 
 @discussion The FEDialControl object will request a UIImage object to be used as the foreground image.  This is useful for dial images that have a complex design with stationary graphics that sit on top of the rotating dial.

 @param dialControl The dial control object requesting the image.
 @return A UIImage object containing the foreground image for the dial control.
 */
- (UIImage *)foregroundImageForDialControl:(FEDialControl *)dialControl;

/** Obtains the non-rotating interface image of the dial (behind all other views)
 
 @discussion The FEDialControl object will request a UIImage object to be used as the background image.  This is useful for dial images that have a complex design with stationary graphics that sit behind the rotating dial.  It should also be used in cases where the rotationalComponent is set to FEDialControlRotatingComponentIndicator to display the actual dial.
 
 @param dialControl The dial control object requesting the image.
 @return A UIImage object containing the background image for the dial control.
 */
- (UIImage *) backgroundImageForDialControl:(FEDialControl *)dialControl;

/** Obtains the button image for the center of the dial (optional)
 
 @discussion The FEDialControl object will request a UIImage object to be used to display a button located in the center of the dial.  
 
 @param dialControl The dial control object requesting the image.
 @return A UIImage object containing the up image for the center button.
 */
- (UIImage *) buttonImageForDialControl:(FEDialControl *)dialControl;

/** Obtains the depressed image for the center of the dial (optional)
 
 @discussion The FEDialControl object will request a UIImage object to be used to display the selected or depressed state of the button in the center of the dial.
 
 @param dialControl The dial control object requesting the image.
 @return A UIImage object containing the down or depressed image for the center button.
 */
- (UIImage *) buttonImageDepressedForDialControl:(FEDialControl *)dialControl;

///---------------------------------------------------------------------------------------
/// @name Managing User Interaction
///---------------------------------------------------------------------------------------

/** Notifies the delegate when the value of the dial has changed.  Also fires initially.
 
 @discussion The FEDialControl object will use this method to notify the delegate when the value of the dial has changed.  This method will be called after the user has rotated the dial and lifted their finger.
 
 @param newValue The new active section of the dial.
 */
- (void) dialDidChangeValue:(NSInteger)newValue;

/** Notify the delegate that the button was pressed
 
 @discussion The FEDialControl object will use this method to notify the delegate when the user has tapped the center button (if configured).
 
 @param dialControl The dial control object requesting the image.
 @param section The active section of the dial when the center button was pressed.
 */
-(void) dialControl:(FEDialControl *)dialControl buttonPressedForSection:(NSInteger)section;

@end
