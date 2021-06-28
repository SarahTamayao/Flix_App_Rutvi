//
//  DetailsViewController.m
//  Flix_App
//
//  Created by rutvims on 6/23/21.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TrailerViewController.h"
#import "MovieCollectionCell.h"

@interface DetailsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (nonatomic, strong) NSArray *similar_movies;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //to load poster
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [self.posterView setImageWithURL:posterURL];
    //to load backdrop
    if(self.movie[@"backdrop_path"] != [NSNull null]){
        NSString *backdropURLString = self.movie[@"backdrop_path"];
        NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
        
        NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
        [self.backdropView setImageWithURL:backdropURL];
    }
    
    //rest of the properties
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    self.ratingLabel.text = [NSString stringWithFormat:@"%@/%@", self.movie[@"vote_average"], @"10"];
    
    //fix style
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
    [self.ratingLabel sizeToFit];
    
    
    [self fetchSimilarMovies];
}

-(void) fetchSimilarMovies{
    NSString *baseURLString = @"https://api.themoviedb.org/3/movie/";
    
    NSString *videoURLString = [NSString stringWithFormat:@"%@/%@", self.movie[@"id"], @"similar?api_key=bc576bd97242828b55b4c70fc10e4f3a&language=en-US&page=1"];
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
           NSLog(@"%@", dataDictionary);

           self.similar_movies = dataDictionary[@"results"];
           [self.collectionView reloadData];
       }
    }];
    [task resume];
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    NSDictionary *similar_movie = self.similar_movies[indexPath.item];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    
    NSString *posterURLString = similar_movie[@"poster_path"];

    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    NSLog(@"%@", posterURL);
    if(posterURL != NULL){
        cell.posterView.image = nil;
        [cell.posterView setImageWithURL:posterURL];
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.similar_movies.count;
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TrailerViewController *trailerViewController = [segue destinationViewController];
    NSString *id = [NSString stringWithFormat:@"%@", self.movie[@"id"]];
    
    trailerViewController.movie_id = [id integerValue];
}

@end
