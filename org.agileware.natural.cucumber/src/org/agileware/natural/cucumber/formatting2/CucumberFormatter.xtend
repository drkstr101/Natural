/*
 * generated by Xtext 2.21.0
 */
package org.agileware.natural.cucumber.formatting2

import com.google.inject.Inject
import org.agileware.natural.cucumber.cucumber.AbstractScenario
import org.agileware.natural.cucumber.cucumber.Background
import org.agileware.natural.cucumber.cucumber.CucumberModel
import org.agileware.natural.cucumber.cucumber.Example
import org.agileware.natural.cucumber.cucumber.Feature
import org.agileware.natural.cucumber.cucumber.Scenario
import org.agileware.natural.cucumber.cucumber.ScenarioOutline
import org.agileware.natural.cucumber.cucumber.Step
import org.agileware.natural.cucumber.services.CucumberGrammarAccess
import org.agileware.natural.lang.model.DocString
import org.agileware.natural.lang.model.Meta
import org.agileware.natural.lang.model.Table
import org.agileware.natural.lang.model.Tag
import org.eclipse.xtext.formatting2.AbstractFormatter2
import org.eclipse.xtext.formatting2.IFormattableDocument
import org.eclipse.xtext.formatting2.regionaccess.ISemanticRegion

class CucumberFormatter extends AbstractFormatter2 {

	// note: format extension methods SHOULD
	// be null-safe, hence the lack of guards
	// /////////////////////////////////////////////
	@Inject extension CucumberGrammarAccess cucumberGrammarAccess

	def dispatch void format(CucumberModel model, extension IFormattableDocument doc) {
		println(textRegionAccess)
		model.document.format()
		println(doc)
	}

	def dispatch void format(Feature model, extension IFormattableDocument doc) {
		
		// Format Tags
		model.meta.format()
		
		for (s : model.scenarios) {
			s.format()
		}
	}

	def dispatch void format(Background model, extension IFormattableDocument doc) {
		
		// Format Tags
		model.meta.format()

		// Indent interior
		val begin = model.regionFor.ruleCallTo(NLRule)
		val end = endRegionFor(model, doc)
		interior(begin, end)[indent]

		for (s : model.steps) {
			s.prepend[indent]
			s.format()
		}
	}

	def dispatch void format(Scenario model, extension IFormattableDocument doc) {
		model.meta.format()

		// Indent interior
		val begin = model.regionFor.ruleCallTo(NLRule)
		val end = endRegionFor(model, doc)
		interior(begin, end)[indent]

		for (s : model.steps) {
			s.prepend[indent]
			s.format()
		}
	}

	def dispatch void format(ScenarioOutline model, extension IFormattableDocument doc) {
		model.meta.format()

		// Indent interior
		val begin = model.regionFor.ruleCallTo(NLRule)
		val end = endRegionFor(model, doc)
		interior(begin, end)[indent]

		for (s : model.steps) {
			s.prepend[indent]
			s.format()
		}

		for (e : model.examples) {
			e.prepend[indent]
			e.format()
		}
	}

	def dispatch void format(Example model, extension IFormattableDocument doc) {
		model.meta.format()
		
		// TODO this is just a hacky work-around until we can figure
		// why having tags changes the indentation behavior of the 
		// keyword
		if (model.meta !== null) {
			val region = model.regionFor.keyword(exampleAccess.examplesKeyword_2)
			region.prepend[indent]
		}
		
		// indent Table
		model.table.rows.forEach[prepend[indent]]
		
		model.table.format()
	}

	def dispatch void format(Step model, extension IFormattableDocument doc) {
		model.text.format()
		model.table.format()
	}

	def dispatch void format(Meta model, extension IFormattableDocument doc) {
		for (t : model.tags) {
			t.format()
		}
	}

	def dispatch void format(Tag model, extension IFormattableDocument doc) {
		// TODO...
	}

	// ----------------------------------------------------------
	//
	// Helper Methods
	//
	// ----------------------------------------------------------
	
	/**
	 * Returns the semantic element that closes the Feature
	 * 
	 * Delegates to:
	 * 1. The last element in scenarios
	 * 2. The last element in background
	 * 3. The NL rule after title
	 */
	def ISemanticRegion endRegionFor(Feature model, extension IFormattableDocument doc) {
		if (!model.scenarios.isEmpty()) {
			return endRegionFor(model.scenarios.last, doc)
		}

		return model.regionFor.ruleCallTo(NLRule)
	}

	/**
	 * Returns the semantic element that closes an AbstractScenario
	 * 
	 * Delegates to:
	 * 1. The last element in `steps`
	 * 3. The NL rule after title
	 */
	def ISemanticRegion endRegionFor(AbstractScenario model, extension IFormattableDocument doc) {
		if (!model.steps.isEmpty()) {
			return endRegionFor(model.steps.last, doc)
		}

		return model.regionFor.ruleCallTo(NLRule)
	}

	/**
	 * Returns the semantic element that closes a ScenarioOutline
	 * 
	 * Delegates to:
	 * 1. The last element in examples
	 * 2. The last element in steps
	 * 3. The NL rule after title
	 */
	def ISemanticRegion endRegionFor(ScenarioOutline model, extension IFormattableDocument doc) {
		if (!model.examples.isEmpty()) {
			return endRegionFor(model.examples.last, doc)
		} else if (!model.steps.isEmpty()) {
			return endRegionFor(model.steps.last, doc)
		}

		return model.regionFor.ruleCallTo(NLRule)
	}

	/**
	 * Returns the semantic element that closes an Example
	 * 
	 * Delegates to:
	 * 1. The NL rule after the Table
	 * 1. The NL rule after the title
	 */
	def ISemanticRegion endRegionFor(Example model, extension IFormattableDocument doc) {
		if (model.table !== null) {
			return endRegionFor(model.table, doc)
		}

		return model.regionFor.ruleCallTo(NLRule)
	}

	/**
	 * Returns the semantic element that closes a Step
	 * 
	 * Delegates to:
	 * 1. Either to code or table if present
	 * 2. The NL rule after `description`
	 */
	def ISemanticRegion endRegionFor(Step model, extension IFormattableDocument doc) {
		if (model.text !== null) {
			return endRegionFor(model.text, doc)
		} else if (model.table !== null) {
			return endRegionFor(model.table, doc)
		}

		return model.regionFor.ruleCallTo(NLRule)
	}

	/**
	 * Returns the semantic element that closes a DocString
	 * 
	 * Delegates to:
	 * 1. The NLRule at the end of the element
	 */
	def ISemanticRegion endRegionFor(DocString model, extension IFormattableDocument doc) {
		return model.regionFor.ruleCall(docStringAccess.NLTerminalRuleCall_2)
	}

	/**
	 * Returns the semantic element that closes a Table
	 * 
	 * Delegates to:
	 * 1. The NLRule at the end of the table
	 */
	def ISemanticRegion endRegionFor(Table model, extension IFormattableDocument doc) {
		return model.rows.last.regionFor.ruleCallTo(NLRule)
	}
}
