//
//  DropDown.h
//  
//
//  Created by Wang, Aaron on 04/05/2017.
//
//

#import <UIKit/UIKit.h>

@interface DropDown : UIView <UITableViewDelegate,UITableViewDataSource>{
    UITableView *tv;
    NSArray *tableArray;
    UITextField *textField;
    BOOL showList;
    CGFloat tableHeight;
    CGFloat frameHeight;
    UIButton *button;
}

@property (nonatomic,retain) UITableView *tv;
@property (nonatomic,retain) NSArray *tableArray;
@property (nonatomic,retain) UITextField *textField;
@property (nonatomic,retain) UIButton *button;

@end
