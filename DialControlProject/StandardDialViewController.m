//
//  StandardDialViewController.m
//  DialControlProject
//
//  Created by Brad Eaton on 11/2/12.
//  Copyright (c) 2012 Brad Eaton. All rights reserved.
//

#import "StandardDialViewController.h"
#import "FEDialControl.h"

@interface StandardDialViewController ()
    
@end

@implementation StandardDialViewController

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
    // This is the default... but we're saying that the dial its self turns rather than the indicator.  This really only effects how currentSection is reported.
    dialControl.rotationalComponent = FEDialControlRotatingComponentDial;
    
}

-(IBAction)setDialToPosition:(id)sender {
    [dialControl rotateDialToSection:[(UISegmentedControl *)sender selectedSegmentIndex]];
}

#pragma mark - RotaryWheel Delegate Methods

// Notifies the delegate when the value of the wheel has changed.  Also fires initially.
- (void)dialDidChangeValue:(NSInteger)newValue {
    self.statusLabel.text = [NSString stringWithFormat:@"Dial Position: %d",newValue];
}

// Obtains the number of sections in the wheel from the delegate
- (NSInteger)numberOfSectionsInDial:(FEDialControl *)rotaryWheel {
    return 8;
}

// Obtains the section image or icon for the specified section from the delegate
- (UIImage *) dialControl:(FEDialControl *)rotaryWheel imageForSection:(NSInteger)section {
    return [UIImage imageNamed:[NSString stringWithFormat:@"SectionImage%d.png",section+1]];
}

// Obtains the selected section image or icon for the specified section from the delegate
- (UIImage *) dialControl:(FEDialControl *)rotaryWheel imageForSelectedSection:(NSInteger)section {
    return [UIImage imageNamed:[NSString stringWithFormat:@"SectionImageSelected%d.png",section+1]];
}

// Obtains the non-rotating interface image of the wheel (behind all other views)
- (UIImage *) backgroundImageForDialControl:(FEDialControl *)rotaryWheel {
    return [UIImage imageNamed:@"Background.png"];
}

// Obtains the non-rotating interface image of the wheel (in font of all other views)
- (UIImage *)foregroundImageForDialControl:(FEDialControl *)rotaryWheel {
    return [UIImage imageNamed:@"section_marker.png"];
}

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
    self.statusLabel.text = [NSString stringWithFormat:@"Button Press:%d", section];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
