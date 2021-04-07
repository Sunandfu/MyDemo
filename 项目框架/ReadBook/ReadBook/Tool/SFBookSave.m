//
//  SFBookSave.m
//  ReadBook
//
//  Created by lurich on 2020/5/20.
//  Copyright © 2020 lurich. All rights reserved.
//

#import "SFBookSave.h"
#import <FMDB/FMDB.h>

#define DataBasePath [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"Database.db"]

@implementation SFBookSave

+ (FMDatabaseQueue *)defaultDatabaseQueue
{
    static FMDatabaseQueue * databaseQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        databaseQueue = [FMDatabaseQueue databaseQueueWithPath:DataBasePath];
        NSLog(@"数据库路径:%@",DataBasePath);
    });
    return databaseQueue;
}

#pragma mark - User

NSString * createBook = @"create table if not exists Books(ID integer primary key autoincrement,bookIcon text,bookTitle text,bookAuthor text,bookSynopsis text,bookDate text,bookUrl text,bookNumber text,bookIndex integer,bookPage integer,pageOffset float,bookCatalog text,bookContent text,bookDelegate integer,other1 text,other2 text,other3 float);";

+ (BOOL)insertBook:(BookModel *)book
{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createBook;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString * insert = [NSString stringWithFormat:@"insert into Books(bookIcon,bookTitle,bookAuthor,bookSynopsis,bookDate,bookUrl,bookNumber,bookIndex,bookPage,pageOffset,bookCatalog,bookContent,bookDelegate,other1,other2,other3)values('%@','%@','%@','%@','%@','%@','%@','%ld','%ld',%lf,'%@','%@','%ld','%@','%@',%lf);",book.bookIcon,book.bookTitle,book.bookAuthor,book.bookSynopsis,book.bookDate,book.bookUrl,book.bookNumber,(long)book.bookIndex,(long)book.bookPage,book.pageOffset,book.bookCatalog,book.bookContent,(long)book.bookDelegate,book.other1,book.other2,book.other3];
            work = [db executeUpdate:insert];
        }
    }];
    return work;
}

+ (BOOL)updateBook:(BookModel *)book
{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createBook;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString * update = [NSString stringWithFormat:@"update Books set bookIcon = '%@',bookTitle = '%@',bookAuthor = '%@',bookSynopsis = '%@',bookDate = '%@',bookUrl = '%@',bookNumber = '%@',bookIndex = '%ld',bookPage = '%ld',pageOffset = '%lf',bookCatalog = '%@',bookContent = '%@',bookDelegate = '%ld',other1 = '%@',other2 = '%@',other3 = '%lf' where ID = %ld ;",book.bookIcon,book.bookTitle,book.bookAuthor,book.bookSynopsis,book.bookDate,book.bookUrl,book.bookNumber,(long)book.bookIndex,(long)book.bookPage,book.pageOffset,book.bookCatalog,book.bookContent,(long)book.bookDelegate,book.other1,book.other2,book.other3,(long)book.ID];
            work = [db executeUpdate:update];
        }
    }];
    return work;
}

