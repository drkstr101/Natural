package org.agileware.natural.core.stepmatcher;

import java.util.Collection;

public interface IStepMatcher {
	
	public boolean isActivated();
	
	public void evict();
	
	public void findMatches(final String description, final IMatchCollector collector);
	
	public Collection<String> findProposals();
}
