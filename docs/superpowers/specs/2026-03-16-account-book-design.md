# 记账本应用设计文档

## 概述

记账本是一个 Flutter 功能模块，支持日常个人记账和项目/旅行记账场景，提供灵活的分摊功能和丰富的统计分析。

## 需求概要

| 方面 | 描述 |
|------|------|
| 定位 | 现有项目的功能模块，从 demo 列表进入 |
| 场景 | 日常个人记账 + 项目/旅行记账 |
| 数据存储 | 本地优先（SQLite），预留云端同步接口 |
| 账本结构 | 主账本 + 子账本 |
| 分类管理 | 可自定义，支持图标和颜色 |
| 分摊功能 | 灵活分摊（平均/比例/指定金额） |
| 统计报表 | 基础统计 + 详细报表 + 自定义报表 |
| UI 风格 | 卡片可视化 |
| 记账入口 | 快速记账 + 完整记账 |

## 数据模型

### 核心实体

#### Book（账本）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | String | 账本ID |
| name | String | 账本名称 |
| type | BookType | 主账本 / 子账本 |
| icon | String | 图标 |
| color | int | 主题色 |
| createdAt | DateTime | 创建时间 |
| isArchived | bool | 是否归档 |

#### Member（成员）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | String | 成员ID |
| bookId | String | 所属账本 |
| name | String | 名称 |
| avatar | String? | 头像（emoji或颜色） |
| phone | String? | 手机号 |
| email | String? | 邮箱 |

#### Category（分类）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | String | 分类ID |
| bookId | String? | 所属账本（null为全局默认） |
| name | String | 分类名称 |
| type | CategoryType | 收入 / 支出 |
| icon | String | 图标 |
| color | int | 颜色 |
| sortOrder | int | 排序 |
| isDefault | bool | 是否预设分类 |

#### Record（记账记录）

| 字段 | 类型 | 说明 |
|------|------|------|
| id | String | 记录ID |
| bookId | String | 所属账本 |
| amount | double | 金额 |
| type | RecordType | 收入 / 支出 |
| categoryId | String | 分类ID |
| date | DateTime | 日期 |
| note | String? | 备注 |
| splits | List\<Split\>? | 分摊明细（可选） |
| payerId | String? | 垫付人ID（分摊场景） |
| attachments | List\<String\>? | 附件（票据图片） |
| createdAt | DateTime | 创建时间 |

#### Split（分摊明细）

| 字段 | 类型 | 说明 |
|------|------|------|
| memberId | String | 成员ID |
| amount | double | 分摊金额 |
| splitType | SplitType | 平均 / 比例 / 指定金额 |
| ratio | double? | 比例（按比例分摊时） |

### 实体关系

```
Book (1) ──────< (N) Category
  │
  └────────────< (N) Record
                    │
                    └────────< (N) Split

Book (1) ──────< (N) Member
                    │
                    └────────< (N) Split
```

## 页面与导航

### 页面结构

```
记账本模块入口
    │
    ├── 首页仪表盘 (Dashboard)
    │   ├── 账本切换
    │   ├── 快捷记账入口
    │   ├── 今日/本月概览
    │   ├── 最近记录列表
    │   └── 统计图表入口
    │
    ├── 记账页面 (AddRecord)
    │   ├── 快速记账
    │   ├── 完整记账
    │   └── 分摊设置
    │
    ├── 我的页面 (Profile)
    │   ├── 分类管理
    │   ├── 账本管理
    │   ├── 成员管理
    │   └── 数据备份/导出
    │
    ├── 记录详情 (RecordDetail)
    ├── 统计报表 (Statistics)
    └── 分摊详情 (SplitDetail)
```

### 底部导航

| Tab | 功能 |
|-----|------|
| 首页 | 展示当前账本概览，支持快速切换主/子账本 |
| 记账 | 悬浮按钮，点击弹出快速记账面板，长按或上滑进入完整记账 |
| 我的 | 分类管理、账本管理、成员管理、设置 |

## 核心功能流程

### 记账流程

1. 用户点击 ➕ 按钮
2. 弹出快速记账面板（底部卡片）
   - 金额输入（大字体）
   - 常用分类横向滚动选择
   - 收入/支出切换
   - 保存 / 更多选项
3. 选择「更多」展开完整记账
   - 金额、分类
   - 日期、时间
   - 备注
   - 分摊设置
   - 添加附件
4. 保存记录

### 分摊流程

1. 记账时开启「分摊」开关
2. 从账本成员中选择参与人员
3. 选择分摊方式
   - 平均分摊：自动计算每人金额
   - 按比例分摊：输入每人比例
   - 指定金额：输入每人具体金额
4. 选择垫付人（谁先付的钱）
5. 保存记录，生成分摊明细

### 账本管理流程

1. 主账本默认创建
2. 可创建子账本
   - 设置名称、图标、颜色
   - 添加成员
   - 可设置预算
3. 子账本可归档/结算

## 组件设计

### 首页仪表盘

- 顶部：账本切换下拉、统计/日历入口
- 本月收支卡片：显示支出/收入金额及环比变化
- 支出分类卡片：图标 + 名称 + 金额
- 最近记录列表：图标 + 分类 + 备注 + 金额 + 时间
- 悬浮记账按钮

### 快速记账面板

- 收入/支出切换
- 大字体金额输入
- 常用分类横向滚动
- 取消 / 保存 / 更多操作

### 记录详情页

- 金额 + 分类卡片
- 备注信息
- 账本、创建时间
- 分摊明细（如适用）
- 附件展示
- 删除操作

### 统计报表页

- 时间范围选择器
- 支出趋势折线图
- 分类占比饼图 + 柱状条
- 同比环比数据
- 自定义报表入口

