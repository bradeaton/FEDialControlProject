//
//  StandardDialViewController.h
//  DialControlProject
//
//  Created by Brad Eaton on 11/2/12.
//  Copyright (c) 2012 Brad Eaton. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FEDialControl;

@interface StandardDialViewController : UIViewController {
    FEDialControl *dialControl;
}

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)setDialToPosition:(id)sender;

@end
