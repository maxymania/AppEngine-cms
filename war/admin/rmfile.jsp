<%@ page import = "com.google.appengine.api.users.*"%><%
%><%@ page import = "c_gh.maxymania.gaecms.*"%><%
%><%@ page import = "c_gh.maxymania.gaecms.fileservice.*"%><%
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
if(!admin)throw new ServletException("Access Not Granted");

String name = request.getParameter("name");

if(name==null)throw new ServletException("Invalid Operation");

Files files = new Files();
Blobs blobs = new Blobs();

blobs.delete(files,name);


response.setStatus(response.SC_SEE_OTHER);
response.setHeader("Location",request.getContextPath()+"/admin/index.jsp"+ParameterUtils.createParameters(response,"loc","files"));
%>