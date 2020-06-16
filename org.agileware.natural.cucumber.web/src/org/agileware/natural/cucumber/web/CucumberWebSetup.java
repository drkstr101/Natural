/*
 * generated by Xtext 2.21.0
 */
package org.agileware.natural.cucumber.web;

import com.google.inject.Guice;
import com.google.inject.Injector;
import org.agileware.natural.cucumber.CucumberRuntimeModule;
import org.agileware.natural.cucumber.CucumberStandaloneSetup;
import org.agileware.natural.cucumber.ide.CucumberIdeModule;
import org.eclipse.xtext.util.Modules2;

/**
 * Initialization support for running Xtext languages in web applications.
 */
public class CucumberWebSetup extends CucumberStandaloneSetup {
	
	@Override
	public Injector createInjector() {
		return Guice.createInjector(Modules2.mixin(new CucumberRuntimeModule(), new CucumberIdeModule(), new CucumberWebModule()));
	}
	
}