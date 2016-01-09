//
//  ContactFriendViewController.m
//  ZpotDrop
//
//  Created by ME on 8/31/15.
//  Copyright (c) 2015 zpotdrop. All rights reserved.
//

#import "ContactFriendViewController.h"
#import "LoadingView.h"
#import "ContactCell.h"
#import <AddressBook/AddressBook.h>
@interface ContactFriendViewController ()<UISearchBarDelegate>{
    UISearchBar* _searchZpotBar;
    UITableView* _mTableView;
    NSMutableArray* _searchResult;
    NSMutableArray* _contactsFriends;
    LoadingView* loadingView;
}

@end

@implementation ContactFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBackButton];
    self.view.backgroundColor  = [UIColor whiteColor];
    _searchResult = [NSMutableArray array];
    _contactsFriends = [NSMutableArray array];
    self.title = @"search".localized.uppercaseString;
    _searchZpotBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y, self.view.width, 40)];
    _searchZpotBar.backgroundColor = [UIColor clearColor];
    _searchZpotBar.barTintColor = [UIColor clearColor];
    _searchZpotBar.backgroundImage = [[UIImage alloc]init];
    _searchZpotBar.returnKeyType = UIReturnKeyDone;
    _searchZpotBar.enablesReturnKeyAutomatically = NO;
    _searchZpotBar.delegate = self;
    _searchZpotBar.placeholder = @"search_for_people".localized;
    [_searchZpotBar setImage:[UIImage imageNamed:@"ic_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [_searchZpotBar addBorderWithFrame:CGRectMake(0, _searchZpotBar.height - 1.0, _searchZpotBar.width, 1) color:COLOR_SEPEARATE_LINE];
    NSDictionary *placeholderAttributes = @{
                                            NSForegroundColorAttributeName: [UIColor colorWithRed:219 green:219 blue:219],
                                            NSFontAttributeName: [UIFont fontWithName:@"PTSans-Regular" size:14],
                                            };
    
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc] initWithString:_searchZpotBar.placeholder
                                                                                attributes:placeholderAttributes];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setAttributedPlaceholder:attributedPlaceholder];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:@"PTSans-Regular" size:16]];
    [self.view addSubview:_searchZpotBar];
    
    _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _searchZpotBar.y + _searchZpotBar.height, self.view.frame.size.width, self.view.frame.size.height - (_searchZpotBar.y + _searchZpotBar.height)) style:UITableViewStylePlain];
    [_mTableView setDelegate:self];
    [_mTableView setDataSource:self];
    [_mTableView registerClass:[ContactCell class] forCellReuseIdentifier:@"contactCell"];
    [_mTableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeInteractive];
    [_mTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_mTableView];
    
    loadingView  = [[LoadingView alloc]init];
    [self getContactFriends];
}

-(void)getContactFriends{
    [loadingView showViewInView:_mTableView];
    [self getContactList:^(NSArray *data) {
        __block long count = data.count;
        if (count == 0) {
            [loadingView hideView];
        }
        for (NSDictionary* dict in data) {
            NSArray* phones = [dict objectForKey:@"phones"];
            NSArray* emails = [dict objectForKey:@"emails"];
            [[APIService shareAPIService]findUserWithPhones:phones emails:emails completion:^(NSArray *users) {
                [_contactsFriends addObjectsFromArray:users];
                count--;
                if (count == 0) {
                    [_searchResult addObjectsFromArray:_contactsFriends];
                    [_mTableView reloadData];
                    [loadingView hideView];
                }
            }];
        }
    }];
}

-(void)getContactList:(void(^)(NSArray* data))completion{
    CFErrorRef *error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    NSMutableArray* items = [[NSMutableArray alloc] init];
    __block ABRecordRef source = nil;
    __block CFArrayRef allPeople = nil;
    __block CFIndex nPeople = 0;
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            // First time access has been granted, add the contact
            source = ABAddressBookCopyDefaultSource(addressBook);
            allPeople = (ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName));
            //CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
            nPeople = CFArrayGetCount(allPeople); // bugfix who synced contacts with facebook
//            items = [NSMutableArray arrayWithCapacity:nPeople];
            if (!allPeople || !nPeople) {
                NSLog(@"people nil");
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        source = ABAddressBookCopyDefaultSource(addressBook);
        allPeople = (ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName));
        //CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
        nPeople = CFArrayGetCount(allPeople); // bugfix who synced contacts with facebook
