/*
 * generated by Xtext
 */
package org.rlogiacco.eclipse.cucumber.ui;

import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.eclipse.xtext.ui.editor.hyperlinking.IHyperlinkHelper;

/**
 * Use this class to register components to be used within the IDE.
 */
public class CucumberDSLUiModule extends org.rlogiacco.eclipse.cucumber.ui.AbstractCucumberDSLUiModule {
	public CucumberDSLUiModule(AbstractUIPlugin plugin) {
		super(plugin);
	}
	
	@Override
	public Class<? extends IHyperlinkHelper> bindIHyperlinkHelper() {
		return CucumberDSLHyperlinkHelper.class;
	}
}
