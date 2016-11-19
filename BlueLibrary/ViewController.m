//
//  ViewController.m
//  BlueLibrary
//
//  Created by Eli Ganem on 31/7/13.
//  Copyright (c) 2013 Eli Ganem. All rights reserved.
//

#import "ViewController.h"
#import "LibraryAPI.h"
#import "Album+TableRepresentation.h"
#import "HorizontalScroller.h"
#import "AlbumView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, HorizontalScrollerDelegate>
{
    UITableView *dataTable;
    NSArray *allAlbums;
    NSDictionary *currentAlbumData;
    NSInteger currentAlbumIndex;
    
    HorizontalScroller *scroller;
    
    UIToolbar *toolbar;
    NSMutableArray * undoStack;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithRed:0.76f green:0.81f blue:0.87f alpha:1];
    currentAlbumIndex = 0;
    
    //2
    allAlbums = [[LibraryAPI sharedInstance] getAlbums];
    
    // 3
    // the uitableview that presents the album data
    dataTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height-120) style:UITableViewStyleGrouped];
    dataTable.delegate = self;
    dataTable.dataSource = self;
    dataTable.backgroundView = nil;
    [self.view addSubview:dataTable];
    
    [self loadPreviousState];
    
    scroller = [[HorizontalScroller alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    scroller.backgroundColor = [UIColor colorWithRed:0.24f green:0.35f blue:0.49f alpha:1 ];
    scroller.delegate = self;
    [self.view addSubview:scroller];
    NSLog(@"%@", scroller);
    [self reloadScroller];
    
    [self showDataForAlbumAtIndex:currentAlbumIndex];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(saveCurrentState) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    
    
    //makrUI
    toolbar = [[UIToolbar alloc]init];
    UIBarButtonItem *undoItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undoAction)];
    undoItem.enabled = NO;
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *delete = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteAlbum)];
    
    [toolbar setItems:@[undoItem, space, delete]];
    [self.view addSubview:toolbar];
    undoStack = [[NSMutableArray alloc]init];
    
    
}

- (void)viewWillLayoutSubviews {
    toolbar.frame = CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49);
    dataTable.frame = CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height - 200);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showDataForAlbumAtIndex:(NSInteger)albumIndex{
    // defensive code: make sure the requested index is lower than the amount of albums
    if (albumIndex < allAlbums.count) {
        // fetch the album
        Album *album = allAlbums[albumIndex];
        // save the albums data to present it later in the tableview
        currentAlbumData = [album tr_tableRepresentation];
    } else {
        currentAlbumData = nil;
    }
    
    // we have the data we need, let's refresh our tableview
    [dataTable reloadData];
}


- (void)saveCurrentState {
    [[NSUserDefaults standardUserDefaults]setInteger:currentAlbumIndex forKey:@"currentAlbumIndex"];
    [[LibraryAPI sharedInstance]saveAlbums];
}

- (void)loadPreviousState {
    currentAlbumIndex = [[NSUserDefaults standardUserDefaults]integerForKey:@"currentAlbumIndex"];
    [self showDataForAlbumAtIndex:currentAlbumIndex];
}

#pragma mark -- UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [currentAlbumData[@"titles"] count];
    
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = currentAlbumData[@"titles"][indexPath.row];
    cell.detailTextLabel.text = currentAlbumData[@"values"][indexPath.row];
    
    
    
    return cell;
}


- (void)reloadScroller {
    allAlbums = [[LibraryAPI sharedInstance]getAlbums];
    if (currentAlbumIndex < 0) {
        currentAlbumIndex = 0;
    }else if (currentAlbumIndex >= allAlbums.count) {
        currentAlbumIndex = allAlbums.count - 1;
    }
    
    [scroller reload];
    
    NSLog(@"%@", scroller);
    
    [self showDataForAlbumAtIndex:currentAlbumIndex];
}


#pragma mark - HorizontalScrollerDelegate

//点击哪个AlbumView之后，更新对应的tableView的数据
- (void)horizontalScroller:(HorizontalScroller *)scroller clickedViewAtIndex:(int)index {
    currentAlbumIndex = index;
    [self showDataForAlbumAtIndex:index];
}

- (NSInteger)numberOfViewsForHorizontalScroller:(HorizontalScroller *)scroller {
    return allAlbums.count;
}

- (UIView *)horizontalScroller:(HorizontalScroller *)scroller viewAtIndex:(int)index {
    Album *album = allAlbums[index];
    return [[AlbumView alloc]initWithFrame:CGRectMake(0, 0, 100, 100) albumCover:album.coverUrl];
}

- (NSInteger)initialViewIndexForHorizontalScroller:(HorizontalScroller *)scroller {
    return currentAlbumIndex;
}

#pragma mark -- add delete undo

- (void)addAlbum:(Album *)album atIndex:(int)index {
    [[LibraryAPI sharedInstance]addAlbum:album atIndex:index];
    currentAlbumIndex = index;
    [self reloadScroller];
}


//target-action  -- deleteItemButon
- (void) deleteAlbum {
    
    Album *deletedAlbum = allAlbums[currentAlbumIndex];
    
    //tips:with NSInvocation, you need to keep the following points in mind:
    //The arguments must be passed by poingt
    //The arguments start at index 2, indices 0 and 1 are reserved for the target and the selector
    //If there's a chance that the arguments will be deallocated, then, you should call retainArguments
    
    NSMethodSignature *sig = [self methodSignatureForSelector:@selector(addAlbum:atIndex:)];
    NSInvocation *undoAction = [NSInvocation invocationWithMethodSignature:sig];
    [undoAction setTarget:self];    //atIndex :0
    [undoAction setSelector:@selector(addAlbum:atIndex:)];  //atIndex:1
    [undoAction setArgument:&deletedAlbum atIndex:2];
    [undoAction setArgument:&currentAlbumIndex atIndex:3];
    [undoAction retainArguments];
    
    
    
    [undoStack addObject:undoAction];
    
    [[LibraryAPI sharedInstance]deleteAlbumAtIndex:currentAlbumIndex];
    [self reloadScroller];
    
    [toolbar.items[0] setEnabled:YES];
}

//target-action  --undoItemButton
- (void)undoAction {
    if (undoStack.count > 0) {
        NSInvocation *undoAction = [undoStack lastObject];
        [undoStack removeLastObject];
        [undoAction invoke];
        
    }
    
    if (undoStack.count == 0) {
        [toolbar.items[0] setEnabled:NO];
    }
}


@end
