//
//  TypeFilterDate+Extention.swift
//  MoneyOK
//
//  Created by Ярослав Шерстюк on 18.02.2023.
//

import Foundation
import SwiftUI

// MARK: - Типы транзакции
enum TypeFilterDate: String, Equatable, CaseIterable {
    
    case today = "Today" // сьогодня
    case exactDate = "Exact date" // Конкретна дата
    case toTheDate = "To the date" // До дати
    case aftertheDate = "After the date" // Після дати
    case rangeDate = "Range" // Зазаначений діапазон
    
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}
