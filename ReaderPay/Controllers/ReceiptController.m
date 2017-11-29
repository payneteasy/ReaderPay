//
//  ReceiptController.m
//
//  Created by Sergey Anisiforov on 13/06/2017.
//  Copyright © 2017 payneteasy. All rights reserved.
//

#import "ReceiptController.h"
#import "ReceiptCell.h"
#import "ReceiptItem.h"
#import "UIView+Constraints.h"

@interface ReceiptController () <UITableViewDataSource, UITableViewDelegate>

@end

static NSString *identCellValue      = @"ReceiptValueCell";
static NSString *identCellCenter     = @"ReceiptCenterCell";
static NSString *identCellLeft       = @"ReceiptLeftCell";
static NSString *identCellRight      = @"ReceiptRightCell";
static NSString *identCellJustified  = @"ReceiptJustifiedCell";
static NSString *identCellDouble     = @"ReceiptDoubleCell";

@implementation ReceiptController {
    NSDecimalNumber *_amount;
    NSString *_currency;
    NSNumber *_invoiceId;
    NSMutableArray<ReceiptItem *> *_arrayReceipt;
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _arrayReceipt = [NSMutableArray<ReceiptItem *> array];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_tableView) {
        UIView *view = [self viewForReceipt];
        if (view) {
            _tableView = [UITableView new];
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _tableView.allowsSelection = NO;
            _tableView.showsHorizontalScrollIndicator = NO;
            _tableView.showsVerticalScrollIndicator = NO;
            _tableView.dataSource = self;
            _tableView.delegate = self;
            _tableView.backgroundColor = [UIColor clearColor];
            [view addSubview:_tableView];
            [_tableView autoPinToSuperview];
            
            [_tableView registerNib:[UINib nibWithNibName:identCellValue bundle:nil] forCellReuseIdentifier:identCellValue];
            [_tableView registerNib:[UINib nibWithNibName:identCellCenter bundle:nil] forCellReuseIdentifier:identCellCenter];
            [_tableView registerNib:[UINib nibWithNibName:identCellLeft bundle:nil] forCellReuseIdentifier:identCellLeft];
            [_tableView registerNib:[UINib nibWithNibName:identCellRight bundle:nil] forCellReuseIdentifier:identCellRight];
            [_tableView registerNib:[UINib nibWithNibName:identCellJustified bundle:nil] forCellReuseIdentifier:identCellJustified];
            [_tableView registerNib:[UINib nibWithNibName:identCellDouble bundle:nil] forCellReuseIdentifier:identCellDouble];
        }
    }
    [self updateInterface];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)setAmount:(NSDecimalNumber *)amount currency:(NSString *)currency invoiceId:(NSNumber *)invoiceId {
    _amount = amount;
    _currency = currency;
    _invoiceId = invoiceId;
    [self updateInterface];
}

- (void)setResponse:(PaynetStatusResponse *)response {
    _response = response;
    [self updateInterface];
}

