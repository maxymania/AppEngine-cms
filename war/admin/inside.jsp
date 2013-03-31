<%@ page import = "c_gh.maxymania.gaecms.*"%><%
%><%@ page import = "c_gh.maxymania.gaecms.fileservice.*"%><%
if(request.getAttribute("adminToken")==null)throw new ServletException("Direct access to this file is STRICTLY FORBIDDEN!!!");
%><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Admin Interface</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="bootstrap/css/bootstrap.css" rel="stylesheet">
<link href="style.css" rel="stylesheet">
<%
Settings settings = new Settings();
Settings.Config conf = settings.load();
//Settings.Config conf = null;
Object op = request.getAttribute("op");
if("edit".equals(op)){
%>
<!-- TinyMCE -->
<script type="text/javascript" src="jscripts/tiny_mce/tiny_mce.js"></script>
<script type="text/javascript">
	tinyMCE.init({
		// General options
		mode : "textareas",
		theme : "advanced",
		plugins : "pagebreak,style,layer,table,save,advhr,advimage,advlink,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template,wordcount,advlist,autosave",

		// Theme options
		theme_advanced_buttons1 : "save,newdocument,|,bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,styleselect,formatselect,fontselect,fontsizeselect",
		theme_advanced_buttons2 : "cut,copy,paste,pastetext,pasteword,|,search,replace,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,image,cleanup,help,code,|,insertdate,inserttime,preview,|,forecolor,backcolor",
		theme_advanced_buttons3 : "tablecontrols,|,hr,removeformat,visualaid,|,sub,sup,|,charmap,emotions,iespell,media,advhr,|,print,|,ltr,rtl,|,fullscreen",
		theme_advanced_buttons4 : "insertlayer,moveforward,movebackward,absolute,|,styleprops,|,cite,abbr,acronym,del,ins,attribs,|,visualchars,nonbreaking,pagebreak,restoredraft",
		theme_advanced_toolbar_location : "top",
		theme_advanced_toolbar_align : "left",
		theme_advanced_statusbar_location : "bottom",
		theme_advanced_resizing : true,

		// Example content CSS (should be your site CSS)
		content_css : "no.css",

		// Drop lists for link/image/media/template dialogs
		//template_external_list_url : "lists/template_list.js",
		external_link_list_url : "lists/link_list.js",
		external_image_list_url : "lists/image_list.js",
		media_external_list_url : "lists/media_list.js",

		// Style formats
		style_formats : [
			{title : 'Bold text', inline : 'b'},
			{title : 'Red text', inline : 'span', styles : {color : '#ff0000'}},
			{title : 'Red header', block : 'h1', styles : {color : '#ff0000'}},
			{title : 'Example 1', inline : 'span', classes : 'example1'},
			{title : 'Example 2', inline : 'span', classes : 'example2'},
			{title : 'Table styles'},
			{title : 'Table row 1', selector : 'tr', classes : 'tablerow1'}
		],

		// Replace values for the template plugin
		//template_replace_values : {
		//	username : "Some User",
		//	staffid : "991234"
		//}
	});
</script>
<!-- /TinyMCE -->
<% } %>

