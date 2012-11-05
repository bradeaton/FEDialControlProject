//
//  FEDialControlSection.h
//
//  Created by Brad Eaton on 10/21/12.
//  Copyright (c) 2012 Brad Eaton. All rights reserved.
//

#import <Foundation/Foundation.h>
/** @discussion Represents a single section in the rotating dial of a FEDialControl object.
 */
@interface FEDialControlSection : NSObject

///---------------------------------------------------------------------------------------
/// @name Position of Section on Dial Control
///---------------------------------------------------------------------------------------

/** The section number (0 based) of this section.  These are numbered clockwise from the FEDialControlHomePosition.
 */
@property int section;

/** The angle in radians of the left edge of this pie section on the dial.
 */
@property float minValue;

/** The angle in radians of the right edge of this pie section on the dial.
 */
@property float maxValue;

/** The angle in radians of the center edge of this pie section on the dial. (Its mid-point)
 */
@property float midValue;

///---------------------------------------------------------------------------------------
/// @name Section Appearance
///---------------------------------------------------------------------------------------

/** The UIImageView object that was passed to the dialControl:imageForSection: delegate method.
 */
@property UIImageView *view;

/** The UIImageView object that was passed to the dialControl:imageForSelectedSection: delegate method.
 */
@property UIImageView *selectedView;


@end
