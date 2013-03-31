<%@ page import = "com.google.appengine.api.users.*"%><%
%><%@ page import = "com.google.appengine.api.datastore.Link"%><%
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

String redirect = request.getParameter("redirect");
String delete = request.getParameter("delete");
String text = request.getParameter("text");
String cat = request.getParameter("cat");

String addlocal = request.getParameter("addlocal");
String add = request.getParameter("add");

HlinkManager m = new HlinkManager();
if(delete!=null){
	m.delete(delete);
}else if(text!=null && cat!=null){
	if(addlocal!=null){
		LHlink lnk = new LHlink();
		lnk.text=text;
		lnk.cat=cat;
		lnk.href=addlocal;
		m.store(lnk);
	}else if(add!=null){
		Hlink lnk = new Hlink();
		lnk.text=text;
		lnk.cat=cat;
		lnk.href=new Link(add);
		m.store(lnk);
	}
}

if(redirect!=null){
	response.setStatus(response.SC_SEE_OTHER);
	response.setHeader("Location",redirect);
}
%>