</head>
<body>
<div style="position: absolute; left: 10px; right: 10px; top: 10px; bottom: 10px;">
  <div class="well" style="float: left; width: 160px; padding: 8px;">
    <ul class="nav nav-list">
      <li class="nav-header">Functions</li>
      <li><a href="<%= ParameterUtils.addParameters(request, response,"loc","listarticles")%>"><i class="icon-folder-open"></i> List Articles</a></li>
      <li><a href="<%= ParameterUtils.addParameters(request, response,"loc","newarticle")%>"><i class="icon-file"></i> New Article</a></li>
      <li><a href="<%= ParameterUtils.addParameters(request, response,"loc","comments")%>"><i class="icon-comment"></i> Comments</a></li>
      <li><a href="<%= ParameterUtils.addParameters(request, response,"loc","files")%>"><i class="icon-upload"></i> Files</a></li>
      <li><a href="<%= ParameterUtils.addParameters(request, response,"loc","global-settings")%>"><i class="icon-warning-sign"></i> Global Settings</a></li>
      
      <li class="nav-header">Local Hyperlinks</li>
      <li><a href="<%= ParameterUtils.addParameters(request, response,"loc","lhlinks","cat",null)%>"><i class="icon-list"></i> All</a></li>
      <%
      // ArrayUtil.array("Sites","Wiki","Files")
      for(String cat:conf.list(Settings.LIST_ADMIN_LHLINK)){ %>
      <li><a href="<%= ParameterUtils.addParameters(request, response,"loc","lhlinks","cat",cat)%>"><i class="icon-list"></i> <%=cat %></a></li>
      <% } %>
      <li class="nav-header">Hyperlinks</li>
      <li><a href="<%= ParameterUtils.addParameters(request, response,"loc","hlinks","cat",null)%>"><i class="icon-list"></i> All</a></li>
      <%
      // ArrayUtil.array("Blogroll")
      for(String cat:conf.list(Settings.LIST_ADMIN_HLINK)){ %>
      <li><a href="<%= ParameterUtils.addParameters(request, response,"loc","hlinks","cat",cat)%>"><i class="icon-list"></i> <%=cat %></a></li>
      <% } %>
      
      <li class="nav-header">User Actions</li>
      <li><a href="<%=request.getAttribute("logiohref")%>"><i class="icon-off"></i> <%=request.getAttribute("logio")%></a></li>
      <li><a href="<%=request.getContextPath()+"/"%>"><i class="icon-home"></i> Homepage</a></li>
    </ul>
  </div>

  <div class="well" style="float: left; position: absolute; left: 210px; right: 0; top: 0; bottom: 50px">
   <%
   if("edit".equals(op)){
   %>
   <form method="post" action="post.jsp">
	<div>
		<!-- Gets replaced with TinyMCE, remember HTML in a textarea should be encoded -->
		<p>Id: <input type="text" name="id" value="<%=request.getAttribute("id") %>" /> (Must be URL-Safe and unique)</p>
		<p>Title: <input type="text" name="title" value="<%=request.getAttribute("title") %>" /></p>
		<br />
		<div>
			<textarea id="elm1" name="text" rows="15" cols="80" style="width: 80%"><%=request.getAttribute("text") %></textarea>
		</div>
		<br />
		<!-- <input type="hidden" name="docstate" value="" /> -->
		<input type="checkbox" name="blogify" value="true"> Create a Blog Entry (will alter the entry ID to be unique anyway)<br>
		<input class="btn btn-mini"  type="submit" name="save" value="Submit" />
		<input class="btn btn-mini"  type="reset" name="reset" value="Reset" />
	</div>
   </form>
   <% } else if("listarticles".equals(op)){%>
   <ul class="nav nav-list">
   <li class="nav-header">Special Articles</li>
   <% for(String id:ArrayUtil.array("home")){%>
   <li><a href="<%=ParameterUtils.addParameters(request, response,"loc","edit","id",id)%>"><i class="icon-file"></i> <%=EscapeUtils.escape(id) %></a></li>
   <% } %>
   <li class="nav-header">Articles</li>
   <%
   Articles arts = new Articles();
   int n=0;
   int pg=ParameterUtils.parseInt(""+request.getParameter("p"), 0);
   String myurl = "index.jsp"+ParameterUtils.addParameters(request, response);
   String[] cats = conf.list(Settings.LIST_ADMIN_ARTICLES_LHLINK);
   for(String id:arts.getArticleIds(20,pg)){n++;
   Article art = arts.getArticle(id);
   %>
   <li>
   <p>
   <a href="<%=ParameterUtils.addParameters(request, response,"loc","edit","id",id)%>"><i class="icon-file"></i> <%=EscapeUtils.escape(id) %></a>
   <% for(String cat:cats){ %>
   <a class="btn btn-mini" href="lnkctl.jsp<%=ParameterUtils.createParameters(response,"redirect",myurl,"cat",cat,"text",""+art.title,"addlocal","/?page="+EscapeUtils.escapeURL(id, response))%>"><i class="icon-plus"></i><i class="icon-hand-right"></i> <%=EscapeUtils.escape(cat)%></a>
   <% } %>
   </p>
   </li>
   <% } %>
   </ul>
   <p>
   <% if(pg>0){%>
   <a href="<%= ParameterUtils.addParameters(request, response,"p",""+(pg-1)) %>">Previous</a>
   <% }if(n==20){ %>
   <% if(pg>0){%> | <%} %>
   <a href="<%= ParameterUtils.addParameters(request, response,"p",""+(pg+1)) %>">Next</a>
   <% } %>
   </p>
   <% } else if("listcomments".equals(op)){%>
   <table>
   <thead><tr>
   <th>Email</th>
   <th>Name</th>
   <th>Text</th>
   <th>Admin</th>
   </tr></thead>
   <tbody>
   <%
   Articles arts = new Articles();
   int n=0;
   int pg=ParameterUtils.parseInt(""+request.getParameter("p"), 0);
   for(Comment c:arts.getComments(20, pg)){n++;
   %>
   <tr>
   <td><%=EscapeUtils.escape(c.email) %></td>
   <td><%=EscapeUtils.escape(c.name) %></td>
   <td><textarea><%=EscapeUtils.escape(c.text) %></textarea></td>
   <td><form action="rmcomment.jsp" method="post"><input type="hidden" name="id" value="<%=c.__id %>" /><input class="btn btn-mini"  type="submit" value="Delete"></form></td>
   </tr>
   <% } %>
   </tbody>
   </table>
   <p>
   <% if(pg>0){%>
   <a href="<%= ParameterUtils.addParameters(request, response,"p",""+(pg-1)) %>">Previous</a>
   <% }if(n==20){ %>
   <% if(pg>0){%> | <%} %>
   <a href="<%= ParameterUtils.addParameters(request, response,"p",""+(pg+1)) %>">Next</a>
   <% } %>
   </p>
   <% } else if("files".equals(op)){
      Files files = new Files();
      Blobs blobs = new Blobs();
   %>
   <form action="<%= blobs.url("/admin/postfile.jsp") %>" method="post" enctype="multipart/form-data">
      <input type="checkbox" name="prefix" value="date"> Use Date/Time as Prefix (avoids name-conflicts)<br>
      <input type="file" name="myFile">
      <input class="btn btn-mini" type="submit" value="Upload">
   </form>
   <table>
   <thead><tr>
   <th>Name</th>
   <th>Content-Type</th>
   <th>MD5</th>
   <th>Size</th>
   <th>Admin</th>
   </tr></thead>
   <tbody>
   <%
	 int pg=ParameterUtils.parseInt(""+request.getParameter("p"), 0);
	 int n=0;
	 String myurl = "index.jsp"+ParameterUtils.addParameters(request, response);
	 for(FilesFile file:files.list(20, pg)){n++;
   %>
   <tr>
   <td><a href="<%=request.getContextPath()+"/resource/"+file.name %>"><%=file.name %></a></td>
   <td><%=file.mimeType %></td><td><%=file.md5hash %></td><td><%=file.size %></td>
   <td>
   <form action="rmfile.jsp" method="post"><input type="hidden" name="name" value="<%=file.name %>" /><input class="btn btn-mini" type="submit" value="Delete">
   <% for(String cat:conf.list(Settings.LIST_ADMIN_FILES_LHLINK)){ %>
   <a class="btn btn-mini" href="lnkctl.jsp<%=ParameterUtils.createParameters(response,"redirect",myurl,"cat",cat,"text",""+file.name,"addlocal","/resource/"+file.name)%>"><i class="icon-plus"></i><i class="icon-hand-right"></i> <%=EscapeUtils.escape(cat)%></a>
   <% } %>
   </form>
   </td>
   </tr>
   <% } %>
   </tbody>
   </table>
   <p>
   <% if(pg>0){%>
   <a href="<%= ParameterUtils.addParameters(request, response,"p",""+(pg-1)) %>">Previous</a>
   <% }if(n==20){ %>
   <% if(pg>0){%> | <%} %>
   <a href="<%= ParameterUtils.addParameters(request, response,"p",""+(pg+1)) %>">Next</a>
   <% } %>
   </p>
   <% } else if("lhlinks".equals(op)){
	 int pg=ParameterUtils.parseInt(""+request.getParameter("p"), 0);
	 int n=0;
	 HlinkManager hlm = new HlinkManager();
	 //String myurl = request.getContextPath()+"/admin/"+ParameterUtils.addParameters(request, response);
	 String myurl = "index.jsp"+ParameterUtils.addParameters(request, response);
	 String cat = request.getParameter("cat");
   %>
   <ul class="nav nav-list">
   <li class="nav-header">Add Hyperlink</li>
   <li><p>
   <form action="lnkctl.jsp">
   <input type="hidden" name="redirect" value="<%=myurl%>">
   <% if(cat!=null){ %>
   <input type="hidden" name="cat" value="<%=EscapeUtils.escape(cat)%>">
   <% }else{ %>
   Category: <input type="text" name="cat" value="">
   <% } %>
   Name:<input type="text" name="text" value=""> Url :<input type="text" name="addlocal" value=""> <input class="btn btn-mini" type="submit" value="Add">
   </form>
   </p>
   <p>Note that Url must be Application-relative</p></li>
   <li class="nav-header">Local Hyperlinks</li>
   <% for(LHlink lnk:hlm.getLHLinks(20, pg, cat)){n++; %>
   <li><p>
   <i class="icon-hand-right"></i> <%=EscapeUtils.escape(lnk.cat) %> : <%=EscapeUtils.escape(lnk.text) %> (<%=EscapeUtils.escape(lnk.href) %>)
   <a class="btn btn-mini" href="lnkctl.jsp<%=ParameterUtils.createParameters(response,"redirect",myurl,"delete",lnk.__id)%>"><i class="icon-remove"></i> Delete</a>
   </p></li>
   <% } %>
   </ul>
   
   <p>
   <% if(pg>0){%>
   <a href="<%= ParameterUtils.addParameters(request, response,"p",""+(pg-1)) %>">Previous</a>
   <% }if(n==20){ %>
   <% if(pg>0){%> | <%} %>
   <a href="<%= ParameterUtils.addParameters(request, response,"p",""+(pg+1)) %>">Next</a>
   <% } %>
   </p>
   
   <% } else if("hlinks".equals(op)){
	 int pg=ParameterUtils.parseInt(""+request.getParameter("p"), 0);
	 int n=0;
	 HlinkManager hlm = new HlinkManager();
	 //String myurl = request.getContextPath()+"/admin/"+ParameterUtils.addParameters(request, response);
	 String myurl = "index.jsp"+ParameterUtils.addParameters(request, response);
	 String cat = request.getParameter("cat");
   %>
   <ul class="nav nav-list">
   <li class="nav-header">Add Hyperlink</li>
   <li><p>
   <form action="lnkctl.jsp">
   <input type="hidden" name="redirect" value="<%=myurl%>">
   <% if(cat!=null){ %>
   <input type="hidden" name="cat" value="<%=EscapeUtils.escape(cat)%>">
   <% }else{ %>
   Category: <input type="text" name="cat" value="">
   <% } %>
   Name:<input type="text" name="text" value=""> Url :<input type="text" name="add" value=""> <input class="btn btn-mini" type="submit" value="Add">
   </form>
   </p></li>
   <li class="nav-header">Hyperlinks</li>
   <% for(Hlink lnk:hlm.getHLinks(20, pg, cat)){n++; %>
   <li><p>
   <i class="icon-hand-right"></i> <%=EscapeUtils.escape(lnk.cat) %> : <%=EscapeUtils.escape(lnk.text) %> (<%=EscapeUtils.escape(lnk.href.toString()) %>)
   <a class="btn btn-mini" href="lnkctl.jsp<%=ParameterUtils.createParameters(response,"redirect",myurl,"delete",lnk.__id)%>"><i class="icon-remove"></i> Delete</a>
   </p></li>
   <% } %>
   </ul>
   
   <p>
   <% if(pg>0){%>
   <a href="<%= ParameterUtils.addParameters(request, response,"p",""+(pg-1)) %>">Previous</a>
   <% }if(n==20){ %>
   <% if(pg>0){%> | <%} %>
   <a href="<%= ParameterUtils.addParameters(request, response,"p",""+(pg+1)) %>">Next</a>
   <% } %>
   </p>
   <% } else if("global-settings".equals(op)){%>
   <form action="configctl.jsp" method="post">
   <ul class="nav nav-list">
   <li><p><a class="btn btn-mini" href="configctl.jsp?reset=1"><i class="icon-warning-sign"></i> Reset</a></p></li>
   <li class="nav-header">Website Settings</li>
   <li>Title: <input type="text" name="wstitle" value="<%=EscapeUtils.escape(conf.wstitle()) %>" /><br/> </li>
   <li>Title2: <input type="text" name="wstitle2" value="<%=EscapeUtils.escape(conf.wstitle2()) %>" /><br/> </li>
   <li><input type="checkbox" name="allowComments" value="true"<%=conf.allowComments()?" checked":""%>> Allow Comments</li>
   <li class="nav-header">Local Hyperlink Categories</li>
   <li>Shown in Admin-Backend(all): <input type="text" name="admin_lhlink" value="<%=EscapeUtils.escape(conf.listV(Settings.LIST_ADMIN_LHLINK)) %>" /><br/> </li>
   <li>Shown in Backend as File-Linking Option: <input type="text" name="admin_files_lhlink" value="<%=EscapeUtils.escape(conf.listV(Settings.LIST_ADMIN_FILES_LHLINK)) %>" /><br/> </li>
   <li>Shown in Backend as Articles-Linking Option: <input type="text" name="admin_articles_lhlink" value="<%=EscapeUtils.escape(conf.listV(Settings.LIST_ADMIN_ARTICLES_LHLINK)) %>" /><br/> </li>
   <li>Shown in Sitebar: <input type="text" name="sitebar_lhlink" value="<%=EscapeUtils.escape(conf.listV(Settings.LIST_SITEBAR_LHLINK)) %>" /><br/></li>
   <li>Shown in Menu: <input type="text" name="menu_lhlink" value="<%=EscapeUtils.escape(conf.listV(Settings.LIST_MENU_LHLINK)) %>" /><br/></li>
   <li class="nav-header">Hyperlink Categorie</li>
   <li>Shown in Admin-Backend(all): <input type="text" name="admin_hlink" value="<%=EscapeUtils.escape(conf.listV(Settings.LIST_ADMIN_HLINK)) %>" /><br/></li>
   <li>Shown in Sitebar: <input type="text" name="sitebar_hlink" value="<%=EscapeUtils.escape(conf.listV(Settings.LIST_SITEBAR_HLINK)) %>" /><br/></li>
   <li class="nav-header">Default Action</li>
   <li><select name="default_action" size="3">
   <% {
	 String defAction = conf.defaultAction();
	 for(String sel:ArrayUtil.array("blog","home")){ %>
      <option<%=sel.equals(defAction)?" selected":""%>><%=sel %></option>
   <% } } %>
   </select></li>
   <li><input class="btn btn-mini" type="submit" name="save" value="Save" /></li>
   </ul>
   </form>
   <% } else if("error404article".equals(op)){%>
   Resource not found!
   <% }else{ %>
   none!
   <% } %>
  </div>
</div>
</body>
</html>