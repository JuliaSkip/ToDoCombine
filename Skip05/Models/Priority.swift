//
//  Priority.swift
//  Skip05
//
//  Created by Скіп Юлія Ярославівна on 27.02.2026.
//

enum Priority: String, CaseIterable, Identifiable {
    case low
    case medium
    case high
    
    var id: String { rawValue }
}
