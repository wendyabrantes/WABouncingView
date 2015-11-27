//
//  ViewController.m
//  WABouncingMenuExample
//
//  Created by Wendy Abrantes on 26/11/2015.
//  Copyright © 2015 Wendy Abrantes. All rights reserved.
//

#import "ViewController.h"
#import "WABouncingView.h"

@interface ViewController ()
{
    WABouncingView *bcView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    bcView = [[WABouncingView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200)
                                   circleMenuFrame:CGRectMake(self.view.frame.size.width - 75,
                                                              200 - 75,
                                                              55,
                                                              55)];

    [self.view addSubview:bcView];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
