infix operator ++ {}
func ++ (lhs: Int->Int, rhs: Int->Int) -> Int->Int {
    return {
        lhs(rhs($0))
    }
}

let increase = {
    (i:Int) -> Int in i+1
}
let doubleIncrease = increase ++ increase
println(doubleIncrease(1))
