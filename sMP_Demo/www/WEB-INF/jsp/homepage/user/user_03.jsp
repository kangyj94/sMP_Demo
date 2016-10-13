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
            <!-- 좌측메뉴 시작--><%@include file="/WEB-INF/jsp/homepage/inc/sub_left_03_02.jsp"%><!-- 좌측메뉴 끝-->
        </td>
            <td width="34" valign="top">&nbsp;</td>
            <td width="757" valign="top">
            <!-- 메인 컨텐츠 내용 시작-->
            <table width="757px" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/sub_c_categorySt_03.gif" width="757" height="63"></td>
              </tr>
              <tr>
                <td width="300"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/user_st_03.gif" width="300" height="38"></td>
                <td width="457" class="locacion"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/icon_home.gif" width="12" height="11"> Home &gt; 이용안내 &gt;<span class="orange"> FAQ</span></td>
              </tr>
              <tr>
                <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/contents_line.gif" width="757" height="19"></td>
              </tr>
              <tr>
                <td colspan="2"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/faq_txt_box.gif" alt="고객여러분의 이용에 최대한의 편의를 제공하겠습니다. 무엇이든 물어봐주십시요." width="757" height="48" /></td>
              </tr>
              <tr>
                <td colspan="2">&nbsp;</td>
              </tr>
              <tr>
                <td colspan="2" align="left"><!-- FAQ 시작-->
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td class="table_top_line"></td>
                    </tr>
                    <tr>
                      <td class="bbs_td_subject">
                      <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="150" align="center">구분</td>
                          <td align="center" class="table_td_split2"></td>
                          <td align="center">제목</td>
                        </tr>
                      </table></td>
                    </tr>
                    <tr>
                      <td class="table_middle_line"></td>
                    </tr>
                  </table>
                  <div id="q11" class="question">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td height="2" class="org1_color1"></td>
                  <td height="2" class="org1_color1"></td>
                </tr>
				<tr>
                  <td width="160" align="center">회원정보</td>
                  <td height="30" style="padding-left:5;"><a href="javascript:faqView(11)"><strong>회원가입은 어떻게 하나요?</strong></a></td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
				</div>
                <div id="a11" class="answer" style="display:none;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="10" align="center" valign="top" bgcolor="f7f8f9" style="padding:5px 0 5px 0;"></td>
                  <td height="30" bgcolor="f7f8f9" style="padding:10px 10px 10px 10px;">회원은 회원사(법인)계약이 되어있고 소속회사의 직원이면 누구나 회원가입을 하실 수 있습니다. <br />
사이트 상단 로그인 우측 회원가입버튼을 클릭 후 우선 회원사 가입를 입력하시기 바랍니다. <br />
회원사 가입이 완료되면 입력하신 E-Mail주소로 회원사CODE를 보내 드립니다.<br />
회원사CODE를 등록한 회원사 직원에 한하여 회원가입을 승인해 드립니다.<br />
가입 중 문의사항이 있으시면 고객께서는 02-753-1215,1216로 연락하여 주시기 바랍니다.<br />
친절하게 상담해 드리겠습니다.</td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
</div>
				<div id="q12" class="question">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td height="2" class="org1_color1"></td>
                  <td height="2" class="org1_color1"></td>
                </tr>
				<tr>
                  <td width="160" align="center">회원정보</td>
                  <td height="30" style="padding-left:5;"><a href="javascript:faqView(12)"><strong>회원가입 후 승인까지 얼마나 시간이 소요 되나요?</strong></a></td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
				</div>
                <div id="a12" class="answer" style="display:none;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="10" align="center" valign="top" bgcolor="f7f8f9" style="padding:5px 0 5px 0;"></td>
                  <td height="30" bgcolor="f7f8f9" style="padding:10px 10px 10px 10px;">회원사CODE가 부여되고 난 후 24시간이내에 회원승인을 해드립니다.<br />
회원사CODE 부여를 위하여 사업장 방문 시 에는 2~3일 기간이 소요 될 수도 있습니다.</td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
</div>
				<div id="q13" class="question">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td height="2" class="org1_color1"></td>
                  <td height="2" class="org1_color1"></td>
                </tr>
				<tr>
                  <td width="160" align="center">검색서비스</td>
                  <td height="30" style="padding-left:5;"><a href="javascript:faqView(13)"><strong>상품검색은 어떻게 하나요?</strong></a></td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
				</div>
                <div id="a13" class="answer" style="display:none;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="10" align="center" valign="top" bgcolor="f7f8f9" style="padding:5px 0 5px 0;"></td>
                  <td height="30" bgcolor="f7f8f9" style="padding:10px 10px 10px 10px;">상품 검색은 검색엔진을 통해 원하시는 상품을 가장 빠르게 찾을 수 있습니다.<br />
사이트 화면의 중앙에 상품 검색창이 있습니다.<br />