+ (NSArray<BookModel *> *)selectBook
{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    __block NSMutableArray *books = [NSMutableArray array];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createBook;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString * select = @"select * from Books";
            FMResultSet * set = [db executeQuery:select];
            while ([set next]) {
                BookModel *book = [BookModel new];
                book.ID = [set intForColumn:@"ID"];
                book.bookIcon = [set stringForColumn:@"bookIcon"];
                book.bookTitle = [set stringForColumn:@"bookTitle"];
                book.bookAuthor = [set stringForColumn:@"bookAuthor"];
                book.bookSynopsis = [set stringForColumn:@"bookSynopsis"];
                book.bookDate = [set stringForColumn:@"bookDate"];
                book.bookUrl = [set stringForColumn:@"bookUrl"];
                book.bookNumber = [set stringForColumn:@"bookNumber"];
                book.bookIndex = [set longForColumn:@"bookIndex"];
                book.bookPage = [set longForColumn:@"bookPage"];
                book.pageOffset = [set doubleForColumn:@"pageOffset"];
                book.bookCatalog = [set stringForColumn:@"bookCatalog"];
                book.bookContent = [set stringForColumn:@"bookContent"];
                book.bookDelegate = [set longForColumn:@"bookDelegate"];
                book.other1 = [set stringForColumn:@"other1"];
                book.other2 = [set stringForColumn:@"other2"];
                book.other3 = [set doubleForColumn:@"other3"];
                [books addObject:book];
            }
            [set close];
        }
    }];
    return [NSArray arrayWithArray:books];
}
+ (BookModel *)selectedBookID:(NSInteger)bookID
{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    __block BookModel *book = [BookModel new];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createBook;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString * select = @"select * from Books";
            FMResultSet * set = [db executeQuery:select];
            while ([set next]) {
                NSInteger bookid = [set intForColumn:@"ID"];
                if (bookid == bookID) {
                    book.ID = [set intForColumn:@"ID"];
                    book.bookIcon = [set stringForColumn:@"bookIcon"];
                    book.bookTitle = [set stringForColumn:@"bookTitle"];
                    book.bookAuthor = [set stringForColumn:@"bookAuthor"];
                    book.bookSynopsis = [set stringForColumn:@"bookSynopsis"];
                    book.bookDate = [set stringForColumn:@"bookDate"];
                    book.bookUrl = [set stringForColumn:@"bookUrl"];
                    book.bookNumber = [set stringForColumn:@"bookNumber"];
                    book.bookIndex = [set longForColumn:@"bookIndex"];
                    book.bookPage = [set longForColumn:@"bookPage"];
                    book.pageOffset = [set doubleForColumn:@"pageOffset"];
                    book.bookCatalog = [set stringForColumn:@"bookCatalog"];
                    book.bookContent = [set stringForColumn:@"bookContent"];
                    book.bookDelegate = [set longForColumn:@"bookDelegate"];
                    book.other1 = [set stringForColumn:@"other1"];
                    book.other2 = [set stringForColumn:@"other2"];
                    book.other3 = [set doubleForColumn:@"other3"];
                    break;
                }
            }
            [set close];
        }
    }];
    return book;
}
+ (NSArray<BookModel *> *)selectedBookWithGroupID:(NSInteger)groupID{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    __block NSMutableArray *books = [NSMutableArray array];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createBook;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString * select = @"select * from Books";
            FMResultSet * set = [db executeQuery:select];
            while ([set next]) {
                CGFloat groupid = [set longForColumn:@"bookDelegate"];
                if (groupid == groupID) {
                    BookModel *book = [BookModel new];
                    book.ID = [set intForColumn:@"ID"];
                    book.bookIcon = [set stringForColumn:@"bookIcon"];
                    book.bookTitle = [set stringForColumn:@"bookTitle"];
                    book.bookAuthor = [set stringForColumn:@"bookAuthor"];
                    book.bookSynopsis = [set stringForColumn:@"bookSynopsis"];
                    book.bookDate = [set stringForColumn:@"bookDate"];
                    book.bookUrl = [set stringForColumn:@"bookUrl"];
                    book.bookNumber = [set stringForColumn:@"bookNumber"];
                    book.bookIndex = [set longForColumn:@"bookIndex"];
                    book.bookPage = [set longForColumn:@"bookPage"];
                    book.pageOffset = [set doubleForColumn:@"pageOffset"];
                    book.bookCatalog = [set stringForColumn:@"bookCatalog"];
                    book.bookContent = [set stringForColumn:@"bookContent"];
                    book.bookDelegate = [set longForColumn:@"bookDelegate"];
                    book.other1 = [set stringForColumn:@"other1"];
                    book.other2 = [set stringForColumn:@"other2"];
                    book.other3 = [set doubleForColumn:@"other3"];
                    [books addObject:book];
                }
            }
            [set close];
        }
    }];
    return [NSArray arrayWithArray:books];
}
+ (BookModel *)selectedBookNumber:(NSString *)bookNumber{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    __block BookModel *book = [BookModel new];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createBook;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString * select = @"select * from Books";
            FMResultSet * set = [db executeQuery:select];
            while ([set next]) {
                NSString *bookNum = [set stringForColumn:@"bookNumber"];
                if ([bookNum isEqualToString:bookNumber]) {
                    book.ID = [set intForColumn:@"ID"];
                    book.bookIcon = [set stringForColumn:@"bookIcon"];
                    book.bookTitle = [set stringForColumn:@"bookTitle"];
                    book.bookAuthor = [set stringForColumn:@"bookAuthor"];
                    book.bookSynopsis = [set stringForColumn:@"bookSynopsis"];
                    book.bookDate = [set stringForColumn:@"bookDate"];
                    book.bookUrl = [set stringForColumn:@"bookUrl"];
                    book.bookNumber = [set stringForColumn:@"bookNumber"];
                    book.bookIndex = [set longForColumn:@"bookIndex"];
                    book.bookPage = [set longForColumn:@"bookPage"];
                    book.pageOffset = [set doubleForColumn:@"pageOffset"];
                    book.bookCatalog = [set stringForColumn:@"bookCatalog"];
                    book.bookContent = [set stringForColumn:@"bookContent"];
                    book.bookDelegate = [set longForColumn:@"bookDelegate"];
                    book.other1 = [set stringForColumn:@"other1"];
                    book.other2 = [set stringForColumn:@"other2"];
                    book.other3 = [set doubleForColumn:@"other3"];
                    break;
                }
            }
            [set close];
        }
    }];
    return book;
}
+ (BOOL)deleteBook:(BookModel *)book;
{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createBook;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString *delete = [NSString stringWithFormat:@"delete from Books where ID = %ld",(long)book.ID];
            work = [db executeUpdate:delete];
        }
    }];
    return work;
}
+ (BOOL)deleteBookTable
{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createBook;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString * delete = [NSString stringWithFormat:@"drop table if exists Books"];
            work = [db executeUpdate:delete];
        }
    }];
    return work;
}
+ (BOOL)isHaveBook:(BookModel *)book{
    NSArray *bookArray = [SFBookSave selectBook];
    for (BookModel *model in bookArray) {
        if ([model.bookNumber isEqualToString:book.bookNumber] ) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - LocalBook

NSString * createLocalBook = @"create table if not exists LocalBooks(ID integer primary key autoincrement,name text,path text,type text,readTime text,menuData text,contentData text,bookIndex integer,bookPage integer,pageOffset float,other1 text,other2 text,other3 float);";

//插入某个数据
+ (BOOL)insertLocalBook:(DCBookModel *)book{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createLocalBook;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString * insert = [NSString stringWithFormat:@"insert into LocalBooks(name,path,type,readTime,menuData,contentData,bookIndex,bookPage,pageOffset,other1,other2,other3)values('%@','%@','%@','%@','%@','%@','%ld','%ld',%lf,'%@','%@',%lf);",book.name,book.path,book.type,book.readTime,book.menuData,book.contentData,(long)book.bookIndex,(long)book.bookPage,book.pageOffset,book.other1,book.other2,book.other3];
            work = [db executeUpdate:insert];
        }
    }];
    return work;
}
//删除某个数据
+ (BOOL)deleteLocalBook:(DCBookModel *)book{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createLocalBook;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString *delete = [NSString stringWithFormat:@"delete from LocalBooks where ID = %ld",(long)book.ID];
            work = [db executeUpdate:delete];
        }
    }];
    return work;
}
//更新某个数据
+ (BOOL)updateLocalBook:(DCBookModel *)book{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createLocalBook;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString * update = [NSString stringWithFormat:@"update LocalBooks set name = '%@',path = '%@',type = '%@',readTime = '%@',menuData = '%@',contentData = '%@',bookIndex = '%ld',bookPage = '%ld',pageOffset = '%lf',other1 = '%@',other2 = '%@',other3 = '%lf' where ID = %ld ;",book.name,book.path,book.type,book.readTime,book.menuData,book.contentData,(long)book.bookIndex,(long)book.bookPage,book.pageOffset,book.other1,book.other2,book.other3,(long)book.ID];
            work = [db executeUpdate:update];
        }
    }];
    return work;
}
//查询某个数据  根据书籍ID
+ (DCBookModel *)selectedLocalBookID:(NSInteger)bookID{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    __block DCBookModel *book = [DCBookModel new];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createLocalBook;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString * select = @"select * from LocalBooks";
            FMResultSet * set = [db executeQuery:select];
            while ([set next]) {
                NSInteger bookid = [set intForColumn:@"ID"];
                if (bookid == bookID) {
                    book.ID = [set intForColumn:@"ID"];
                    book.name = [set stringForColumn:@"name"];
                    book.path = [set stringForColumn:@"path"];
                    book.type = [set stringForColumn:@"type"];
                    book.readTime = [set stringForColumn:@"readTime"];
                    book.menuData = [set stringForColumn:@"menuData"];
                    book.contentData = [set stringForColumn:@"contentData"];
                    book.bookIndex = [set longForColumn:@"bookIndex"];
                    book.bookPage = [set longForColumn:@"bookPage"];
                    book.pageOffset = [set doubleForColumn:@"pageOffset"];
                    book.other1 = [set stringForColumn:@"other1"];
                    book.other2 = [set stringForColumn:@"other2"];
                    book.other3 = [set doubleForColumn:@"other3"];
                    break;
                }
            }
            [set close];
        }
    }];
    return book;
}
//查找所有数据
+ (NSArray<DCBookModel *> *)selectLocalBook{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    __block NSMutableArray *books = [NSMutableArray array];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createLocalBook;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString * select = @"select * from LocalBooks";
            FMResultSet * set = [db executeQuery:select];
            while ([set next]) {
                DCBookModel *book = [DCBookModel new];
                book.ID = [set intForColumn:@"ID"];
                book.name = [set stringForColumn:@"name"];
                book.path = [set stringForColumn:@"path"];
                book.type = [set stringForColumn:@"type"];
                book.readTime = [set stringForColumn:@"readTime"];
                book.menuData = [set stringForColumn:@"menuData"];
                book.contentData = [set stringForColumn:@"contentData"];
                book.bookIndex = [set longForColumn:@"bookIndex"];
                book.bookPage = [set longForColumn:@"bookPage"];
                book.pageOffset = [set doubleForColumn:@"pageOffset"];
                book.other1 = [set stringForColumn:@"other1"];
                book.other2 = [set stringForColumn:@"other2"];
                book.other3 = [set doubleForColumn:@"other3"];
                [books addObject:book];
            }
            [set close];
        }
    }];
    return [NSArray arrayWithArray:books];
}
//查询某个数据  根据书籍名称
+ (DCBookModel *)selectedLocalBookName:(NSString *)bookName{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    __block DCBookModel *book = [DCBookModel new];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createLocalBook;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString * select = @"select * from LocalBooks";
            FMResultSet * set = [db executeQuery:select];
            while ([set next]) {
                NSString *name = [set stringForColumn:@"name"];
                if ([name isEqualToString:bookName]) {
                    book.ID = [set intForColumn:@"ID"];
                    book.name = [set stringForColumn:@"name"];
                    book.path = [set stringForColumn:@"path"];
                    book.type = [set stringForColumn:@"type"];
                    book.readTime = [set stringForColumn:@"readTime"];
                    book.menuData = [set stringForColumn:@"menuData"];
                    book.contentData = [set stringForColumn:@"contentData"];
                    book.bookIndex = [set longForColumn:@"bookIndex"];
                    book.bookPage = [set longForColumn:@"bookPage"];
                    book.pageOffset = [set doubleForColumn:@"pageOffset"];
                    book.other1 = [set stringForColumn:@"other1"];
                    book.other2 = [set stringForColumn:@"other2"];
                    book.other3 = [set doubleForColumn:@"other3"];
                    break;
                }
            }
            [set close];
        }
    }];
    return book;
}

