//
//  RotatingIndicatorDialViewController.m
//  DialControlProject
//
//  Created by Brad Eaton on 11/3/12.
//  Copyright (c) 2012 Brad Eaton. All rights reserved.
//

#import "RotatingIndicatorDialViewController.h"

#import "FEDialControl.h"

@interface RotatingIndicatorDialViewController ()

@end

@implementation RotatingIndicatorDialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Create the dial control
    dialControl = [[FEDialControl alloc] initWithFrame:CGRectMake(0,0,320,320) delegate:self homePosition:FEDialControlHomePositionTop centerOfRotation:CGPointMake(160, 160)];
    dialControl.center = CGPointMake(160,160);
    
    // Add it to the view
    [self.view addSubview:dialControl];
    //  In this version of the dial, we want the appearance that the dial is stationary and the indicator rotates.  This changes how the currently selected section is calculated.
    dialControl.rotationalComponent = FEDialControlRotatingComponentIndicator;

}

-(IBAction)setDialToPosition:(id)sender {
    [dialControl rotateDialToSection:[(UISegmentedControl *)sender selectedSegmentIndex]];
}

#pragma mark - RotaryWheel Delegate Methods

// Notifies the delegate when the value of the wheel has changed.  Also fires initially.
- (void)dialDidChangeValue:(NSInteger)newValue {
    self.statusLabel.text = [NSString stringWithFormat:@"dialDidChangeValue:%d",newValue];
}

// Obtains the number of sections in the wheel from the delegate
- (NSInteger)numberOfSectionsInDial:(FEDialControl *)rotaryWheel {
    return 8;
}

// Obtains the section image or icon for the specified section from the delegate
- (UIImage *) dialControl:(FEDialControl *)rotaryWheel imageForSection:(NSInteger)section {
    if (section == 0) {
        return [UIImage imageNamed:@"RotatingIndicator.png"];
    } else {
        return [[UIImage alloc] init];
    }
}

//// Obtains the selected section image or icon for the specified section from the delegate
//- (UIImage *) dialControl:(FEDialControl *)rotaryWheel imageForSelectedSection:(NSInteger)section {
//    return [UIImage imageNamed:[NSString stringWithFormat:@"SectionImageSelected%d.png",section+1]];
//}

// Obtains the non-rotating interface image of the wheel (behind all other views)
- (UIImage *) backgroundImageForDialControl:(FEDialControl *)rotaryWheel {
    return [UIImage imageNamed:@"RotatingIndicatorBackground.png"];
}

//// Obtains the non-rotating interface image of the wheel (in font of all other views)
//- (UIImage *)foregroundImageForDialControl:(FEDialControl *)rotaryWheel {
//    return [UIImage imageNamed:@"section_marker.png"];
//}

// Obtains the button up image
- (UIImage *)buttonImageForDialControl:(FEDialControl *)rotaryWheel {
    return [UIImage imageNamed:@"CenterButtonUp.png"];
}

// Obtains the button down image
- (UIImage *)buttonImageDepressedForDialControl:(FEDialControl *)rotaryWheel {
    return [UIImage imageNamed:@"CenterButtonDown.png"];
}

// The button was pressed
-(void) dialControl:(FEDialControl *)rotaryWheel buttonPressedForSection:(NSInteger)section {
    self.statusLabel.text = [NSString stringWithFormat:@"dialControl:buttonPressedForSection:%d", section];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
