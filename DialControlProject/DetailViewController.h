//
//  DetailViewController.h
//  DialControlProject
//
//  Created by Brad Eaton on 11/2/12.
//  Copyright (c) 2012 Brad Eaton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