## 技术实现

### 目录结构

```
lib/account_book/
├── main.dart                        # 模块入口
│
├── data/
│   ├── models/                      # 数据模型
│   │   ├── book.dart
│   │   ├── category.dart
│   │   ├── record.dart
│   │   ├── split.dart
│   │   └── member.dart
│   │
│   ├── sources/
│   │   ├── local/                   # 本地数据源
│   │   │   ├── database.dart
│   │   │   ├── books_dao.dart
│   │   │   ├── categories_dao.dart
│   │   │   ├── records_dao.dart
│   │   │   └── members_dao.dart
│   │   └── remote/                  # 云端接口（预留）
│   │       └── sync_service.dart
│   │
│   └── repositories/                # 数据仓库
│       ├── book_repository.dart
│       ├── category_repository.dart
│       ├── record_repository.dart
│       └── member_repository.dart
│
├── domain/
│   ├── usecases/                    # 业务用例
│   │   ├── add_record.dart
│   │   ├── calculate_split.dart
│   │   ├── get_statistics.dart
│   │   └── export_data.dart
│   └── utils/                       # 工具类
│       ├── split_calculator.dart
│       └── date_utils.dart
│
├── presentation/
│   ├── providers/                   # Riverpod 状态
│   │   ├── books_provider.dart
│   │   ├── records_provider.dart
│   │   ├── categories_provider.dart
│   │   └── statistics_provider.dart
│   │
│   ├── pages/                       # 页面
│   │   ├── dashboard_page.dart
│   │   ├── add_record_page.dart
│   │   ├── record_detail_page.dart
│   │   ├── statistics_page.dart
│   │   ├── profile_page.dart
│   │   ├── book_manage_page.dart
│   │   ├── category_manage_page.dart
│   │   └── member_manage_page.dart
│   │
│   └── widgets/                     # 组件
│       ├── quick_record_sheet.dart
│       ├── record_card.dart
│       ├── category_picker.dart
│       ├── member_picker.dart
│       ├── split_panel.dart
│       ├── amount_input.dart
│       ├── chart_widgets/
│       │   ├── trend_chart.dart
│       │   └── pie_chart.dart
│       └── common/
│           ├── app_card.dart
│           └── empty_state.dart
│
└── di/
    └── providers.dart               # 依赖注入
```

### 数据库表设计

```sql
-- 账本表
CREATE TABLE books (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    type INTEGER NOT NULL,        -- 0: 主账本, 1: 子账本
    icon TEXT NOT NULL,
    color INTEGER NOT NULL,
    created_at INTEGER NOT NULL,
    is_archived INTEGER DEFAULT 0
);

-- 成员表
CREATE TABLE members (
    id TEXT PRIMARY KEY,
    book_id TEXT NOT NULL,
    name TEXT NOT NULL,
    avatar TEXT,
    phone TEXT,
    email TEXT,
    FOREIGN KEY (book_id) REFERENCES books(id)
);

-- 分类表
CREATE TABLE categories (
    id TEXT PRIMARY KEY,
    book_id TEXT,                 -- NULL 表示全局默认分类
    name TEXT NOT NULL,
    type INTEGER NOT NULL,        -- 0: 支出, 1: 收入
    icon TEXT NOT NULL,
    color INTEGER NOT NULL,
    sort_order INTEGER DEFAULT 0,
    is_default INTEGER DEFAULT 0,
    FOREIGN KEY (book_id) REFERENCES books(id)
);

-- 记录表
CREATE TABLE records (
    id TEXT PRIMARY KEY,
    book_id TEXT NOT NULL,
    amount REAL NOT NULL,
    type INTEGER NOT NULL,        -- 0: 支出, 1: 收入
    category_id TEXT NOT NULL,
    date INTEGER NOT NULL,
    note TEXT,
    payer_id TEXT,
    created_at INTEGER NOT NULL,
    FOREIGN KEY (book_id) REFERENCES books(id),
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (payer_id) REFERENCES members(id)
);

-- 分摊表
CREATE TABLE splits (
    id TEXT PRIMARY KEY,
    record_id TEXT NOT NULL,
    member_id TEXT NOT NULL,
    amount REAL NOT NULL,
    split_type INTEGER NOT NULL,  -- 0: 平均, 1: 比例, 2: 指定金额
    ratio REAL,
    FOREIGN KEY (record_id) REFERENCES records(id),
    FOREIGN KEY (member_id) REFERENCES members(id)
);

-- 索引
CREATE INDEX idx_records_book_date ON records(book_id, date);
CREATE INDEX idx_records_category ON records(category_id);
CREATE INDEX idx_splits_record ON splits(record_id);
```

### 依赖包

```yaml
dependencies:
  # 数据库
  sqflite: ^2.3.0
  path: ^1.8.3

  # 状态管理
  flutter_riverpod: ^2.4.9

  # 图表
  fl_chart: ^0.66.0

  # 工具
  intl: ^0.19.0          # 国际化/日期格式化
  uuid: ^4.2.1           # ID生成
  collection: ^1.18.0    # 集合工具

dev_dependencies:
  build_runner: ^2.4.7
```

### 项目集成

在 `lib/model/demo_item.dart` 中添加入口：

```dart
DemoItem(
  title: '记账本',
  subtitle: '个人记账与项目分摊',
  icon: Icons.account_balance_wallet,
  route: '/account_book',
),
```

## 后续扩展

- 云端同步：实现 SyncService，支持多设备数据同步
- 数据导入/导出：支持 CSV、Excel 格式导出
- 预算管理：设置月度/分类预算，超支提醒
- 账单提醒：定期账单自动记录
- 小组件：iOS/Android 桌面小组件快速记账
