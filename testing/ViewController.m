//
//  ViewController.m
//  testing
//
//  Created by Richard Velazquez on 2/25/16.
//  Copyright © 2016 Richard Velazquez. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *dreamList;
@property NSMutableArray *enteredDreams;
@property NSMutableArray *dreamDescriptions;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enteredDreams = [NSMutableArray new];
    self.dreamDescriptions = [[NSMutableArray alloc]init];
}

-(void)presentDreamEntry{
    
    UIAlertController *enterDream = [UIAlertController alertControllerWithTitle:@"Dream Entry" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [enterDream addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Dream Title";
    }];
    
    [enterDream addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Dream Description";
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save Dream" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        
        UITextField *textField1 = enterDream.textFields.firstObject;
        [self.enteredDreams addObject:textField1.text];
        
        
        UITextField *textField2 = enterDream.textFields.lastObject;
        [self.dreamDescriptions addObject:textField2.text];
        
        [self.dreamList reloadData];
        
        
    }];
    
    [enterDream addAction:cancel];
    [enterDream addAction:saveAction];
    
    [self presentViewController:enterDream animated:true completion:nil];
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.dreamList dequeueReusableCellWithIdentifier:@"CellID"];
    cell.textLabel.text = [self.enteredDreams objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.dreamDescriptions objectAtIndex:indexPath.row];
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.enteredDreams.count;
}


- (IBAction)onEditButtonPressed:(UIBarButtonItem *)sender {
    
    if (self.editing) {
        self.editing = false;
        [self.dreamList setEditing:false animated:true];
        sender.style = UIBarButtonItemStylePlain;
        sender.title = @"Edit";
        
    } else {
        self.editing = true;
        [self.dreamList setEditing:true animated:true];
        sender.style = UIBarButtonItemStyleDone;
        sender.title = @"Done";
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSString *title = [self.enteredDreams objectAtIndex:sourceIndexPath.row];
    [self.enteredDreams removeObject:title];
    [self.enteredDreams insertObject:title atIndex:destinationIndexPath.row];
    
    NSString *description = [self.dreamDescriptions objectAtIndex:sourceIndexPath.row];
    [self.dreamDescriptions removeObject:description];
    [self.dreamDescriptions insertObject:description atIndex:destinationIndexPath.row];
    
}

- (IBAction)onAddButtonPressed:(id)sender {
    [self presentDreamEntry];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DetailViewController *dvc = segue.destinationViewController;
    dvc.titleString = [self.enteredDreams objectAtIndex:self.dreamList.indexPathForSelectedRow.row];
    dvc.descriptionString = [self.dreamDescriptions objectAtIndex:self.dreamList.indexPathForSelectedRow.row];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.enteredDreams removeObjectAtIndex:indexPath.row];
    [self.dreamDescriptions removeObjectAtIndex:indexPath.row];
    [self.dreamList reloadData];
    
}


@end
