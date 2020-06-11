package org.agileware.natural.core.validation;

import java.util.Formatter;
import java.util.Locale;

public class IssueCode {
	
	static final Formatter formatter = new Formatter(new StringBuilder(), Locale.US);
	
	static final String PREFIX = "org.agileware.natural.";
	
	private String id;
	
	private String msg;

	public IssueCode(String id, String msg) {
		this.id = PREFIX + id;
		this.msg = msg;
	}

	public String id() {
		return this.id;
	}

	public String message(Object... tokens) {
		return formatter.format(this.msg, tokens).toString();
	}
}
