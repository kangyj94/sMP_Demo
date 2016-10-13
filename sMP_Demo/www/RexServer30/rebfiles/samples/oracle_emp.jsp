<%@ page pageEncoding="utf-8"%><%
	//request.setCharacterEncoding("utf-8");

	String sDataType = (request.getParameter("datatype") == null ? "" : request.getParameter("datatype"));

	String sData = "";

	if (sDataType.equalsIgnoreCase("xml")) {
		response.setContentType("text/xml;charset=utf-8");

		sData += "<?xml version='1.0' encoding='utf-8'?><gubun><rpt1><rexdataset><rexrow><EMPNO><![CDATA[7369]]></EMPNO><ENAME><![CDATA[SMITH]]></ENAME><JOB><![CDATA[CLERK]]></JOB><MGR><![CDATA[7902]]></MGR><HIREDATE><![CDATA[1980-12-17 00:00:00.0]]></HIREDATE><SAL><![CDATA[800]]></SAL><COMM><![CDATA[null]]></COMM><DEPTNO><![CDATA[20]]></DEPTNO></rexrow>";
		sData += "<rexrow><EMPNO><![CDATA[7499]]></EMPNO><ENAME><![CDATA[ALLEN]]></ENAME><JOB><![CDATA[SALESMAN]]></JOB><MGR><![CDATA[7698]]></MGR><HIREDATE><![CDATA[1981-02-20 00:00:00.0]]></HIREDATE><SAL><![CDATA[1600]]></SAL><COMM><![CDATA[300]]></COMM><DEPTNO><![CDATA[30]]></DEPTNO></rexrow>";
		sData += "<rexrow><EMPNO><![CDATA[7521]]></EMPNO><ENAME><![CDATA[WARD]]></ENAME><JOB><![CDATA[SALESMAN]]></JOB><MGR><![CDATA[7698]]></MGR><HIREDATE><![CDATA[1981-02-22 00:00:00.0]]></HIREDATE><SAL><![CDATA[1250]]></SAL><COMM><![CDATA[500]]></COMM><DEPTNO><![CDATA[30]]></DEPTNO></rexrow>";
		sData += "<rexrow><EMPNO><![CDATA[7566]]></EMPNO><ENAME><![CDATA[JONES]]></ENAME><JOB><![CDATA[MANAGER]]></JOB><MGR><![CDATA[7839]]></MGR><HIREDATE><![CDATA[1981-04-02 00:00:00.0]]></HIREDATE><SAL><![CDATA[2975]]></SAL><COMM><![CDATA[null]]></COMM><DEPTNO><![CDATA[20]]></DEPTNO></rexrow>";
		sData += "<rexrow><EMPNO><![CDATA[7654]]></EMPNO><ENAME><![CDATA[MARTIN]]></ENAME><JOB><![CDATA[SALESMAN]]></JOB><MGR><![CDATA[7698]]></MGR><HIREDATE><![CDATA[1981-09-28 00:00:00.0]]></HIREDATE><SAL><![CDATA[1250]]></SAL><COMM><![CDATA[1400]]></COMM><DEPTNO><![CDATA[30]]></DEPTNO></rexrow>";
		sData += "<rexrow><EMPNO><![CDATA[7698]]></EMPNO><ENAME><![CDATA[BLAKE]]></ENAME><JOB><![CDATA[MANAGER]]></JOB><MGR><![CDATA[7839]]></MGR><HIREDATE><![CDATA[1981-05-01 00:00:00.0]]></HIREDATE><SAL><![CDATA[2850]]></SAL><COMM><![CDATA[null]]></COMM><DEPTNO><![CDATA[30]]></DEPTNO></rexrow>";
		sData += "<rexrow><EMPNO><![CDATA[7782]]></EMPNO><ENAME><![CDATA[CLARK]]></ENAME><JOB><![CDATA[MANAGER]]></JOB><MGR><![CDATA[7839]]></MGR><HIREDATE><![CDATA[1981-06-09 00:00:00.0]]></HIREDATE><SAL><![CDATA[2450]]></SAL><COMM><![CDATA[null]]></COMM><DEPTNO><![CDATA[10]]></DEPTNO></rexrow>";
		sData += "<rexrow><EMPNO><![CDATA[7788]]></EMPNO><ENAME><![CDATA[SCOTT]]></ENAME><JOB><![CDATA[ANALYST]]></JOB><MGR><![CDATA[7566]]></MGR><HIREDATE><![CDATA[1987-04-19 00:00:00.0]]></HIREDATE><SAL><![CDATA[3000]]></SAL><COMM><![CDATA[null]]></COMM><DEPTNO><![CDATA[20]]></DEPTNO></rexrow>";
		sData += "<rexrow><EMPNO><![CDATA[7839]]></EMPNO><ENAME><![CDATA[KING]]></ENAME><JOB><![CDATA[PRESIDENT]]></JOB><MGR><![CDATA[null]]></MGR><HIREDATE><![CDATA[1981-11-17 00:00:00.0]]></HIREDATE><SAL><![CDATA[5000]]></SAL><COMM><![CDATA[null]]></COMM><DEPTNO><![CDATA[10]]></DEPTNO></rexrow>";
		sData += "<rexrow><EMPNO><![CDATA[7844]]></EMPNO><ENAME><![CDATA[TURNER]]></ENAME><JOB><![CDATA[SALESMAN]]></JOB><MGR><![CDATA[7698]]></MGR><HIREDATE><![CDATA[1981-09-08 00:00:00.0]]></HIREDATE><SAL><![CDATA[1500]]></SAL><COMM><![CDATA[0]]></COMM><DEPTNO><![CDATA[30]]></DEPTNO></rexrow>";
		sData += "<rexrow><EMPNO><![CDATA[7876]]></EMPNO><ENAME><![CDATA[ADAMS]]></ENAME><JOB><![CDATA[CLERK]]></JOB><MGR><![CDATA[7788]]></MGR><HIREDATE><![CDATA[1987-05-23 00:00:00.0]]></HIREDATE><SAL><![CDATA[1100]]></SAL><COMM><![CDATA[null]]></COMM><DEPTNO><![CDATA[20]]></DEPTNO></rexrow>";
		sData += "<rexrow><EMPNO><![CDATA[7900]]></EMPNO><ENAME><![CDATA[JAMES]]></ENAME><JOB><![CDATA[CLERK]]></JOB><MGR><![CDATA[7698]]></MGR><HIREDATE><![CDATA[1981-12-03 00:00:00.0]]></HIREDATE><SAL><![CDATA[950]]></SAL><COMM><![CDATA[null]]></COMM><DEPTNO><![CDATA[30]]></DEPTNO></rexrow>";
		sData += "<rexrow><EMPNO><![CDATA[7902]]></EMPNO><ENAME><![CDATA[FORD]]></ENAME><JOB><![CDATA[ANALYST]]></JOB><MGR><![CDATA[7566]]></MGR><HIREDATE><![CDATA[1981-12-03 00:00:00.0]]></HIREDATE><SAL><![CDATA[3000]]></SAL><COMM><![CDATA[null]]></COMM><DEPTNO><![CDATA[20]]></DEPTNO></rexrow>";
		sData += "<rexrow><EMPNO><![CDATA[7934]]></EMPNO><ENAME><![CDATA[MILLER]]></ENAME><JOB><![CDATA[CLERK]]></JOB><MGR><![CDATA[7782]]></MGR><HIREDATE><![CDATA[1982-01-23 00:00:00.0]]></HIREDATE><SAL><![CDATA[1300]]></SAL><COMM><![CDATA[null]]></COMM><DEPTNO><![CDATA[10]]></DEPTNO></rexrow>";
		sData += "<rexrow><EMPNO><![CDATA[8888]]></EMPNO><ENAME><![CDATA[홍길동]]></ENAME><JOB><![CDATA[기술]]></JOB><MGR><![CDATA[7788]]></MGR><HIREDATE><![CDATA[null]]></HIREDATE><SAL><![CDATA[null]]></SAL><COMM><![CDATA[null]]></COMM><DEPTNO><![CDATA[null]]></DEPTNO></rexrow></rexdataset></rpt1></gubun>";

		out.print(sData);
	} else if (sDataType.equalsIgnoreCase("csv")) {
		response.setContentType("text/html;charset=utf-8");

		sData += "7369|*|SMITH|*|CLERK|*|7902|*|1980-12-17 00:00:00.0|*|800|*|null|*|20|#|";
		sData += "7499|*|ALLEN|*|SALESMAN|*|7698|*|1981-02-20 00:00:00.0|*|1600|*|300|*|30|#|";
		sData += "7521|*|WARD|*|SALESMAN|*|7698|*|1981-02-22 00:00:00.0|*|1250|*|500|*|30|#|";
		sData += "7566|*|JONES|*|MANAGER|*|7839|*|1981-04-02 00:00:00.0|*|2975|*|null|*|20|#|";
		sData += "7654|*|MARTIN|*|SALESMAN|*|7698|*|1981-09-28 00:00:00.0|*|1250|*|1400|*|30|#|";
		sData += "7698|*|BLAKE|*|MANAGER|*|7839|*|1981-05-01 00:00:00.0|*|2850|*|null|*|30|#|";
		sData += "7782|*|CLARK|*|MANAGER|*|7839|*|1981-06-09 00:00:00.0|*|2450|*|null|*|10|#|";
		sData += "7788|*|SCOTT|*|ANALYST|*|7566|*|1987-04-19 00:00:00.0|*|3000|*|null|*|20|#|";
		sData += "7839|*|KING|*|PRESIDENT|*|null|*|1981-11-17 00:00:00.0|*|5000|*|null|*|10|#|";
		sData += "7844|*|TURNER|*|SALESMAN|*|7698|*|1981-09-08 00:00:00.0|*|1500|*|0|*|30|#|";
		sData += "7876|*|ADAMS|*|CLERK|*|7788|*|1987-05-23 00:00:00.0|*|1100|*|null|*|20|#|";
		sData += "7900|*|JAMES|*|CLERK|*|7698|*|1981-12-03 00:00:00.0|*|950|*|null|*|30|#|";
		sData += "7902|*|FORD|*|ANALYST|*|7566|*|1981-12-03 00:00:00.0|*|3000|*|null|*|20|#|";
		sData += "7934|*|MILLER|*|CLERK|*|7782|*|1982-01-23 00:00:00.0|*|1300|*|null|*|10|#|";
		sData += "8888|*|홍길동|*|기술|*|7788|*|null|*|null|*|null|*|null";

		out.print(sData);
	}
%>