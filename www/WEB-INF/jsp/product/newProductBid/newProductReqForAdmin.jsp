<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances"%>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="kr.co.bitcube.common.dto.ActivitiesDto"%>
<%@ page import="java.util.List"%>

<%
	@SuppressWarnings("unchecked")
	//화면권한가져오기(필수)
	List<ActivitiesDto> roleList = (List<ActivitiesDto>) request.getAttribute("useActivityList");
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/system/systemInclude.jsp"%>
<!--------------------------- jQuery Fileupload --------------------------->

<!--------------------------- Modal Dialog Start --------------------------->
<!--------------------------- Modal Dialog End --------------------------->
<!-- file Upload 스크립트 -->
<script type="text/javascript">
	
</script>

<!-- 버튼 이벤트 스크립트 -->
<script type="text/javascript">
	
</script>

<!-- 그리드 초기화 스크립트 -->
<script type="text/javascript">
	
</script>

<!-- 그리드 이벤트 스크립트 -->
<script type="text/javascript">
	
</script>
</head>

<body>
   <form id="frmFile" name="frmFile" method="post" enctype="multipart/form-data">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">
         <tr>
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr valign="top">
                     <td width="20" valign="middle">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_ptitle1.gif" style="width: 14px; height: 15px;" />
                     </td>
                     <td height="29" class="ptitle">신규품목 요청 상세</td>
                  </tr>
               </table>
               <!-- 타이틀 끝 -->
            </td>
         </tr>
         <tr>
            <td>
               <!-- 타이틀 시작 -->
               <table width="100%" style="height: 27px;" border="0" cellpadding="0" cellspacing="0">
                  <tr>
                     <td width="20" valign="top">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/bullet_stitle_blue.gif" style="width: 5px; height: 5px;" class="bullet_stitle" />
                     </td>
                     <td class="stitle">신규품목 요청 내용</td>
                     <td align="right" class="ptitle">
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_product2.gif" style="width: 86px; height: 22px;" />
                        <img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/btn_type3_search.gif" style="width: 85px; height: 23px;" />
                     </td>
                  </tr>
               </table>
               <!-- 타이틀 끝 -->
            </td>
         </tr>
         <tr>
            <td>
               <!-- 컨텐츠 시작 -->
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                     <td colspan="6" class="table_top_line"></td>
                  </tr>
                  <tr>
                     <td colspan="6" height="1" bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject" width="100">고객사</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="srcLoginId4" name="srcLoginId4" type="text" value="" size="20" maxlength="30" style="width: 400px; width: 90%" />
                     </td>
                     <td class="table_td_subject" width="100">요청일자</td>
                     <td class="table_td_contents">
                        <input id="srcLoginId18" name="srcLoginId18" type="text" value="" size="20" maxlength="30" readonly="readonly" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height="1" bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject">상품명</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="srcLoginId19" name="srcLoginId19" type="text" value="" size="20" maxlength="30" style="width: 400px; width: 94%" />
                     </td>
                     <td class="table_td_subject">진행상태</td>
                     <td class="table_td_contents">
                        <input id="srcLoginId20" name="srcLoginId20" type="text" value="" size="20" maxlength="30" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height="1" bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject">상품규격</td>
                     <td colspan="3" class="table_td_contents">
                        <input id="srcLoginId22" name="srcLoginId22" type="text" value="" size="20" maxlength="30" style="width: 400px; width: 94%" />
                     </td>
                     <td class="table_td_subject">상품검색</td>
                     <td class="table_td_contents">
                        <input id="srcLoginId20" name="srcLoginId20" type="text" value="" size="20" maxlength="30" />
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height="1" bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject">요청사항</td>
                     <td colspan="5" class="table_td_contents4">
                        <textarea name="textarea" id="textarea" cols="45" rows="10" style="width: 500px; width:90%;height: 50px"></textarea>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height="1" bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td class="table_td_subject">첨부파일</td>
                     <td class="table_td_contents">
                        <input type="text" name="" id="" value="" style="width: 120px; width: 90%"/>
                     </td>
                     <td class="table_td_subject">첨부파일</td>
                     <td class="table_td_contents">
                        <input type="text" name="" id="" value="" style="width: 120px; width: 90%"/>
                     </td>
                     <td class="table_td_subject">첨부파일</td>
                     <td class="table_td_contents">
                        <input type="text" name="" id="" value="" style="width: 120px; width: 90%"/>
                     </td>
                  </tr>
                  <tr>
                     <td colspan="6" height="1" bgcolor="eaeaea"></td>
                  </tr>
                  <tr>
                     <td colspan="6" class="table_top_line"></td>
                  </tr>
               </table>
               <!-- 컨텐츠 끝 -->
            </td>
         </tr>
         <tr>
            <td>&nbsp;</td>
         </tr>
      </table>
      <div id="dialogSelectRow" title="Warning" style="display: none; font-size: 12px; color: red;">
         <p>처리할 데이터를 선택 하십시오!</p>
      </div>

      <!-------------------------------- Dialog Div Start -------------------------------->
      <!-------------------------------- Dialog Div End -------------------------------->
   </form>
</body>
</html>