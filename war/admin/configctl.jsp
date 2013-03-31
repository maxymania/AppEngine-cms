<%@ page import = "com.google.appengine.api.users.*"%><%
%><%@ page import = "c_gh.maxymania.gaecms.*"%><%
%><%! java.text.SimpleDateFormat DATEPREFIX = new java.text.SimpleDateFormat("yyyy-MM-dd-hhmmss-");%><%
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

String reset = request.getParameter("reset");
boolean allowComments = "true".equalsIgnoreCase(request.getParameter("allowComments"));

if("1".equals(reset)){
	Settings settings = new Settings();
	Settings.Config conf = settings.load();
	conf.reset2();
	conf.store();
}else{
String
	admin_lhlink = request.getParameter("admin_lhlink"),
	admin_files_lhlink = request.getParameter("admin_files_lhlink"),
	admin_articles_lhlink = request.getParameter("admin_articles_lhlink"),
	sitebar_lhlink = request.getParameter("sitebar_lhlink"),
	menu_lhlink = request.getParameter("menu_lhlink"),
	admin_hlink = request.getParameter("admin_hlink"),
	sitebar_hlink = request.getParameter("sitebar_hlink"),
	default_action = request.getParameter("default_action"),
	wstitle = request.getParameter("wstitle"),
	wstitle2 = request.getParameter("wstitle2");

if(		admin_lhlink==null||
		sitebar_lhlink==null||
		menu_lhlink==null||
		admin_hlink==null||
		sitebar_hlink==null||
		default_action==null)throw new ServletException("Invalid Operation");

Settings settings = new Settings();
Settings.Config conf = settings.load();
conf.defaultAction(default_action);
conf.wstitle(wstitle);
conf.wstitle2(wstitle2);
conf.allowComments(allowComments);
conf.listV(Settings.LIST_ADMIN_LHLINK,admin_lhlink);
conf.listV(Settings.LIST_ADMIN_FILES_LHLINK,admin_files_lhlink);
conf.listV(Settings.LIST_ADMIN_ARTICLES_LHLINK,admin_articles_lhlink);

conf.listV(Settings.LIST_SITEBAR_LHLINK,sitebar_lhlink);
conf.listV(Settings.LIST_MENU_LHLINK,menu_lhlink);
conf.listV(Settings.LIST_ADMIN_HLINK,admin_hlink);
conf.listV(Settings.LIST_SITEBAR_HLINK,sitebar_hlink);
conf.store();
}


response.setStatus(response.SC_SEE_OTHER);
response.setHeader("Location","index.jsp"+ParameterUtils.createParameters( response,"loc","global-settings"));
%>