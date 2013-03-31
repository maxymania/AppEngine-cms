<%@ page import = "c_gh.maxymania.gaecms.*"%><%
%><%@ page import = "java.util.regex.*"%><%
%><%! Pattern EMAIL = Pattern.compile("[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}", Pattern.CASE_INSENSITIVE) ; %><%

Settings settings = new Settings();
Settings.Config conf = settings.load();

String articleid = request.getParameter("articleid");
String author = request.getParameter("author");
String email = request.getParameter("email");
String comment = request.getParameter("comment");

if(!conf.allowComments())throw new ServletException("Posting not disabled.");
if(articleid==null||author==null||email==null||comment==null)throw new ServletException("Execution error");

Articles arts = new Articles();

if(EMAIL.matcher(email).matches()){
	Comment c = new Comment();
	c.email=email;
	c.name=author;
	c.text=comment;
	arts.addComment(articleid,c);
}

response.setStatus(response.SC_SEE_OTHER);
response.setHeader("Location",request.getContextPath()+"/"+ParameterUtils.createParameters(response,"page",articleid));
%>