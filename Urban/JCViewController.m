//
//  JCViewController.m
//  Urban
//
//  Created by Junsheng Cheng on 3/21/14.
//  Copyright (c) 2014 Junsheng Cheng. All rights reserved.
//

#import "JCViewController.h"
#import "UrbanData.h"

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
    self.searchResultField.scrollEnabled = YES;
    
    self.urbanEndpoint = @"http://api.urbandictionary.com/v0/";
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

    NSURL *baseUrl = [NSURL URLWithString:self.urbanEndpoint];
    NSDictionary *parameters = @{@"term" : searchTerm};
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:@"define" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        self.searchTermField.enabled = YES;
        
        NSDictionary *jsonData = (NSDictionary *)responseObject;
        NSError *err = nil;
        UrbanData * data = [[UrbanData alloc] initWithDictionary:jsonData error:&err];
        
        if (!err && data.list.count > 0) {
            UrbanTerm *term = [data.list firstObject];
            
            NSString *text = [NSString stringWithFormat:@"%@ \n\n[Example]\n%@",
                                     term.definition,term.example];
            NSMutableAttributedString *searchResult = [[NSMutableAttributedString alloc] initWithString:text];
            [searchResult addAttribute:NSFontAttributeName
                                value:[UIFont systemFontOfSize:14]
                                range:NSMakeRange(0, text.length)];
            
            [self.searchResultField setAttributedText:searchResult];
            
            self.thumbsUp.hidden = self.thumbsDn.hidden = NO;
            
            self.thumbsUp.text = [NSString stringWithFormat:@"%d", term.thumbs_up];
            self.thumbsDn.text = [NSString stringWithFormat:@"%d", term.thumbs_down];
        }
        else {
            NSMutableAttributedString *feedback = [[NSMutableAttributedString alloc] initWithString:@"Opps, not found :("];
            [feedback addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:24]
                            range:NSMakeRange(0, feedback.length)];
            
            [feedback addAttribute:NSForegroundColorAttributeName
                             value:[UIColor redColor]
                             range: NSMakeRange(0, feedback.length)];
            
            [self.searchResultField setAttributedText:feedback];
            self.thumbsUp.hidden = YES;
            self.thumbsDn.hidden = YES;
        }
        

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.searchTermField.enabled = YES;
        self.searchResultField.text = @"";
        
        self.thumbsUp.hidden = YES;
        self.thumbsDn.hidden = YES;
    }];
}
@end
