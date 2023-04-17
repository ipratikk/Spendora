//
//  FeatureModel.swift
//  Spendora
//
//  Created by Pratik Goel on 13/04/23.
//

import Foundation
import Lottie

public struct FeatureModel {
    let title: String
    let body: String
    let animation: LottieAnimation?
}

public enum Feature {

    static let all: [Feature] = [.listExpenses, .splitExpenses, .analyzeExpenses]

    case listExpenses
    case splitExpenses
    case analyzeExpenses

    var title: String {
        switch self {
            case .listExpenses:
                return Module.Strings.Features.listExpenseTitle
            case .splitExpenses:
                return Module.Strings.Features.splitExpenseTitle
            case .analyzeExpenses:
                return Module.Strings.Features.analyzeExpenseTitle
        }
    }

    var body: String {
        switch self {
            case .listExpenses:
                return Module.Strings.Features.listExpenseBody
            case .splitExpenses:
                return Module.Strings.Features.splitExpenseBody
            case .analyzeExpenses:
                return Module.Strings.Features.analyzeExpenseBody
        }
    }

    var animation: LottieAnimation? {
        switch self {
            case .listExpenses:
                return Module.Animations.listExpense
            case .splitExpenses:
                return Module.Animations.splitExpense
            case .analyzeExpenses:
                return Module.Animations.analyzeExpense
        }
    }

    var model: FeatureModel {
        return FeatureModel(title: title, body: body, animation: animation)
    }
}
