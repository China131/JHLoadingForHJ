//
//  ViewController.m
//  JHLoadingForHJ
//
//  Created by 简豪 on 16/8/10.
//  Copyright © 2016年 codingMan. All rights reserved.
//

#import "ViewController.h"
#import "JHHJView.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray * dataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      _dataArr = @[@"样式1",@"样式2",@"样式3",@"样式4"];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, K_IOS_WIDTH, K_IOS_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
  

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ce"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ce"];
    }
    cell.textLabel.text = _dataArr[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [JHHJView showLoadingOnTheKeyWindowWithType:indexPath.row];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [JHHJView hideLoading];
        
    });
    
}




@end
