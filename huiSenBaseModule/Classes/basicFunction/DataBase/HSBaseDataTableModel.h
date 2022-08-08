//
//  HSBaseDataTableModel.h
//  huiSenSmart
//
//  Created by jonkersun on 2021/5/21.
//

#import <Foundation/Foundation.h>
#import "NSObject+LKDBHelper.h"


#pragma mark  ------------  以下是该APP数据库的所有表格的表格名称  -----------------
static NSString *const HSExampleTableName = @"HSExampleTableModel";              // 示例表

#pragma mark  ------------  子类需要遵循和实现的协议  ----------------
@protocol HSBaseDataTableModelProtocol <NSObject>
@required
/// 设置表的名称
+ (NSString *)getTableName;
/// 设置联合主键，优先级高于getPrimaryKey
+(NSArray *)getPrimaryKeyUnionArray;
@optional
/// 设置主键
+ (NSString *)getPrimaryKey;
/**
 将父类的属性映射到sqlite库表
 */
+ (BOOL)isContainParent;

+ (BOOL)getAutoUpdateSqlColume;

@end

@interface HSBaseDataTableModel : NSObject
#pragma mark  ------------  查  ------------
/// 根据类型，返回对应表格中所有模型集合
/// @param orderBy orderBy 正序或者倒叙排列数据  (yes 正序，  NO 倒叙)
+ (NSArray <HSBaseDataTableModel *>*)table_SearchAllModelWithOrderBy:(BOOL)orderBy;

/// 根据需要排序的关键字，返回对应表格中所有模型集合
/// @param mainKey 所需要的排序的关键字,不传默认rowid
/// @param orderBy 正序或者倒叙排列数据  (yes 正序，  NO 倒叙)
+ (NSArray <HSBaseDataTableModel *>*)table_SearchAllModelWithProperty:(NSString *)mainKey OrderBy:(BOOL)orderBy;

/// 根据表格类型，查询对应表格中最新的N条数据
/// @param count count 获取数据的数量
+ (NSArray <HSBaseDataTableModel *>*)table_SearchLastModelWithCount:(NSInteger)count;

/// 根据 and(与) 条件 查询对应表格中符合条件的数据模型
/// @param condition 例如 @"outpointIndex = 23 and transactionID = 'xxxxxx'"  也可以传入字典@{@"outpointIndex" : @23, @"transactionID" : @"xxxxxx"}
+ (NSArray <HSBaseDataTableModel *>*)table_SearchModelWithVersusCondition:(id)condition;

/// 根据 or(或) 条件 查询对应表格中符合条件的数据模型
/// @param condition 例如 @"outpointIndex = '23' or rowid = '5'";
+ (NSArray <HSBaseDataTableModel *>*)table_SearchModelWithOrCondition:(NSString *)condition;

/// 根据 in 条件 查询对应表格中符合条件的数据模型
/// @param condition 例如 @"outpointIndex in (23, 24)"  也可以传入字典@{@"outpointIndex" : @[@23, @24]};
+ (NSArray <HSBaseDataTableModel *>*)table_SearchModelWithInCondition:(id)condition;

/// 查询符合条件的数据有多少条
/// @param condition condition 例如@"outpointIndex = 23 and transactionID = 'xxxxx'"
+ (NSInteger)table_SearchModelGetRowCountWithWhere:(NSString *)condition;


#pragma mark  ------------  删  ------------
// 可以每一个子类根据自己的表的关键词做一个方法重写
- (BOOL)table_DeleteModelFromDB;

/// 根据条件删除多条数据
/// @param condition 例如@"name = ‘jake’ and age = '24' "
+ (BOOL)table_DeleteDataFromDBWithCondition:(NSString *)condition;
#pragma mark  ------------  改  ------------

/// 根据条件修改数据
/// @param from 条件 例如: @"name = 'xxxxxx'"
/// @param to 修改为 例如  @"name = 'wxy'"
+ (BOOL)table_UpdateFromDBWithFrom:(NSString *)from to:(NSString *)to;

/// 可以每一个子类根据自己的表的关键词做一个方法重写
- (BOOL)table_UpDateToDB;

#pragma mark  ------------  增  ------------
/// 保存数据模型到数据库表格中
- (BOOL)table_Save;

/// 保存多条数据模型到数据库表格中
/// @param modelArray 需要保存的数据组
+ (BOOL)table_SaveAllWithModels:(NSArray <HSBaseDataTableModel *>*)modelArray;
@end
