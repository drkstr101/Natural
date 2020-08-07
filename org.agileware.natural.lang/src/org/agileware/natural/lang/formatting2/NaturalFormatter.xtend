/*
 * generated by Xtext 2.23.0-SNAPSHOT
 */
package org.agileware.natural.lang.formatting2

import com.google.inject.Inject
import org.agileware.natural.lang.model.Document
import org.agileware.natural.lang.services.NaturalGrammarAccess
import org.eclipse.xtext.formatting2.AbstractFormatter2
import org.eclipse.xtext.formatting2.IFormattableDocument

class NaturalFormatter extends AbstractFormatter2 {
	
	@Inject extension NaturalGrammarAccess

	def dispatch void format(Document model, extension IFormattableDocument document) {
		for (s : model.sections) {
			s.format()
		}
	}
}