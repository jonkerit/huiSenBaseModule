//
//  HSExampleTableModel.m
//  huiSenSmart
//
//  Created by jonkersun on 2021/11/11.
//

#import "HSExampleTableModel.h"

@implementation HSExampleTableModel
#pragma mark ----HSBaseDataTableModelProtocol----
/// 设置表的名称
+ (NSString*)getTableName{
    return HSExampleTableName;
}
/// 设置联合主键，优先级高于getPrimaryKey
+(NSArray *)getPrimaryKeyUnionArray{
    return @[@"name"];
}
@end
