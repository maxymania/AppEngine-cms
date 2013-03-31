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
if(request.getParameter("id")==null)throw new ServletException("Invalid Operation");

boolean blogify = "true".equalsIgnoreCase(request.getParameter("blogify"));
String id = request.getParameter("id");


if(blogify)
	id = DATEPREFIX.format(new java.util.Date())+id;

Article art = new Article();
art.id = id;
art.title = request.getParameter("title");
art.text = request.getParameter("text");
if( (art.id==null)||
	(art.title==null)||
	(art.text==null))throw new ServletException("Posting Error");
Articles arts = new Articles();

arts.storeArticle(art);

if(blogify)
	arts.blogAdd(id);

response.setStatus(response.SC_SEE_OTHER);
response.setHeader("Location","index.jsp"+ParameterUtils.createParameters( response,"loc","edit","id",art.id));
%>