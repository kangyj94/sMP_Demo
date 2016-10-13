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
</script>
<body onLoad="MM_preloadImages('<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/left_menu_03_01_on.gif','<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/left_menu_03_03_on.gif','<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/left_menu_03_02_on.gif','<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/left_menu_03_04_on.gif')">
<table width="186" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/sub_left_st_03.gif" width="186" height="65" /></td>
  </tr>
  <tr>
    <td><a href="/homepage/user/user_01.home" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('menu_01','','<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/left_menu_03_01_on.gif',1)"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/left_menu_03_01.gif" name="menu_01" width="186" height="19" border="0" id="menu_01" /></a></td>
  </tr>
  <tr>
    <td><a href="/homepage/user/user_02.home" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('menu_02','','<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/left_menu_03_02_on.gif',1)"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/left_menu_03_02.gif" name="menu_02" width="186" height="19" border="0" id="menu_02" /></a></td>
  </tr>
  <tr>
    <td><a href="/homepage/user/user_03.home" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('menu_03','','<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/left_menu_03_03_on.gif',1)"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/left_menu_03_03.gif" name="menu_03" width="186" height="19" border="0" id="menu_03" /></a></td>
  </tr>
  <tr>
    <td><a href="/homepage/user/user_04.home" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('menu_04','','<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/left_menu_03_04_on.gif',1)"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/left_menu_03_04.gif" name="menu_04" width="186" height="19" border="0"></a></td>
  </tr>
  <tr>
    <td><a href="/homepage/user/user_05.home" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('menu_05','','<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/left_menu_03_05_on.gif',1)"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/left_menu_03_05.gif" name="menu_05" width="186" height="19" border="0"></a></td>
  </tr>
</table>