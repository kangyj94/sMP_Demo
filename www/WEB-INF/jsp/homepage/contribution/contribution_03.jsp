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
</script>
</head>
<body>
<table width="977px" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center" height="101px">
    <!-- 상단메뉴 레이아웃 시작 --><%@include file="/WEB-INF/jsp/homepage/inc/top.jsp"%><!-- 상단메뉴 레이아웃 끝 --></td>
  </tr>
  <tr>
    <td align="center">&nbsp;</td>
  </tr>
  <tr>
    <td align="center"><!-- 메인 컨텐츠 시작-->
      <table width="977" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="186" valign="top" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/sub_left_menu_bg.gif)">
            <!-- 좌측메뉴 시작--><%@include file="/WEB-INF/jsp/homepage/inc/sub_left_07.jsp"%><!-- 좌측메뉴 끝-->
        </td>
            <td width="34" valign="top">&nbsp;</td>
            <td width="757" valign="top">
            <!-- 메인 컨텐츠 내용 시작-->
            <table width="757px" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/sub_c_categorySt_07.gif" width="757" height="63"/></td>
              </tr>
              <tr>
                <td width="300"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contribution_st_03.gif" width="300" height="38"/></td>
                <td width="457" class="locacion"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_home.gif" width="12" height="11"/> Home &gt; 사회공헌 &gt;<span class="orange"> 사회공헌 뉴스</span></td>
              </tr>
              <tr>
                <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contents_line.gif" width="757" height="19"/></td>
              </tr>
              <tr>
                <td colspan="2" align="left">
                <!-- 사회공헌뉴스 시작-->
                <!-- 검색 시작-->
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td class="bbs_search"><select size="1" name="paym_cond_code" notnull="결제조건"/>
                      <option>전체</option>
                    </select> <input name="adde_text_desc" type="text" value="" id="홈페이지주소2" class="input_text"  size="40" maxlength="60" /> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/bbs_search.gif" width="45" height="22" align="absmiddle"/></td>
                  </tr>
                </table>
                <!-- 검색 끝-->
                <!-- 사회공헌 뉴스 리스트 시작-->
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td colspan="4" class="table_top_line"></td>
                  </tr>
                  <tr class="bbs_td_subject">
                    <td width="50" class="bbs_td_subject2">번호</td>
                    <td class="bbs_td_subject2">제목</td>
                    <td width="60" class="bbs_td_subject2">작성자</td>
                    <td class="bbs_td_subject2">등록일</td>
                    </tr>
                  <tr>
                    <td colspan="4" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td width="50">10</td>
                    <td class="bbs_td_contents1"><a href="/homepage/contribution/contribution_03_view.home">사회공헌 뉴스 테스트 입니다.</a></td>
                    <td width="60">관리자</td>
                    <td>2012-10-10</td>
                    </tr>
                  <tr>
                    <td colspan="4" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td width="50">9</td>
                    <td class="bbs_td_contents1"><a href="/homepage/contribution/contribution_03_view.home">사회공헌 뉴스 테스트 입니다.</a></td>
                    <td width="60">관리자</td>
                    <td>2012-10-10</td>
                    </tr>
                  <tr>
                    <td colspan="4" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td width="50">8</td>
                    <td class="bbs_td_contents1"><a href="#">사회공헌 뉴스 테스트 입니다.</a></td>
                    <td width="60">관리자</td>
                    <td>2012-10-10</td>
                    </tr>
                  <tr>
                    <td colspan="4" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td width="50">7</td>
                    <td class="bbs_td_contents1">사회공헌 뉴스 테스트 입니다.</td>
                    <td width="60">관리자</td>
                    <td>2012-10-10</td>
                    </tr>
                  <tr>
                    <td colspan="4" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td width="50">6</td>
                    <td class="bbs_td_contents1">사회공헌 뉴스 테스트 입니다.</td>
                    <td width="60">관리자</td>
                    <td>2012-10-10</td>
                    </tr>
                  <tr>
                    <td colspan="4" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td width="50">5</td>
                    <td class="bbs_td_contents1">사회공헌 뉴스 테스트 입니다.</td>
                    <td width="60">관리자</td>
                    <td>2012-10-10</td>
                    </tr>
                  <tr>
                    <td colspan="4" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td width="50">4</td>
                    <td class="bbs_td_contents1">사회공헌 뉴스 테스트 입니다.</td>
                    <td width="60">관리자</td>
                    <td>2012-10-10</td>
                    </tr>
                  <tr>
                    <td colspan="4" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td width="50">3</td>
                    <td class="bbs_td_contents1">사회공헌 뉴스 테스트 입니다.</td>
                    <td width="60">관리자</td>
                    <td>2012-10-10</td>
                    </tr>
                  <tr>
                    <td colspan="4" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td width="50">2</td>
                    <td class="bbs_td_contents1">사회공헌 뉴스 테스트 입니다.</td>
                    <td width="60">관리자</td>
                    <td>2012-10-10</td>
                    </tr>
                  <tr>
                    <td colspan="4" class="table_middle_line"></td>
                  </tr>
                  <tr class="bbs_td_contents2">
                    <td width="50">1</td>
                    <td class="bbs_td_contents1">사회공헌 뉴스 테스트 입니다.</td>
                    <td width="60">관리자</td>
                    <td>2012-10-10</td>
                    </tr>
                  <tr>
                    <td colspan="4" class="table_bottom_line"></td>
                  </tr>
                </table>                <!-- 사회공헌 뉴스 리스트 끝-->
                <!-- 페이징 시작-->
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td class="bbs_paging paging"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/paging_first.gif" width="17" height="11" /> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/paging_prev.gif" width="14" height="11" hspace="5px"/>  <a href="#" class="on">1</a> <a href="#">2</a> <a href="#">3</a> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/paging_next.gif" width="14" height="11" hspace="5px"/> <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/paging_last.gif" width="17" height="11" /></td>
                  </tr>
                </table>
                <!-- 페이징 끝-->
                <!-- 사회공헌뉴스 끝-->
                </td>
              </tr>
            </table>
            <!-- 메인 컨텐츠 내용 끝-->
            </td>
        </tr>
      </table>
      <!-- 메인 컨텐츠 끝--></td>
  </tr>
  <tr>
    <td align="center">&nbsp;</td>
  </tr>
  <tr>
    <td height="78" align="center"><!-- 푸터 시작--><%@include file="/WEB-INF/jsp/homepage/inc/footer.jsp"%><!-- 푸터 끝--></td>
  </tr>
</table>
</body>
</html>