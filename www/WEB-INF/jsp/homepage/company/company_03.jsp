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
					<!-- 좌측메뉴 시작--><%@include file="/WEB-INF/jsp/homepage/inc/sub_left_01.jsp"%><!-- 좌측메뉴 끝-->
					</td>
					<td width="34" valign="top">&nbsp;</td>
					<td width="757" valign="top">
						<!-- 메인 컨텐츠 내용 시작-->
						<table width="757px" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/sub_c_categorySt_01.gif" width="757" height="63"/></td>
							</tr>
							<tr>
								<td width="300">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/company_st_03.gif" width="300" height="38"/>
								</td>
								<td width="457" class="locacion">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_home.gif" width="12" height="11"/> Home &gt; 회사소개 &gt;<span class="orange"> CEO Message</span>
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contents_line.gif" width="757" height="19"/>
								</td>
							</tr>
							<tr>
								<td colspan="2" align="left"><p><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/greeting_v2_1.jpg" alt="최고의 고객가치를 창출해 나가는 회사
										Most Reliable Network Partner
										
										안녕하세요. OK Plaza를 방문해 주셔서 감사합니다.
										
										지난 1997년 설립된 SK텔레시스는 세계 최고의 IT분야 R&D 역량을 바탕으로 2G, 3G, 와이브로와 최신 통신 기술인 4G LTE에 이르기까지 국내외 통신 인프라에 최적화된 중계기와 이동통신 장비 개발 및 구축을 통해 통신 시장을 이끌어가고 있는 전문기업입니다.
										
										SK텔레시스는 SK그룹 내 유일한 이동통신장비 전문 개발 업체로서, 통신 사업자에 최적화된 솔루션을 제공하기 위해 힘쓰는 한편, '품질'과 '신뢰'에 기반한 새로운 고객 가치를 창출해내고 있습니다.
										
										또한 급변하는 IT기술 발전에 효율적으로 대응하고 세계적인 기술개발을 위해 2010년 판교 테크노밸리에 R&D센터를 설립하여 연구개발에 적극적인 투자를 하고 있으며, 이를 통해 차별화된 통신장비를 개발하여 이동통신장비 시장의 흐름을 선도해나가고 있습니다.
										
										저와 임직원 모두는 현재까지 축적해온 경쟁 우위 기술력을 기반으로 사업의 다각화를 위해 끊임 없이 노력함으로써, '작지만 강한' 글로벌 Top 수준의 통신장비 전문회사로 거듭날 수 있도록 최선을 다하고 앞선 기술력을 바탕으로 최고의 비즈니스 파트너가 되도록 노력하겠습니다.
										
										Stay Together, '언제 어디서나' 즐거운 커뮤니케이션을 위해 SK텔레시스가 여러분과 함께하겠습니다.
										
										감사합니다." width="757" /></p>
								</td>
							<tr>
								<td colspan="2" align="left">
									<p><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/greeting_v2_2.jpg" width="757" /></p>
								</td>
							</tr>
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
		<td height="78" align="center"><!-- 푸터 시작--><%@include file="/WEB-INF/jsp/homepage/inc/footer.jsp"%><!-- 푸터 끝--></td>
	</tr>
</table>
</body>
</html>