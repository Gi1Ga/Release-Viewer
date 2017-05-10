//
//  DropDown.m
//  
//
//  Created by Wang, Aaron on 04/05/2017.
//
//

#import "DropDown.h"

@implementation DropDown

@synthesize tv,tableArray,textField,button;

- (id)initWithFrame:(CGRect)frame
{
    if(frame.size.height<200){
        frameHeight = 200;
    }else{
        frameHeight = frame.size.height;
    }
    tableHeight = frameHeight - 30;
    frame.size.height = 30.0f;
    self=[super initWithFrame:frame];
    
    if(self){
        showList = NO;
        tv = [[UITableView alloc] initWithFrame:CGRectMake(0,30,frame.size.width,0)];
        tv.delegate = self;
        tv.dataSource = self;
        tv.backgroundColor = [UIColor grayColor];
        tv.separatorColor = [UIColor lightGrayColor];
        tv.hidden = YES;
        [self addSubview:tv];
        
        textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width-40, 30)];
        textField.clearsOnBeginEditing = YES;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        [textField addTarget:self action:@selector(dropdown) forControlEvents:UIControlEventAllTouchEvents];
        [self addSubview:textField];
        
        button = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width, 0, 30, 30)];
        [button setTitle:@"OK" forState:UIControlStateNormal];
        [button setTitle:@"OK" forState:UIControlStateHighlighted];
        [self addSubview:button];
    }
    return self;
}

- (void) dropdown{
    [textField resignFirstResponder];
    if(showList){
        return;
    }else{
        CGRect sf = self.frame;
        sf.size.height = frameHeight;
        
        [self.superview bringSubviewToFront:self];
        tv.hidden = NO;
        showList = YES;
        
        CGRect frame = tv.frame;
        frame.size.height = 0;
        tv.frame = frame;
        frame.size.height = tableHeight;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.frame = sf;
        tv.frame = frame;
        [UIView commitAnimations];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [tableArray objectAtIndex:[indexPath row]];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 35;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    textField.text = [tableArray objectAtIndex:[indexPath row]];
    showList = NO;
    tv.hidden = YES;
    CGRect sf = self.frame;
    sf.size.height = 30;
    self.frame = sf;
    CGRect frame = tv.frame;
    frame.size.height = 0;
    tv.frame = frame;
}
    
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
