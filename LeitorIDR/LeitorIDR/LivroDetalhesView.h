//
//  LivroDetalhesView.h
//  LeitorIDR
//
//  Created by Yesus Castillo Vera on 25/02/14.
//  Copyright (c) 2014 Yesus Castillo Vera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LivroResponse.h"

@interface LivroDetalhesView : UIViewController{
    IBOutlet UITextField *downloadField;
    IBOutlet UIProgressView *progressBar;
    IBOutlet UIActivityIndicatorView *loadingIndicator;
    IBOutlet UILabel *tituloLivro;
    LivroResponse *livroResponse;
}

-(IBAction)startDownload:(id)sender;
@property (nonatomic, retain) LivroResponse *livroResponse;
@property (nonatomic, retain) UILabel *tituloLivro;

@end
