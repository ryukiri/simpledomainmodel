//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
    public func convert(_ to: String) -> Money {
        var newAmt = self.amount
        
        switch to {
            // To USD
            case "USD":
                print("USD")
                if self.currency == "USD" {         // From USD
                    newAmt = self.amount
                    return Money(amount: newAmt, currency: "USD")
                } else if self.currency == "GBP" {  // From GBP
                    newAmt = self.amount * 2
                    return Money(amount: newAmt, currency: "USD")
                } else if self.currency == "EUR" {  // From EUR
                    newAmt = self.amount * 2/3
                    return Money(amount: newAmt, currency: "USD")
                } else if self.currency == "CAN" {  // From CAN
                    newAmt = self.amount * 4/5
                    return Money(amount: newAmt, currency: "USD")
                }
            
            // To GBP
            case "GBP":
                print("GBP")
                if self.currency == "USD" {         // From USD
                    newAmt = self.amount * 1/2
                    return Money(amount: newAmt, currency: "GBP")
                } else if self.currency == "GBP" {  // From GBP
                    return Money(amount: newAmt, currency: "GBP")
                } else if self.currency == "EUR" {  // From EUR
                    newAmt = self.amount * 2/3 * 1/2
                    return Money(amount: newAmt, currency: "GBP")
                } else if self.currency == "CAN" {  // From CAN
                    newAmt = self.amount * 4/5/2
                    return Money(amount: newAmt, currency: "GBP")
                }
            
            // To EUR
            case "EUR":
                print("EUR")
                if self.currency == "USD" {         // From USD
                    newAmt = self.amount * 3/2
                    return Money(amount: newAmt, currency: "EUR")
                } else if self.currency == "GBP" {  // From GBP
                    newAmt = self.amount * 2 * 3/2
                    return Money(amount: newAmt, currency: "EUR")
                } else if self.currency == "EUR" {  // From EUR
                    return Money(amount: newAmt, currency: "EUR")
                } else if self.currency == "CAN" {  // From CAN
                    newAmt = self.amount * 4/5 * 3/2
                }
            
            // To CAN
            case "CAN":
                print("CAN")
                if self.currency == "USD" {         // From USD
                    newAmt = self.amount * 5/4
                    return Money(amount: newAmt, currency: "CAN")
                } else if self.currency == "GBP" {  // From GBP
                    newAmt = self.amount * 2 * 5/4
                    return Money(amount: newAmt, currency: "CAN")
                } else if self.currency == "EUR" {  // From EUR
                    newAmt = self.amount * 2/3 * 5/4
                    return Money(amount: newAmt, currency: "CAN")
                } else if self.currency == "CAN" {  // From CAN
                    return Money(amount: newAmt, currency: "CAN")
                }
            
            default:
                return Money(amount: 0, currency: "UNKNOWN")
        }
        return Money(amount: newAmt, currency: "EUR")
    }
  
    public func add(_ to: Money) -> Money {
        let convertToCurrency = to.convert(to.currency)
        return Money(amount: convertToCurrency.amount + to.amount, currency: convertToCurrency.currency)
    }
    
    public func subtract(_ from: Money) -> Money {
        let convertToCurrency = from.convert(from.currency)
        return Money(amount: convertToCurrency.amount - from.amount, currency: convertToCurrency.currency)
    }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
    case .Hourly(let mon):
        return Int(mon * Double(hours))
    case .Salary(let mon):
        return mon
    }
  }
  
  open func raise(_ amt : Double) {
    switch self.type {
    case .Hourly(let mon):
        self.type = JobType.Hourly(mon + amt)
    case .Salary(let mon):
        self.type = JobType.Salary(mon + Int(amt))
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {
        // Minimum employment age is 15 according to test file
        if self.age > 15 {
            return self._job
        }
        return nil
    }
    set(value) {
        self._job = value
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {
        // Only legal to marry if 18+
        if self.age > 17 {
            return self._spouse
        }
        return nil
    }
    set(value) {
        self._spouse = value
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    let sentence = "[Person: firstName:\(self.firstName) lastName:\(self.lastName) age:\(self.age) job:\(self.job?.type) spouse:\(spouse?.firstName)]"
    print(sentence)
    return sentence
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if spouse1.spouse == nil && spouse2.spouse == nil {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        members.append(spouse1)
        members.append(spouse2)
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    for index in members {
        if index.age > 21 {
            members.append(child)
            return true
        }
    }
    return false
  }
  
  open func householdIncome() -> Int {
    var income = 0
    for index in members {
        if index.job != nil {
            income += index.job!.calculateIncome(2000)
        }
    }
    
    return income
  }
}





