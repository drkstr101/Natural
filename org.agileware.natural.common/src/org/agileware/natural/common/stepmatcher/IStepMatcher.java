package org.agileware.natural.common.stepmatcher;

import java.util.Collection;

import org.eclipse.jdt.core.ICompilationUnit;

public interface IStepMatcher {
	
	public boolean isActivated();
	
	/**
	 * @param description
	 * @param command
	 */
	public Collection<StepMatchEntry> findMatches(final String keyword, final String description);
	
	/**
	 * @param element
	 */
	public void evict(final ICompilationUnit element);
}
