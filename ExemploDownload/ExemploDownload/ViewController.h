//
//  ViewController.h
//  ExemploDownload
//
//  Created by Yesus Castillo Vera on 29/12/13.
//  Copyright (c) 2013 com.teste. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    IBOutlet UITextField *downloadField;
    IBOutlet UIProgressView *progressBar;
    IBOutlet UIActivityIndicatorView *loadingIndicator;
}

-(IBAction)startDownload:(id)sender;

@end
