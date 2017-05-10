//
//  GraphViewController.m
//  Release Viewer
//
//  Created by Wang, Aaron on 13/04/2017.
//  Copyright © 2017 BHP Billiton. All rights reserved.
//

#import "GraphViewController.h"
#import "DataViewController.h"
#import "PNChart.h"
#import "JHChartHeader.h"
#import <sqlite3.h>
#import "SQLiteOperation.h"
#import "TableContent.h"
#import "DropDown.h"


@interface GraphViewController () <PNChartDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) PNLineChart * lineChart;
@property (nonatomic,strong) PNPieChart * pieChart;
@property (nonatomic,strong) JHTableChart * tableChart;
@property (nonatomic,strong) TableContent * tableContent;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) SQLiteOperation * sqlOperation;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation GraphViewController

#define screenHeight [UIScreen mainScreen].bounds.size.height
#define screenWidth  [UIScreen mainScreen].bounds.size.width
#define screenSize   [UIScreen mainScreen].bounds.size

#define kYearComponent 0
#define kMonthComponent 1
#define kDayComponent 2


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.sqlOperation = [[SQLiteOperation alloc] init];
    
    NSString *tableName=[NSString stringWithFormat:@"%@",self.project];
    self.tableContent = [[TableContent alloc] init];
    NSArray *tableData= [self.tableContent getData:self.project];
    self.view.backgroundColor = [UIColor whiteColor];
/*    
    #define UD [NSUserDefaults standardUserDefaults]
    NSString *keyEverLaunched = [NSString stringWithFormat:@"\"%@\"everLaunched)",self.project];
    NSString *keyfirstLaunch = [NSString stringWithFormat:@"\"%@\"firstLaunch)",self.project];
    if (![UD boolForKey:keyEverLaunched]) {
        [UD setBool:YES forKey:keyEverLaunched];
        [UD setBool:YES forKey:keyfirstLaunch];
    }
    else{
        [UD setBool:NO forKey:keyfirstLaunch];
    }


    
    //init database
    if ([UD boolForKey:keyfirstLaunch]) {

        NSString *createsql = [NSString stringWithFormat:@"create table if not exists \"%@\" (Date text, IOS int, Android int, IDevice int, ADevice int, Installed int)",tableName];
        NSLog(@"%@", createsql);
        [self.sqlOperation createTable:createsql];
    
        NSArray *paramarray=tableData;
        NSLog(@"%@", paramarray);
        NSString *insertsql = [NSString stringWithFormat:@"insert into \"%@\" (Date, IOS, Android, IDevice, ADevice, Installed) values (?,?,?,?,?,?)",tableName];
        [self.sqlOperation dealData:insertsql paramArray:paramarray];
    }
*/
    //select IOS and Android data, for trend chart and pie chart
    NSString *selectsqlIOS = [NSString stringWithFormat:@"select IOS from \"%@\"",tableName];
    NSArray *selectResultIOS=[self.sqlOperation selectData:selectsqlIOS resultColumns:1];
    
    NSString *selectsqlAndroid = [NSString stringWithFormat:@"select Android from \"%@\"",tableName];
    NSArray *selectResultAndroid=[self.sqlOperation selectData:selectsqlAndroid resultColumns:1];
    
    NSMutableArray *data01Array=[[NSMutableArray alloc] init];
    NSInteger selectResultRowIOS=[selectResultIOS count];
    for(int i=0; i<selectResultRowIOS ;i++){
        [data01Array addObject:selectResultIOS[i][0]];
    }
    
    NSMutableArray *data02Array=[[NSMutableArray alloc] init];
    NSInteger selectResultRowAndroid=[selectResultIOS count];
    for(int i=0; i<selectResultRowAndroid ;i++){
        [data02Array addObject:selectResultAndroid[i][0]];
    }
    
    NSString *selectsqlDate = [NSString stringWithFormat:@"select Date from \"%@\"",tableName];
    NSArray *selectResultDate=[self.sqlOperation selectData:selectsqlDate resultColumns:1];
    NSMutableArray *dateArray=[[NSMutableArray alloc] init];
    NSInteger selectResultRowDate=[selectResultDate count];
    for(int i=0; i<selectResultRowDate ;i++){
        [dateArray addObject:selectResultDate[i][0]];
    }
    
    
//    NSLog(@"%@", data01Array);
//    NSLog(@"%@", data02Array);
//    NSLog(@"%@", self.projects);

//    NSArray *data01Array = @[@16, @41, @57, @71, @100, @126, @185, @264, @303, @352, @448, @482];
//    NSArray *data02Array = @[@4, @6, @2, @8, @9, @16, @35, @44, @52, @67, @87, @100];
    
    //lay scrollview
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(0,0,screenWidth,screenHeight);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.scrollEnabled = true;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
//    self.scrollView.contentInset = UIEdgeInsetsMake(20, 20, 20, 20);
    
    
    if([self.navigationItem.title isEqual:@"Trend"]){
    
        self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 200)];
        self.lineChart.legendStyle = PNLegendItemStyleStacked;
        self.lineChart.delegate = self;
        
        self.lineChart.showCoordinateAxis = YES; //显示坐标系
        self.lineChart.showGenYLabels = YES;
        self.lineChart.showLabel = YES;
        self.lineChart.thousandsSeparator = YES;
 
        [self.lineChart setXLabels:dateArray];
        
