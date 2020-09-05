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
import org.agileware.natural.lang.formatting2.NaturalFormatHelper
import org.agileware.natural.lang.model.DocString
import org.agileware.natural.lang.model.Meta
import org.agileware.natural.lang.model.Narrative
import org.agileware.natural.lang.model.Paragraph
import org.agileware.natural.lang.model.Table
import org.agileware.natural.lang.model.Tag
import org.eclipse.xtext.Assignment
import org.eclipse.xtext.Keyword
import org.eclipse.xtext.formatting2.AbstractFormatter2
import org.eclipse.xtext.formatting2.FormatterRequest
import org.eclipse.xtext.formatting2.IFormattableDocument
import org.eclipse.xtext.formatting2.regionaccess.ISemanticRegion
import org.agileware.natural.lang.model.NarrativeSection

class CucumberFormatter extends AbstractFormatter2 {

	@Inject extension CucumberGrammarAccess cucumberGrammarAccess

	@Inject NaturalFormatHelper.Factory formatHelperFactory

	var extension NaturalFormatHelper _formatHelper = null

	override protected initialize(FormatterRequest request) {
		_formatHelper = formatHelperFactory.create(request.textRegionAccess, naturalGrammarAccess)
		_formatHelper.initialize(request)

		super.initialize(request)
	}

	def dispatch void format(CucumberModel model, extension IFormattableDocument doc) {
		// println(textRegionAccess)
		model.document.format()
		// println(doc)
	}

	def dispatch void format(Feature model, extension IFormattableDocument doc) {
		
		resetIndentation()
		
		// Condense all BLANK_SPACE regions into single line break
		model.allRegionsFor.ruleCallsTo(BLANK_SPACERule).forEach [ region |
			// println('''Trimming BLANK_SPACE: «region.offset» «region.length»''')
			trimBlankSpace(region, 1, doc)
		]

		// Format Tags
		model.meta.format()

		// Cleanup whitespace around keyword/title
		if (model.title === null) {
			model.regionFor.keyword(documentAccess.documentKeyword_3).append[noSpace]
		} else {
			model.regionFor.assignment(documentAccess.titleAssignment_4).prepend[oneSpace].append[noSpace]
		}

		increaseIndent()
		indentBlock(model.startIndent, model.endIndent, doc)

		// Format narrative
		if (model.narrative !== null) {
			model.narrative.format().prepend[indent]
			if (!model.narrative.hasLeadingBlankSpace) {
				model.narrative.prepend[setNewLines(2)]
			}
		}

		// Format scenarios
		model.scenarios.forEach[format().prepend[indent]]

		decreaseIndent()
	}

	def dispatch void format(Background model, extension IFormattableDocument doc) {
		// Apply default scenario formatting
		val keyword = backgroundAccess.backgroundKeyword_2
		val titleAssignment = backgroundAccess.titleAssignment_3
		formatScenarioBlock(model, keyword, titleAssignment, doc)
	}

	def dispatch void format(Scenario model, extension IFormattableDocument doc) {
		// Apply default scenario formatting
		val keyword = scenarioAccess.scenarioKeyword_2
		val titleAssignment = scenarioAccess.titleAssignment_3
		formatScenarioBlock(model, keyword, titleAssignment, doc)
	}

	def dispatch void format(ScenarioOutline model, extension IFormattableDocument doc) {

		// Apply default scenario formatting
		val keyword = scenarioOutlineAccess.scenarioOutlineKeyword_2
		val titleAssignment = scenarioOutlineAccess.titleAssignment_3
		formatScenarioBlock(model, keyword, titleAssignment, doc)

		increaseIndent()
		model.examples.forEach[format().prepend[indent]]
		decreaseIndent()
	}

	def dispatch void format(Meta model, extension IFormattableDocument doc) {
		model.tags.forEach[format]
	}

	def dispatch void format(Tag model, extension IFormattableDocument doc) {
		// Trim leading/trailing whitespace
		model.surround[noSpace]

		if (model.value !== null) {
			// Cleanup whitespace around value assignment
			model.regionFor.keyword(':').prepend[noSpace].append[oneSpace]
			model.regionFor.assignment(tagAccess.valueAssignment_2_1).prepend[oneSpace].append[noSpace]
		}

		// Insert newline if not present from BLANK_SPACE
		if (model.isLast()) {
			model.append[setNewLines(0)]
		} else if (!model.hasTrailingBlankSpace) {
			model.append[newLine]
		}
	}
	
