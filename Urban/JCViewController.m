//
//  JCViewController.m
//  Urban
//
//  Created by Junsheng Cheng on 3/21/14.
//  Copyright (c) 2014 Junsheng Cheng. All rights reserved.
//

#import "JCViewController.h"

@interface JCViewController () <UITextFieldDelegate>
@property(nonatomic, strong) NSString *urbanEndpoint;

@property (weak, nonatomic) IBOutlet UITextField *searchTermField;
@property (weak, nonatomic) IBOutlet UITextView *searchResultField;
@property (weak, nonatomic) IBOutlet UILabel *thumbsUp;

@property (weak, nonatomic) IBOutlet UILabel *thumbsDn;
@end

@implementation JCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.searchTermField.delegate = self;

    self.searchResultField.text = @"";
    self.searchResultField.editable = NO;
    
    self.urbanEndpoint = @"http://api.urbandictionary.com/v0";
    self.thumbsUp.hidden = YES;
    self.thumbsDn.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchTermField resignFirstResponder];
    NSString *searchTerm = self.searchTermField.text;
    
    if (searchTerm.length > 0) {
        [self searchUrban:searchTerm];
    }
    return YES;
}

- (void)searchUrban:(NSString *)searchTerm {
    [self.searchTermField setEnabled:NO];

    NSString *resource = [NSString stringWithFormat:@"%@/define?term=%@", self.urbanEndpoint, searchTerm];
    NSURL *url = [NSURL URLWithString:[resource stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *data = (NSDictionary *)responseObject;
        
        BOOL foundDefinition = NO;
        
        if ([data objectForKey:@"list"]) {
            NSArray *entries = data[@"list"];
            if (entries.count > 0) {
                NSDictionary * entry = entries[0];
                if ([entry objectForKey:@"definition"]) {
                    self.searchResultField.text = entry[@"definition"];
                    foundDefinition = YES;
                }
               
                if ([entry objectForKey:@"example"]) {
                    self.searchResultField.text = [NSString stringWithFormat:@"%@ \n\n[Example]\n%@", self.searchResultField.text, entry[@"example"]];
                }
                
                if ([entry objectForKey:@"thumbs_up"]) {
                    self.thumbsUp.hidden = NO;
                    self.thumbsUp.text = [NSString stringWithFormat:@"%@", entry[@"thumbs_up"]];
                }
                
                if ([entry objectForKey:@"thumbs_down"]) {
                    self.thumbsDn.hidden = NO;
                    self.thumbsDn.text = [NSString stringWithFormat:@"%@", entry[@"thumbs_down"]];
                }
            }
        }
        
        if (!foundDefinition) {
            self.searchResultField.text = @"";
            self.thumbsUp.hidden = YES;
            self.thumbsDn.hidden = YES;
        }
        
        [self.searchTermField setEnabled:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.searchResultField.text = @"";
        self.thumbsUp.text = @"up";
        self.thumbsDn.text = @"dn";
        
        [self.searchTermField setEnabled:YES];
    }];
    
    [operation start];
}
@end
