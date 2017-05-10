//
//  ViewController.m
//  Release Viewer
//
//  Created by Wang, Aaron on 28/03/2017.
//  Copyright © 2017 BHP Billiton. All rights reserved.
//

#import "ViewController.h"
#import "DataViewController.h"
#import <sqlite3.h>
#import "SQLiteOperation.h"
#import "TableContent.h"


@interface ViewController ()

@property (nonatomic) NSMutableArray *projects;
@property (nonatomic) UITableView *tableView;
@property (strong, nonatomic) SQLiteOperation *sqlOperation;
@property (strong,nonatomic) TableContent *tableContent;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    #define UD [NSUserDefaults standardUserDefaults]

    if (![UD boolForKey:@"EverLaunched"]) {
        [UD setBool:YES forKey:@"EverLaunched"];
        [UD setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [UD setBool:NO forKey:@"firstLaunch"];
    }
    
    self.sqlOperation = [[SQLiteOperation alloc] init];
    self.tableContent = [[TableContent alloc] init];
    
    NSString *createsql = @"create table if not exists projects(id integer primary key autoincrement, name text unique)";
    [self.sqlOperation createTable:createsql];
    
    NSArray *paramarray=@[@[@"Leaders' Toolkit"],@[@"Maintenance Information"],@[@"My Travel"],@[@"SGL App"],@[@"Shutdown"]];
    NSString *insertsql = @"insert into projects(name) values(?)";
    [self.sqlOperation dealData:insertsql paramArray:paramarray];
    
    NSString *selectsql = @"select name from projects";
    self.projects=[self.sqlOperation selectData:selectsql resultColumns:1];
    

    for (NSArray *project in self.projects){
        NSString *tableName=[NSString stringWithFormat:@"%@",project[0]];
    
        //init database
        if ([UD boolForKey:@"firstLaunch"]) {
        
            NSString *createsql = [NSString stringWithFormat:@"create table if not exists \"%@\" (Date text, IOS int, Android int, IDevice int, ADevice int, Installed int)",tableName];
            NSLog(@"%@", createsql);
            [self.sqlOperation createTable:createsql];
        
            NSLog(@"%@",project[0]);
            NSArray *tableData= [self.tableContent getData:project[0]];
//            NSArray *paramarray=tableData;
            NSLog(@"%@", tableData);
            NSString *insertsql = [NSString stringWithFormat:@"insert into \"%@\" (Date, IOS, Android, IDevice, ADevice, Installed) values (?,?,?,?,?,?)",tableName];
            [self.sqlOperation dealData:insertsql paramArray:tableData];
        }
    }
/*    self.projects=[[NSMutableArray alloc] init];
    
    // 设置数据库文件路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"mydb"];
    // 创建数据库句柄
    sqlite3 *db;
    char *error;
    if (sqlite3_open([path UTF8String], &db) == SQLITE_OK) {
        NSLog(@"sqlite dadabase is opened.");
    } else {
        NSLog(@"sqlite dadabase open fail.");
    }
    
    NSString *createSql = @"create table if not exists projects(id integer primary key autoincrement, name text unique)";
    
    if (sqlite3_exec(db, [createSql UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"create table is ok.");
    } else {
        NSLog(@"error: %s", error);
        
        // 每次使用完毕清空 error 字符串，提供给下一次使用
        sqlite3_free(error);
    }
    NSString *insertSql = @"insert into projects(name) values(\"Leaders' Toolkit\"),('Maintenance Information'),('My Travel'),('SGL App'),('Shutdown')";
    
    if (sqlite3_exec(db, [insertSql UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"insert operation is ok.");
    } else {
        NSLog(@"error: %s", error);
        
        // 每次使用完毕清空 error 字符串，提供给下一次使用
        sqlite3_free(error);
    }
    sqlite3_stmt *statement;
    
    NSString *selectSql = @"select name from projects";
    
    if (sqlite3_prepare_v2(db, [selectSql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while(sqlite3_step(statement) == SQLITE_ROW) {
            
            NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            NSLog(@"%@",name);

            [self.projects addObject:name];

        }
        NSLog(@"select operation is ok.");
    } else {
        NSLog(@"select operation is fail.");
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(db);
*/

//    self.projects=@[@"Leaders' Toolkit",@"Maintenance Information",@"My Travel",@"SGL App",@"Shutdown"];
    

    
    
    
    self.tableView = (id)[self.view viewWithTag:1];

/*    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.top=40;
    [self.tableView setContentInset:contentInset];
*/
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Projects" style:UIBarButtonItemStylePlain target:nil action:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{

    return  [self.projects count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
       cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIndentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIndentifier];
    
    if(cell == nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIndentifier];
    }
    
    UIImage *image = [UIImage imageNamed:self.projects[indexPath.row][0]];
    cell.imageView.image = image;
    
    cell.textLabel.text=self.projects[indexPath.row][0];
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    DataViewController *listVC = segue.destinationViewController;
    
    NSString *project=self.projects[indexPath.row][0];
    listVC.navigationItem.title=project;
    
}



@end
