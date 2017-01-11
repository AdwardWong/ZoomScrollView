//
//  ADTestTableViewController.m
//  ADHeadViewTransform
//
//  Created by AdwardWang on 2016/11/1.
//  Copyright © 2016年 Adward. All rights reserved.
//

#import "ADTestTableViewController.h"
#import "UIScrollView+ADHeadImageViewScaleTtransform.h"

static NSString * const ID = @"cell";


@interface ADTestTableViewController ()

@end

@implementation ADTestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tableView头部缩放图片
    self.tableView.AD_headerScaleImage = [UIImage imageNamed:@"rose"];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 150)];
    headerView.backgroundColor = [UIColor clearColor];//这句代码必须要写
    self.tableView.tableHeaderView = headerView;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID]
    ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor redColor];
    cell.textLabel.text = @"rose falls";
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
