package org.agileware.natural.lang.serializer

import org.agileware.natural.lang.model.DocString
import org.agileware.natural.lang.model.Document
import org.agileware.natural.lang.model.Meta
import org.agileware.natural.lang.model.Narrative
import org.agileware.natural.lang.model.NarrativeSection
import org.agileware.natural.lang.model.NaturalModel
import org.agileware.natural.lang.model.Paragraph
import org.agileware.natural.lang.model.Section
import org.agileware.natural.lang.model.Table
import org.agileware.natural.lang.model.TableCol
import org.agileware.natural.lang.model.TableRow
import org.agileware.natural.lang.model.Tag
import org.eclipse.xtext.util.Strings

class NaturalSerializer {
	
	def String serialize(NaturalModel model) {
		return (model.document === null)? "\n" : serialize(model.document)
	}
	
	def String serialize(Document model) '''
		# language: en
		«FOR s : model.sections»
			«serialize(s)»
		«ENDFOR»
	'''

	def String serialize(Section model) '''
		Section: «model.title»
		«IF model.narrative !== null»
			«serialize(model.narrative)»
		«ENDIF»
	'''

	def String serialize(Narrative model) '''
		«FOR s : model.sections SEPARATOR '\n'»
			«serialize(s)»
		«ENDFOR»
	'''
	
	def String serialize(NarrativeSection model) {
		if(model instanceof Paragraph) return serialize(model as Paragraph)
		else if(model instanceof DocString) return serialize(model as DocString)
		else if(model instanceof Table) return serialize(model as Table)
		
		return "\n"
	}

	def String serialize(Meta model) '''
		«FOR t : model.tags»
			«serialize(t)»
		«ENDFOR»
	'''

	def String serialize(Tag model) {
		if(Strings.isEmpty(model.value)) {
			return '''
				@«model.id»
			'''
		}
		
		return '''
			@«model.id»: «model.value»
		'''
	}

	def String serialize(Paragraph model) '''
		«FOR l : model.lines»
			«l.value»
		«ENDFOR»
	'''

	/**
	 * TODO whitespace must be preserved in String contents!
	 *      We should use some kind of ITextReplacer implementation to
	 *      handle multi-line string formatting rather than using a
	 *      line-based text model in the AST.
	 */
	def String serialize(DocString model) '''
		"""
		«FOR l : model.contents.lines»
			«l»
		«ENDFOR»
		"""
	'''

	def String serialize(Table model) '''
		«FOR r : model.rows»
			«serialize(r)»
		«ENDFOR»
	'''

	def String serialize(TableRow model) '''
		«model.cols.map[serialize].join()» |
	'''

	def String serialize(TableCol model) {
		return model.cell
	}

}
