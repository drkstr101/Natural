package org.agileware.natural.lang.formatting2

import com.google.common.collect.Lists
import com.google.inject.Inject
import java.util.Collections
import java.util.List
import org.agileware.natural.lang.services.NaturalGrammarAccess
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.eclipse.xtext.Assignment
import org.eclipse.xtext.formatting.IIndentationInformation
import org.eclipse.xtext.formatting2.IFormattableDocument
import org.eclipse.xtext.formatting2.ITextReplacer
import org.eclipse.xtext.formatting2.ITextReplacerContext
import org.eclipse.xtext.formatting2.regionaccess.ISemanticRegion
import org.eclipse.xtext.formatting2.regionaccess.ITextRegionAccess
import org.eclipse.xtext.formatting2.regionaccess.ITextRegionExtensions
import org.eclipse.xtext.formatting2.regionaccess.ITextSegment
import org.eclipse.xtext.formatting2.regionaccess.internal.NodeSemanticRegion

@FinalFieldsConstructor
class NaturalTextFormatter {

	static class Factory {
		@Inject IIndentationInformation indentationInformation

		def NaturalTextFormatter create(ITextRegionAccess regionAccess, NaturalGrammarAccess grammerAccess) {
			new NaturalTextFormatter(this, regionAccess.extensions, grammerAccess)
		}
	}

	val Factory factory

	val extension ITextRegionExtensions

	val extension NaturalGrammarAccess

	def formatText(EObject owner, Assignment assignment, extension IFormattableDocument doc) {
		// TODO...
	}

	def formatMultilineText(EObject owner, Assignment assignment, extension IFormattableDocument doc) {
		val region = owner.regionFor.assignment(assignment)
	 	addReplacer(new MultilineTextReplacer(region))
	}

}

@FinalFieldsConstructor
class MultilineTextReplacer implements ITextReplacer {
	
	val ISemanticRegion region

	override ITextSegment getRegion() {
		region
	}

	override createReplacements(ITextReplacerContext context) {
		val model = LinesModel.build(region.text)
		
		println("======= LINE MODEL =======")
		for(l : model.lines) {
			println('''
			«l.relativeOffset»	«l.length»: «l»
			''')
		}
		println("======= LINE MODEL =======")
			
		val newText = model.toString()
		context.addReplacement(region.replaceWith(newText))
		
		return context
	}
}

/** 
 * @author Sebastian Zarnekow - Initial contribution and API
 */
class LinesModel {
	def static LinesModel build(String text) {
		val List<TextLine> lines = Lists::newArrayList()
		appendLines(text, lines)
		return new LinesModel(Collections::unmodifiableList(lines))
	}

	/** 
	 * adapted from
	 * org.eclipse.jface.text.DefaultLineTracker.nextDelimiterInfo(String, int)
	 */
	def static void appendLines(String text, List<TextLine> result) {
		if(text === null) return;
		val int length = text.length()
		var int nextLineOffset = 0
		var int idx = 0
		while (idx < length) {
			val char currentChar = (text.charAt(idx)) as char
			// check for \r or \r\n
			if (currentChar === Character.valueOf('\r').charValue) {
				var int delimiterLength = 1
				if (idx + 1 < length && text.charAt(idx + 1) === Character.valueOf('\n').charValue) {
					delimiterLength++
					idx++
				}
				val int lineLength = idx - delimiterLength - nextLineOffset + 1
				val TextLine line = new TextLine(text, nextLineOffset, lineLength, delimiterLength)
				result.add(line)
				nextLineOffset = idx + 1
			} else if (currentChar === Character.valueOf('\n').charValue) {
				val int lineLength = idx - nextLineOffset
				val TextLine line = new TextLine(text, nextLineOffset, lineLength, 1)
				result.add(line)
				nextLineOffset = idx + 1
			}
			idx++
		}
		if (nextLineOffset !== length) {
			val int lineLength = length - nextLineOffset
			val TextLine line = new TextLine(text, nextLineOffset, lineLength, 0)
			result.add(line)
		}
	}

	final List<TextLine> _lines

	def List<TextLine> getLines() {
		return _lines
	}

	private new(List<TextLine> lines) {
		_lines = lines
	}

	override String toString() {
		return String::join(System::lineSeparator(), _lines)
	}
}

/** 
 * @author Sebastian Zarnekow - Initial contribution and API
 */
class TextLine implements CharSequence {
	final String completeText
	final int offset
	final int length
	final int delimiterLength

	new(String completeText, int offset, int length, int delimiterLength) {
		this.completeText = completeText
		this.offset = offset
		this.length = length
		this.delimiterLength = delimiterLength
	}

	def String getCompleteText() {
		return completeText
	}

	def boolean hasLeadingWhiteSpace() {
		if(length === 0) return false
		val boolean result = Character::isWhitespace(charAt(0))
		return result
	}

	def boolean containsOnlyWhitespace() {
		for (var int i = 0; i < length(); i++) {
			if (!Character::isWhitespace(charAt(i))) {
				return false
			}
		}
		return true
	}

	def CharSequence getLeadingWhiteSpace() {
		for (var int i = 0; i < length(); i++) {
			if (!Character::isWhitespace(charAt(i))) {
				if(i === 0) return ""
				return new LeadingWSTextLinePart(completeText, offset, i)
			}
		}
		return new LeadingWSTextLinePart(completeText, offset, length)
	}

	def boolean hasTrailingLineBreak() {
		return delimiterLength > 0
	}

	def int getRelativeOffset() {
		return offset
	}

	override int length() {
		return length
	}

	override char charAt(int index) {
		return completeText.charAt(index + offset)
	}

	def int getDelimiterLength() {
		return delimiterLength
	}

	override String toString() {
		return completeText.substring(offset, offset + length)
	}

	override int hashCode() {
		val int prime = 31
		var int result = 1
		result = prime * result + toString().hashCode()
		result = prime * result + delimiterLength
		return result
	}

	override boolean equals(Object obj) {
		if(this === obj) return true
		if(obj === null) return false
		if(getClass() !== obj.getClass()) return false
		val TextLine other = (obj as TextLine)
		if(length !== other.length) return false
		if(delimiterLength !== other.delimiterLength) return false
		if(!completeText.regionMatches(offset, other.completeText, other.offset, length)) return false
		return true
	}

	/** 
	 * @throws IndexOutOfBoundsException if <tt>start</tt> or <tt>end</tt> are
	 * negative, if <tt>end</tt> is greater than
	 * <tt>length()</tt>, or if <tt>start</tt> is
	 * greater than <tt>end</tt>
	 */
	override CharSequence subSequence(int start, int end) {
		if (start < 0 || start > end) {
			throwIndexOutOfBounds(start)
		}
		if (end < 0 || end > length) {
			throwIndexOutOfBounds(end)
		}
		if (start > end) {
			throwIndexOutOfBounds(end - start)
		}
		return completeText.subSequence(start + offset, end + offset)
	}

	def protected void throwIndexOutOfBounds(int offset) {
		throw new IndexOutOfBoundsException(('''Index out of range: «offset»'''.toString))
	}
}

class LeadingWSTextLinePart extends TextLine {
	new(String completeText, int offset, int length) {
		super(completeText, offset, length, 0)
	}

	override CharSequence getLeadingWhiteSpace() {
		return this
	}

	override boolean hasLeadingWhiteSpace() {
		return length() > 0
	}

	override boolean containsOnlyWhitespace() {
		return true
	}
}

