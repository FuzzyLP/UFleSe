<%@page import="urls.ServerAndAppUrls"%>
<%@page import="constants.KUrls"%>
<%@page import="constants.KConstants"%>
<jsp:include page="WEB-INF/commonHtmlHead.jsp" />

<header id="about">
	<a style="text-decoration:none"
		href="<%=KUrls.Auth.SignOut.getUrl(false) %>">APPLICATION</a>
	<div id="title">UFleSe: Usability/Your Flexible Searches in Databases</div>
</header>

<body>
	<br>
	<br>
	<br>
<div class="about">
	<h2><center>UFlese: Usability Flexibile Searches</center></h2>
	<p align="justify">UFleSe is a search tool that provides a
		user-friendly web interface for users to be able to make expressive
		queries (using fuzzy searching criteria, fuzzy rules, synonyms,
		antonyms, similarity, negation, and fuzzy qualifiers) over
		conventional and crisp data. UFleSe allows users to upload their data
		file ( with as JSON, SQL, Prolog, CSV, XLS,and XLSX extensions) to
		define in an easy way the similarity concepts and the fuzzy criteria
		(Fuzzy concept, rules, synonyms, and antonyms) that they want to use
		for searching. UFleSe lets the different users personalize these
		fuzzy search criteria according to their personal preferences, and it
		provides constructive answers to the queries.</p>
	<p align="justify">UFleSe is a framework composed by two
		sub-frameworks: the engine that processes fuzzy queries and the web
		interface that presents results in a human-readable way. The engine
		is an improved version of the framework Rfuzzy presented in "RFuzzy:
		Syntax, semantics and implementation details of a simple and
		expressive fuzzy tool over Prolog". In this new framework we have
		included the management of quantifiers (even negation), similarity,
		overload of attribute's names and others. Its main advantage over
		some other engines is that its syntax is trivial, it allows to reuse
		existing databases and Prolog code and it has every facility we need
		to represent real-world applications. Rfuzzy is a package of the Ciao
		Prolog logic programming environment. The web interface is a Java
		application that interprets the answers provided by the fuzzy
		framework. It runs on a Tomcat server behind an Apache proxy.</p>

	<h2><center>Technologies used</center></h2>
	<p align="justify">UFleSe core is developed as a Ciao Prolog
		package, while the web interface is managed by a Java application
		running on an Apache Tomcat Debian (Linux) server. The client part of
		the web interface is developed in HTML and JavaScript and uses Ajax
		to improve the usability. Besides, we use some libraries developed by
		others. Mainly: SocialAuth, OpenId4Java, jQuery, jQuery UI and
		Highcharts JS.</p>

	<h2><center>Developers</center></h2>
	<p align="justify">This application was developed by Ph.D. student
		Mohammad Halim Deedar under the supervision of Dr. Susana Muñoz
		Hernandez.</p>
	<br/>
	<div class="footer">
		<div id="images">
			<a href="http://babel.ls.fi.upm.es/"> <img height="80" width="100"
				src="images/logo-babel.jpg" alt="logo babel research group"></img></a>
					
			<a href="http://upm.es/"><img src="images/UPM.png" height= "80" width= "80"
				alt="logo Universidad Politécnica de Madrid"></img></a> 
					
			<a href="http://www.fi.upm.es/"><img src="images/logo2.png" height= "80" width= "100" 
				alt="logo Facultad de Informática"></img></a> 
			
			<a href="http://www.dlsiis.fi.upm.es/"><img src="images/logo3.png" height= "80" width= "150"
				alt="logo Departamento de Lenguajes y Sistemas Informáticos e Ingeniería del Software"></img></a> 
		</div>
	</div>
</div>
</body>	
</html>
