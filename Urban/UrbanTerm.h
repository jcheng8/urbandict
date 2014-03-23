//
//  UrbanTerm.h
//  Urban
//
//  Created by Junsheng Cheng on 3/23/14.
//  Copyright (c) 2014 Junsheng Cheng. All rights reserved.
//

#import "JSONModel.h"

@protocol UrbanTerm
@end

@interface UrbanTerm : JSONModel

@property(nonatomic) long defid;
@property(nonatomic, strong) NSString *word;
@property(nonatomic, strong) NSString *author;
@property(nonatomic, strong) NSString *permalink;
@property(nonatomic, strong) NSString *definition;
@property(nonatomic, strong) NSString *example;
@property(nonatomic) int thumbs_up;
@property(nonatomic) int thumbs_down;
@property(nonatomic) NSString *current_vote;

@end
