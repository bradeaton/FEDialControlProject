//
//  FEDialControlSection.m
//
//  Created by Brad Eaton on 10/21/12.
//  Copyright (c) 2012 Brad Eaton. All rights reserved.
//

#import "FEDialControlSection.h"

@implementation FEDialControlSection

@synthesize section, view, selectedView, minValue, maxValue, midValue;

-(NSString *) description {
    return [NSString stringWithFormat:@"%i | %f, %f, %f", self.section, self.minValue, self.midValue, self.maxValue];
    
}

@end
