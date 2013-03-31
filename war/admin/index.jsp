<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%
%><%@ page import = "com.google.appengine.api.users.*"%><%
%><%@ page import = "c_gh.maxymania.gaecms.*"%><%
UserService userService = UserServiceFactory.getUserService();
boolean logged;
boolean admin;
{
	logged=userService.isUserLoggedIn();
	User user;
	if(logged){
		admin=userService.isUserAdmin();
		user =userService.getCurrentUser();
	}else{
		admin=false;
		user = null;
	}
}

String url = request.getRequestURI()+ParameterUtils.addParameters(request, response);
String logioUrl = logged?userService.createLogoutURL(url):userService.createLoginURL(url);
String logio = userService.isUserLoggedIn()?"Logout":"Login";


request.setAttribute("logiohref",logioUrl);
request.setAttribute("logio",logio);


request.setAttribute("op", "none");
String loc = request.getParameter("loc");
if(loc==null){
	request.setAttribute("op", "listarticles");
}else if("newarticle".equalsIgnoreCase(loc)){
	request.setAttribute("op", "edit");
	request.setAttribute("id", "example-id");
	request.setAttribute("title", "Example Title");
	request.setAttribute("text", "");
	// dont forget: if something is to escape, do it here!
}else if("edit".equalsIgnoreCase(loc)){
	String id = request.getParameter("id");
	if(id!=null){
		Articles arts = new Articles();
		Article art = arts.getArticle(id);
		if(art!=null){
			request.setAttribute("op", "edit");
			request.setAttribute("id", EscapeUtils.escape(art.id));
			request.setAttribute("title", EscapeUtils.escape(art.title));
			request.setAttribute("text", EscapeUtils.escape(art.text));
		}else{
			request.setAttribute("op", "error404article");
			request.setAttribute("id", EscapeUtils.escape(id));
		}
	}
}else if("listarticles".equalsIgnoreCase(loc)){
	request.setAttribute("op", "listarticles");
}else if("comments".equalsIgnoreCase(loc)){
	request.setAttribute("op", "listcomments");
}else if("files".equalsIgnoreCase(loc)){
	request.setAttribute("op", "files");
}else if("lhlinks".equalsIgnoreCase(loc)){
	request.setAttribute("op", "lhlinks");
}else if("hlinks".equalsIgnoreCase(loc)){
	request.setAttribute("op", "hlinks");
}else if("global-settings".equalsIgnoreCase(loc)){	
	request.setAttribute("op", "global-settings");
}

if(logged&&admin){
request.setAttribute("adminToken","OK");
%><jsp:forward page="inside.jsp"/><%
}else{%><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="bootstrap/css/bootstrap.css" rel="stylesheet">
<link href="style.css" rel="stylesheet">
</head>
<body>
<div style="position: absolute; left: 10px; right: 10px; top: 10px; bottom: 10px;">
<div class="well" style="float: left; padding: 8px;">
Sorry, This site part is only allowed for the Admininistrator.<br>
<% if(logged){ %>Only the Administrator can Login for this site.<%} %>
<a href="<%=logioUrl %>"><%=logio %></a>
</div>
</div>
</body>
</html><%}%>