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
		<td align="center">
			<!-- 메인 컨텐츠 시작-->
			<table width="977" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="186" valign="top" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/sub_left_menu_bg.gif)">
					<!-- 좌측메뉴 시작--><%@include file="/WEB-INF/jsp/homepage/inc/sub_left_03.jsp"%><!-- 좌측메뉴 끝-->
					</td>
					<td width="34" valign="top">&nbsp;</td>
					<td width="757" valign="top">
						<!-- 메인 컨텐츠 내용 시작-->
						<table width="757px" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/sub_c_categorySt_03.gif" width="757" height="63"/></td>
							</tr>
							<tr>
								<td width="300"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/user_st_01_01_01_01.gif" alt="고객사 회원가입" width="300" height="38"/></td>
								<td width="457" class="locacion"><p><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_home.gif" width="12" height="11"/> Home &gt; 이용안내 &gt; 회원가입 안내 &gt;<span class="orange"> 구매사 회원가입 안내</span><span class="orange"></span></p></td>
							</tr>
							<tr>
								<td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contents_line.gif" width="757" height="19"/></td>
							</tr>
							<tr>
								<td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/user_txt_box_01.gif" width="757" height="69" alt="구매사 가입 안내는 시행사 및 구매사의 「법인」 가입절차 입니다. 기존의 복잡한 구매방식을 On-Line 시스템으로 개선하여 경제적이고 효율적인 구매가 가능 하도록 지원합니다."/></td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="2" align="left"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/user_img_01_01.gif" alt="Step 01 _ 회원사가입문의
									- 전화번호 : 02-753-4692
									- 홈페이지 :
									
									Step 02 _ 가입신청서 작성
									- 회원사 기초정보 등록
									
									Step 03 _ 실무협의
									- 사업시스템 소개 
									- 구매대상 품목/규모, 조사
									- 서비스의 범위 조사
									
									Step 04 _ 계약체결 & 서비스 개시
									- 상호 계약체결 
									- 회원사 등록/회원사 Code 부여" width="757" height="272" usemap="#MapMapM" border="0"/>
								</td>
							</tr>
						</table>
						<map name="MapMapM">
							<area shape="rect" coords="445,56,86,21" href="mailto:bjh33@sk.com" alt="bjh33@sk.com" onFocus="this.blur()"/>
							<area shape="rect" coords="553,56,107,23" href="mailto:bjh33@sk.com" alt="bjh33@sk.com" onFocus="this.blur()"/>
						</map>
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
		<td height="78" align="center"><!-- 푸터 시작--><%@include file="/WEB-INF/jsp/homepage/inc/footer.jsp"%><!-- 푸터 끝--></td>
	</tr>
</table>
</body>
</html>