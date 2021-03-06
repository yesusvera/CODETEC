//
//  ViewController.m
//  ExemploDownload
//
//  Created by Yesus Castillo Vera on 29/12/13.
//  Copyright (c) 2013 com.teste. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPRequestOperation.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startDownload:(id)sender{
    NSURL *url = [NSURL URLWithString:downloadField.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSString *saveFilename = [self downloadSavePathFor:url.lastPathComponent];
    
    NSLog(@"Salvando =o arquivo em %@", saveFilename);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:saveFilename append:NO];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op, NSHTTPURLResponse *response) {
        [loadingIndicator stopAnimating];
        loadingIndicator.hidden = YES;
        
        [self showMessage:@"Download finalizado com sucesso!"];
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
        [self showMessage:
         [NSString stringWithFormat:@"Error no download: %@", [error localizedDescription]]];
    }];
    
    
    [operation setDownloadProgressBlock:^(NSUInteger read, long long totalRead, long long totalExpected) {
        progressBar.progress = (float)totalRead / (float)totalExpected;
    }];
    
    progressBar.hidden = NO;
    loadingIndicator.hidden = NO;
    [loadingIndicator startAnimating];
    
    [operation start];
}

-(NSString *) downloadSavePathFor:(NSString *) filename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return [documentsPath stringByAppendingPathComponent:filename];
}

-(void) showMessage: (NSString *) message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"OK" , nil];
    
    [alert show];
}

@end
