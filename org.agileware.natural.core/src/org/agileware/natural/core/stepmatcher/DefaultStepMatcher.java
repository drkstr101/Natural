package org.agileware.natural.core.stepmatcher;

import java.util.Collection;
import java.util.Collections;

public class DefaultStepMatcher implements IStepMatcher {

	@Override
	public boolean isActivated() {
		return false;
	}
	
	@Override
	public void evict() {}

	@Override
	public void findMatches(String description, IMatchCollector collector) {}

	@Override
	public Collection<String> findProposals() {
		return Collections.emptyList();
	}

}