-기본검색 : 상품명, 규격, 제조사, 주문단위를 확인<br />
-검색버튼을 클릭하시면 원하는 정보가 화면에 출력됩니다. <br />
-유사어 검색 : 유사어 정보가 입력되어 있는 상품에 대해 상품명 검색이 가능합니다.<br />
-카테고리 검색 : 체계적인 카테고리(대, 중, 소, 상세분류)를 차례대로 찾아 들어가시면 규격으로 검색이 가능합니다. </td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
</div>
				<div id="q14" class="question">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td height="2" class="org1_color1"></td>
                  <td height="2" class="org1_color1"></td>
                </tr>
				<tr>
                  <td width="160" align="center">검색서비스</td>
                  <td height="30" style="padding-left:5;"><a href="javascript:faqView(14)"><strong>긴급으로 주문신청하려면 어떻게 하나요?</strong></a></td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
				</div>
                <div id="a14" class="answer" style="display:none;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="10" align="center" valign="top" bgcolor="f7f8f9" style="padding:5px 0 5px 0;"></td>
                  <td height="30" bgcolor="f7f8f9" style="padding:10px 10px 10px 10px;">긴급구매는 구매등록 화면에서 긴급으로 Check해 주시면 됩니다.<br />
단, 당일배송에 대하여는 구매사에서 배송료를 부담 하셔야 합니다.</td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
              </div>
              <div id="q15" class="question">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td height="2" class="org1_color1"></td>
                  <td height="2" class="org1_color1"></td>
                </tr>
				<tr>
                  <td width="160" align="center">검색서비스</td>
                  <td height="30" style="padding-left:5;"><a href="javascript:faqView(15)"><strong>사이트에 없는 상품은 어떻게 주문할 수 있나요?</strong></a></td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
				</div>
                <div id="a15" class="answer" style="display:none;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="10" align="center" valign="top" bgcolor="f7f8f9" style="padding:5px 0 5px 0;"></td>
                  <td height="30" bgcolor="f7f8f9" style="padding:10px 10px 10px 10px;">사이트에서 현재 제공되지 않는 상품에 대해서는 신규상품신청 화면에 입력하시면 됩니다.<br />
신규상품에 대한 정보를 입력하시고 주문상품은 FAX 발송 또는 화면을 첨부해 주셔도 되고,<br />
담당자 면담을 원하시면 방문 후 접수 처리해 드립니다.<br />
상품등록이 완료되면 품명을 클릭하여 주문할 수 있습니다.(상품등록 시 연락를 드립니다.)</td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
              </div>
              <div id="q16" class="question">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td height="2" class="org1_color1"></td>
                  <td height="2" class="org1_color1"></td>
                </tr>
				<tr>
                  <td width="160" align="center">주문</td>
                  <td height="30" style="padding-left:5;"><a href="javascript:faqView(16)"><strong>주문신청은 어떻게 하나요?</strong></a></td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
				</div>
                <div id="a16" class="answer" style="display:none;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="10" align="center" valign="top" bgcolor="f7f8f9" style="padding:5px 0 5px 0;"></td>
                  <td height="30" bgcolor="f7f8f9" style="padding:10px 10px 10px 10px;">구매등록을 접속 후 배송정보 등록/상품카탈로그 선택/수량,납기등록을 하신 후주문 선택한 상품을 구매할 상품인지 확인 후 완료 버튼을 클릭하시면 됩니다.</td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
              </div>
<div id="q17" class="question">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td height="2" class="org1_color1"></td>
                  <td height="2" class="org1_color1"></td>
                </tr>
				<tr>
                  <td width="160" align="center">주문</td>
                  <td height="30" style="padding-left:5;"><a href="javascript:faqView(17)"><strong>주문이 정상적으로 주문이 되었는지 확인할 경우?</strong></a></td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
				</div>
                <div id="a17" class="answer" style="display:none;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="10" align="center" valign="top" bgcolor="f7f8f9" style="padding:5px 0 5px 0;"></td>
                  <td height="30" bgcolor="f7f8f9" style="padding:10px 10px 10px 10px;">진척도 조회 또는 실적조회를 클릭하시면 주문/발주/생산/인수단계를 확인할 수 있습니다.</td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
              </div>
<div id="q18" class="question">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td height="2" class="org1_color1"></td>
                  <td height="2" class="org1_color1"></td>
                </tr>
				<tr>
                  <td width="160" align="center">발주</td>
                  <td height="30" style="padding-left:5;"><a href="javascript:faqView(18)"><strong>발주에 대한 상태별로 조회를 하고 싶습니다.</strong></a></td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
				</div>
                <div id="a18" class="answer" style="display:none;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="10" align="center" valign="top" bgcolor="f7f8f9" style="padding:5px 0 5px 0;"></td>
                  <td height="30" bgcolor="f7f8f9" style="padding:10px 10px 10px 10px;">진척도 조회 메뉴를 클릭하고 발주처리가 완료된 상품목록을 일자/주문번호/처리상태별로 조회할 수 있습니다.</td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
              </div>
