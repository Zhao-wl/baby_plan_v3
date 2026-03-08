## Context

`data-model-design` 变更已完成 9 个业务表的定义，但当前测试覆盖率仅约 7%。现有测试仅包含基础的枚举值测试和文件存在性检查，缺少对表结构、外键关联、索引创建等关键功能的验证。

**当前状态：**
- 表定义文件：9 个（users, families, family_members, babies, activity_records, growth_records, vaccine_library, vaccine_records, age_benchmark_data）
- 现有测试：5 个基础测试（枚举值、文件存在性）
- 缺失测试：表字段验证、外键约束、索引创建、枚举完整性

**约束条件：**
- 测试需在 flutter_test 框架下运行
- Drift 数据库测试需要使用内存数据库或测试专用连接
- 测试应支持 Web 平台（当前开发默认平台）

## Goals / Non-Goals

**Goals:**
- 为所有 9 个业务表创建字段完整性测试
- 为所有外键关联创建约束测试
- 为所有数据库索引创建验证测试
- 为所有枚举类型创建值完整性测试
- 验证软删除字段在支持表中的存在性
- 验证同步字段在支持表中的存在性

**Non-Goals:**
- 不涉及数据库性能测试（已在 database.dart 中有测试方法）
- 不涉及数据迁移测试（需要单独的集成测试环境）
- 不涉及业务逻辑测试（Repository/Service 层）

## Decisions

### 1. 测试文件组织结构

**选择：按功能模块拆分测试文件**

```
test/database/
├── database_test.dart          # 保留现有测试
├── table_structure_test.dart   # 表结构字段测试
├── foreign_keys_test.dart      # 外键关联测试
├── indexes_test.dart           # 索引验证测试
└── enums_test.dart             # 枚举值完整性测试
```

**选择理由：**
- 单一职责：每个测试文件专注一个测试维度
- 可维护性：新增表时只需在对应文件添加测试
- 执行效率：可单独运行特定维度的测试

### 2. 测试策略：编译时检查 vs 运行时验证

**选择：混合策略**

- **枚举测试**：运行时验证，确保值与规格一致
- **字段测试**：编译时检查（导入成功 = 字段存在）+ 运行时验证（类型正确）
- **索引测试**：运行时验证，查询 SQLite 系统表确认索引存在
- **外键测试**：运行时验证，通过插入测试验证约束

**选择理由：**
- 编译时检查快速失败，适合结构性验证
- 运行时验证确保实际行为符合预期

### 3. 外键测试策略

**选择：正向验证 + 反向约束测试**

```dart
// 正向：验证外键关系可建立
test('Baby can be linked to family', () async {
  // 插入家庭 → 插入宝宝 → 验证关联
});

// 反向：验证无效外键被拒绝
test('Baby with invalid familyId should fail', () async {
  // 尝试插入无效 familyId → 预期失败
});
```

**选择理由：**
- 双向验证确保外键约束真正生效
- Drift 默认不强制外键约束，需显式启用

## Risks / Trade-offs

| 风险 | 影响 | 缓解措施 |
|------|------|----------|
| Drift 内存数据库与实际数据库行为差异 | 中 | 使用相同的 connection.dart 配置 |
| 外键约束默认未启用 | 中 | 测试前显式启用外键约束 |
| Web 平台 SQLite 限制 | 低 | 测试使用 sqflite_common_ffi_web 兼容模式 |
| 测试运行时间增加 | 低 | 使用分组和并行测试优化 |

**Trade-offs：**
- 不创建 Repository 层测试：专注于表结构验证，业务逻辑测试留待后续
- 不测试数据迁移：迁移测试需要复杂的环境设置，建议单独处理