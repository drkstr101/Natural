package org.agileware.natural.common.stepmatcher;

import org.eclipse.jdt.core.IMethod;

public class StepMatchEntry {

	private final String _annotationValue;

	/**
	 * @return the _annotationValue
	 */
	public String getAnnotationValue() {
		return _annotationValue;
	}

	private final IMethod _method;

	/**
	 * @return the _method
	 */
	public IMethod getMethod() {
		return _method;
	}

	/**
	 * @param annotationValue
	 * @param method
	 */
	public StepMatchEntry(String annotationValue, IMethod method) {
		_annotationValue = annotationValue;
		_method = method;
	}

}
