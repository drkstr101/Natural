package org.agileware.natural.core.formatting2;

import org.eclipse.xtext.formatting2.ITextReplacer;
import org.eclipse.xtext.formatting2.ITextReplacerContext;
import org.eclipse.xtext.formatting2.regionaccess.ITextSegment;
import org.eclipse.xtext.formatting2.regionaccess.internal.NodeSemanticRegion;

/**
 * Condenses EOL into a single line break prior to setting formatting rules.
 */
public class NewlineCondenser implements ITextReplacer {

	private NodeSemanticRegion region;

	public NewlineCondenser(NodeSemanticRegion region) {
		this.region = region;
	}

	@Override
	public ITextSegment getRegion() {
		return region;
	}

	@Override
	public ITextReplacerContext createReplacements(ITextReplacerContext context) {
		context.addReplacement(region.replaceWith(System.lineSeparator()));
		return context;
	}
}
