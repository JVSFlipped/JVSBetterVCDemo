# 更好地使用 ViewController
## 前言
viewController 是 iOS 使用的基本元素之一, 是 MVC 中重要的一环, 在代码的编写中, viewController 经常变得很臃肿, 这是因为我们经常让 viewController 做一些本不应该他做的事情, 比如 viewController 的 View 的较为复杂子视图的布局, 属性的修改, 一些子视图的代码逻辑等等.
## 正文
### 1.去除重复的, 不必要的冗余代码.
#### 剥离 tableViewDelegate 和 tableViewDataSource 
tableView 是经常使用的UI控件, tableViewDataSource 和 tableViewDelegate 的代码是几乎每个控制器里面都会出现的东西, 那么如果要构建的 tableView 比较简单, 就可以考虑用通用的 tableViewDelegate 和 tableViewDataSource. 根据我个人习惯, 我一般都会让所有 cell 的 model 继承自一个基础的 model
##### JVSBaseModel.h

```
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JVSBaseModel : NSObject

/**
 * 判断 model 对应的 cell 是否是被选中状态
 */
@property (nonatomic, assign) BOOL isSelected;

/**
 * model 对应 cell 的 identifier
 */
@property (nonatomic, copy) NSString *identifier;


/**
 * cell 的高度
 */
@property (nonatomic, assign) CGFloat cellHeight;


/**
 * 子类一定要实现的方法, 一般用来根据 model 的内容来设置 identifier 以达到区分不同 cell 的目的.
 */
- (void)configureModel;

@end
```
##### JVSTableViewDelegate.h
```
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class JVSBaseModel;
@protocol JVSTabelViewSeletedDelegate

/**
 * 点击 cell 的代理

 @param item 点击的 cell 对应的模型
 */
- (void)selectedCellWithItem:(JVSBaseModel *)item;

@end

/**
 * 通用的 tableView 代理, 支持不同样式的 cell, 但是不支持多个 section, 也不支持 sectionHeader 和 footerHeader.
 */
@interface JVSTableViewDelegate : NSObject <UITableViewDelegate>


/**
 * 点击 cell 时候处理的代理.
 */
@property (nonatomic, weak) id<JVSTabelViewSeletedDelegate, NSObject> delegate;

/**
 * 初始化方法

 @param items 模型数组
 @param delegate 点击cell的代理
 @return 实例
 */
- (instancetype)initWithItems:(NSMutableArray *)items andSelectedDelegate:(id)delegate;

@end

```
##### JVSTableViewDelegate.m
```
#import "JVSTableViewDelegate.h"
#import "JVSBaseModel.h"

@interface JVSTableViewDelegate()

@property (nonatomic, strong) NSMutableArray *itemsArrM;
@end
@implementation JVSTableViewDelegate

- (instancetype)initWithItems:(NSMutableArray *)items andSelectedDelegate:(id)delegate
{
    if (self = [super init]) {
        self.itemsArrM = items;
        self.delegate = delegate;
    }
    return self;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JVSBaseModel *item = self.itemsArrM[indexPath.row];
    return item.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JVSBaseModel *item = self.itemsArrM[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(selectedCellWithItem:)]) {
        [self.delegate selectedCellWithItem:item];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
```
##### JVSTableViewDataSource.h
```
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JVSBaseModel.h"

/**
 * 配置 cell 的 block

 @param cell 需要配置的 cell
 @param item 模型
 */
typedef void (^configureCell)(UITableViewCell *cell, JVSBaseModel *item);

/**
 * 通用的简易 tableViewDataSource, 支持多种不同的 cell, 不过不支持多个 section 以及头部和尾部视图
 */
@interface JVSTableViewDataSource : NSObject<UITableViewDataSource>

/**
 * 配置 cell 的 block
 */
@property (nonatomic, copy) configureCell cellConfigureCellBlock;


/**
 * 模型数组
 */
@property (nonatomic, strong) NSMutableArray *itemsArrM;

/**
 * 初始化方法

 @param items 模型数组
 @param configureCellBlock 配置 cell 的 block
 @return 实例对象
 */
- (instancetype)initWithItems:(NSMutableArray *)items  andConfigureCellBlock:(configureCell)configureCellBlock;
@end

```