<div id="q19" class="question">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td height="2" class="org1_color1"></td>
                  <td height="2" class="org1_color1"></td>
                </tr>
				<tr>
                  <td width="160" align="center">정산</td>
                  <td height="30" style="padding-left:5;"><a href="javascript:faqView(19)"><strong>거래명세서 발행은 어떻게 하나요?</strong></a></td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
				</div>
                <div id="a19" class="answer" style="display:none;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="10" align="center" valign="top" bgcolor="f7f8f9" style="padding:5px 0 5px 0;"></td>
                  <td height="30" bgcolor="f7f8f9" style="padding:10px 10px 10px 10px;">거래명세서는 월 단위 또는 기간별로 해당 거래내역(거래일자/상품명/구매수량/구매금액/할인료)을 확인 하실 수 있으시며, 출력 가능합니다.</td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
              </div>
<div id="q20" class="question">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td height="2" class="org1_color1"></td>
                  <td height="2" class="org1_color1"></td>
                </tr>
				<tr>
                  <td width="160" align="center">정산</td>
                  <td height="30" style="padding-left:5;"><a href="javascript:faqView(20)"><strong>전자세금계산서 발행은 어떻게 하나요?</strong></a></td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
				</div>
                <div id="a20" class="answer" style="display:none;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="10" align="center" valign="top" bgcolor="f7f8f9" style="padding:5px 0 5px 0;"></td>
                  <td height="30" bgcolor="f7f8f9" style="padding:10px 10px 10px 10px;">세금계산서는 고객별 계약에 따라 월 단위 마감 후 우편으로 발송해 드립니다.</td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
              </div>
<div id="q21" class="question">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td height="2" class="org1_color1"></td>
                  <td height="2" class="org1_color1"></td>
                </tr>
				<tr>
                  <td width="160" align="center">주문 취소 및 반품</td>
                  <td height="30" style="padding-left:5;"><a href="javascript:faqView(21)"><strong>주문취소는가능한가요?</strong></a></td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
				</div>
                <div id="a21" class="answer" style="display:none;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="10" align="center" valign="top" bgcolor="f7f8f9" style="padding:5px 0 5px 0;"></td>
                  <td height="30" bgcolor="f7f8f9" style="padding:10px 10px 10px 10px;">1.주문취소는 Mall에서 접수 전까지는 주문취소가 가능합니다.<br/>

2.Mall에서 접수 후 주문취소 절차는 다음과 같습니다.<br/>
1) 진척도 조회 메뉴를 클릭 후 주문조회(주문단위)버튼 클릭합니다.<br/> 
2) 주문번호를 확인 후 Mall담당자에게 유선으로 취소주문을 합니다.<br/>
3) Mall 담당자가 접수를 해지하면 주문수정/삭제 메뉴에서 주문취소를 합니다. <br/>
     단, 생산이 완료된 상태에서는 주문취소가 안됩니다.</td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
              </div>
<div id="q22" class="question">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td height="2" class="org1_color1"></td>
                  <td height="2" class="org1_color1"></td>
                </tr>
				<tr>
                  <td width="160" align="center">주문 취소 및 반품</td>
                  <td height="30" style="padding-left:5;"><a href="javascript:faqView(22)"><strong>반품은 가능한가요?</strong></a></td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
				</div>
                <div id="a22" class="answer" style="display:none;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="10" align="center" valign="top" bgcolor="f7f8f9" style="padding:5px 0 5px 0;"></td>
                  <td height="30" bgcolor="f7f8f9" style="padding:10px 10px 10px 10px;">1. 반품은 상품의 배송완료가 끝난 주문에 대해서 반품요청이 가능합니다.<br/>
2. 반품절차는 다음과 같습니다.<br/>
1) 반품할 해당 주문번호를 검색하여 확인합니다.<br/>
2) 사이트의 고객지원센타에 전화해 반품을 신청합니다.<br/>
3) Mall에서 공급사와 상품명을 입력합니다.<br/>
4) 반품요청된 상품에 대해서는 SK telesys에서 수령하여 공급사에게 전달됩니다. <br/>
3. 주문취소 및 반품접수 후에는 상담원이 확인후 처리를 해 드립니다. </td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
              </div>
<div id="q23" class="question">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td height="2" class="org1_color1"></td>
                  <td height="2" class="org1_color1"></td>
                </tr>
				<tr>
                  <td width="160" align="center">배송</td>
                  <td height="30" style="padding-left:5;"><a href="javascript:faqView(23)"><strong>상품에 대한 배송기간은 어떻게 되나요?</strong></a></td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
				</div>
                <div id="a23" class="answer" style="display:none;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="10" align="center" valign="top" bgcolor="f7f8f9" style="padding:5px 0 5px 0;"></td>
                  <td height="30" bgcolor="f7f8f9" style="padding:10px 10px 10px 10px;">상품별 납품보증일 사전에 정하며, 고객께서 납품보증일 이전 인수를 요청 시에는 가능한 
배송해 드리지만 부득이한 경우는 사전에 연락을 드립니다.<br/>
※납품보증일을 원칙으로 하나, 계약 당시 사전 협의가 필요함.</td>
                </tr>
                <tr>
                  <td height="1" align="center" bgcolor="e9edf0"></td>
                  <td height="1" bgcolor="e9edf0" ></td>
                </tr>
              </table>
              </div>
                <!-- FAQ 끝-->
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