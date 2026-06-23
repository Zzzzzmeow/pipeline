# 仓颉单元测试 CI/CD 流水线

## 一、选用的 CI/CD 流水线

选择 **GitHub Actions** 作为 CI/CD 平台，原因如下：

- GitHub Actions 对公开仓库完全免费，无需购买企业版或额外开通权限
- gitcode.com 和 Gitee 的流水线功能对个人免费账号均有权限限制，无法使用
- 仓颉编译器是华为自研闭源工具链，不在任何 CI 平台的公共镜像中，因此采用**自托管 Runner** 模式，部署在已安装仓颉工具链的 Linux 主机上，Runner 注册后与 GitHub 仓库保持长连接，监听并执行流水线任务

## 二、搭建过程

### 2.1 初始化仓颉项目

使用仓颉包管理工具 `cjpm` 创建项目骨架：

```bash
$ cjpm init --path . --name z_pipeline --type executable
cjpm init success
```

生成文件：`cjpm.toml`（项目配置）、`src/main.cj`（入口文件）。

### 2.2 编写源代码

创建计算器模块 `src/calculator.cj`，实现加减乘除和阶乘五个方法，对除零和负数阶乘抛出异常：

```cangjie
package z_pipeline

public class Calculator {
    public func add(a: Int64, b: Int64): Int64 {
        return a + b
    }

    public func subtract(a: Int64, b: Int64): Int64 {
        return a - b
    }

    public func multiply(a: Int64, b: Int64): Int64 {
        return a * b
    }

    public func divide(a: Int64, b: Int64): Float64 {
        if (b == 0) {
            throw Exception("division by zero")
        }
        return Float64(a) / Float64(b)
    }

    public func factorial(n: Int64): Int64 {
        if (n < 0) {
            throw Exception("negative input")
        }
        if (n <= 1) {
            return 1
        }
        return n * factorial(n - 1)
    }
}
```

### 2.3 编写单元测试

创建测试文件 `src/calculator_test.cj`，共 7 个用例，覆盖正常路径、边界值、异常场景：

```cangjie
package z_pipeline

@Test
class CalculatorTest {

    @TestCase
    func testAdd() {
        let calc = Calculator()
        @Expect(calc.add(2, 3), 5)
        @Expect(calc.add(-1, 1), 0)
        @Expect(calc.add(0, 0), 0)
        @Expect(calc.add(-5, -3), -8)
    }

    @TestCase
    func testSubtract() {
        let calc = Calculator()
        @Expect(calc.subtract(10, 3), 7)
        @Expect(calc.subtract(0, 5), -5)
        @Expect(calc.subtract(-3, -7), 4)
    }

    @TestCase
    func testMultiply() {
        let calc = Calculator()
        @Expect(calc.multiply(3, 4), 12)
        @Expect(calc.multiply(-2, 5), -10)
        @Expect(calc.multiply(0, 100), 0)
        @Expect(calc.multiply(-3, -3), 9)
    }

    @TestCase
    func testDivide() {
        let calc = Calculator()
        @Expect(calc.divide(10, 2), 5.0)
        @Expect(calc.divide(7, 2), 3.5)
        @Expect(calc.divide(-6, 2), -3.0)
    }

    @TestCase
    func testDivideByZeroThrows() {
        let calc = Calculator()
        var caught = false
        try {
            calc.divide(5, 0)
        } catch (e: Exception) {
            caught = true
        }
        @Expect(caught, true)
    }

    @TestCase
    func testFactorial() {
        let calc = Calculator()
        @Expect(calc.factorial(0), 1)
        @Expect(calc.factorial(1), 1)
        @Expect(calc.factorial(5), 120)
        @Expect(calc.factorial(10), 3628800)
    }

    @TestCase
    func testFactorialNegativeThrows() {
        let calc = Calculator()
        var caught = false
        try {
            calc.factorial(-1)
        } catch (e: Exception) {
            caught = true
        }
        @Expect(caught, true)
    }
}
```

### 2.4 配置 CI/CD 流水线

创建 `.github/workflows/ci.yml`，定义 push 到 `main` 分支时自动触发三阶段流水线：

```yaml
name: Cangjie CI/CD

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build-and-test:
    runs-on: self-hosted
    env:
      CANGJIE_HOME: /root/cangjie
    steps:
      - uses: actions/checkout@v4

      - name: Verify environment
        run: |
          export PATH="${CANGJIE_HOME}/bin:${CANGJIE_HOME}/tools/bin:${PATH}"
          cjc --version
          cjpm --version

      - name: Build
        run: |
          export PATH="${CANGJIE_HOME}/bin:${CANGJIE_HOME}/tools/bin:${PATH}"
          cjpm build

      - name: Unit test
        run: |
          export PATH="${CANGJIE_HOME}/bin:${CANGJIE_HOME}/tools/bin:${PATH}"
          cjpm test --verbose
```

### 2.5 注册 Runner 并推送

在 GitHub 项目页面 Settings → Actions → Runners → New self-hosted runner 获取注册 token，在装有仓颉工具链的主机上执行注册并启动 Runner，随后推送代码即可触发流水线。

## 三、最终结果

流水线自动执行后输出：

```
--------------------------------------------------------------------------------------------------
TP: z_pipeline, time elapsed: 1163250 ns, RESULT:
    TCS: CalculatorTest, time elapsed: 1163250 ns, RESULT:
    [ PASSED ] CASE: testAdd (130720 ns)
    [ PASSED ] CASE: testSubtract (8948 ns)
    [ PASSED ] CASE: testMultiply (9687 ns)
    [ PASSED ] CASE: testDivide (9030 ns)
    [ PASSED ] CASE: testDivideByZeroThrows (27763 ns)
    [ PASSED ] CASE: testFactorial (8956 ns)
    [ PASSED ] CASE: testFactorialNegativeThrows (10710 ns)
Summary: TOTAL: 7
    PASSED: 7, SKIPPED: 0, ERROR: 0
    FAILED: 0
--------------------------------------------------------------------------------------------------
cjpm test success
```

**总计 7 个用例全部通过，0 失败，0 跳过。** GitHub Actions 页面显示 `build-and-test` 绿色 ✓。

## 四、文件结构

```
z_pipeline/
├── .github/workflows/ci.yml    # GitHub Actions 流水线配置
├── cjpm.toml                   # 仓颉项目配置
└── src/
    ├── main.cj                 # 程序入口
    ├── calculator.cj           # 计算器模块（5 个方法）
    └── calculator_test.cj      # 单元测试（7 个用例）
```
