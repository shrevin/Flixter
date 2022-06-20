//
//  YoutubeViewController.m
//  Flixter
//
//  Created by Shreya Vinjamuri on 6/19/22.
//

#import "YoutubeViewController.h"

@interface YoutubeViewController ()
@property (strong, nonatomic) IBOutlet UIView *myView;
@property (strong, nonatomic) NSString *video_id;
@end

@implementation YoutubeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self.playerView loadWithVideoId:@"M7lc1UVf-VE"];
    [self fetchVideos];
    // NSLog(self.video_id);
    // [self.playerView loadWithVideoId:@"0nfm4jR3Zzw"];
    //[self.playerView loadWithVideoId:self.video_id playerVars:playerVars];
}

- (IBAction)playVideo:(id)sender {
  [self.playerView playVideo];
}

- (IBAction)stopVideo:(id)sender {
  [self.playerView stopVideo];
}

- (void) fetchVideos {
    
    // 1. Create URL
    NSString *first_part = @"https://api.themoviedb.org/3/movie/";
    NSString *second_part = @"/videos?api_key=9d44e7197700f244d88a956e57d35776&language=en-US";
    NSString *id_part = [NSString stringWithFormat:@"%@", self.movie_id];
    NSString *partURL = [first_part stringByAppendingString:id_part];
    NSString *fullURL = [partURL stringByAppendingString:second_part];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSLog(fullURL);
    
    // 2. Create Request
    // request object will use our URL info and generate a request object
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    // 3. Create Session
    // creating a NSURLSession
    // the delegateQueue: alert us on main thread that we got our information back
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    // 4. Create Session task --> we will pass it the request that we created
    // completion handler is code we are going to execute when we get a response
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           } else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               // TODO: Get the array of movies
//               NSArray*keys=[dataDictionary allKeys]; // getting all keys in data dictionary
               // NSLog(@"%@", dataDictionary);// log an object with the %@ formatter.
//               // TODO: Store the movies in a property to use elsewhere
//               // self.myArray = dataDictionary[keys];
//               NSMutableArray *temp_array = [[NSMutableArray alloc]init];
//               for (int i = 0; i < [keys count]; i++) {
//                   [temp_array addObject:dataDictionary[keys[i]]];
//               }
//               self.myArray = temp_array;
               self.video_id = dataDictionary[@"results"][0][@"key"];
               // TODO: Reload your table view data
//               [self.myView reloadInputViews];
               // NSLog(self.video_id);
               NSDictionary *playerVars = @{
                 @"playsinline" : @1,
               };
               [self.playerView loadWithVideoId:self.video_id playerVars:playerVars];
           }
       }];
    
    // 5. tells task that we have the code we need to get everything, so this will send the request
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
