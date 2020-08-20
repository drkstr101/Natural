package org.agileware.natural.lang.formatting2

import com.google.inject.Inject
import org.agileware.natural.common.text.DefaultIndentationHandler
import org.agileware.natural.common.text.MultilineTextProcessor
import org.agileware.natural.lang.model.MultilineText
import org.agileware.natural.lang.model.Text
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.eclipse.xtext.formatting2.IFormattableDocument
import org.eclipse.xtext.formatting2.regionaccess.ITextRegionAccess
import org.eclipse.xtext.formatting2.regionaccess.ITextRegionExtensions

@FinalFieldsConstructor
class TextFormatter {

	static class Factory {
		@Inject MultilineTextProcessor multilineTextProcessor

		def TextFormatter create(ITextRegionAccess regionAccess) {
			new TextFormatter(this, regionAccess.extensions)
		}
	}

	val Factory factory
	
	val extension ITextRegionExtensions

	def dispatch void format(Text model, extension IFormattableDocument doc) {
		// TODO...
	}

	def dispatch void format(MultilineText model, extension IFormattableDocument doc) {
		val text = this.factory.multilineTextProcessor.process(model.value, new DefaultIndentationHandler())
		println('''
		==================
		Formated Text:
		«text.toString()»
		==================
		''')
	}

}
