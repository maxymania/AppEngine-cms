package c_gh.maxymania.gaecms;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.servlet.ServletResponse;

import org.apache.commons.lang3.StringEscapeUtils;

public class EscapeUtils {
	public static String escape(String s) {
		return StringEscapeUtils.escapeHtml4(s);
	}
	public static String escapeXML(String s) {
		return StringEscapeUtils.escapeXml(s);
	}
	public static String escapeJS(String s) {
		return StringEscapeUtils.escapeEcmaScript(s);
	}
	public static String escapeURL(String s) throws UnsupportedEncodingException{
		return URLEncoder.encode(s, "UTF-8");
	}
	public static String escapeURL(String s,ServletResponse resp) throws UnsupportedEncodingException{
		return URLEncoder.encode(s, resp.getCharacterEncoding());
	}
}
