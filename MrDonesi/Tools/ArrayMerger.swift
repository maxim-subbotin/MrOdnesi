//
//  ArrayMerger.swift
//  MrDonesi
//
//  Created by Maxim Subbotin on 17.06.2022.
//

import Foundation

public class ArrayMerger<V: Identifiable> {
    public struct Move {
        public var from: Int
        public var to: Int
    }
    public struct Result {
        public var array: [V]
        public var deleted = [Int]()
        public var inserted = [Int]()
        public var moves = [Move]()
    }
    
    public init() { }
    
    public func merge(oldArray: [V]?, newArray: [V]?) -> Result {
        var array1 = oldArray ?? [V]()
        let array2 = newArray ?? [V]()
        
        let oldIds = Set(array1.map({ $0.id }))
        let newIds = Set(array2.map({ $0.id }))
        
        let deletedIds = oldIds.subtracting(newIds)
        let addedIds = newIds.subtracting(oldIds)
        
        var deletedIndexes = [Int]()
        for i in array1.map({ $0.id }) {
            if deletedIds.contains(i) {
                if let delIndex = array1.firstIndex(where: { $0.id == i }) {
                    deletedIndexes.append(delIndex)
                    //array1.remove(at: delIndex)
                }
            }
        }
        array1.removeAll(where: { deletedIds.contains($0.id) })
        
        var insertedIndexes = [Int]()
        for (index, element) in addedIds.enumerated() {
            insertedIndexes.append(array1.count)
            if let el = array2.first(where: { $0.id == element }) {
                array1.append(el)
            }
        }
        /*for i in 0..<array2.count {
            if addedIds.contains(array2[i].id) {
                insertedIndexes.append(i)
                array1.append(array2[i])
            }
        }*/
        
        var movedIndexes = [Move]()
        for i in 0..<array1.count {
            if array1[i].id != array2[i].id {
                if let newPos = array2.firstIndex(where: { $0.id == array1[i].id }) {
                    movedIndexes.append(Move(from: i, to: newPos))
                }
            }
        }
        
        return Result(array: oldArray ?? [V](), deleted: deletedIndexes, inserted: insertedIndexes, moves: movedIndexes)
    }
}
