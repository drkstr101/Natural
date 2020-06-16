/*
 * generated by Xtext 2.21.0
 */
package org.agileware.natural.cucumber.validation;

import static org.agileware.natural.cucumber.cucumber.CucumberPackage.Literals.ABSTRACT_SCENARIO__STEPS;
import static org.agileware.natural.cucumber.cucumber.CucumberPackage.Literals.BACKGROUND__STEPS;
import static org.agileware.natural.cucumber.cucumber.CucumberPackage.Literals.FEATURE__SCENARIOS;
import static org.agileware.natural.cucumber.cucumber.CucumberPackage.Literals.SECTION__TITLE;
import static org.agileware.natural.cucumber.validation.CucumberIssueCodes.MISSING_SCENARIOS;
import static org.agileware.natural.cucumber.validation.CucumberIssueCodes.MISSING_STEPS;
import static org.agileware.natural.cucumber.validation.CucumberIssueCodes.MISSING_TITLE;

import org.agileware.natural.common.stepmatcher.IStepMatcher;
import org.agileware.natural.cucumber.cucumber.AbstractScenario;
import org.agileware.natural.cucumber.cucumber.Background;
import org.agileware.natural.cucumber.cucumber.Feature;
import org.eclipse.xtext.validation.Check;
import org.eclipse.xtext.validation.CheckType;

import com.google.inject.Inject;

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
public class CucumberValidator extends AbstractCucumberValidator {
	
	@Inject IStepMatcher stepMatcher;
	
	@Check
	public void featureHasTitle(Feature model) {
		if (model.getTitle() == null) {
			warning(MISSING_TITLE.message(), model, SECTION__TITLE, MISSING_TITLE.id());
		}
	}
	
	@Check
	public void featureHasScenarios(Feature model) {
		if (model.getScenarios().isEmpty()) {
			warning(MISSING_SCENARIOS.message(), model, FEATURE__SCENARIOS, MISSING_SCENARIOS.id());
		}
	}
	
	@Check
	public void scenarioHasTitle(AbstractScenario model) {
		if (model.getTitle() == null) {
			warning(MISSING_TITLE.message(), model, SECTION__TITLE, MISSING_TITLE.id());
		}
	}
	
	@Check
	public void backgroundHasSteps(Background model) {
		if (model.getSteps().isEmpty()) {
			warning(MISSING_STEPS.message(), model, BACKGROUND__STEPS, MISSING_STEPS.id());
		}
	}
	
	@Check
	public void scenarioHasSteps(AbstractScenario model) {
		if (model.getSteps().isEmpty()) {
			error(MISSING_STEPS.message(), model, ABSTRACT_SCENARIO__STEPS, MISSING_STEPS.id());
		}
	}
	
	@Check(CheckType.EXPENSIVE)
	public void stepHasMatchingAnnotation(Background model) {
		if(stepMatcher.isActivated()) {
			// TODO...
		}
	}
	
}