//
//  RotatingIndicatorDialViewController.h
//  DialControlProject
//
//  Created by Brad Eaton on 11/3/12.
//  Copyright (c) 2012 Brad Eaton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FEDialControl;

@interface RotatingIndicatorDialViewController : UIViewController {
    FEDialControl *dialControl;
}

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)setDialToPosition:(id)sender;

@end
