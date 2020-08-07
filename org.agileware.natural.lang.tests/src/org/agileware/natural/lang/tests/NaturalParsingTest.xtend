/*
 * generated by Xtext 2.23.0-SNAPSHOT
 */
package org.agileware.natural.lang.tests

import com.google.inject.Inject
import org.agileware.natural.lang.model.NaturalModel
import org.agileware.natural.lang.model.Table
import org.agileware.natural.lang.serializer.NaturalSerializer
import org.agileware.natural.testing.AbstractExamplesTest
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static org.hamcrest.MatcherAssert.*
import static org.hamcrest.Matchers.*

@RunWith(XtextRunner)
@InjectWith(NaturalInjectorProvider)
class NaturalParsingTest extends AbstractExamplesTest<NaturalModel> {

	@Inject NaturalSerializer serializer

	@Test
	def void documentWithTitle() {

		val model = parse('''
			# language: en
			Document:   Hello,  Natural! 
		''')

		assertThat(model, notNullValue())
		assertThat(validate(model), empty())

		val doc = model.document
		assertThat(doc.sections, hasSize(0))
		assertThat(doc, notNullValue())
		assertThat(doc.title, equalTo("Hello, Natural!"))
	}

	@Test
	def void simpleDocumentNarrative() {

		val model = parse('''
			# language: en
			Document:
				The quick brown fox
				Jumps over the lazy dog
		''')

		assertThat(model, notNullValue())
		assertThat(validate(model), empty())

		val doc = model.document
		assertThat(doc, notNullValue())
		assertThat(doc.narrative, notNullValue())
		assertThat(doc.narrative.sections, hasSize(1))
		assertThat(serializer.serialize(doc.narrative), equalToCompressingWhiteSpace('''
			The quick brown fox
			Jumps over the lazy dog
		'''))
	}

	@Test
	def void complexDocumentNarrative() {

		val model = parse('''
			# language: en
			Document:
				The quick brown fox
				
				"""
				At -9.8 m/s^2
				"""
				
				| x | y |
				| a | 0 |
				| b | 1 |
				
				Jumps over the lazy dog
		''')

		assertThat(model, notNullValue())
		assertThat(validate(model), empty())

		val doc = model.document
		assertThat(doc, notNullValue())
		assertThat(doc.narrative, notNullValue())
		assertThat(doc.narrative.sections, hasSize(4))
		assertThat(serializer.serialize(doc.narrative), equalToCompressingWhiteSpace('''
			The quick brown fox
			
			"""
			At -9.8 m/s^2
			"""
			
			| x | y |
			| a | 0 |
			| b | 1 |
			
			Jumps over the lazy dog
		'''))
		
		val table = doc.narrative.sections.get(2) as Table
		assertThat(table.rows, hasSize(3))
	}

	@Test
	def void multipleSectionsWithMetaTags() {
		val model = parse('''
			# language: en
			@title: Hello, Meta Tags!  
			
			Document:  
				The quick brown fox
				Jumps over the lazy dog
			
			@foo
			@bar
			Section: A
			
			@foo @bar
			
			Section: B
		''')

		assertThat(model, notNullValue())
		assertThat(validate(model), empty())

		val doc = model.document
		assertThat(doc, notNullValue())
		assertThat(doc.title, nullValue())
		assertThat(doc.sections, hasSize(2))
		assertThat(doc.meta.tags, hasSize(1))
		assertThat(doc.meta.tags.get(0).id, equalTo("title"))
		assertThat(doc.meta.tags.get(0).value, equalTo("Hello, Meta Tags!"))
		assertThat(serializer.serialize(doc.narrative), equalToCompressingWhiteSpace('''
			The quick brown fox
			Jumps over the lazy dog
		'''))
		assertThat(doc.sections.get(0).meta.tags, hasSize(2))
		assertThat(doc.sections.get(1).meta.tags, hasSize(2))
	}
}
