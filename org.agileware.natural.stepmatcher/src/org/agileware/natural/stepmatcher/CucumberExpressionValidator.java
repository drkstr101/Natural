package org.agileware.natural.stepmatcher;

import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.regex.PatternSyntaxException;

public class CucumberExpressionValidator {

	private static final Pattern TOKEN_PATTERN = Pattern.compile("(?|({\\w+})|(\\(\\w+(\\s\\w+)?\\)))");

	public static boolean isMatchingAnnotationValue(final String annotationValue, final String description) {
		return matchRegex(annotationValue, description) || matchExpression(annotationValue, description);
	}

	private static boolean matchRegex(final String annotationValue, final String description) {
		try {
			return description.matches(Pattern.quote(annotationValue));
		} catch (final PatternSyntaxException e) {
			// PASS
		}

		return false;
	}

	private static boolean matchExpression(final String annotationValue, final String description) {
		int lastIndex = 0;
		final StringBuilder result = new StringBuilder();
		final Matcher matcher = TOKEN_PATTERN.matcher(annotationValue);
		while (matcher.find()) {
			result.append(annotationValue, lastIndex, matcher.start()).append(convertToken(matcher.group(1)));
			lastIndex = matcher.end();
		}

		if (lastIndex < annotationValue.length()) {
			result.append(annotationValue, lastIndex, annotationValue.length());
		}

		try {
			return description.matches(Pattern.quote(result.toString()));
		} catch (final PatternSyntaxException e) {
			e.printStackTrace();
		}

		return false;
	}

	private static String convertToken(final String token) {
		System.out.println("Converting Cucumber Expression: " + token);
		return token;
	}
}
