<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>OK Plaza에 오신것을 환영합니다.</title>
<link href="<%=Constances.SYSTEM_JSCSS_URL%>/css/homepage_style.css" rel="stylesheet" type="text/css" />
<script type="text/javascript">
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}
</script>
<script type="text/javascript">
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
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

function fnDownloadSktelesys(){
    var popurl = "/sktelesys.pdf";
    var windowWidth = screen.width/2;
    var windowHeight = screen.height/2;
    window.open(popurl, 'okplazaTelesysPop', 'width='+windowWidth+', height='+windowHeight+', scrollbars=no, status=no, resizable=yes');
}
</script>
</head>
<body>
    <table width="977px" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
            <td align="center" height="101px">
                <!-- 상단메뉴 레이아웃 시작 --><%@include file="/WEB-INF/jsp/homepage/inc/top.jsp"%><!-- 상단메뉴 레이아웃 끝 -->
            </td>
        </tr>
        <tr>
            <td align="center">&nbsp;</td>
        </tr>
        <tr>
            <td align="center">
                <!-- 메인 컨텐츠 시작-->
                <table width="977" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td width="186" valign="top" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/sub_left_menu_bg.gif)">
                            <!-- 좌측메뉴 시작--><%@include file="/WEB-INF/jsp/homepage/inc/sub_left_03_02.jsp"%><!-- 좌측메뉴 끝-->
                        </td>
                        <td width="34" valign="top">&nbsp;</td>
                        <td width="757" valign="top">
                            <!-- 메인 컨텐츠 내용 시작-->
                            <table width="757px" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/sub_c_categorySt_03.gif" width="757" height="63"/></td>
                                </tr>
                                <tr>
                                    <td width="300"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/user_st_05.gif" width="300" height="38"/></td>
                                    <td width="457" class="locacion"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_home.gif" width="12" height="11"/> Home &gt; 이용안내 &gt;<span class="orange"> 전자결제시스템</span></td>
                                </tr>
                                <tr>
                                    <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contents_line.gif" width="757" height="19"/></td>
                                </tr>
                                <tr>
                                    <td colspan="2">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td colspan="2">
<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
<!--                                             <tr> -->
<!--                                                 <td> -->
<%--                                                     <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/subtit_05_03.gif"  /> --%>
<!--                                                 </td> -->
<!--                                                 <td> -->
<%--                                                     <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/subtxt_05_03.gif" /> --%>
<!--                                                 </td> -->
<!--                                             </tr> -->
                                            <tr>
                                                <td align="left" colspan="2">
<!--                                                     <br/> -->
<!--                                                     <br/> -->
<!--                                                     <br/> -->
                                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/purchase_system_txt_01.gif" />
                                                    <br/>
                                                    <br/>
                                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/purchase_system_stxt_01.gif" />
                                                    <br/>
                                                    <br/>
                                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/purchase_system_txt_02.gif"  />
                                                    <br/>
                                                    <br/>
                                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/purchase_system_txt_03.gif"   />
                                                    <br/>
                                                    <br/>
                                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/purchase_system_stxt_02.gif"  />
                                                    <br />
                                                    <br />
                                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/purchase_system_stxt_03.gif"  />
                                                    <br />
                                                    <br />
                                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/purchase_system_txt_04.gif"  />
                                                    <br />
                                                    <br />
                                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/purchase_system_stxt_03_3.gif"  />
                                                    <br />
                                                    <br />
                                                    <a href="/sample_doc.doc"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/sktelesys_doc_sample.gif"  border="0"/></a>
                                                    <br />
                                                    <br />
                                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/purchase_system_stxt_04.gif"  />
                                                    <br />
                                                    <br />
                                                    <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/purchase_system_stxt_06.gif"  />
                                                    <br />
                                                    <br />
                                                    <a href="javascript:fnDownloadSktelesys();"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/btn_sktelesys_download.gif"  border="0"/></a>
                                                    <a href="https://sbiz.wooribank.com/biz/Dream?withyou=BZSTL0016" target="_blank"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/btn_woori_bank_link.gif"   border="0"/></a>
                                                </td>
                                            </tr>
                                        </table>
<!-- ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// -->
                                    </td>
                                </tr>
                            </table>
                            <!-- 메인 컨텐츠 내용 끝-->
                        </td>
                    </tr>
                </table>
                <!-- 메인 컨텐츠 끝-->
            </td>
        </tr>
        <tr>
            <td align="center">&nbsp;</td>
        </tr>
        <tr>
            <td height="78" align="center">
                <!-- 푸터 시작--><%@include file="/WEB-INF/jsp/homepage/inc/footer.jsp"%><!-- 푸터 끝-->
            </td>
        </tr>
    </table>
</body>
</html>