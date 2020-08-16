/*
 * generated by Xtext 2.23.0-SNAPSHOT
 */
package org.agileware.natural.lang.formatting2

import com.google.inject.Inject
import org.agileware.natural.lang.model.DocString
import org.agileware.natural.lang.model.Document
import org.agileware.natural.lang.model.Meta
import org.agileware.natural.lang.model.Narrative
import org.agileware.natural.lang.model.NaturalModel
import org.agileware.natural.lang.model.Table
import org.agileware.natural.lang.model.Tag
import org.agileware.natural.lang.model.Title
import org.agileware.natural.lang.services.NaturalGrammarAccess
import org.eclipse.xtext.formatting2.AbstractFormatter2
import org.eclipse.xtext.formatting2.IFormattableDocument
import org.eclipse.xtext.formatting2.regionaccess.ISemanticRegion

class NaturalFormatter extends AbstractFormatter2 {

	@Inject extension NaturalGrammarAccess

	def dispatch void format(NaturalModel model, extension IFormattableDocument doc) {
		println(textRegionAccess)
		model.document.format()
		println(doc)
	}

	def dispatch void format(Document model, extension IFormattableDocument document) {
		model.meta.format()
		model.title.format()
		model.narrative.format()
		for (s : model.sections) {
			s.format()
		}
	}

	def dispatch void format(Meta model, extension IFormattableDocument doc) {
		for (t : model.tags) {
			t.format()
		}
	}

	def dispatch void format(Tag model, extension IFormattableDocument doc) {
		// TODO...
	}

	def dispatch void format(Title model, extension IFormattableDocument doc) {
		// TODO...
	}

	def dispatch void format(Narrative model, extension IFormattableDocument doc) {
		// TODO...
	}
	
		/**
	 * Returns the semantic element that closes a DocString
	 * 
	 * Delegates to:
	 * 1. The EOLRule at the end of the element
	 */
	def ISemanticRegion endRegionFor(DocString model, extension IFormattableDocument doc) {
		return model.regionFor.ruleCall(docStringAccess.NLTerminalRuleCall_2)
	}

	/**
	 * Returns the semantic element that closes a Table
	 * 
	 * Delegates to:
	 * 1. The EOLRule at the end of the table
	 */
	def ISemanticRegion endRegionFor(Table model, extension IFormattableDocument doc) {
		return model.rows.last.regionFor.ruleCallTo(NLRule)
	}
}