- (void)updateInterface {
    NSString *status;
    switch (_response.status) {
        case PaynetStatusTypeApproved:
            status = @"APPROVED";
            break;
        case PaynetStatusTypeDeclined:
            status = @"DECLINED";
            break;
        case PaynetStatusTypeFiltered:
            status = @"FILTERED";
            break;
        case PaynetStatusTypeProcessing:
            status = @"PROCESSING";
            break;
        case PaynetStatusTypeError:
            status = @"ERROR";
            break;
        default:
            status = @"UNKNOWN";
            break;
    }
    
    [_arrayReceipt removeAllObjects];
    
    [self addReceiptItemWithName:@"Terminal:" value:_response.terminalId alignment:ReceiptItemAlignmentCenter];
    [self addReceiptItemWithName:@"Order ID:"
                           value:[NSString stringWithFormat:@"%lu", (unsigned long)_response.paynetOrderId]
                      secondName:nil
                     secondValue:status];
    if (_response.errorMessage.length)
        [self addReceiptItemWithName:nil value:_response.errorMessage alignment:ReceiptItemAlignmentRight];
    [self addReceiptItemWithName:@"Amount:"
                           value:_amount.stringValue
                       alignment:ReceiptItemAlignmentJustified];
    [self addReceiptItemWithName:@"AID:"
                           value:_response.emvTerminalAid_9F06
                      secondName:nil
                     secondValue:_response.emvAppLabel_50];
    [self addReceiptItemWithName:@"TVR:"
                           value:_response.emvTvr_95
                      secondName:@"CVM:"
                     secondValue:_response.emvCvm_9F34];
    [self addReceiptItemWithName:@"CID:"
                           value:_response.emvCid_9f27
                      secondName:nil
                     secondValue:_response.emvAppCryptogram_9f26];
    [self addReceiptItemWithName:@"Card:"
                           value:_response.cardType
                       alignment:ReceiptItemAlignmentLeft];
    [self addReceiptItemWithName:nil
                           value:[NSString stringWithFormat:@"**** **** **** %@ : %@",
                                  _response.lastFourDigits ? _response.lastFourDigits : @"",
                                  _response.emvPanSequence_5f34 ? _response.emvPanSequence_5f34 : @""]
                       alignment:ReceiptItemAlignmentCenter];
    [self addReceiptItemWithName:nil
                           value:_response.cardholderName
                       alignment:ReceiptItemAlignmentCenter];
    [self addReceiptItemWithName:@"RPN:"
                           value:_response.rrn
                       alignment:ReceiptItemAlignmentJustified];
    [self addReceiptItemWithName:@"Auth Response:"
                           value:_response.authCode
                       alignment:ReceiptItemAlignmentJustified];
    [self addReceiptItemWithName:@"Response Code:"
                           value:_response.responseCode
                       alignment:ReceiptItemAlignmentJustified];
    [self addReceiptItemWithName:@"Date mPOS:"
                           value:_response.readerProcessingDate
                       alignment:ReceiptItemAlignmentJustified];
    [self addReceiptItemWithName:@"Date GATE:"
                           value:_response.paynetProcessingDate
                       alignment:ReceiptItemAlignmentJustified];
    [self addReceiptItemWithName:@"Date BANK:"
                           value:_response.acquirerProcessingDate
                       alignment:ReceiptItemAlignmentJustified];
    
    [_tableView reloadData];

    [self showReceiptId:_response.receiptId];
}

- (void)addReceiptItemWithName:(NSString *)name
                         value:(NSString *)value
                     alignment:(ReceiptItemAlignment)alignment {
    [_arrayReceipt addObject:[[ReceiptItem alloc] initWithName:name value:value alignment:alignment]];
}

- (void)addReceiptItemWithName:(NSString *)name
                         value:(NSString *)value
                    secondName:(NSString *)secondName
                   secondValue:(NSString *)secondValue {
    [_arrayReceipt addObject:[[ReceiptItem alloc] initWithName:name value:value secondName:secondName secondValue:secondValue]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayReceipt.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReceiptItem *receiptItem = _arrayReceipt[indexPath.row];
    NSString *cellIdentifier = nil;
    switch (receiptItem.count) {
        case 2:
            cellIdentifier = identCellDouble;
            break;
        default:
            switch (receiptItem.alignment) {
                case ReceiptItemAlignmentCenter:
                    cellIdentifier = receiptItem.name.length > 0 ? identCellCenter : identCellValue;
                    break;
                case ReceiptItemAlignmentLeft:
                    cellIdentifier = identCellLeft;
                    break;
                case ReceiptItemAlignmentRight:
                    cellIdentifier = identCellRight;
                    break;
                default:
                    cellIdentifier = identCellJustified;
                    break;
            }
            break;
    }
    
    ReceiptCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell setReceiptItem:receiptItem];
    [self customizeReceiptCell:cell];
    return cell;
}

#pragma mark - ReceiptControllerProtocol

- (void)showReceiptId:(NSString *)text {
}

- (UIView *)viewForReceipt {
    return nil;
}

- (void)customizeReceiptCell:(UITableViewCell *)cell {
}

@end
