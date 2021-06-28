//
//  TrailerViewController.m
//  Flix_App
//
//  Created by rutvims on 6/25/21.
//

#import "TrailerViewController.h"

@interface TrailerViewController()
@property(strong, nonatomic) NSString *videoURL;
@property (nonatomic, strong) NSArray *trailers;

@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchVideo];
}

-(void)fetchVideo{
    NSString *baseURLString = @"https://api.themoviedb.org/3/movie/";
    
    NSString *videoURLString = [NSString stringWithFormat:@"%d/%@", self.movie_id, @"videos?api_key=bc576bd97242828b55b4c70fc10e4f3a&language=en-US"];
    NSString *fullVideoURLString = [baseURLString stringByAppendingString:videoURLString];
    NSURL *videoURL = [NSURL URLWithString:fullVideoURLString];
    
    NSURL *url = videoURL;
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               self.trailers = dataDictionary[@"results"];
               NSDictionary *specific = self.trailers[self.trailers.count - 1];
               if(specific[@"key"] != [NSNull null]){
                   [self.playerView loadWithVideoId:specific[@"key"]];
               }
               
           }
       }];
    [task resume];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
