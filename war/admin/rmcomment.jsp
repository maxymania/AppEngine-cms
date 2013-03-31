<%@ page import = "com.google.appengine.api.users.*"%><%
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
if(!admin)throw new ServletException("Access Not Granted");

String id = request.getParameter("id");

if(id==null)throw new ServletException("Invalid Operation");

Articles arts = new Articles();

arts.deleteComment(id);

response.setStatus(response.SC_SEE_OTHER);
response.setHeader("Location",request.getContextPath()+"/admin/index.jsp"+ParameterUtils.createParameters(response,"loc","comments"));
%>