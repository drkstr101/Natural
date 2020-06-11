package org.agileware.natural.cucumber.tests

import org.agileware.natural.cucumber.cucumber.Feature
import org.agileware.natural.testing.AbstractFormatterTest
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(CucumberInjectorProvider)
class CucumberFormatterTest extends AbstractFormatterTest<Feature> {

	@Test
	def void indentScenarioSteps() {
		val toBeFormatted = '''
			# language: en
			
			Feature: Jack and Jill
			
			Background:
			Given a precondition
			
			Scenario: Jack falls down
			When Jack falls down
			Then Jill comes tumbling after
		'''
		val expectation = '''
			# language: en
			
			Feature: Jack and Jill
			
			Background:
				Given a precondition
			
			Scenario: Jack falls down
				When Jack falls down
				Then Jill comes tumbling after
		'''
		assertFormatted(toBeFormatted, expectation)
	}

	@Test
	def void indentExamples() {
		val toBeFormatted = '''
			# language: en
			
			Feature:
			
			Scenario Outline:
			When [foo] happens
			Then there should be a <bar>
			
			Examples:
			| foo | bar |
			| a   | 0   |
			| b   | 1   |
		'''
		val expectation = '''
			# language: en
			
			Feature:
			
			Scenario Outline:
				When [foo] happens
				Then there should be a <bar>
			
				Examples:
					| foo | bar |
					| a   | 0   |
					| b   | 1   |
		'''

		assertFormatted(toBeFormatted, expectation)
	}

	@Test
	def void formatMetaData() {
		val toBeFormatted = '''
			# SL_COMMENT
			
			@pet_store   @foo : bar  
			Feature: Add a new pet
		'''
		val expectation = '''
			# SL_COMMENT
			
			@pet_store
			@foo:bar
			Feature: Add a new pet
		'''

		assertFormatted(toBeFormatted, expectation)
	}

	@Test
	def void indentStepInterior() {
		val toBeFormatted = '''
			# SL_COMMENT
			
			Feature:
			
			Background:
			Given some table data
			| name  | status      |
			| Spike | unavailable |
			| Fido  | available   |
		'''
		val expectation = '''
			# SL_COMMENT
			
			Feature:
			
			Background:
				Given some table data
				| name  | status      |
				| Spike | unavailable |
				| Fido  | available   |
		'''

		assertFormatted(toBeFormatted, expectation)
	}
	
	@Test
	def void seperateSections() {
		val toBeFormatted = '''
			Feature: Jack and Jill
			
			
			Background:
			Given a precondition
			Scenario: Jack falls down
			When Jack falls down
			Then Jill comes tumbling after
		'''
		val expectation = '''
			Feature: Jack and Jill
			
			Background:
				Given a precondition
			
			Scenario: Jack falls down
				When Jack falls down
				Then Jill comes tumbling after
		'''
		assertFormatted(toBeFormatted, expectation)
	}
}
