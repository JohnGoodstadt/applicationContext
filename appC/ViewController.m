//
//  ViewController.m
//  appC
//
//  Created by john on 31/08/2015.
//  Copyright © 2015 john goodstadt. All rights reserved.
//

#import "ViewController.h"

#import <WatchConnectivity/WatchConnectivity.h>

@interface ViewController () <WCSessionDelegate>

@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UILabel *counterLabel;
@property (assign) int counter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if(WCSession.isSupported){
        WCSession* session = WCSession.defaultSession;
        session.delegate = self;
        [session activateSession];
        
    }
    
    
    self.counter = 1;
    self.counterLabel.text = [NSString stringWithFormat:@"%i",_counter];
    
}
/**
 Uses given Dictionary to send and handle its reply and any errors.
 
 @param request message that is sent to the counterpart device - keyword, value.
 
 @return void
 */

-(void)packageAndSendMessage:(NSDictionary*)request
{
    
    //[request setObject:[NSDate date] forKey:@"dateSent"];
    
    
    if(WCSession.isSupported){
        
        if(WCSession.isSupported){
            WCSession* session = WCSession.defaultSession;
            session.delegate = self;
            [session activateSession];
            
            
            
            
            
            if(session.reachable){
                
                NSError *error = nil;
                
                
                /*
                 Discussion
                 Use this method to transfer a dictionary of data items to the counterpart app. The system sends context data when the opportunity arises, with the goal of having the data ready to use by the time the counterpart wakes up. The counterpart’s session delivers the data to the session:didReceiveUpdate: method of its delegate. A counterpart can also retrieve the data from the receivedApplicationContext property of its session.
                 
                 This method replaces the previous dictionary that was set, so you should use this method to communicate state changes or to deliver data that is updated frequently anyway. For example, this method is well suited for updating your app’s glance.
                 
                 You may call this method when the counterpart is not currently reachable.
                 
                 */
                
                //reply will come in didReceiveApplicationContext
                [session updateApplicationContext:request error:&error]; //send message to Phone
                
                if(error){
                    NSLog(@"%@",error.localizedDescription);
                }
                
            }
            else{
                [self.replyLabel setText:@"Session is not reachable"];
            }
            
        }
        
        
    }
    else
    {
        [self.replyLabel setText:@"Session is not supported"];
    }
    
    
    
    
    
}
/*
 Called when the session receives context data from the counterpart.
 The session uses this method to deliver the last known context data from its counterpart—that is, data sent by the counterpart using the updateAppContext:error: method of its own session object. If context data is already waiting to be delivered, this method is called shortly after you activate the session object for the current process.
 Use context data to get a head start on updating your app’s user interface. A counterpart can send context data representing the last known state information. For example, a mail program running on iOS might include data from the five most recently received email messages in the appContext dictionary. A WatchKit extension would then replace any stale data with the new information.
 A context update is not necessarily a replacement for other types of messaging. It is intended to help a newly launched app display recent data more quickly than it could if it had to query its counterpart first. You should still use other forms of messaging to retrieve a more complete set of data as needed.
 You must implement this method if your app receives context updates.
 */
- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *, id> *)applicationContext{
    
    
    if(applicationContext){
        
        NSString* command = [applicationContext objectForKey:@"request"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.replyLabel setText:command];
        });
              
        
        
    }
    
    
}

#pragma mark Button Actions
- (IBAction)SendMessageButtonPressed:(id)sender {
    
    [self.replyLabel setText:@"Sending..."];
    
    
    
    NSDictionary* message = @{@"request":[NSString stringWithFormat:@"Message %d from the Phone",self.counter] ,@"counter":[NSString stringWithFormat:@"%d",self.counter]};
    
    self.counter++;
    self.counterLabel.text = [NSString stringWithFormat:@"%i",_counter];
    
    [self packageAndSendMessage:message];
    
}
- (IBAction)yesButtonPressed:(id)sender {
    
    [self.replyLabel setText:@"Sending Yes..."];
    
    self.counter++;
    self.counterLabel.text = [NSString stringWithFormat:@"%i",_counter];
    
    
    [self packageAndSendMessage:@{@"request":@"Yes",@"counter":[NSString stringWithFormat:@"%i",_counter]}];
}
- (IBAction)noButtonPressed:(id)sender {
    
    [self.replyLabel setText:@"Sending No..."];
    
    self.counter++;
    self.counterLabel.text = [NSString stringWithFormat:@"%i",_counter];
    
    
    [self packageAndSendMessage:@{@"request":@"No",@"counter":[NSString stringWithFormat:@"%i",_counter]}];
}

@end

