package org.agileware.natural.cucumber.validation;

import static org.agileware.natural.cucumber.cucumber.CucumberPackage.Literals.ABSTRACT_SCENARIO__STEPS;
import static org.agileware.natural.cucumber.cucumber.CucumberPackage.Literals.FEATURE__SCENARIOS;
import static org.agileware.natural.cucumber.cucumber.CucumberPackage.Literals.FEATURE__TITLE;
import static org.agileware.natural.cucumber.cucumber.CucumberPackage.Literals.STEP__DESCRIPTION;
import static org.agileware.natural.cucumber.validation.CucumberIssueCodes.MISSING_FEATURE_TITLE;
import static org.agileware.natural.cucumber.validation.CucumberIssueCodes.MISSING_SCENARIOS;
import static org.agileware.natural.cucumber.validation.CucumberIssueCodes.MISSING_SCENARIO_STEPS;
import static org.agileware.natural.cucumber.validation.CucumberIssueCodes.MISSING_STEPDEFS;
import static org.agileware.natural.cucumber.validation.CucumberIssueCodes.MULTIPLE_STEPDEFS;

import java.util.List;
import java.util.stream.Collectors;

import org.agileware.natural.common.JavaAnnotationMatcher;
import org.agileware.natural.cucumber.cucumber.AbstractScenario;
import org.agileware.natural.cucumber.cucumber.Background;
import org.agileware.natural.cucumber.cucumber.Feature;
import org.agileware.natural.cucumber.cucumber.Step;
import org.eclipse.jdt.core.IMethod;
import org.eclipse.xtext.util.Strings;
import org.eclipse.xtext.validation.Check;
import org.eclipse.xtext.validation.CheckType;
import org.eclipse.xtext.validation.ValidationMessageAcceptor;

import com.google.inject.Inject;

public class CucumberValidator extends AbstractCucumberValidator {

	private static boolean isBackground(AbstractScenario scenario) {
		return scenario instanceof Background;
	}

	private final static class Counter implements JavaAnnotationMatcher.Command {
		private int count = 0;

		public int get() {
			return count;
		}

		public void match(String annotationValue, IMethod method) {
			count++;
		}
	}

	@Inject
	private JavaAnnotationMatcher matcher;

	/**
	 * Issue a warning if the Feature has no title
	 * 
	 * @param model
	 */
	@Check(CheckType.FAST)
	public void featureTitle(Feature model) {
		if (Strings.isEmpty(model.getTitle())) {
			warning("Feature title is missing", FEATURE__TITLE, ValidationMessageAcceptor.INSIGNIFICANT_INDEX,
					MISSING_FEATURE_TITLE);
		}
	}

	/**
	 * Issue a warning if Feature has no scenarios defined. **note:** Do not depend
	 * on grammar rule validation
	 * 
	 * @param model
	 */
	@Check(CheckType.FAST)
	public void missingScenarios(Feature model) {
		if (model.getScenarios().isEmpty()) {
			warning("Feature has no scenarios", model, FEATURE__SCENARIOS, MISSING_SCENARIOS);
		}
	}

	/**
	 * Issue a warning if AbstractScenario has no defined steps. **note:** Do not
	 * depend on grammar rule validation
	 * 
	 * @param model
	 */
	@Check(CheckType.FAST)
	public void missingScenarioSteps(AbstractScenario model) {
		if (model.getSteps().isEmpty()) {
			warning("Scenario has no steps", model, ABSTRACT_SCENARIO__STEPS, MISSING_SCENARIO_STEPS);
		}
	}

	@Check(CheckType.EXPENSIVE)
	public void invalidStepDefs(Step model) {
		System.out.println("Validating: " + model);
		final Counter counter = new Counter();
		String description = model.getDescription().trim();
		matcher.findMatches(description, counter);
		if (counter.get() == 0) {
			warning(String.format("No step definition found for `%s`", description), model, STEP__DESCRIPTION,
					MISSING_STEPDEFS);
		} else if (counter.get() > 1) {
			warning(String.format("Multiple step definitions found for `%s`", description), model, STEP__DESCRIPTION,
					MULTIPLE_STEPDEFS);
		}
	}
}