#pragma mark - 书籍分组

NSString * createBookGroups = @"create table if not exists BookGroups(ID integer primary key autoincrement,name text,createTime text,other1 text,other2 text,other3 float);";

//插入某个数据
+ (BOOL)insertBookGroup:(SFBookGroupModel *)group{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createBookGroups;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString * insert = [NSString stringWithFormat:@"insert into BookGroups(name,createTime,other1,other2,other3)values('%@','%@','%@','%@',%lf);",group.name,group.createTime,group.other1,group.other2,group.other3];
            work = [db executeUpdate:insert];
        }
    }];
    return work;
}
//删除某个数据
+ (BOOL)deleteBookGroup:(SFBookGroupModel *)group{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createBookGroups;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString *delete = [NSString stringWithFormat:@"delete from BookGroups where ID = %ld",(long)group.ID];
            work = [db executeUpdate:delete];
        }
    }];
    return work;
}
//更新某个数据
+ (BOOL)updateBookGroup:(SFBookGroupModel *)group{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createBookGroups;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString * update = [NSString stringWithFormat:@"update BookGroups set name = '%@',createTime = '%@',other1 = '%@',other2 = '%@',other3 = '%lf' where ID = %ld ;",group.name,group.createTime,group.other1,group.other2,group.other3,(long)group.ID];
            work = [db executeUpdate:update];
        }
    }];
    return work;
}
//查询某个数据  根据书籍ID
+ (SFBookGroupModel *)selectedBookGroupID:(NSInteger)groupID{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    __block SFBookGroupModel *group = [SFBookGroupModel new];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createBookGroups;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString * select = @"select * from BookGroups";
            FMResultSet * set = [db executeQuery:select];
            while ([set next]) {
                NSInteger bookid = [set intForColumn:@"ID"];
                if (bookid == groupID) {
                    group.ID = [set intForColumn:@"ID"];
                    group.name = [set stringForColumn:@"name"];
                    group.createTime = [set stringForColumn:@"createTime"];
                    group.other1 = [set stringForColumn:@"other1"];
                    group.other2 = [set stringForColumn:@"other2"];
                    group.other3 = [set doubleForColumn:@"other3"];
                    break;
                }
            }
            [set close];
        }
    }];
    return group;
}
//查找所有数据
+ (NSArray<SFBookGroupModel *> *)selectBookGroups{
    FMDatabaseQueue * queue = [self defaultDatabaseQueue];
    __block BOOL work = NO;
    __block NSMutableArray *groups = [NSMutableArray array];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db open]) {
            NSString * create = createBookGroups;
            work = [db executeUpdate:create];
            if (!work) {
                [db close];
            }
            NSString * select = @"select * from BookGroups";
            FMResultSet * set = [db executeQuery:select];
            while ([set next]) {
                SFBookGroupModel *group = [SFBookGroupModel new];
                group.ID = [set intForColumn:@"ID"];
                group.name = [set stringForColumn:@"name"];
                group.createTime = [set stringForColumn:@"createTime"];
                group.other1 = [set stringForColumn:@"other1"];
                group.other2 = [set stringForColumn:@"other2"];
                group.other3 = [set doubleForColumn:@"other3"];
                [groups addObject:group];
            }
            [set close];
        }
    }];
    return [NSArray arrayWithArray:groups];
}

@end
