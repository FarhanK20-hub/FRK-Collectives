package com.frk.tags;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.SimpleTagSupport;
import java.io.IOException;
import java.text.NumberFormat;
import java.util.Locale;

/**
 * CurrencyTag — Custom JSTL tag for formatting prices in Indian Rupees (₹).
 * Usage: <frk:formatCurrency value="${price}" />
 * Output: ₹ 4,999.00
 */
public class CurrencyTag extends SimpleTagSupport {
    private double value;

    public void setValue(double value) {
        this.value = value;
    }

    @Override
    public void doTag() throws JspException, IOException {
        JspWriter out = getJspContext().getOut();
        NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("en", "IN"));
        String formatted = currencyFormatter.format(value);
        out.print(formatted);
    }
}
