<%
	//request.setCharacterEncoding("utf-8");

	//System.setProperty("rexpert.properties.dir", "C:/RexServer30/WEB-INF/classes/Rexpert/conf");

	String strId = (request.getParameter("ID") == null ? "" : request.getParameter("ID"));

	if (strId.equalsIgnoreCase("SDXML")) {
		response.setContentType("text/xml;charset=UTF-8");
	} else if (strId.equalsIgnoreCase("SDCSV")) {
		response.setContentType("text/html;charset=UTF-8");
	}

	Rexpert.DataServer.Main.fnRun(request, response, application);
%>