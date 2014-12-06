let directlyDeclaredAdder = { (a: Int, b:Int) -> Int in
    return a + b
}

let inferencedAdder = { (a,b) -> Int in a+b }
