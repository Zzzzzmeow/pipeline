# 仓颉单元测试 CI/CD 流水线

## 选型

GitHub Actions，公开仓库免费，无权限限制。自托管 Runner 部署在已安装仓颉工具链的 Linux 主机上。

## 触发

push 到 `main` 分支自动执行。

## 流水线阶段

| 阶段 | 操作 |
|------|------|
| 环境检查 | `cjc --version` / `cjpm --version` |
| 构建 | `cjpm build` |
| 单元测试 | `cjpm test --verbose` |

## 测试覆盖

`CalculatorTest` 共 7 个用例：加法、减法、乘法、除法、除零异常、阶乘、负数阶乘异常。

## 最终结果

```
TOTAL: 7    PASSED: 7    FAILED: 0    SKIPPED: 0
```

## 项目文件

```
z_pipeline/
├── .github/workflows/ci.yml    # GitHub Actions 配置
├── cjpm.toml
└── src/
    ├── calculator.cj           # 计算器模块
    └── calculator_test.cj      # 单元测试
```
