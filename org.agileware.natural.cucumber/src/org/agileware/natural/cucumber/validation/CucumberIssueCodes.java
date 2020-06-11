package org.agileware.natural.cucumber.validation;

import org.agileware.natural.core.validation.IssueCode;

public class CucumberIssueCodes {

	public static IssueCode MISSING_SCENARIOS = new IssueCode("MissingScenarios", "Missing scenarios.");
	
	public static IssueCode MISSING_TITLE = new IssueCode("MissingTitle", "Missing title.");

	public static IssueCode MISSING_STEPS = new IssueCode("MissingSteps", "Missing steps.");
	
	public static IssueCode MISSING_STEPDEF = new IssueCode("MissingStepdef", "Missing step definition.");
	
	public static IssueCode MULTIPLE_STEPDEFS = new IssueCode("MultipleStepdefs", "Multiple step definitions.");
}
