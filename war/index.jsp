<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%
%><%@ page import = "com.google.appengine.api.users.*"%><%
%><%@ page import = "c_gh.maxymania.gaecms.*"%><%
UserService userService = UserServiceFactory.getUserService();
//request.setAttribute("wstitle", "My Content Management System");
//request.setAttribute("wstitle2", "Yet another subtitle");
{
	boolean logged=userService.isUserLoggedIn();
	boolean admin;
	User user;
	if(logged){
		admin=userService.isUserAdmin();
		user =userService.getCurrentUser();
	}else{
		admin=false;
		user = null;
	}
	request.setAttribute("isAdmin",admin);
	request.setAttribute("isLogin",logged);
	request.setAttribute("user"   ,user);
}
Settings settings = new Settings();
Settings.Config conf = settings.load();
request.setAttribute("settingscfg", conf);
request.setAttribute("wstitle", conf.wstitle());
request.setAttribute("wstitle2", conf.wstitle2());

String url = request.getRequestURI()+ParameterUtils.addParameters(request, response);
String logioUrl = userService.isUserLoggedIn()?userService.createLogoutURL(url):userService.createLoginURL(url);
String logio = userService.isUserLoggedIn()?"Logout":"Login";

request.setAttribute("logiohref",logioUrl);
request.setAttribute("logio",logio);

%><jsp:forward page="inside.jsp"/>