//        items = [NSMutableArray arrayWithCapacity:nPeople];
        
        if (!allPeople || !nPeople) {
            NSLog(@"people nil");
        }
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
    
//    ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
//    CFArrayRef allPeople = (ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName));
//    //CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
//    CFIndex nPeople = CFArrayGetCount(allPeople); // bugfix who synced contacts with facebook
//    NSMutableArray* items = [NSMutableArray arrayWithCapacity:nPeople];
    
//    if (!allPeople || !nPeople) {
//        NSLog(@"people nil");
//    }
    
    
    for (int i = 0; i < nPeople; i++) {
        
        @autoreleasepool {
            
            //data model
            NSMutableDictionary* dict = [NSMutableDictionary dictionary];
            
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            
            //get First Name
            CFStringRef firstName = (CFStringRef)ABRecordCopyValue(person,kABPersonFirstNameProperty);
            NSString * firstNames = [(__bridge NSString*)firstName copy];
            
            if (firstName != NULL) {
                CFRelease(firstName);
            }
            
            
            //get Last Name
            CFStringRef lastName = (CFStringRef)ABRecordCopyValue(person,kABPersonLastNameProperty);
            NSString* lastNames = [(__bridge NSString*)lastName copy];
            
            if (lastName != NULL) {
                CFRelease(lastName);
            }
            
            
            if (!firstNames) {
                firstNames = @"";
            }
            
            if (!lastNames) {
                lastNames = @"";
            }
            
            [dict setObject:[NSNumber numberWithInt:ABRecordGetRecordID(person)] forKey:@"id"];
            
            //append first name and last name
            NSString* fullName = [NSString stringWithFormat:@"%@ %@", firstNames,lastNames];
            [dict setObject:fullName forKey:@"name"];
            
            //get Phone Numbers
            NSMutableArray *phoneNumbers = [NSMutableArray array];
            ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            
            for(CFIndex i=0; i<ABMultiValueGetCount(multiPhones); i++) {
                @autoreleasepool {
                    CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                    NSString *phoneNumber = CFBridgingRelease(phoneNumberRef);
                    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
                    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
                    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
                    if (phoneNumber != nil)[phoneNumbers addObject:phoneNumber];
                    //NSLog(@"All numbers %@", phoneNumbers);
                }
            }
            
            if (multiPhones != NULL) {
                CFRelease(multiPhones);
            }
            
            [dict setObject:@"phones" forKey:phoneNumbers];
            
            //get Contact email
            NSMutableArray *contactEmails = [NSMutableArray new];
            ABMultiValueRef multiEmails = ABRecordCopyValue(person, kABPersonEmailProperty);
            
            for (CFIndex i=0; i<ABMultiValueGetCount(multiEmails); i++) {
                @autoreleasepool {
                    CFStringRef contactEmailRef = ABMultiValueCopyValueAtIndex(multiEmails, i);
                    NSString *contactEmail = CFBridgingRelease(contactEmailRef);
                    if (contactEmail != nil)[contactEmails addObject:contactEmail];
                    // NSLog(@"All emails are:%@", contactEmails);
                }
            }
            
            if (multiPhones != NULL) {
                CFRelease(multiEmails);
            }
            
            [dict setObject:@"emails" forKey:contactEmails];
            
            [items addObject:dict];
            
        }
    } //autoreleasepool
//    CFRelease(allPeople);
//    CFRelease(addressBook);
//    CFRelease(source);
    completion(items);
}

-(NSString *)correctName:(NSString *)name{
    NSString* result = [name stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return result;
}

#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (searchBar.text.length > 0) {
        NSArray* result = [_contactsFriends filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"username contains[c] %@ OR first_name contains[c] %@ OR last_name contains[c] %@",searchBar.text,searchBar.text,searchBar.text]];
        [_searchResult removeAllObjects];
        [_searchResult addObjectsFromArray:result];
        [_mTableView reloadData];
    }else{
        [_searchResult removeAllObjects];
        [_searchResult addObjectsFromArray:_contactsFriends];
        [_mTableView reloadData];
    }
    [searchBar resignFirstResponder];
}

#pragma mark - UITablViewDatasource and Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_searchResult count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ContactCell cellHeightWithData:nil];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell* cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell" forIndexPath:indexPath];
    UserDataModel* user = [_searchResult objectAtIndex:indexPath.row];
    cell.dataModel.dataDelegate = nil;
    cell.dataModel = nil;
    user.dataDelegate = cell;
    [cell setupCellWithData:user andOptions:nil];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
