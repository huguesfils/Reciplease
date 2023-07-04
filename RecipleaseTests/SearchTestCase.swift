//
//  SearchTestCase.swift
//  RecipleaseTests
//
//  Created by Hugues Fils on 01/07/2023.
//

import XCTest
@testable import Reciplease

final class SearchTestCase: XCTestCase {
    
    @MainActor func testGivenIngredientsArrayIsEmpty_WhenIncrementAnIngredientFromUserInput_ThenIngredientShouldContainANewIngredient() throws {
       //given
       let viewModel = SearchViewModel()
        viewModel.searchInput = "lemon"
        //when
        viewModel.addIngredient()
        //then
        XCTAssert(viewModel.ingredients.contains("lemon"))
    }
}
