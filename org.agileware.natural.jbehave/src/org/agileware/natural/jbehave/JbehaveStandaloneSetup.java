/*
 * generated by Xtext 2.21.0
 */
package org.agileware.natural.jbehave;


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
public class JbehaveStandaloneSetup extends JbehaveStandaloneSetupGenerated {

	public static void doSetup() {
		new JbehaveStandaloneSetup().createInjectorAndDoEMFRegistration();
	}
}
