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
<SCRIPT LANGUAGE="JavaScript">
// FAQ
var faq_idx_tmp = 0;
function faqView(idx) {
	if (faq_idx_tmp != 0) document.getElementById("a"+faq_idx_tmp).style.display = "none";
	document.getElementById("a"+idx).style.display = "block";
	faq_idx_tmp = idx;
}
</SCRIPT>
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
					<!-- 좌측메뉴 시작-->
						<%@include file="/WEB-INF/jsp/homepage/inc/sub_left_03_02.jsp"%>
					<!-- 좌측메뉴 끝-->
					</td>
					<td width="34" valign="top">&nbsp;</td>
					<td width="757" valign="top">
						<!-- 메인 컨텐츠 내용 시작-->
						<table width="757px" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/sub_c_categorySt_03.gif" width="757" height="63"></td>
							</tr>
							<tr>
								<td width="300"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/user_st_04.gif" width="300" height="38"></td>
								<td width="457" class="locacion"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_home.gif" width="12" height="11"> Home &gt; 이용안내 &gt;<span class="orange"> 고객지원센터</span></td>
							</tr>
							<tr>
								<td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contents_line.gif" width="757" height="19"></td>
							</tr>
							<tr>
								<td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/user_txt_box_04.gif" alt="고객여러분의 이용에 최대한의 편의를 제공하겠습니다. 무엇이든 물어봐주십시요." width="757" height="48" /></td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="2" align="left" class="helpDesk">
									<!-- 고객지원센터 시작-->
									OK Plaza 고객지원센터는 회원가입에서 주문, Monitoring, 배송, 지불 청구까지 과정안내와 
									시스템 사용방법 및 사용   불편사항에 <br />
									접수 및 해결을위하여 담당자를 별도 운영하고 있습니다.<br />
									이용과정에서 불편한 점이나 의문사항이 있으시면 언제든지 연락   주십시요.<br />
									담당자가 친절하고 신속하게 상담해 드리겠습니다.<!-- 고객지원센터 끝-->
								</td>
							</tr>
							<tr>
								<td colspan="2" align="left">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="2" align="left">
									<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
										<tr>
											<td width="100"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/user_04_img_01.gif" width="100" height="100" /></td>
											<td>
												<table width="100%" border="0" cellspacing="0" cellpadding="0">
													<tr>
														<td colspan="12" class="table_top_line"></td>
													</tr>
													<tr>
														<td class="table_td_split2" rowspan="18"></td>
														<td class="bbs_td_subject2" width="180" colspan="4">업무 구분</td>
														<td class="table_td_split2"></td>
														<td width="90" class="bbs_td_subject2" style="line-height: 16px;">담당자</td>
														<td class="table_td_split2"></td>
														<td width="100" class="bbs_td_subject2">연락처</td>
														<td class="table_td_split2"></td>
														<td width="100" class="bbs_td_subject2">이메일</td>
														<td class="table_td_split2"></td>
													</tr>
													<tr>
														<td colspan="12" class="table_middle_line"></td>
													</tr>
													<tr>
														<td class="bbs_td_contents2" style="text-align: center" colspan="2" rowspan="7">
															<font color="#663333">자재 문의</font></td>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2" style="text-align: center">
															<font color="#663333">철가, 환경친화형 위장재, 건축 및 제조/유통</font></td>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2" style="line-height: 16px;">과장 김&nbsp;&nbsp;철</td>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2">02-2129-2045</td>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2" style="text-align: left">
															<a href="mailto:bogeus@sk.com"><u>bogeus@sk.com</u></a>
														</td>
														<td class="table_td_split2"></td>
													</tr>
													<tr>
														<td colspan="12" class="table_middle_line"></td>
													</tr>
													<tr>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2" style="text-align: center">
															<font color="#663333">RF케이블 및 RF소자, 무선일반지입, OJC, 전송망자재</font></td>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2" style="line-height: 16px;">과장 최기원</td>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2">031-786-5564</td>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2" style="text-align: left">
															<a href="mailto:nowik@sk.com"><u>nowik@sk.com</u></a>
														</td>
														<td class="table_td_split2"></td>
													</tr>
													<tr>
														<td colspan="12" class="table_middle_line"></td>
													</tr>
													<tr>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2" style="text-align: center">
															<font color="#663333">선로자재, 안전용품, 유선일반지입, 광케이블, 함체</font></td>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2" style="line-height: 16px;">대리 진영준</td>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2">02-2129-1889</td>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2" style="text-align: left">
															<a href="mailto:jyj79@sk.com"><u>jyj79@sk.com</u></a>
														</td>
														<td class="table_td_split2"></td>
													</tr>
													<tr>
														<td colspan="12" class="table_middle_line"></td>
													</tr>
													<tr>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2" style="text-align: center">
															<font color="#663333">
																가입자망개통공사자재 <br/>(SKB Home고객센터/Home클리닉),<br/>
																광관로시설공사자재 <br/>(SKT 및 SKB 택지공사업체)
															</font>
														</td>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2" style="line-height: 16px;">대리 김형진</td>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2">02-2129-2070</td>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2" style="text-align: left">
															<a href="mailto:rokmc@sk.com"><u>rokmc@sk.com</u></a>
														</td>
														<td class="table_td_split2"></td>
													</tr>
													<tr>
														<td colspan="12" class="table_middle_line"></td>
													</tr>
													<tr>
														<td class="bbs_td_contents2" style="text-align: center" colspan="2" rowspan="3">
															<font color="#663333">회&nbsp;계</font></td>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2" style="text-align: center">
															<font color="#663333">채권/여신</font></td>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2" style="line-height: 16px;">대리 송태리</td>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2">02-2129-2049<br/>070-7403-2049</td>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2" style="text-align: left">
															<a href="mailto:trsong@sk.com"><u>trsong@sk.com</u></a>
														</td>
														<td class="table_td_split2"></td>
													</tr>
													<tr>
														<td colspan="12" class="table_middle_line"></td>
													</tr>
													<tr>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2" style="text-align: center">
															<font color="#663333">세금계산서</font></td>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2" style="line-height: 16px;">대리 변지희</td>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2">02-2129-1953<br/>070-7403-1953</td>
														<td class="table_td_split2"></td>
														<td class="bbs_td_contents2" style="text-align: left">
															<a href="mailto:bjh33@sk.com"><u>bjh33@sk.com</u></a>
														</td>
														<td class="table_td_split2"></td>
													</tr>
													<tr>
														<td colspan="12" class="table_middle_line"></td>
													</tr>
													<tr>
														<td colspan="12" class="table_bottom_line"></td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
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
		<td height="78" align="center"><!-- 푸터 시작--><%@include file="/WEB-INF/jsp/homepage/inc/footer.jsp"%><!-- 푸터 끝--></td>
	</tr>
</table>
</body>
</html>