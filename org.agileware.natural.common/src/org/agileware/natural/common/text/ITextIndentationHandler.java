package org.agileware.natural.common.text;

/**
 * The indentation handler encapsulates the logic of rich string indentation
 * with respect to template and semantic whitespace per line.
 * @author Sebastian Zarnekow - Initial contribution and API
 */
public interface ITextIndentationHandler {

	/**
	 * Announce semantic indentation. The passed indentation is expected to
	 * contain the complete whitespace prefix of a line. Implementors will
	 * extract the new parts from it automatically.
	 * @param completeIndentation the leading whitespace of a line. May not be <code>null</code>.
	 */
	void pushSemanticIndentation(final CharSequence completeIndentation);

	/**
	 * Drop the recently announced indentation and use the previous state.
	 */
	void popIndentation();

	/**
	 * Announce the current indentation to the acceptor.
	 */
	void accept(final ITextPartAcceptor acceptor);

	/**
	 * Return the current semantic indentation.
	 * @return the complete semantic indentation. Never <code>null</code>.
	 */
	CharSequence getTotalSemanticIndentation();

	/**
	 * Return the current indentation.
	 * @return the complete indentation. Never <code>null</code>.
	 */
	CharSequence getTotalIndentation();
}
