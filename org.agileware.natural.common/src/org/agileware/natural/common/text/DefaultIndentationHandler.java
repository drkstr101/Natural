package org.agileware.natural.common.text;

import java.util.LinkedList;

import com.google.common.collect.Lists;

/**
 * Default indentation handler for multi-line strings. Tries to be graceful with
 * inconsistent indentation.
 * @author Sebastian Zarnekow - Initial contribution and API
 */
public class DefaultIndentationHandler implements ITextIndentationHandler {
	protected static abstract class IndentationData {
		protected CharSequence value;

		protected IndentationData(final CharSequence value) {
			this.value = value;
		}

		protected abstract void accept(ITextPartAcceptor acceptor);

		@Override
		public String toString() {
			return getClass().getSimpleName() + " [" + value + "]";
		}
	}

	protected static class SemanticIndentationData extends IndentationData {

		protected SemanticIndentationData(final CharSequence value) {
			super(value);
		}

		@Override
		protected void accept(final ITextPartAcceptor acceptor) {
			acceptor.acceptSemanticText(value);
		}

	}

	private LinkedList<IndentationData> indentationData;

	private final LinkedList<LinkedList<IndentationData>> indentationDataStack;

	public DefaultIndentationHandler() {
		this.indentationData = Lists.newLinkedList();
		this.indentationDataStack = Lists.newLinkedList();
		indentationDataStack.add(indentationData);
	}

	@Override
	public void popIndentation() {
		indentationData.removeLast();
		if (indentationData.isEmpty() && indentationDataStack.size() > 1) {
			indentationDataStack.removeLast();
			indentationData = indentationDataStack.getLast();
		}
	}

	@Override
	public void pushSemanticIndentation(final CharSequence indentation) {
		if (indentationData.isEmpty()) {
			indentationData.add(new SemanticIndentationData(indentation));
		} else {
			final String currentIndentation = getTotalIndentation();
			if (indentation.toString().startsWith(currentIndentation)) {
				final String trimmedIndentation = indentation.toString().substring(currentIndentation.length());
				indentationData.add(new SemanticIndentationData(trimmedIndentation));
			} else {
				final LinkedList<IndentationData> newIndentationData = Lists.newLinkedList();
				newIndentationData.add(new SemanticIndentationData(indentation));
				indentationDataStack.add(newIndentationData);
				indentationData = newIndentationData;
			}
		}
	}

	@Override
	public CharSequence getTotalSemanticIndentation() {
		final StringBuilder result = new StringBuilder();
		for(final IndentationData data: indentationData) {
			if (data instanceof SemanticIndentationData)
				result.append(data.value);
		}
		return result.toString();
	}

	@Override
	public String getTotalIndentation() {
		final StringBuilder result = new StringBuilder();
		for(final IndentationData data: indentationData) {
			result.append(data.value);
		}
		return result.toString();
	}

	@Override
	public void accept(final ITextPartAcceptor acceptor) {
		for(final IndentationData data: indentationData) {
			data.accept(acceptor);
		}
	}
}
