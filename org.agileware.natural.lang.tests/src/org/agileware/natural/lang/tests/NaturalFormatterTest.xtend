package org.agileware.natural.lang.tests

import org.agileware.natural.lang.model.NaturalModel
import org.agileware.natural.testing.AbstractFormatterTest
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(NaturalInjectorProvider)
class NaturalFormatterTest extends AbstractFormatterTest<NaturalModel> {
	
	@Test
	def void cleanupWhiteSpace() {
		// SHOULD trim extra whitespace around text
		val toBeFormatted = '''
			# language: en
			Document: Hello, Natural Formatter!
			
			The quick brown fox
			Jumps over the lazy dog
			
			Section: A
			
			Section: B
		'''
		val expectation = '''
			# language: en
			Document: Hello, Natural Formatter!
			
			The quick brown fox
			Jumps over the lazy dog
			
			Section: A
			
			Section: B
		'''
		assertFormatted(toBeFormatted, expectation)
	}
	
}