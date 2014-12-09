let accumulator = {
    (initial:Int, handler:(Int, Int)->Int) -> ([Int]->Int) in

    return { (array:[Int]) -> Int in
        reduce(array, initial, handler)
    }
}

let summer = accumulator(0, {$0 + $1})
println(summer(array))
