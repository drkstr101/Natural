package org.agileware.natural.common.stepmatcher;

import java.util.Collection;
import java.util.Collections;

import org.eclipse.jdt.core.ICompilationUnit;

public class DefaultStepMatcher implements IStepMatcher {

	@Override
	public Collection<StepMatchEntry> findMatches(final String keyword, final String description) {
		return Collections.unmodifiableCollection(Collections.emptyList());
	}

	@Override
	public void evict(final ICompilationUnit element) {
		// do nothing...
	}

	@Override
	public boolean isActivated() {
		return false;
	}

}
