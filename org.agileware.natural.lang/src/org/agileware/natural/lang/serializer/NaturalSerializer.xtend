package org.agileware.natural.lang.serializer

import org.agileware.natural.lang.model.DocString
import org.agileware.natural.lang.model.Document
import org.agileware.natural.lang.model.Meta
import org.agileware.natural.lang.model.MultilineText
import org.agileware.natural.lang.model.NaturalModel
import org.agileware.natural.lang.model.Section
import org.agileware.natural.lang.model.Table
import org.agileware.natural.lang.model.TableCol
import org.agileware.natural.lang.model.TableRow
import org.agileware.natural.lang.model.Text

class NaturalSerializer {

	def String serialize(NaturalModel model) {
		return (model.document === null) ? "\n" : serialize(model.document)
	}

	def String serialize(Document model) '''
		# language: en
		«serialize(model.meta)»
		Document: «serialize(model.title)»
		«serialize(model.narrative)»
		«FOR s : model.sections»
			«serialize(s)»
		«ENDFOR»
	'''

	def String serialize(Section model) '''
		Section: «model.title»
		«serialize(model.narrative)»
	'''

	def String serialize(Text model) {
		if(model === null) return ""

		return model.value
	}

	def String serialize(MultilineText model) {
		if(model === null) return ""

		return model.value
	}

	def String serialize(Meta model) {
		if(model === null) return ""

		return '''
			«FOR t : model.tags»
				«t.value»
			«ENDFOR»
		'''
	}

	def String serialize(Table model) {
		if(model === null) return ""

		return '''
			«FOR r : model.rows»
				«serialize(r)»
			«ENDFOR»
		'''
	}

	def String serialize(TableRow model) '''
		«model.cols.map[serialize].join()» |
	'''

	def String serialize(TableCol model) {
		return model.value
	}

	def String serialize(DocString model) {
		if(model === null) return ""

		return '''
			«model.value»
		'''
	}
}
