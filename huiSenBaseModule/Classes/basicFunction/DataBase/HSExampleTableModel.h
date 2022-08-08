//
//  HSExampleTableModel.h
//  huiSenSmart
//
//  Created by jonkersun on 2021/11/11.
//

#import "HSBaseDataTableModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HSExampleTableModel : HSBaseDataTableModel<HSBaseDataTableModelProtocol>
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *height;


@end

NS_ASSUME_NONNULL_END
