//
//  kSortViewController.m
//  汉字排序
//
//  Created by 张坤 on 15/12/25.
//  Copyright © 2015年 KZ. All rights reserved.
//

#import "kSortViewController.h"
#import "Header.h"
@interface kSortViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_cityArr;
    NSMutableDictionary *_sortCitysDic;
    NSArray *_charArr;//字母数组
}
@end

@implementation kSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setContentView];
}
- (void)setContentView{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"city" ofType:@"plist"];
    _cityArr = [NSArray arrayWithContentsOfFile:path];
    
    _sortCitysDic = [NSMutableDictionary dictionaryWithCapacity:20];
    //创建26个可变数组
    for (char character='a'; character<='z'; character++) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:20];
        [_sortCitysDic setObject:array forKey:[NSString stringWithFormat:@"%c",character-32]];
    }
    //将城市按首字母放入对应的数组中
    for (NSString *city in _cityArr) {
        NSString *firChar = [NSString stringWithFormat:@"%c",pinyinFirstLetter([city characterAtIndex:0])-32];
        NSMutableArray *tempArray = [_sortCitysDic objectForKey:firChar];
        [tempArray addObject:city];
    }
    //去掉空白数组
    for (char characte = 'a'; characte<='z'; characte++) {
        NSString *firChar = [NSString stringWithFormat:@"%c",characte];
        NSArray *finalArray = [_sortCitysDic objectForKey:firChar];
        if (finalArray.count == 0) {
            [_sortCitysDic removeObjectForKey:firChar];
        }
    }
    //按字母顺序进行排序
    _charArr = [_sortCitysDic allKeys];
    _charArr = [_charArr sortedArrayUsingSelector:@selector(compare:)];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark UITableViewDataSource
//一共几个分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _charArr.count;
}
//每个分区有几个单元格
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *firChar = _charArr[section];
    NSArray *sameFirCharArr = [_sortCitysDic objectForKey:firChar];
    return sameFirCharArr.count;
}
//分区的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _charArr[section];
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _charArr;
}
//单元格展示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *firChar = _charArr[indexPath.section];
    NSArray *sameFirCharArr = [_sortCitysDic objectForKey:firChar];
    cell.textLabel.text = sameFirCharArr[indexPath.row];
    return cell;
}
@end
