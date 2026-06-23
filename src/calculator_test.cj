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
