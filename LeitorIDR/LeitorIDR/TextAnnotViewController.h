//
//  TextAnnotViewController.h
//  PDFViewer
//
//  Created by strong on 13-7-11.
//
//

#import <UIKit/UIKit.h>
@protocol saveTextAnnotDelegate <NSObject>

-(void)OnSaveTextAnnot :(NSString*)textAnnot;
@end


@interface TextAnnotViewController : UIViewController
{
    id<saveTextAnnotDelegate> m_delegate;
    UITextField* _textField;
    NSString* text;
}
@property(readwrite) int pos_x;
@property(readwrite) int pos_y;
@property(strong,nonatomic)NSString *text;


-(void)setDelegate:(id<saveTextAnnotDelegate>)delegate;
-(IBAction)cancelTextAnnot:(id)sender;

-(IBAction)saveTextAnnot:(id)sender;
@end
