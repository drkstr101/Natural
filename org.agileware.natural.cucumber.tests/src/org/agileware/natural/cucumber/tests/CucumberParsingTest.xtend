package org.agileware.natural.cucumber.tests

import com.google.inject.Inject
import org.agileware.natural.cucumber.cucumber.CucumberModel
import org.agileware.natural.cucumber.serializer.CucumberSerializer
import org.agileware.natural.testing.AbstractParserTest
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static org.hamcrest.MatcherAssert.*
import static org.hamcrest.Matchers.*
import static org.agileware.natural.testing.Matchers.*

@RunWith(XtextRunner)
@InjectWith(CucumberInjectorProvider)
class CucumberParsingTest extends AbstractParserTest<CucumberModel> {

	@Inject CucumberSerializer serializer

	@Test
	def void parseSimpleFeature() {
		val model = parse('''
			Feature: Hello, World!
			
			Scenario: A
				Given a precondition
			
			Scenario: B
				And another
		''')

		assertThat(model, notNullValue())
		assertThat(validate(model), empty())

		println(serializer.serialize(model))
	}

	@Test
	def void parseFullExample() {
		val model = parse('''
			#language: en
			
			#TODO tag style missing
			@release:Release-2 @version:1.0.0
				@pet_store
			Feature: Add a new pet  
				In order to sell a pet
				As a store owner
				I want to add a new pet to the catalog
			
				Background: Add a dog 
					Given I have the following pet
					| name | status    |
					| Fido | available |
					And I add the pet to the store #TODO SL_COMMENT breaks parser at EOL if no additional newline between steps
					
					But the pet is not yet mine
			
				@add @fido
				Scenario: Add another dog 
					Then the should be available in the store
			
				@update @fido
				Scenario:
					#TODO stylized NUMBER
					Given the pet is available in the store -9.8
					"""
					The quick brown fox
					Jumps over the lazy dog
					"""
					When I update the pet with  
						| name | status      |
						| Fido | unavailable |
					Then the pet should be "unavailable" in the store 
			
				@eat-pickles
				Scenario Outline: Eating pickles
					Given there are <start> pickles
					#TODO missing alternate keyword style
					When I eat [eat] pickles
					Then I should have <left> pickles
			
					@hungry
					Examples:
					| start | eat | left |
					|    12 |  10 |    2 |
					|    20 |  15 |    5 |
			
					@full
					Examples: With a title
					| start | eat | left |
					|    12 |   2 |   10 |
					|    20 |   5 |   15 |
		''')

		assertThat(model, notNullValue())
		assertThat(validate(model), hasNoErrors())
	}
}
