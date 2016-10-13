<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<script type="text/javascript">
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function fnJoinPop(){
	window.open("/homepage/user/user_02_pop.home", 'okplazaPop', 'width=830, height=400, scrollbars=no, status=no, resizable=no');
}
</script>
<body onLoad="MM_preloadImages('<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/top_menu_01_on.gif','<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/top_menu_02_on.gif','<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/top_menu_03_on.gif','<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/top_menu_04_on.gif','<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/top_menu_05_on.gif')"><table width="977" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="center" valign="center" style="padding-top: 20px;">
    	<a href="/index.jsp" onFocus="this.blur()"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/logo.gif" border="0"/></a>
    </td>
<!--     <td width="650" height="27" align="right" valign="top">상단 로그인 영역 시작</td> -->
  </tr>
<!--   <tr> -->
<!--     <td width="650" height="74" valign="top"> -->
    <!-- 상단메뉴 시작-->
<!--     <table width="650" border="0" cellspacing="0" cellpadding="0"> -->
<!--       <tr> -->
<%--         <td width="130"><a href="/homepage/company/company_01.home" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('top_menu_01','','<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/top_menu_01_on.gif',1)"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/top_menu_01.gif" alt="회사소개" name="top_menu_01" width="130" height="49" border="0" id="top_menu_01" /></a></td> --%>
<%--         <td width="130"><a href="/homepage/business/business_01.home" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('top_menu_02','','<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/top_menu_02_on.gif',1)"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/top_menu_02.gif" alt="사업소개" name="top_menu_02" width="130" height="49" border="0" id="top_menu_02" /></a></td> --%>
<%--         <td width="130"><a href="/homepage/user/user_01.home" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('top_menu_03','','<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/top_menu_03_on.gif',1)"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/top_menu_03.gif" alt="이용안내" name="top_menu_03" width="130" height="49" border="0" id="top_menu_03" /></a></td> --%>
<%--         <td width="130"><a href="/homepage/ethics/ethics_01.home" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('top_menu_04','','<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/top_menu_04_on.gif',1)"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/top_menu_04.gif" alt="윤리경영" name="top_menu_04" width="130" height="49" border="0" id="top_menu_04" /></a></td> --%>
<%--         <td><a href="/homepage/inc/frameset.home" onMouseOver="MM_swapImage('top_menu_05','','<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/top_menu_05_on.gif',1)" onMouseOut="MM_swapImgRestore()" target="_blank"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/top_menu_05.gif" alt="사회공헌" name="top_menu_05" width="130" height="49" border="0" id="top_menu_05" /></a></td> --%>
<!--       </tr> -->
<!--       <tr> -->
<!--         <td height="25" colspan="5"></td> -->
<!--         </tr> -->
<!--     </table> -->
      <!-- 상단메뉴 끝-->
<!--     </td> -->
<!--   </tr> -->
</table>