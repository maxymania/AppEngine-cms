<%@ page import="c_gh.maxymania.gaecms.*" %><%
if(request.getAttribute("wstitle")==null) throw new ServletException("Access Not Granted");
Settings.Config conf = (Settings.Config)request.getAttribute("settingscfg");
HlinkManager hlman = new HlinkManager();
%>
<!--
			 <li class="page_item"><a href="< %=request.getContextPath() % >/" title="Home">Home</a></li>
			 <li class="page_item"><a href="< %=request.getContextPath()+"/?blogview=true" % >" title="Blog">Blog</a></li>
-->
			 <% for(String cat:conf.list(Settings.LIST_MENU_LHLINK)) for(LHlink lnk:hlman.getLHLinks(10, 0, cat)){ %>
			 <li class="page_item"><a href="<%=request.getContextPath()+lnk.href %>" title="<%=EscapeUtils.escape(lnk.text) %>"><%=EscapeUtils.escape(lnk.text) %></a></li>
			 <% } %>