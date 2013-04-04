<%@ page import="c_gh.maxymania.gaecms.*" %><%
if(request.getAttribute("wstitle")==null) throw new ServletException("Access Not Granted");
Settings.Config conf = (Settings.Config)request.getAttribute("settingscfg");
HlinkManager hlman = new HlinkManager();
%>
<!-- Sitebar Menus -->
<% for(String cat:conf.list(Settings.LIST_SITEBAR_LHLINK)){ %>
				<li class="widget-container widget_links"><h3 class="widget-title"><%=EscapeUtils.escape(cat) %></h3>
				<ul>
				<%
				for(LHlink lnk:hlman.getLHLinks(50, 0, cat)){
				%>
					<li><a href="<%=lnk.href.toString() %>"><%=EscapeUtils.escape(lnk.text) %></a></li>
				<% } %>
				</ul>
				</li>
<% } %>
<% for(String cat:conf.list(Settings.LIST_SITEBAR_HLINK)){ %>
				<li class="widget-container widget_links"><h3 class="widget-title"><%=EscapeUtils.escape(cat) %></h3>
				<ul>
				<%
				for(Hlink lnk:hlman.getHLinks(50, 0, cat)){
				%>
					<li><a href="<%=lnk.href.toString() %>"><%=EscapeUtils.escape(lnk.text) %></a></li>
				<% } %>
				</ul>
				</li>
<% } %>
<!-- Meta -->
				<li class="widget-container widget_links"><h3 class="widget-title">Meta</h3>
				<ul>
					<li><a href="<%=request.getAttribute("logiohref") %>"><%= request.getAttribute("logio") %></a></li>
					<% if((Boolean)request.getAttribute("isAdmin")){ %>
					<li><a href="<%=request.getContextPath()+"/admin/" %>">Admin</a></li>
					<% } %>
				</ul>
				</li>