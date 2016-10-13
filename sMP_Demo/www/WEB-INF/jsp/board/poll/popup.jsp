<%@page import="java.math.BigDecimal"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<script type="text/javascript">
function notice_getCookie( name ){
    var nameOfCookie = name + "=";
    var x = 0;
    while ( x <= document.cookie.length )
    {
            var y = (x+nameOfCookie.length);
            if ( document.cookie.substring( x, y ) == nameOfCookie ) {
                    if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 )
                            endOfCookie = document.cookie.length;
                    return unescape( document.cookie.substring( y, endOfCookie ) );
            }
            x = document.cookie.indexOf( " ", x ) + 1;
            if ( x == 0 )
                    break;
    }
    return "";
}
<%
List<Map> list = (List) request.getAttribute("list");
for (int i=0; i<list.size(); i++) {
    Map data = list.get(i);
%>
if ( notice_getCookie( "poll<%=data.get("POLLID")%>" ) != "no" ) {
	cw=screen.availWidth;     //화면 넓이
	ch=screen.availHeight;    //화면 높이
	sw=<%=((Integer)data.get("WIDTH")).intValue()+1%>;    //띄울 창의 넓이
	sh=<%=((Integer)data.get("HEIGHT")).intValue()+140%>;    //띄울 창의 높이
	ml=((cw-sw)/2) + <%=i*50%>;        //가운데 띄우기위한 창의 x위치
	mt=((ch-sh)/2) + <%=i*40%>;         //가운데 띄우기위한 창의 y위치
	window.open('/board/poll/<%=data.get("POLLID")%>.sys', 'okplazaPop<%=data.get("POLLID")%>', 'width=<%=((Integer)data.get("WIDTH")).intValue()+1%>, height=<%=((Integer)data.get("HEIGHT")).intValue()+140%>,top='+mt+',left='+ml+', scrollbars=no, status=no, resizable=yes, maximize=no');
}
<%
}
%>
</script>
 