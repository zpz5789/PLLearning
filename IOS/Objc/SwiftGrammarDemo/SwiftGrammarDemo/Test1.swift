//
//  Test1.swift
//  SwiftGrammarDemo
//
//  Created by zpz on 2019/4/25.
//  Copyright © 2019 zpz. All rights reserved.
//

import Foundation

func test1() -> Void {
    let a = 10
    // 这是一个注释
    print("a ->\(a)")
    
    let three = 3
    let pointOneFourOneFiveNine = 0.1415
    let pi = Double(three) + pointOneFourOneFiveNine
    print(pi)
    
    let inttegerPi = Int(pi)
    print(inttegerPi)
    
    // 别名
    typealias AudioSample = UInt16
    
    // bool
    _ = true
    _ = false
    
    // 元祖
    let tuples = (404, "Not found")
    let (statusCode, statusMessage) = tuples
    print("\(statusCode),\(statusMessage)")
    
    // 可选值
    var serverResponseCode: Int? = 404
    serverResponseCode = nil
    
    var surveyAnswer: String?
    
    
    // 空合运算符 a??a ， 将对可选类型a进行空判断，如果a包含一个值就进行解封，否则就返回一个默认值
    
    // 区间运算符 （a..b） (a..<b)
    
    // 逻辑运算符 短路运算
    
    // 字符串
    var emptyString = ""
    var anotherEmptyString = String()
    if emptyString.isEmpty {
        print("Nothing to see here")
    }
    
    for character in "Dog!".characters {
        print(character)
    }
    
    let excalamationMark: Character = "!"
    
    var greeting = "guten tag"
    greeting.insert("3", at: greeting.endIndex)
    greeting.remove(at: greeting.endIndex)
    let range = greeting.index(greeting.endIndex, offsetBy: -3)..<greeting.endIndex
    greeting.removeSubrange(range)
    
    greeting.hasPrefix("a")
    greeting.hasSuffix("b")
    
    
    // 集合 Arrays/ sets/ dictionaries
    // 数组
    var someInts = [Int]()
    someInts.append(3)
    var threeDoubles = Array(repeating: 0, count: 3)
    
    var shoppingList: [String] = ["Eggs", "Milk", "youtiao"]
    
    shoppingList += ["Baking powder"]
    
    shoppingList[0] = "Six egg"
    shoppingList[1...3] = ["apple", "bananas"]
    // insert(_:at:) remove at:
    
    for item in shoppingList {}
    
    for (index, value) in shoppingList.enumerated() {}
    
    // 集合
    var leters = Set<Character>()
    let favoriteGenres: Set<String> = ["Roc", "Classical", "Hip pop"]
    // 一个set类型不能从数组字面量中被单独推断出来，因此Set类型必须显示声明
    
    for genre in favoriteGenres.sorted() {
        print("\(genre)")
    }
    // intersection symmetricDifference  union
    
    // 字典
    var namersOfIntegers = [Int: String]()
    namersOfIntegers[16] = "sixteen"
    namersOfIntegers = [:]
    
    var airports: [String: String] = ["YYZ" : "Toronto Pearson", "DUB" : "Dublin"]
    
    for (airportCode, ariportName) in airports {
        print("\(airportCode), \(ariportName)")
    }
    for _ in airports.keys {}
    for _ in airports.values {}
    
    // 控制流
    // 循环 for in、while、Repeat-While
    
    for index in 1...5 {
        print("\(index)")
    }
    // 条件 if、else if 、 Switch
    // Switch不存在隐式贯穿
    
    let anotherCharacter: Character = "a"
    switch anotherCharacter {
    case "a", "A"://复合匹配
        print("The letter A")
    default:
        print("Not the letter A")
    }
    // 区间匹配
    let approximateCount = 62
    let countedThings = "moons orbiting Saturn"
    var naturalCount: String
    switch approximateCount {
    case 0:
        naturalCount = "no"
    case 1..<5:
        naturalCount = "a few"
    case 5..<12:
        naturalCount = "several"
    case 12..<100:
        naturalCount = "dozens of"
    case 100..<1000:
        naturalCount = "hundreds of"
    default:
        naturalCount = "many"
    }
    // 元祖匹配
    let somePoint = (1, 1)
    switch somePoint {
    case (0, 0):
        print("(0, 0) is at the origin")
    case (_, 0):
        print("(\(somePoint.0), 0) is on the x-axis")
    case (0, _):
        print("(0, \(somePoint.1)) is on the y-axis")
    case let (a, b):    // 绑定值
        print("\(a), \(b)")
    case let (a, b) where a==b: //where
        print("\(a), \(b)")
    case (-2...2, -2...2):
        print("(\(somePoint.0), \(somePoint.1)) is inside the box")
    default:
        print("(\(somePoint.0), \(somePoint.1)) is outside of the box")
    }
    
    // 控制转移语句 continue  break  fallthrough return throw
    
    // guard 如果guard语句的条件被满足，则继续执行guard语句大括号后的代码，将变量或者常量的可选绑定作为guard语句的条件，都可以保护guard语句后面的代码
    var guardName: String? = "abc"
    guard let name = guardName else {
        return;
    }
}


