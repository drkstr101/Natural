package org.agileware.natural.lang.formatting2

import com.google.inject.Inject
import org.agileware.natural.lang.text.TextLine
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
import org.eclipse.xtext.nodemodel.util.NodeModelUtils
import java.util.List

@FinalFieldsConstructor
class MultilineTextFormatter {

	static class Factory {
		@Inject IIndentationInformation indentationInformation

		def MultilineTextFormatter create(ITextRegionAccess regionAccess) {
			new MultilineTextFormatter(this, regionAccess.extensions)
		}
	}

	val Factory factory

	val extension ITextRegionExtensions

	def formatText(EObject owner, Assignment assignment, int indentationLevel, extension IFormattableDocument doc) {
		val region = owner.regionFor.assignment(assignment)
		if (region instanceof NodeSemanticRegion) {
			addReplacer(new MultilineTextReplacer(region, indentationLevel))
		}
	}
}

@FinalFieldsConstructor
class MultilineTextReplacer implements ITextReplacer {

	static def indentToRemove(List<TextLine> lines, int originalStartColumn) {
		var count = lines.length - 1
		if (count < 1) {
			return 0
		}

		val (TextLine)=>Integer countLeadingWS = [leadingWhiteSpace.length()]
		val minCountLeadingWS = lines.tail.take(count).map[countLeadingWS.apply(it)].min

		return Math.min(minCountLeadingWS, originalStartColumn)
	}

	val NodeSemanticRegion region

	val int indentationLevel

	override ITextSegment getRegion() {
		region
	}

	override createReplacements(ITextReplacerContext context) {
		val indentationString = context.getIndentationString(indentationLevel)
		val originalStartColumn = NodeModelUtils.getLineAndColumn(region.node, region.offset).column

		val model = TextModel.build(region.text)
		val indentToRemove = indentToRemove(model.lines, originalStartColumn)
		println('''======= Processng Text Indentation (indentationLevel: «indentationLevel», originalStartColumn: «originalStartColumn», indentToRemove: «indentToRemove») =======''')

		context.addReplacement(region.replaceWith(toIndentedString(model.lines, indentationString, indentToRemove)))

		return context
	}

	def String toIndentedString(List<TextLine> lines, String indentationString, int indentToRemove) {
		val result = new StringBuilder()
		val length = lines.size()

		for (var i = 0; i < length; i++) {
			val line = lines.get(i)
			println('''[offset: «line.relativeOffset», length: «line.length», leadingWhiteSpace: «line.leadingWhiteSpace.length»] «line»''')

			if (i == 0) {
				result.append(line)
			} else if (indentationString.length <= indentToRemove) {
				result.append(line)
			} else {
				result.append(indentationString)
						.append(line.leadingWhiteSpace)
						.append(line.semanticText)
			}

			if (i < length - 1) {
				result.append(System.lineSeparator());
			}
		}

		return result.toString();
	}
}
