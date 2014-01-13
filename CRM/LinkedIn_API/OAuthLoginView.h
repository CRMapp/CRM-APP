//
//  iPhone OAuth Starter Kit
//
//  Supported providers: LinkedIn (OAuth 1.0a)
//
//  Lee Whitney
//  http://whitneyland.com
//

#define kLinkedinAppKey @"fk606zx1ygxw"
#define kLinkedinSecretKey @"GEtITo1LLiKT9NMh"

#import <UIKit/UIKit.h>
#import "JSONKit.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OADataFetcher.h"
#import "OATokenManager.h"

@protocol OAuthLinkedinDelegate <NSObject>

- (void)linkedinResponse:(OAServiceTicket *)ticket didFinish:(NSDictionary *)result;
//- (void)linkedinResponse:(OAServiceTicket *)ticket didFail:(NSData *)error;

@end

@interface OAuthLoginView : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UITextField *addressBar;
    
    OAToken *requestToken;
    OAToken *accessToken;
    
    NSDictionary *profile;
    
    // Theses ivars could be made into a provider class
    // Then you could pass in different providers for Twitter, LinkedIn, etc
    NSString *apikey;
    NSString *secretkey;
    NSString *requestTokenURLString;
    NSURL *requestTokenURL;
    NSString *accessTokenURLString;
    NSURL *accessTokenURL;
    NSString *userLoginURLString;
    NSURL *userLoginURL;
    NSString *linkedInCallbackURL;
    OAConsumer *consumer;
}

@property (assign, nonatomic) id delegate;
@property(nonatomic, retain) OAToken *requestToken;
@property(nonatomic, retain) OAToken *accessToken;
@property(nonatomic, retain) NSDictionary *profile;

- (IBAction)btnCancel:(UIButton *)sender;
- (void)initLinkedInApi;
- (void)requestTokenFromProvider;
- (void)allowUserToLogin;
- (void)accessTokenFromProvider;
- (void)testApiCall;

@end
