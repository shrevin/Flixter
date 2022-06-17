//
//  MovieViewController.m
//  Flixter
//
//  Created by Shreya Vinjamuri on 6/15/22.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h" // Objective C has a powerful feature known as categories which is way you can add additional functions to an existing class you didn't even write (AFNetworking adds a few libraries to UIImageView)
#import "DetailsViewController.h"

// .m file is like a private class
@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> // this syntax means that this class implements the UITableViewDataSource and UITableViewDelegate protocol
// the UITableViewDataSource protocol shows the TableView content
// UITableViewDelegate protocol does not have mandatory methods, but gives you opportunity to do things when the table view scrolls, selects a cell...etc
// properties are member variables (they are typically in interface)
@property (nonatomic, strong) NSArray *myArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSArray *filteredData;
@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    // Setting the data source and delegate equal to the view controller
    self.tableView.dataSource = self; // says that table view is expecting a data source given to it by the view controller
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    [self fetchMovies];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    // [self.tableView addSubview:self.refreshControl];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.filteredData = self.myArray;

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
               // ALERT CONTROLLER
               UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies"
                                              message:@"The internet connection appears to be offline."
                                              preferredStyle:UIAlertControllerStyleAlert];
               UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                  handler:^(UIAlertAction * action) {}];
                
               [alert addAction:defaultAction];
               [self presentViewController:alert animated:YES completion:nil];
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               // TODO: Get the array of movies
//               NSArray*keys=[dataDictionary allKeys]; // getting all keys in data dictionary
               NSLog(@"%@", dataDictionary);// log an object with the %@ formatter.
//               // TODO: Store the movies in a property to use elsewhere
//               // self.myArray = dataDictionary[keys];
//               NSMutableArray *temp_array = [[NSMutableArray alloc]init];
//               for (int i = 0; i < [keys count]; i++) {
//                   [temp_array addObject:dataDictionary[keys[i]]];
//               }
//               self.myArray = temp_array;
               self.myArray = dataDictionary[@"results"];
               // TODO: Reload your table view data
               
               [self.activityIndicator stopAnimating];
               self.filteredData = self.myArray;
               [self.tableView reloadData];
               
           }
        [self.refreshControl endRefreshing];
       }];
    
    // 5. tells task that we have the code we need to get everything, so this will send the request
    [task resume];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"rows: %d", self.filteredData.count);
    return self.filteredData.count;
    
}

// what row to provide as you scroll in UITableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    // creating a UITableViewCell
//    UITableViewCell *cell = [[UITableViewCell alloc] init]; // alloc means "create me an instance of it", and init calls initializer
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    NSDictionary *movie = self.filteredData[indexPath.row]; // all the metadata of each movie
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterView.image = nil; // clearing out previous image before setting new one for a cleaner look
    [cell.posterView setImageWithURL:posterURL];
    
    // changing color when selecting cell
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor darkGrayColor]];
    bgColorView.layer.cornerRadius = 10;
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *movie, NSDictionary *bindings) {
            NSString *title = movie[@"title"];
            return [title containsString:searchText];
        }];
        
        self.filteredData = [self.myArray filteredArrayUsingPredicate:predicate];
        
        //NSLog(@"%@", self.filteredData);
        
    }
    else {
        self.filteredData = self.myArray;
    }
    
    [self.tableView reloadData];
 
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 
// sender refers to whatever view triggered the segue (in this case, the sender is the cell that triggered the segue)
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id) sender {
    UITableViewCell *cell = sender;
    NSIndexPath *myIndexPath = [self.tableView indexPathForCell:cell];
    NSDictionary *dataToPass = self.filteredData[myIndexPath.row];
    // Get the new view controller using [segue destinationViewController].
    // [segue destinationViewController] is a reference to the view controller that is going to be popped onto the navigation stack
    DetailsViewController *detailVC = [segue destinationViewController];
    // Pass the selected object to the new view controller.
    detailVC.detailDict = dataToPass;
    detailVC.myPath = myIndexPath;
   

    
    
}

@end
