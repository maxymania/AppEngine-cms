<%@ page import="c_gh.maxymania.gaecms.*" %><%
%><%! java.text.SimpleDateFormat DATEFMT = new java.text.SimpleDateFormat("yyyy/MM/dd hh:mm:ss");%><%
if(request.getAttribute("wstitle")==null) throw new ServletException("Access Not Granted");
Settings.Config conf = (Settings.Config)request.getAttribute("settingscfg");


String pgid = request.getParameter("page");
String blogview = request.getParameter("blogview");
String viewLHCat = request.getParameter("viewlhcat");
String viewHCat = request.getParameter("viewhcat");

boolean isblogview = "true".equalsIgnoreCase(blogview);


if(viewLHCat==null&&viewHCat==null&&pgid==null&&!isblogview){
	if("blog".equals(conf.defaultAction()))
		isblogview=true;
	else
		pgid="home";
}
//if(pgid==null)pgid="home";
//if(pgid==null)isblogview=true;

if(isblogview){
Articles arts = new Articles();
int n=0;
int pg=ParameterUtils.parseInt(""+request.getParameter("p"), 0);
Iterable<String> ids = arts.blogQuery(100, 0);
Iterable<Article> al = arts.getArticles(ids);
if(al==null)
	al = arts.getArticles2(ids);
%>
<% for(Article art:al){ %>
	<div class="post type-post hentry">
	<h2 class="entry-title"><%=EscapeUtils.escape(art.title) %></h2>
	<!--<div class="entry-meta">Meta Meta Meta</div>-->
	<div class="entry-content">
	<%=art.text %>
	</div>
	<div class="entry-utility"><a href="?page=<%=art.id %>" class="noprint">more ...</a></div>
	</div>
<% } %>
<% }else if(viewLHCat!=null){
HlinkManager hlman = new HlinkManager();
int pg=ParameterUtils.parseInt(""+request.getParameter("p"), 0);
int n=0;
%>

<div class="post type-post hentry">
<h2 class="entry-title"><%=EscapeUtils.escape(viewLHCat) %></h2>
<!--<div class="entry-meta">Meta Meta Meta</div>-->
<div class="entry-content">
<ul>
<% for(LHlink lnk:hlman.getLHLinks(100, 0, viewLHCat)){n++; %>
	<li><a href="<%=request.getContextPath()+lnk.href %>"><%=EscapeUtils.escape(lnk.text) %></a></li>
<% } %>
</ul>
</div>
<div class="entry-utility">
<% if(pg>0){%>
<a href="<%= ParameterUtils.addParameters(request, response,"p",""+(pg-1)) %>" class="noprint">Previous</a>
<% }if(n==100){ %>
<% if(pg>0){%> | <%} %>
<a href="<%= ParameterUtils.addParameters(request, response,"p",""+(pg+1)) %>" class="noprint">Next</a>
<% } %>
</div>
</div>

<% }else if(viewHCat!=null){
HlinkManager hlman = new HlinkManager();
int pg=ParameterUtils.parseInt(""+request.getParameter("p"), 0);
int n=0;
%>

<div class="post type-post hentry">
<h2 class="entry-title"><%=EscapeUtils.escape(viewHCat) %></h2>
<!--<div class="entry-meta">Meta Meta Meta</div>-->
<div class="entry-content">
<ul>
<% for(Hlink lnk:hlman.getHLinks(100, 0, viewHCat)){n++; %>
	<li><a href="<%=lnk.href.toString() %>"><%=EscapeUtils.escape(lnk.text) %></a></li>
<% } %>
</ul>
</div>
<div class="entry-utility">
<% if(pg>0){%>
<a href="<%= ParameterUtils.addParameters(request, response,"p",""+(pg-1)) %>" class="noprint">Previous</a>
<% }if(n==100){ %>
<% if(pg>0){%> | <%} %>
<a href="<%= ParameterUtils.addParameters(request, response,"p",""+(pg+1)) %>" class="noprint">Next</a>
<% } %>
</div>
</div>

<% }else{
Articles arts = new Articles();
Article art = arts.getArticle(pgid);
if(art!=null){
%>
<div class="post type-post hentry">
<h2 class="entry-title"><%=EscapeUtils.escape(art.title) %></h2>
<!--<div class="entry-meta">Meta Meta Meta</div>-->
<div class="entry-content">
<%=art.text %>
</div>
</div>


<div id="comments">

<ol class="commentlist">

<%
int n=0;
int pg=ParameterUtils.parseInt(""+request.getParameter("cp"), 0);
for(Comment com:arts.getComments(art.id, 100, pg)){
%>
<li class="comment even thread-even depth-1" id="li-comment-1">
<div class="comment-author vcard"><%=EscapeUtils.escape(com.name) %></div>
<div class="comment-meta commentmetadata">answered:</div>
<div class="comment-body">
<%=EscapeUtils.escape(com.text) %>
</div>
</li>
<% } %>

</ol>
<% if(conf.allowComments()){ %>
<div id="respond">
<h3 id="reply-title">Leave a Comment</h3>
<form action="<%=request.getContextPath()%>/post_comment.jsp" method="post" id="commentform">
<p class="comment-notes">Your E-Mail will not be published. Required Fields are Marked<span class="required">*</span></p>
<p class="comment-form-author"><label for="author">Name</label> <span class="required">*</span><input id="author" name="author" type="text" value="" size="30" aria-required="true" /></p>
<p class="comment-form-email"><label for="email">E-Mail</label> <span class="required">*</span><input id="email" name="email" type="text" value="" size="30" aria-required="true" /></p>
<p class="comment-form-comment"><label for="comment">Kommentar</label><textarea id="comment" name="comment" cols="45" rows="8" aria-required="true"></textarea></p>
<p class="form-submit">
	<input name="submit" type="submit" id="submit" value="Post Comment" />
	<input type='hidden' name="articleid" value="<%=art.id %>" />
</p>
</form>
</div>
<% } %>

</div>

<% } else { %>
<div class="post type-post hentry">
<h2 class="entry-title">Error 404</h2>
<!--<div class="entry-meta">Meta Meta Meta</div>-->
<div class="entry-content">
<p>This page was not found!</p>
<p>pageid = <%=EscapeUtils.escape(pgid) %></p>
</div>
</div>
<% }
} %>
