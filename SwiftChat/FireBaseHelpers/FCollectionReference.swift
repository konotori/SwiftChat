//
//  FCollectionReference.swift
//  SwiftChat
//
//  Created by Tung Nguyen on 20/08/2021.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Recent
}
    

func FirebaseReference(_ collectionReference: FCollectionReference) ->  CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}
