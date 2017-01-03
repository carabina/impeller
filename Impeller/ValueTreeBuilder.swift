//
//  ValueTree.swift
//  Impeller
//
//  Created by Drew McCormack on 15/12/2016.
//  Copyright © 2016 Drew McCormack. All rights reserved.
//

final class ValueTreeBuilder<T:Storable> : SinkRepository {
    private (set) var valueTree: ValueTree
    private var storable: T
    
    init(_ storable:T) {
        valueTree = ValueTree(storedType: T.storedType, metadata: storable.metadata)
        self.storable = storable
        self.save(&self.storable)
    }
    
    func save<T:Storable>(_ value: inout T, context: Any? = nil) {
        storable.store(in: self)
    }
    
    func store<T:StorablePrimitive>(_ value:T, for key:String) {
        let primitive = Primitive(value: value)
        valueTree.set(key, to: .primitive(primitive!))
    }
    
    func store<T:StorablePrimitive>(_ value:T?, for key:String) {
        let primitive = value != nil ? Primitive(value: value!) : nil
        valueTree.set(key, to: .optionalPrimitive(primitive))
    }
    
    func store<T:StorablePrimitive>(_ values:[T], for key:String) {
        let primitives = values.map { Primitive(value: $0)! }
        valueTree.set(key, to: .primitives(primitives))
    }
    
    func store<T:Storable>(_ value:inout T, for key:String) {
        let reference = ValueTreeReference(uniqueIdentifier: value.metadata.uniqueIdentifier, storedType: T.storedType)
        valueTree.set(key, to: .valueTreeReference(reference))
    }
    
    func store<T:Storable>(_ value:inout T?, for key:String) {
        let id = value?.metadata.uniqueIdentifier
        let reference = id != nil ? ValueTreeReference(uniqueIdentifier: id!, storedType: T.storedType) : nil
        valueTree.set(key, to: .optionalValueTreeReference(reference))
    }
    
    func store<T:Storable>(_ values:inout [T], for key:String) {
        let references = values.map {
            ValueTreeReference(uniqueIdentifier: $0.metadata.uniqueIdentifier, storedType: T.storedType)
        }
        valueTree.set(key, to: .valueTreeReferences(references))
    }
}

