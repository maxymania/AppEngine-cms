package c_gh.maxymania.gaecms;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Enumeration;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public class ParameterUtils {
	@SuppressWarnings("unchecked")
	public static Map<String,String> getParameters(ServletRequest request){
		LinkedHashMap<String,String> pm=new LinkedHashMap<String,String>();
		Enumeration<String> names = request.getParameterNames();
		while(names.hasMoreElements()){
			String k = names.nextElement();
			pm.put(k, request.getParameter(k));
		}
		return pm;
	}
	
	public static String encodeToUrl(Map<String,String> param,String encoding) throws UnsupportedEncodingException{
		StringBuffer sb=new StringBuffer();
		boolean first=true;
		for(Entry<String, String> e:param.entrySet()){
			if(first){
				sb.append("?");
				first=false;
			}else
				sb.append("&");
			sb.append(URLEncoder.encode(e.getKey(), encoding)).append("=").append(URLEncoder.encode(e.getValue(), encoding));
		}
		return sb.toString();
	}
	public static String encodeToUrl(Map<String,String> param) throws UnsupportedEncodingException{
		return encodeToUrl(param,"UTF-8");
	}
	public static String encodeToUrl(Map<String,String> param,ServletResponse resp) throws UnsupportedEncodingException{
		return encodeToUrl(param,resp.getCharacterEncoding());
	}
	public static String addParameters(ServletRequest request,ServletResponse response,String ... kvps) throws UnsupportedEncodingException{
		Map<String, String> params = getParameters(request);
		int n = kvps.length;
		for(int i=0;i<n;i+=2){
			String k = kvps[i];
			String v = kvps[i+1];
			if(v!=null)
				params.put(k,v);
			else if(params.containsKey(k))
				params.remove(k);
		}
		return encodeToUrl(params,response);
	}
	public static String createParameters(ServletResponse response,String ... kvps) throws UnsupportedEncodingException{
		Map<String, String> params = new LinkedHashMap<String,String>();
		int n = kvps.length;
		for(int i=0;i<n;i+=2){
			String k = kvps[i];
			String v = kvps[i+1];
			if(v!=null)
				params.put(k,v);
			else if(params.containsKey(k))
				params.remove(k);
		}
		return encodeToUrl(params,response);
	}
	public static int parseInt(String i,int def){
		try{
			return Integer.parseInt(i);
		}catch(NumberFormatException e){}
		return def;
	}
}
