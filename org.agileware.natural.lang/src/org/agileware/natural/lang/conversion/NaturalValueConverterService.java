package org.agileware.natural.lang.conversion;

import java.math.BigInteger;

import org.eclipse.xtext.conversion.IValueConverter;
import org.eclipse.xtext.conversion.ValueConverter;
import org.eclipse.xtext.conversion.impl.AbstractDeclarativeValueConverterService;
import org.eclipse.xtext.conversion.impl.STRINGValueConverter;

import com.google.inject.Inject;

public class NaturalValueConverterService extends AbstractDeclarativeValueConverterService {

	@Inject
	private STRINGValueConverter stringValueConverter;

	@ValueConverter(rule = "STRING_LITERAL")
	public IValueConverter<String> STRING_LITERAL() {
		return stringValueConverter;
	}

	@Inject
	private NUMBERValueConverter numberValueConverter;

	@ValueConverter(rule = "NUMBER_LITERAL")
	public IValueConverter<BigInteger> NUMBER_LITERAL() {
		return numberValueConverter;
	}

}
