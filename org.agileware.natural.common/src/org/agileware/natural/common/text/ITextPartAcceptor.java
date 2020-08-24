package org.agileware.natural.common.text;

/**
 * The {@link ITextPartAcceptor} can be passed into a {@link MultilineTextProcessor} to
 * handle the semantics of a {@link org.eclipse.xtend.core.xtend.RichString} for a
 * specific use case. It's mainly an event sink but may influence the control flow
 * of the {@link MultilineTextProcessor}.
 *
 * @author Sebastian Zarnekow - Initial contribution and API
 */
public interface ITextPartAcceptor {
	/**
	 * @param text the semantic text. May not be <code>null</code>.
	 */
	void acceptSemanticText(final CharSequence text);

	/**
	 * Indicates a semantic line break in a rich string literal.
	 * @param origin the instance holding the complete text value that contains the line break.
	 */
	void acceptSemanticLineBreak(final int charCount);
}
