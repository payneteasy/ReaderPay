//
//  ReaderLocalize.h
//
//  Created by Sergey Anisiforov on 28/11/2017.
//  Copyright © 2017 payneteasy. All rights reserved.
//

#define LocalizedReaderString(key) [NSBundle.mainBundle localizedStringForKey:(key) value:@"" table:@"Reader"]
#define LocalizedReaderFormatString(fmt, ...) [NSString stringWithFormat:LocalizedReaderString(fmt), __VA_ARGS__]

