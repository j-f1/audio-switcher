//
//  Extensions.swift
//  Instant Audio Switcher
//
//  Created by Jed Fox on 3/23/21.
//

import Foundation

extension Array {
  var only: Element? {
    if count == 1 {
      return first
    }
    return nil
  }
}

extension DispatchTimeInterval: Comparable {
  var nanoseconds: Int64? {
    switch self {
    case .seconds(let s): return Int64(s) * 1_000_000_000
    case .milliseconds(let ms): return Int64(ms) * 1_000_000
    case .microseconds(let μs): return Int64(μs) * 1_000
    case .nanoseconds(let ns): return Int64(ns)
    case .never: return nil
    @unknown default: return nil
    }
  }

  public static func < (_ lhs: DispatchTimeInterval, rhs: DispatchTimeInterval) -> Bool {
    if let lhs = lhs.nanoseconds,
       let rhs = rhs.nanoseconds {
      return lhs < rhs
    }
    return false
  }
  public static func > (_ lhs: DispatchTimeInterval, rhs: DispatchTimeInterval) -> Bool {
    if let lhs = lhs.nanoseconds,
       let rhs = rhs.nanoseconds {
      return lhs > rhs
    }
    return false
  }
}

