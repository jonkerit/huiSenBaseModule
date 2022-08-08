//
//  HSBaseDataTableModel.m
//  huiSenSmart
//
//  Created by jonkersun on 2021/5/21.
//

#import "HSBaseDataTableModel.h"
#import <objc/runtime.h>

@implementation HSBaseDataTableModel
- (instancetype)init {
    self = [super init];
    if (self && [self conformsToProtocol:@protocol(HSBaseDataTableModelProtocol)]) {
       
    } else if (self != nil){
        NSException *exception = [NSException exceptionWithName:@"HSBaseDataTableModel init error" reason:[NSString stringWithFormat:@"the child class==(%@) must conforms to protocol: <HSBaseDataTableModelProtocol>",NSStringFromClass([self class])] userInfo:nil];
        @throw exception;
    }
    return self;
}
#pragma mark  ----  查  ----
+ (NSArray <HSBaseDataTableModel *>*)table_SearchAllModelWithOrderBy:(BOOL)orderBy {
    if (orderBy) {
        return [self searchWithCount:0 offset:0 orderBy:nil where:nil];
    }else{
        return [self searchWithCount:0 offset:0 orderBy:@"rowid desc" where:nil];
    }
}

+ (NSArray <HSBaseDataTableModel *>*)table_SearchAllModelWithProperty:(NSString *)mainKey OrderBy:(BOOL)orderBy {
    NSString *key = @"rowid";
    if (mainKey != nil) {
        NSArray *propertyArray = [self getClassProperties:[self class]];
        if ([propertyArray containsObject:mainKey]) {
            key = mainKey;
        }
    }
    NSString *condiction = [NSString stringWithFormat:@"%@ desc",key];
    if (orderBy) {
        return [self searchWithCount:0 offset:0 orderBy:nil where:nil];
    }else{
        return [self searchWithCount:0 offset:0 orderBy:condiction where:nil];
    }
}

+ (NSArray <HSBaseDataTableModel *>*)table_SearchLastModelWithCount:(NSInteger)count {
    return [self searchWithCount:count offset:0 orderBy:@"rowid desc" where:nil];
}

+ (NSArray <HSBaseDataTableModel *>*)table_SearchModelWithVersusCondition:(id)condition{
    return [self searchWithCount:0 offset:0 orderBy:@"rowid desc" where:condition];
}

+ (NSArray <HSBaseDataTableModel *>*)table_SearchModelWithOrCondition:(NSString *)condition {
    return [self searchWithCount:0 offset:0 orderBy:@"rowid desc" where:condition];
}

+ (NSArray <HSBaseDataTableModel *>*)table_SearchModelWithInCondition:(id)condition {
    return [self searchWithCount:0 offset:0 orderBy:@"rowid" where:condition];
}

+ (NSInteger)table_SearchModelGetRowCountWithWhere:(NSString *)condition {
   return [self rowCountWithWhere:condition];
}

+ (NSArray <HSBaseDataTableModel *>*)searchWithCount:(NSInteger)count offset:(NSInteger)offset orderBy:(NSString *)orderBy where:(id)where {
    NSArray <HSBaseDataTableModel *>*modelArray = [self searchWithWhere:where orderBy:orderBy offset:offset count:count];
    return modelArray;
}
// 返回当前类的所有属性
+ (instancetype)getClassProperties:(Class)cls {
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        
        // An opaque type that represents an Objective-C declared property.
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [mArray addObject:name];
    }
    return mArray.copy;
}
#pragma mark  ----  删  ----
- (BOOL)table_DeleteModelFromDB {
    BOOL isExist = [self isExistsFromDB];
    if (isExist) {
        return [self deleteToDB];
    } else {
        return YES;
    }
}

+ (BOOL)table_DeleteDataFromDBWithCondition:(NSString *)condition {
    NSArray <HSBaseDataTableModel *>*modelArray = [self searchWithWhere:nil orderBy:@"rowid desc" offset:0 count:0];
    if (modelArray.count==0) {
        return YES;
    } else {
        return [self deleteWithWhere:condition];
    }
}

#pragma mark  ----  改  ----

+ (BOOL)table_UpdateFromDBWithFrom:(NSString *)from to:(NSString *)to {
    return [self updateToDBWithSet:to where:from];
}
- (BOOL)table_UpDateToDB {
    if ([self isExistsFromDB]) {
        return [self.class updateToDB:self where:nil]; // 更新一条数据
    }else {
        return [self saveToDB]; // 插入一条新数据
    }
}

#pragma mark  ----  保存  ----

- (BOOL)table_Save {
    return [self saveToDB];  // 插入一条新数据
}

+ (BOOL)table_SaveAllWithModels:(NSArray <HSBaseDataTableModel *>*)modelArray {
    if (modelArray.count == 0) {
        return NO;
    }
    BOOL temp = YES;
    for (id obj in modelArray) {
        BOOL isOK = [obj table_UpDateToDB];
        if (!isOK) {
            return isOK;
        }
    }
    return temp;
}

#pragma mark  ----  参数  ----

/**
 将父类的属性映射到sqlite库表
 */
+ (BOOL)isContainParent {
    return YES;
}

+ (BOOL)getAutoUpdateSqlColume {
    return YES;
}

@end