	def dispatch void format(Step model, extension IFormattableDocument doc) {
		// TODO cleanup whitespace
		if (model.text !== null) {
			model.text.format().prepend[indent]
		}

		if (model.table !== null) {
			model.table.format().prepend[indent]
		}
	}
	
	def dispatch void format(Example model, extension IFormattableDocument doc) {

		if (model.meta !== null) {
			model.meta.format()

			// Work-around for strange keyword placement when tags are present
			model.regionFor.keyword(exampleAccess.examplesKeyword_2).prepend[indent]
		}

		// indent Table
		model.table.format().prepend[indent]
	}

	def dispatch void format(Narrative model, extension IFormattableDocument doc) {
		model.sections.forEach[format().prepend[indent]]
	}

	def dispatch void format(Paragraph model, extension IFormattableDocument doc) {
		formatMultilineText(model, paragraphAccess.valueAssignment_1, indentationLevel, doc)
	}

	def dispatch void format(Table model, extension IFormattableDocument doc) {
		model.rows.forEach[prepend[indent]]
	}

	def dispatch void format(DocString model, extension IFormattableDocument doc) {
		formatMultilineText(model, docStringAccess.valueAssignment_1, indentationLevel, doc)
	}

	// ----------------------------------------------------------
	//
	// Helper Methods
	//
	// ----------------------------------------------------------
	
	def void formatScenarioBlock(AbstractScenario model, Keyword keyword, Assignment titleAssignment,
		extension IFormattableDocument doc) {

		// Set block spacing
		if (!model.hasLeadingBlankSpace) {
			model.prepend[setNewLines(2)]
		}

		// Format meta tags
		if (model.meta !== null) {
			model.meta.format()

			// Work-around for strange keyword placement when tags are present
			model.regionFor.keyword(keyword).prepend[indent]
		}

		// Cleanup whitespace around keyword/title
		if (model.title === null) {
			model.regionFor.keyword(keyword).append[noSpace]
		} else {
			model.regionFor.assignment(titleAssignment).prepend[oneSpace].append[noSpace]
		}

		increaseIndent()
		indentBlock(model.startIndent, model.endIndent, doc)

		// Format narrative
		if (model.narrative !== null) {
			model.narrative.format().prepend[indent]
		}

		// Format steps
		model.steps.forEach[format().prepend[indent]]
		
		decreaseIndent()
	}

	def ISemanticRegion startIndent(Feature model) {
		return model.regionFor.ruleCallTo(NLRule)
	}

	def ISemanticRegion endIndent(Feature model) {
		if (!model.scenarios.isEmpty()) {
			return model.scenarios.last.endIndent()
		}

		return model.regionFor.ruleCallTo(NLRule)
	}

	def ISemanticRegion startIndent(AbstractScenario model) {
		return model.regionFor.ruleCallTo(NLRule)
	}
	
	def ISemanticRegion endIndent(Narrative model) {
		return model.sections.last.endIndent()
	}

	def ISemanticRegion endIndent(NarrativeSection model) {
		if(model instanceof Table) {
			return model.rows.last.regionFor.ruleCallTo(NLRule)
		}
		
		return model.regionFor.ruleCallTo(NLRule)
	}

	def ISemanticRegion endIndent(AbstractScenario model) {

		if (model instanceof ScenarioOutline) {
			if (!model.examples.isEmpty()) {
				return model.examples.last.endIndent()
			}
		} else if (!model.steps.isEmpty()) {
			return model.steps.last.endIndent()
		}

		return model.regionFor.ruleCallTo(NLRule)
	}

	def ISemanticRegion endIndent(Example model) {
		if (model.table !== null) {
			return model.table.endIndent()
		}

		return model.regionFor.ruleCallTo(NLRule)
	}

	def ISemanticRegion endIndent(Step model) {
		if (model.text !== null) {
			return model.text.endIndent()
		} else if (model.table !== null) {
			return model.table.endIndent()
		}

		return model.regionFor.ruleCallTo(NLRule)
	}

	def ISemanticRegion endIndent(DocString model) {
		return model.regionFor.ruleCall(docStringAccess.NLTerminalRuleCall_2)
	}

	def ISemanticRegion endIndent(Table model) {
		return model.rows.last.regionFor.ruleCallTo(NLRule)
	}
}
