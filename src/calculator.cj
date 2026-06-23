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
