/*
 * generated by Xtext 2.21.0
 */
package org.agileware.natural.jbehave.web;

import com.google.inject.Guice;
import com.google.inject.Injector;
import org.agileware.natural.jbehave.JbehaveRuntimeModule;
import org.agileware.natural.jbehave.JbehaveStandaloneSetup;
import org.agileware.natural.jbehave.ide.JbehaveIdeModule;
import org.eclipse.xtext.util.Modules2;

/**
 * Initialization support for running Xtext languages in web applications.
 */
public class JbehaveWebSetup extends JbehaveStandaloneSetup {
	
	@Override
	public Injector createInjector() {
		return Guice.createInjector(Modules2.mixin(new JbehaveRuntimeModule(), new JbehaveIdeModule(), new JbehaveWebModule()));
	}
	
}
