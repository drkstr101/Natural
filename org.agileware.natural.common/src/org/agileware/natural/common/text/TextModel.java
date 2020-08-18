package org.agileware.natural.common.text;

import java.util.Collections;
import java.util.List;

import com.google.common.collect.Lists;

/**
 * @author Sebastian Zarnekow - Initial contribution and API
 *
 */
public class TextModel {

	public static TextModel build(final String text) {
		final List<TextLine> lines = Lists.newArrayList();
		appendLines(text, lines);

		return new TextModel(Collections.unmodifiableList(lines));
	}

	/**
	 * adapted from
	 * org.eclipse.jface.text.DefaultLineTracker.nextDelimiterInfo(String, int)
	 */
	public static void appendLines(final String text, final List<TextLine> result) {
		if (text == null)
			return;
		final int length = text.length();
		int nextLineOffset = 0;
		int idx = 0;
		while (idx < length) {
			final char currentChar = text.charAt(idx);
			// check for \r or \r\n
			if (currentChar == '\r') {
				int delimiterLength = 1;
				if (idx + 1 < length && text.charAt(idx + 1) == '\n') {
					delimiterLength++;
					idx++;
				}
				final int lineLength = idx - delimiterLength - nextLineOffset + 1;
				final TextLine line = new TextLine(text, nextLineOffset, lineLength, delimiterLength);
				result.add(line);
				nextLineOffset = idx + 1;
			} else if (currentChar == '\n') {
				final int lineLength = idx - nextLineOffset;
				final TextLine line = new TextLine(text, nextLineOffset, lineLength, 1);
				result.add(line);
				nextLineOffset = idx + 1;
			}
			idx++;
		}
		if (nextLineOffset != length) {
			final int lineLength = length - nextLineOffset;
			final TextLine line = new TextLine(text, nextLineOffset, lineLength, 0);
			result.add(line);
		}
	}

	private final List<TextLine> _lines;

	public List<TextLine> getLines() {
		return _lines;
	}

	private TextModel(final List<TextLine> lines) {
		_lines = lines;
	}

	@Override
	public String toString() {
		return String.join(System.lineSeparator(), _lines);
	}
}
