//
//  FEDialControlProtocol.h
//
//  Created by Brad Eaton on 10/21/12.
//  Copyright (c) 2012 Brad Eaton. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FEDialControl;

@protocol FEDialControlProtocol <NSObject>

// Notifies the delegate when the value of the dial has changed.  Also fires initially.
- (void) dialDidChangeValue:(NSInteger)newValue;

// Obtains the number of sections in the dial from the delegate
- (NSInteger)numberOfSectionsInDial:(FEDialControl *)dialControl;

// Obtains the section image or icon for the specified section from the delegate
- (UIImage *) dialControl:(FEDialControl *)dialControl imageForSection:(NSInteger)section;

@optional

// Obtains the selected version of the section image for the specified section from the delegate
- (UIImage *) dialControl:(FEDialControl *)dialControl imageForSelectedSection:(NSInteger)section;

// Obtains the non-rotating interface image of the dial (in font of all other views)
- (UIImage *)foregroundImageForDialControl:(FEDialControl *)dialControl;

// Obtains the non-rotating interface image of the dial (behind all other views)
- (UIImage *) backgroundImageForDialControl:(FEDialControl *)dialControl;

// Obtains the button image for the center of the dial (optional)
- (UIImage *) buttonImageForDialControl:(FEDialControl *)dialControl;

// Obtains the depressed image for the center of the dial (optional)
- (UIImage *) buttonImageDepressedForDialControl:(FEDialControl *)dialControl;

// Notify the delegate that the button was pressed
-(void) dialControl:(FEDialControl *)dialControl buttonPressedForSection:(NSInteger)section;

@end
