package org.agileware.natural.cucumber.serializer

import org.agileware.natural.cucumber.cucumber.AbstractScenario
import org.agileware.natural.cucumber.cucumber.Background
import org.agileware.natural.cucumber.cucumber.CucumberModel
import org.agileware.natural.cucumber.cucumber.DocString
import org.agileware.natural.cucumber.cucumber.Example
import org.agileware.natural.cucumber.cucumber.Feature
import org.agileware.natural.cucumber.cucumber.Meta
import org.agileware.natural.cucumber.cucumber.MetaTag
import org.agileware.natural.cucumber.cucumber.Scenario
import org.agileware.natural.cucumber.cucumber.ScenarioOutline
import org.agileware.natural.cucumber.cucumber.Step
import org.agileware.natural.cucumber.cucumber.Table
import org.agileware.natural.cucumber.cucumber.TableCol
import org.agileware.natural.cucumber.cucumber.TableRow
import org.agileware.natural.cucumber.cucumber.Text
import org.agileware.natural.cucumber.cucumber.Title

class CucumberSerializer {

	def String serialize(CucumberModel model) '''
		«IF model.feature !== null»
			«serialize(model.feature)»
		«ENDIF»
	'''

	def String serialize(Feature model) '''
		«IF model.meta !== null»
			«serialize(model.meta)»
		«ENDIF»
		Feature: «serialize(model.title)»
		«serialize(model.narrative)»
		
		«IF model.background !== null»
			«serialize(model.background)»
		«ENDIF»
		«FOR s : model.scenarios»
			
			«serialize(s)»
		«ENDFOR»
	'''

	def String serialize(Background model) '''
		Background: «serialize(model.title)»
		«serialize(model.narrative)»
		«FOR s : model.steps»
			«serialize(s)»
		«ENDFOR»
	'''

	def String serialize(AbstractScenario model) {
		if (model instanceof Scenario) {
			return serialize(model as Scenario)
		} else if (model instanceof ScenarioOutline) {
			return serialize(model as ScenarioOutline)
		}

		return ""
	}

	def String serialize(Scenario model) '''
		«IF model.meta !== null»
			«serialize(model.meta)»
		«ENDIF»
		Scenario: «serialize(model.title)»
		«serialize(model.narrative)»
		«FOR s : model.steps»
			«serialize(s)»
		«ENDFOR»
	'''

	def String serialize(ScenarioOutline model) '''
		«IF model.meta !== null»
			«serialize(model.meta)»
		«ENDIF»
		Scenario Outline: «serialize(model.title)»
		«serialize(model.narrative)»
		«FOR s : model.steps»
			«serialize(s)»
		«ENDFOR»
		«FOR e : model.examples»
			
			«serialize(e)»
		«ENDFOR»
	'''

	def String serialize(Example model) '''
		«IF model.meta !== null»
			«serialize(model.meta)»
		«ENDIF»
		Example: «serialize(model.title)»
		«serialize(model.narrative)»
		«serialize(model.table)»
	'''

	def String serialize(Step model) '''
		«model.keyword» «model.description»
		«IF model.table !== null»
			«serialize(model.table)»
		«ELSEIF model.code !== null»
			«serialize(model.code)»
		«ENDIF»
	'''

	def String serialize(Meta model) '''
		«FOR t : model.tags»
			«serialize(t)»
		«ENDFOR»
	'''

	def String serialize(MetaTag model) '''
		«IF model.value === null»
			@«model.key»
		«ELSE»
			@«model.key»: «model.value»
		«ENDIF»
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

	def String serialize(DocString model) '''
		"""
		«model.text»
		"""
	'''

	def String serialize(Title model) {
		return model === null ? "" : model.value
	}

	def String serialize(Text model) {
		return model === null ? "" : model.value
	}
}
