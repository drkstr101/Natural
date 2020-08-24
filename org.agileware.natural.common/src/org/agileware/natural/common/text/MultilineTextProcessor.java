package org.agileware.natural.common.text;

public class MultilineTextProcessor {

	public TextModel process(final String originalText, final DefaultIndentationHandler handler) {
		return TextModel.build(originalText);
	}

}
