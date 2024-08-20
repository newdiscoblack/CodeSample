//
//  matchByDescription.swift
//  CodeSampleTests
//
//  Created by Kacper Jagiełło on 20/08/2024.
//

import Nimble

func matchByDescription<T>(_ expectedValue: T?) -> Matcher<T> {
    return Matcher.define { actualExpression, message in
        let receivedValue = try actualExpression.evaluate()
        switch (receivedValue, expectedValue) {
        case let (receivedValue?, expectedValue?):
            let receivedValueString = String(describing: receivedValue)
            let expectedValueString = String(describing: expectedValue)
            return MatcherResult(
                bool: receivedValueString == expectedValueString,
                message: ExpectationMessage.expectedCustomValueTo(
                    expectedValueString,
                    actual: receivedValueString
                )
            )
        case let (nil, expectedValue?):
            let message = ExpectationMessage.expectedCustomValueTo(
                "equal <\(expectedValue)>",
                actual: "nil"
            )
            return MatcherResult(status: .fail, message: message)
        case (_?, nil):
            return MatcherResult(
                status: .fail,
                message: ExpectationMessage.fail("").appendedBeNilHint()
            )
        case (nil, nil):
            return MatcherResult(status: .matches, message: message)
        }
    }
}
