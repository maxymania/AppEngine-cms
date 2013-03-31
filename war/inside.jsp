<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><%= request.getAttribute("wstitle") %></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<link rel="stylesheet" type="text/css" media="all" href="<%=request.getContextPath() %>/style.css" />
	</head>
	<body class="home blog">
	<div id="wrapper" class="hfeed">
		<div id="header">
		  <div id="masthead">
			<div id="branding" role="banner">
								<h1 id="site-title">
					<span>
						<a href="<%=request.getContextPath() %>/" title="<%= request.getAttribute("wstitle") %>" rel="home"><%= request.getAttribute("wstitle") %></a>
					</span>
				</h1>
				<div id="site-description"><%= request.getAttribute("wstitle2") %></div>

										<IMG src="<%=request.getContextPath() %>/path.jpg" width="940" height="198" alt="">
								</div><!-- #branding -->

			<div id="access" role="navigation">
			 <div class="skip-link screen-reader-text"><A href="#content" title="Springe zum Inhalt">Springe zum Inhalt</A></DIV>
			<div class="menu">
			 <ul>
			 <jsp:include page="menu.jsp"/>
			</ul>
			</div>
			</div><!-- #access -->
		 </div><!-- #masthead -->
	    </div><!-- #header -->
		<div id="main">
		    <div id="container">
		    	<div id="content" role="main">
		    	<jsp:include page="content.jsp"/>
		    	</div>
		    </div>
		    <div id="primary" class="widget-area" role="complementary">
			<ul class="xoxo">
				<jsp:include page="sidebar.jsp"/>
			</ul>
			</div>
		</div>
		
		<div id="footer" role="contentinfo">
		  <div id="colophon">

			<div id="site-info">
				<a href="<%=request.getContextPath() %>/" title="<%= request.getAttribute("wstitle2") %>" rel="home"><%= request.getAttribute("wstitle") %></a>
			</div><!-- #site-info -->

			<div id="site-generator">
			<!--Powered by Google App Engine-->
			<!-- <img src="https://developers.google.com/appengine/images/appengine-silver-120x30.gif" alt="Powered by Google App Engine" /> -->
			<img src="https://developers.google.com/appengine/images/appengine-noborder-120x30.gif" alt="Powered by Google App Engine" />
			</div><!-- #site-generator -->

		  </div><!-- #colophon -->
		</div><!-- #footer -->
		
	</div><!-- #wrapper -->
	</body>
</html>
