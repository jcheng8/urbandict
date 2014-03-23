//
//  UrbanData.h
//  Urban
//
//  Created by Junsheng Cheng on 3/23/14.
//  Copyright (c) 2014 Junsheng Cheng. All rights reserved.
//

#import "JSONModel.h"
#import "UrbanTerm.h"

@interface UrbanData : JSONModel

@property (nonatomic)         NSArray *tags;
@property (nonatomic, strong) NSString *result_type;
@property (nonatomic, strong) NSArray <UrbanTerm> *list;
@property (nonatomic, strong) NSArray *sounds;

@end
