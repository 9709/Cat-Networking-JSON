//
//  ViewController.m
//  Cats-Networking-JSON
//
//  Created by Matthew Chan on 2019-01-24.
//  Copyright © 2019 Matthew Chan. All rights reserved.
//

#import "ViewController.h"
#import "MyCollectionViewCell.h"
#import "Photo.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (nonatomic, strong) NSMutableArray *photoArray;

@end




@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myCollectionView.dataSource = self;
    self.myCollectionView.delegate = self;
    [self fetchingCatData];
    self.photoArray = [[NSMutableArray alloc] init];
}
// ===============================================================================================

- (void)fetchingCatData
{
    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=4989a89d1627dca94ec3ebf58ab06685&tags=cat"];
    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if (error)
        {
            NSLog(@"ERROR: %@", error);
            return;
        }
        
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError)
        {
            NSLog(@"ERROR: %@", jsonError);
            return;
        }
        
        NSDictionary *catsDict = json[@"photos"];
        NSArray *catsArray = catsDict[@"photo"];
        
        for (NSDictionary *photoDict in catsArray) {
            Photo *photo = [[Photo alloc] initWithPhotoDict:photoDict];
            [self.photoArray addObject:photo];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^
          {
              [self.myCollectionView reloadData];
          }];
        
    }];
    
    [task resume];
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    NSLog(@"%li", indexPath.row);
    
    Photo *photo = self.photoArray[indexPath.row];
    
    NSURLSession *urlSession = [NSURLSession sharedSession];  //short way of creating session
// Long way to create session to allow to you customize
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 2
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 3
    
    NSURLSessionDownloadTask *downloadTask = [urlSession downloadTaskWithURL:photo.url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // This will run on the main queue
            
            cell.fishImage.image = image;
            cell.nameLabel.text = photo.title;
        }];
    }];
    
    [downloadTask resume];
    
    return cell;
}



- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoArray.count;
}

@end