func test2() {
    minMax(array: [1,3,5,2,9,10])
    someFunction(argumentLabel: 1)
    someFunction(1)
    var a = 10
    var b = 100
    
    swapTwoInts(&a, &b)
    print("\(a), \(b)")
}

// 多重返回函数
func minMax(array: [Int]) -> (min: Int, max: Int) {
    var min = array[0],max = array[0];
    for element in array {
        if element < min {
            min = element
        }else if element > max {
            max = element
        }
    }
    print("\(min)", "\(max)")
    return (min, max)
}

// 指定参数标签
func someFunction(argumentLabel parameterName: Int) {}
// 忽略参数标签
func someFunction(_ firstParameterName: Int) {
    
}
// 输入输出参数
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}
// 函数作为返回类型

func stepForward(_ input: Int) -> Int {
    return input + 1
}
func stepBackward(_ input: Int) -> Int {
    return input - 1
}
func chooseStepFuction(backward: Bool) -> (Int) -> Int {
    return backward ? stepForward : stepBackward
}

// 闭包
func test3() {
    var names = ["Chris", "Alex", "Ewa", "Bob","Dani"]
    names.sort(by: {$0>$1})
    print(names)
    
    
    
    let stepCounter = StepCount()
    stepCounter.totalSteps = 10
    
    let threeTimesTable = TimesTable(multiplier: 3)
    print("six times three is \(threeTimesTable[6])")

    
    Celsius(fromFahrenheit: 100)
}

// 逃逸闭包
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure (completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}

enum SomeEnumeration {
    case north
    case south
    case east
    case west
}

enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

struct SomeStructure {
    var width = 0
    var height = 0
}

class SomeClass {
    var resoluton = SomeStructure()
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}

let someStructure = SomeStructure()
let someClass = SomeClass()

// 计算属性
struct Point {
    var x = 0.0, y = 0.0
}

struct Size {
    var width = 0.0, height = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let cenX = origin.x + size.width/2
            let cenY = origin.y + size.height/2
            return Point(x: cenX, y: cenY)
        }
        
//        set(newCenter) {
//            origin.x = newCenter.x - size.width/2
//            origin.y = newCenter.y - size.height/2
//        }
        set {
            origin.x = newValue.x - size.width/2
            origin.y = newValue.y - size.height/2
        }
    }
}


// 属性观察器

class StepCount {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("newTotalSteps \(newTotalSteps)")
        }
        
        didSet {
            print("didset")
        }
    }
}

// 下标
struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}

struct Celsius {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
}

// 类的构造器代理规则
/*
 规则 1
 指定构造器必须调用其直接父类的的指定构造器。
 
 规则 2
 便利构造器必须调用同类中定义的其它构造器。
 
 规则 3
 便利构造器必须最终导致一个指定构造器被调用。
 
 一个更方便记忆的方法是：
 
 指定构造器必须总是向上代理
 便利构造器必须总是横向代理
 
 两段式构造过程
 
 第一个阶段，每个存储型属性被引入它们的类指定一个初始值。当每个存储型属性的初始值被确定后，第二阶段开始，它给每个类一次机会，在新实例准备使用之前进一步定制它们的存储型属性。
 
 
 */
