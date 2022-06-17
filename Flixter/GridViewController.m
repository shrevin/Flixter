//
//  GridViewController.m
//  Flixter
//
//  Created by Shreya Vinjamuri on 6/16/22.
//

#import "GridViewController.h"
#import "CollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h""

@interface GridViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray *myArray;
@property (strong, nonatomic) IBOutlet UIView *gridView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    // Do any additional setup after loading the view.
    [self fetchMovies];
    
}

- (void)fetchMovies {
    
    // 1. Create URL
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=9d44e7197700f244d88a956e57d35776"];
    
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
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               // TODO: Get the array of movies
//               NSArray*keys=[dataDictionary allKeys]; // getting all keys in data dictionary
               NSLog(@"%@", dataDictionary);// log an object with the %@ formatter.
//             // TODO: Store the movies in a property to use elsewhere
               self.myArray = dataDictionary[@"results"];
               // TODO: Reload your collection view data
               [self.collectionView reloadData];
              
           }
       }];
    
    // 5. tells task that we have the code we need to get everything, so this will send the request
    [task resume];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.myArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    NSDictionary *movie = self.myArray[indexPath.row]; // all the metadata of each movie
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [cell.posterView setImageWithURL:posterURL];
   // [cell.posterView :posterURL];
    return cell;
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UICollectionViewCell *cell = sender;
    NSIndexPath *myIndexPath = [self.collectionView indexPathForCell:cell];
    NSDictionary *dataToPass = self.myArray[myIndexPath.row];
    // Get the new view controller using [segue destinationViewController].
    // [segue destinationViewController] is a reference to the view controller that is going to be popped onto the navigation stack
    DetailsViewController *detailVC = [segue destinationViewController];
    // Pass the selected object to the new view controller.
    detailVC.detailDict = dataToPass;
    detailVC.myPath = myIndexPath;
}


@end
