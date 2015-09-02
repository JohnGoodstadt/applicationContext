//
//  InterfaceController.m
//  appC WatchKit Extension
//
//  Created by john on 31/08/2015.
//  Copyright © 2015 john goodstadt. All rights reserved.
//

#import "InterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface InterfaceController() <WCSessionDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *replyLabel;
@property (assign) int counter;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    
    if(WCSession.isSupported){
        WCSession* session = WCSession.defaultSession;
        session.delegate = self;
        [session activateSession];
        
    }
    
    self.counter = 1;
    [self setTitle:[NSString stringWithFormat:@"%i",_counter]];
}

/**
 Uses given Dictionary to send and handle its reply and any errors.
 
 @param request message that is sent to the counterpart device - keyword, value.
 
 @return void
 */

-(void)packageAndSendMessage:(NSDictionary*)request
{
    if(WCSession.isSupported){
        
        
        WCSession* session = WCSession.defaultSession;
        session.delegate = self;
        [session activateSession];
        
        if(session.reachable)
        {
            
            
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
        else
        {
            [self.replyLabel setText:@"Session Not reachable"];
        }
        
    }
    else
    {
        [self.replyLabel setText:@"Session Not Supported"];
    }
    
    
    
    
    
}
- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *, id> *)applicationContext{
    
    
    if(applicationContext){
        
        NSString* command = [applicationContext objectForKey:@"request"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.replyLabel setText:command];
        });
        
      
    }
    
    
}
/**
 Standard WatchKit delegate
 */
-(void)sessionWatchStateDidChange:(nonnull WCSession *)session
{
    if(WCSession.isSupported){
        WCSession* session = WCSession.defaultSession;
        session.delegate = self;
        [session activateSession];
        
    }
}
#pragma mark Button Actions
- (IBAction)sendMessageButtonPressed {
    
    [self.replyLabel setText:@"Sending..."];
    
    self.counter++;
    [self setTitle:[NSString stringWithFormat:@"%i",_counter]];
    
    NSDictionary* message = @{@"request":[NSString stringWithFormat:@"Message %d from the Phone",self.counter] ,@"counter":[NSString stringWithFormat:@"%d",self.counter]};
    
    //Send message
    [self packageAndSendMessage:message];
    
}
- (IBAction)yesButtonPressed {
    
    [self.replyLabel setText:@"Sending Yes..."];
    
    self.counter++;
    [self setTitle:[NSString stringWithFormat:@"%i",_counter]];
    
     //Build message and send
    [self packageAndSendMessage:@{@"request":@"Yes",@"counter":[NSString stringWithFormat:@"%i",_counter]}];
    
}
- (IBAction)noButtonPressed {
    
    [self.replyLabel setText:@"Sending No..."];
    
    self.counter++;
    [self setTitle:[NSString stringWithFormat:@"%i",_counter]];
    
     //Build message and send
    [self packageAndSendMessage:@{@"request":@"No",@"counter":[NSString stringWithFormat:@"%i",_counter]}];
}


@end



