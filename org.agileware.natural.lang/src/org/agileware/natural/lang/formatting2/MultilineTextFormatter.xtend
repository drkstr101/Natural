package org.agileware.natural.lang.formatting2

import com.google.inject.Inject
import org.agileware.natural.lang.services.NaturalGrammarAccess
import org.agileware.natural.lang.text.TextModel
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.eclipse.xtext.Assignment
import org.eclipse.xtext.formatting.IIndentationInformation
import org.eclipse.xtext.formatting2.IFormattableDocument
import org.eclipse.xtext.formatting2.ITextReplacer
import org.eclipse.xtext.formatting2.ITextReplacerContext
import org.eclipse.xtext.formatting2.regionaccess.ITextRegionAccess
import org.eclipse.xtext.formatting2.regionaccess.ITextRegionExtensions
import org.eclipse.xtext.formatting2.regionaccess.ITextSegment
import org.eclipse.xtext.formatting2.regionaccess.internal.NodeSemanticRegion

@FinalFieldsConstructor
class MultilineTextFormatter {

	static class Factory {
		@Inject IIndentationInformation indentationInformation

		def MultilineTextFormatter create(ITextRegionAccess regionAccess, NaturalGrammarAccess grammerAccess) {
			new MultilineTextFormatter(this, regionAccess.extensions, grammerAccess)
		}
	}

	val Factory factory

	val extension ITextRegionExtensions

	val extension NaturalGrammarAccess grammarAcess

	def formatText(EObject owner, Assignment assignment, extension IFormattableDocument doc) {
		val region = owner.regionFor.assignment(assignment)
		if (region instanceof NodeSemanticRegion) {
			addReplacer(new MultilineTextReplacer(grammarAcess, region))
		}
	}
}

@FinalFieldsConstructor
class MultilineTextReplacer implements ITextReplacer {

	val NaturalGrammarAccess grammarAcess

	val NodeSemanticRegion region

	override ITextSegment getRegion() {
		region
	}

	override createReplacements(ITextReplacerContext context) {
		val text = new TextModel()
		println('''
			"======= Processng Text ======="
		''')
		for (literal : region.node.leafNodes) {
			println(literal)
		}
		
		// context.addReplacement(region.replaceWith(newText))
		return context
	}
}
