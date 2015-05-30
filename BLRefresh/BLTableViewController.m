//
//  BLTableViewController.m
//  BLRefresh
//
//  Created by sxwyce on 15/5/29.
//  Copyright (c) 2015年 personal. All rights reserved.
//

#import "BLTableViewController.h"
#import "BLTableViewCell.h"

 static NSString * const tableViewIdentifier = @"BLTableViewCell";

@interface BLTableViewController ()
@property(nonatomic, strong)NSMutableArray *titles;
@property(nonatomic, strong)BLTableViewCell *prototypeCell;
@end

@implementation BLTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BLTableViewCell" bundle:nil] forCellReuseIdentifier:tableViewIdentifier];
    self.prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:tableViewIdentifier];
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titles count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BLTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:tableViewIdentifier forIndexPath:indexPath];

    NSString *imageName = [NSString stringWithFormat:@"%ld",indexPath.row % 5];
    cell.leftImageView.image = [UIImage imageNamed:imageName];
    cell.rightTitleLabel.text = [self.titles objectAtIndex:indexPath.row];
    
    return cell;
}

//第一次加载时，计算所有的cell的estimatedHeight,提高性能 iOS 7&8 useful
//这样cell真正显示时，每次只计算visiable cell 的height
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

//无论iOS7 or iOS8 最后都是这个方法获取cell的大小来显示的。上面只是提高了第一次加载的性能
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //返回 UITableViewAutomaticDimension   iOS8 可自动计算高度
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        return UITableViewAutomaticDimension;
    }else{
    // iOS7手动计算高度
#warning lable 总是计算不出正确的高度。经分析：必须设置一个宽度值 preferredMaxLayoutWidth（SDK中解释了它的作用）或有一个宽度值约束，才能计算出Label正确的高度.
        
        //iOS 8下会自动设置 preferredMaxLayoutWidth，但iOS7 没有。iOS7下至少有一个宽度值约束，或者设置宽度值才能计算出正确的高度
        NSString *title = [self.titles objectAtIndex:indexPath.row];
        NSLog(@"cell's title: %@", title);
        
        self.prototypeCell.rightTitleLabel.text = title;
        NSString *imageName = [NSString stringWithFormat:@"%ld",indexPath.row % 5];
        self.prototypeCell.leftImageView.image = [UIImage imageNamed:imageName];
        
        //也可以在cell xib中设置lable的preferredMaxLayoutWidth为某个定值或自动(仅iOS8)，但旋转时会显示不正常（本demo约束条件下）
        CGSize recommendImageViewSize = [self.prototypeCell.leftImageView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        CGFloat preferredMaxLayoutWidth = self.tableView.bounds.size.width - recommendImageViewSize.width;
        self.prototypeCell.rightTitleLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
        NSLog(@"label.preferredMaxLayoutWidth: %f", preferredMaxLayoutWidth);
        
        CGSize recommendSize = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        NSLog(@"recommendSize: %@", NSStringFromCGSize(recommendSize));
        
        //必须+1  cell.bounds.size.height - cell.contentView.bounds.size.height = 1
        return recommendSize.height + 1;
    }
}

#pragma mark - Private Method
-(UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return  newImage;
}
#pragma mark - Properties
-(NSMutableArray *)titles
{
    if (!_titles) {
        
        _titles = [[NSMutableArray alloc]init];
        for (int i = 0 ; i < 30 ; i ++) {
            NSMutableString *text = [[NSMutableString alloc]init];
            for (int j = 0 ; j < i; j ++) {
                [text appendString:@"Auto Layout sample"];
            }
            [_titles addObject:text];
        }
        
    }
    return _titles;
}

@end