##### JVSTableViewDataSource.m
```
#import "JVSTableViewDataSource.h"
#import "JVSBaseModel.h"

@implementation JVSTableViewDataSource

- (instancetype)initWithItems:(NSMutableArray *)items  andConfigureCellBlock:(configureCell)configureCellBlock
{
    if (self = [super init]) {
        self.cellConfigureCellBlock = configureCellBlock;
        self.itemsArrM = items;
    }
    return self;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemsArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JVSBaseModel *item = self.itemsArrM[indexPath.row];
    if (!item.identifier) {
        @throw [NSException exceptionWithName:@"identifierError" reason:
                [NSString stringWithFormat:@"identifier为空"] userInfo:nil];
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:item.identifier];
    if (nil == cell) {
        @throw [NSException exceptionWithName:@"cellNilError" reason:
                [NSString stringWithFormat:@"有取到对应的cell, 请检查该tableView是否注册了%@的cell",item.identifier] userInfo:nil];
    }
    
    self.cellConfigureCellBlock(cell, item);
    return cell;
}
```
#### 使用方式
##### 在 ViewController 中
```
_tableView = [[UITableView alloc] init];
    [_tableView registerClass:[JVSTestTableViewCell class] forCellReuseIdentifier:@"JVSTestCellStyleTitle"];
    [_tableView registerClass:[JVSTestTableViewCell class] forCellReuseIdentifier:@"JVSTestCellStyleImage"];
    
    JVSTableViewDataSource *dataSource =  [[JVSTableViewDataSource alloc] initWithItems:self.itemArrM andConfigureCellBlock:^(UITableViewCell *cell, JVSBaseModel *item) {
        JVSTestTableViewCell *sameCell = (JVSTestTableViewCell *)cell;
        JVSTestCellModel *sameItem = (JVSTestCellModel *)item;
        [sameCell configureCellWithModel:sameItem];
    }];
    _tableView.dataSource = dataSource;
    _tableViewDataSource = dataSource;
    
    JVSTableViewDelegate *delegate = [[JVSTableViewDelegate alloc] initWithItems:self.itemArrM andSelectedDelegate:self];
    _tableViewDelegate = delegate;
    _tableView.delegate = delegate;
    
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-200);
    [self.view addSubview:_tableView];
    
```

有一点需要注意, 由于 tableView 的代理是 weak 引用的, 这里设置完代理后需要自己用一个强引用来引用新建的通用代理, 否则会发生代理自动释放的情况, delegate 和 datasource 都是这样.
### 2.不必要的逻辑, 不要让 viewController 来实现
#### 创建不同类型的 cell, 可以根据不同的 identifier 来实现, 但这个判断不应该在 viewController 中实现, 而应该在 cell 中自行判断.
##### JVSTestTableViewCell.h
```
#import <UIKit/UIKit.h>

@interface JVSTestTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleL;

@property (nonatomic, strong) UIImageView *imageV;

@end
```
这里将两个控件暴露出来是我觉得将配置 cell 的方法写进 cell 的分类里面去, 这样可以有效解耦 cell 和 model. 
##### JVSTestTableViewCell.m
```
#import "JVSTestTableViewCell.h"
@implementation JVSTestTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if ([reuseIdentifier isEqualToString:@"JVSTestCellStyleImage"])
        {
            [self initImageCell];
        } else if([reuseIdentifier isEqualToString:@"JVSTestCellStyleTitle"])
        {
            [self initTitleCell];
        }
    }
    return self;
}

- (void)initTitleCell
{
    _titleL = [[UILabel alloc] init];
    [self.contentView addSubview:_titleL];
}


- (void)initImageCell
{
    _imageV = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageV];
    
}

- (void)layoutSubviews
{
    if ([self.reuseIdentifier isEqualToString:@"JVSTestCellStyleImage"]) {
        self.imageV.frame = self.contentView.bounds;
    } else if ([self.reuseIdentifier isEqualToString:@"JVSTestCellStyleTitle"]) {
        self.titleL.frame = self.contentView.bounds;
    }
}
```
#### 配置 cell 的分类
##### JVSTestTableViewCell.h
```
#import "JVSTestTableViewCell.h"
@class JVSTestCellModel;
@interface JVSTestTableViewCell (ConfigureCellMethod)
- (void)configureCellWithModel:(JVSTestCellModel *)item;
@end
```
##### JVSTestTableViewCell.m
```
#import "JVSTestTableViewCell+ConfigureCellMethod.h"
#import "JVSTestCellModel.h"
@implementation JVSTestTableViewCell (ConfigureCellMethod)

- (void)configureCellWithModel:(JVSTestCellModel *)item
{
    if (item.imageName.length>0) {
        self.imageV.image = [UIImage imageNamed:item.imageName];
    } else {
       self.titleL.text = item.title;
    }
}
@end
```
### 3.合理使用 ViewController 的容器
在 iOS5 之前, view controller 容器是 Apple 的特权。实际上，在 view controller 编程指南中还有一段申明，指出你不应该使用它们。Apple 对 view controllers 的总的建议曾经是“一个 view controller 管理一个全屏幕的内容”。这个建议后来被改为“一个 view controller 管理一个自包含的内容单元”。为什么 Apple 不想让我们构建自己的 tab bar controllers 和 navigation controllers？或者更确切地说，这段代码有什么问题：