//        [self.lineChart setXLabels:@[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月"]];
        
        
        PNLineChartData *data01 = [PNLineChartData new]; //chart数据
        data01.dataTitle = @"IOS";
        data01.color = PNBlue; //折线的颜色
        data01.itemCount = self.lineChart.xLabels.count; //x轴坐标item数
        data01.inflexionPointStyle = PNLineChartPointStyleCircle; //数值点的样式
        data01.inflexionPointColor = data01.color;
        
        data01.getData = ^(NSUInteger index) {
            
            CGFloat yValue = [data01Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        
        
        
        PNLineChartData *data02 = [PNLineChartData new];
        data02.dataTitle = @"Android";
        data02.color = PNRed;
        data02.itemCount = self.lineChart.xLabels.count;
        data02.inflexionPointStyle = PNLineChartPointStyleCircle;
        data02.inflexionPointColor = data02.color;
        
        data02.getData = ^(NSUInteger index) {
            
            CGFloat yValue = [data02Array[index] floatValue];
            return [PNLineChartDataItem dataItemWithY:yValue];
        };
        
        self.lineChart.chartData = @[data01,data02];
        [self.lineChart strokeChart]; //画折线，带动画

        
        self.lineChart.legendStyle = PNLegendItemStyleStacked;// 标示放置的样式
        self.lineChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
        self.lineChart.legendFontColor = [UIColor blackColor];
        
        // 标示所在的View
        UIView *legend = [self.lineChart getLegendWithMaxWidth:320];
        [legend setFrame:CGRectMake(30, 340, legend.frame.size.width-30, legend.frame.size.height)];
        legend.backgroundColor = [UIColor whiteColor];
        
        [self.scrollView addSubview:self.lineChart];
        [self.scrollView addSubview:legend];
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 400+legend.frame.size.height);
        [self.view addSubview:self.scrollView];
        
    }else if([self.navigationItem.title isEqual:@"Platform"]){
        // 数据
 
//        CGFloat data1Sum = [[data01Array valueForKeyPath:@"@sum.floatValue"] floatValue];
//        CGFloat data2Sum = [[data02Array valueForKeyPath:@"@sum.floatValue"] floatValue];
        
        CGFloat data1Sum = [data01Array[[data01Array count]-1] floatValue];
        CGFloat data2Sum = [data02Array[[data02Array count]-1] floatValue];
        
        NSArray *items = @[[PNPieChartDataItem dataItemWithValue:data1Sum color:PNBlue description:@"iOS"],
                           [PNPieChartDataItem dataItemWithValue:data2Sum color:PNRed description:@"Android"],
                           ];
        // 初始化
        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2.0 - 100, 135, 200.0, 200.0) items:items];
        self.pieChart.descriptionTextColor = [UIColor whiteColor];
        self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
        self.pieChart.descriptionTextShadowColor = [UIColor clearColor]; // 阴影颜色
        self.pieChart.showAbsoluteValues = NO; // 显示实际数值(不显示比例数字)
        self.pieChart.showOnlyValues = YES; // 只显示数值不显示内容描述
        
        self.pieChart.innerCircleRadius = 0;
        //        self.pieChart.outerCircleRadius = 0;
        
        [self.pieChart strokeChart];
        
        
        
        self.pieChart.legendStyle = PNLegendItemStyleStacked; // 标注排放样式
        self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
        
        UIView *legend = [self.pieChart getLegendWithMaxWidth:200];
        [legend setFrame:CGRectMake(130, 350, legend.frame.size.width, legend.frame.size.height)];


        
        [self.scrollView addSubview:legend];
        [self.scrollView addSubview:self.pieChart];
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,screenHeight);
        
        DropDown *dd = [[DropDown alloc] initWithFrame:CGRectMake(10,10,140,100)];
        dd.textField.text = @"Select Date";
        dd.tableArray = dateArray;
        [self.scrollView addSubview:dd];
        
        
        //400+legend.frame.size.height);

        [self.view addSubview:self.scrollView];
        
        self.dateLabel.text = dd.textField.text;
        

        
    }else if([self.navigationItem.title isEqual:@"Data"]){


        self.tableChart = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400)];
        /*       Table name         */
        self.tableChart.tableTitleString = @"Summary";
        self.tableChart.tableTitleColor=[UIColor whiteColor];
        /*        Each column of the statement, one of the first to show if the rows and columns that can use the vertical segmentation of rows and columns         */
        self.tableChart.colTitleArr = @[@"Date",@"IOS",@"Android",@"IOS Device",@"Android Device",@"Installed"];
        /*        The width of the column array, starting with the first column         */
        NSNumber * unit1 = [NSNumber numberWithFloat: (screenWidth - 30) * 3.0 / 13.0];
        NSNumber * unit = [NSNumber numberWithFloat: (screenWidth -30 ) * 2.0 / 13.0];
        self.tableChart.colWidthArr = @[unit1,unit,unit,unit,unit,unit];
        /*        Text color of the table body         */
        self.tableChart.bodyTextColor = [UIColor whiteColor];
        /*        Minimum grid height         */
        self.tableChart.minHeightItems = 35;
        /*        Table line color         */
        self.tableChart.lineColor = [UIColor whiteColor];
        
        self.tableChart.backgroundColor = [UIColor orangeColor];
        /*       Data source array, in accordance with the data from top to bottom that each line of data, if one of the rows of a column in a number of cells, can be stored in an array of         */
        self.tableChart.dataArr = tableData;

        /*        show                            */
        [self.tableChart showAnimation];
        /*        Automatic calculation table height        */
        self.tableChart.frame = CGRectMake(0, 0, SCREEN_WIDTH, [self.tableChart heightFromThisDataSource]);
        
        
        [self.scrollView addSubview:self.tableChart];
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, [self.tableChart heightFromThisDataSource]+60);
        [self.view addSubview:self.scrollView];


    }

    
    // Do any additional setup after loading the view.
}

//MARK:PNChart代理  点击方法
- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex {

}

// 线
- (void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex pointIndex:(NSInteger)pointIndex  {

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate
{
    
    return NO;
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.view setNeedsDisplay];
    }];
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