```
[viewControllerA.view addSubView:viewControllerB.view]
```
 
![](https://github.com/JVSFlipped/JVSBetterVCDemo/blob/master/view-insertion.png)

UIWindow 作为一个应用程序的根视图（root view），是旋转和初始布局消息等事件产生的来源。在上图中，child view controller 的 view 插入到 root view controller 的视图层级中，被排除在这些事件之外了。View 事件方法诸如 viewWillAppear: 将不会被调用。

在 iOS 5 之前构建自定义的 view controller 容器时，要保存一个 child view controller 的引用，还要手动在 parent view controller 中转发所有 view 事件方法的调用，要做好非常困难。
幸运的是, 在 iOS5 之后, Apple 完善了以 viewController 来作为容器的 API, 具体来说, 添加了以下属性和方法:

```
@property(nonatomic,readonly) NSArray *childViewControllers;

- (void)addChildViewController:(UIViewController *)childController;

- (void)removeFromParentViewController;

- (void)willMoveToParentViewController:(UIViewController *)parent;

- (void)didMoveToParentViewController:(UIViewController *)parent;

- (void)transitionFromViewController:(nonnull UIViewController *) toViewController:(nonnull UIViewController *) duration:(NSTimeInterval) options:(UIViewAnimationOptions) animations:^(void)animations completion:^(BOOL finished)completion;

```

基本上看名字就知道是用来干嘛的, 简单总结如下:

1. addChildiewController:    
   添加子控制器的方法, 之后会自动调用 *willMoveToParentViewController: superVC*    
2. removeFromParentViewController:  
   移除子控制器的方法, 之后会自动调用 *didMoveToParentViewController: nil*  
3. willMoveToParent 当像父 VC 添加子 VC 之后, 该方法会自动调用. 若要从父 VC 移除子 VC, 需要在移除之前调用该方法, 传入参数 nil. 
4. didMoveToParentViewController:   
   当向父 VC 添加子 VC 之后, 该方法不会被自动调用, 从父 VC 移除子 VC 之后, 该方法会自动调用, 传入的参数为 nil.    
5. transitionFromViewController:(nonnull UIViewController *) toViewController:(nonnull UIViewController *) duration:(NSTimeInterval) options:(UIViewAnimationOptions) animations:^(void)animations completion:^(BOOL finished)completion;    
   切换子视图的控制器, 同时 View 显示的内容也会更新, 注意两个控制器必须已经添加到父控制器中. 在调用这个方法前要调用[fromViewController willMoveToParentViewController], 在 completion中, 调用 [toViewController didMoveToParentViewController: self];    

但事实上, 上面某些调用是可以省略的. 示例代码如下:    
添加子控制器:    

```
JVSTestTableVC *TESTVC = [[JVSTestTableVC alloc] init];
// 添加子控制器,必须写,否则此方法结束, TESTVC就被释放了
[self addChildViewController:TESTVC];
//  [TESTVC willMoveToParentViewController:self]; 自动调用, 省略
//  [TESTVC didMoveToParentViewController:self]; 可省略
``` 
移除子控制器:

```
JVSTestVC *childVC = self.childViewControllers.firstObject;
[childVC willMoveToParentViewController:nil];
[childVC removeFromParentViewController];
//    [_TESTChildVC didMoveToParentViewController:nil]; 自动调用, 省略
NSLog(@"还剩%lu个控制器", self.childViewControllers.count); //打印为0
```
## 总结
总的来说, 坚持要更好地使用和简化 ViewController 只需要让他专注于他该做的事情, 并合理运用他的辅助------childViewControllers, 不要让他去处理不属于他的事物, 即可写出整洁清晰的 ViewController 的代码. 以上内容部分参考了 Objc 中国的期刊内容, 其中掺杂了很多我个人的理解和一些处理思路. 并给出了新的 demo文件.   
完整的示例代码:<https://github.com/JVSFlipped/JVSBetterVCDemo.git>

