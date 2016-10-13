<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<%@ page import="kr.co.bitcube.common.utils.CommonUtils"%>
<%@ page import="java.util.Calendar"%>

<%
	Calendar calendar = Calendar.getInstance();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<style type="text/css">
.holidayWindow {
    display: none;
    position: fixed;
    top: 17%;
    left: 50%;
    margin-left: -300px;
    width: 530px;
    background-color: #EEE;
    color: #333;
    border: 1px solid black;
    padding: 12px;
}
.jqmOverlay { background-color: #000; }
* html .holidayWindow {
     position: absolute;
     top: expression((document.documentElement.scrollTop || document.body.scrollTop) + Math.round(17 * (document.documentElement.offsetHeight || document.body.clientHeight) / 100) + 'px');
}
</style>


<script type="text/javascript">
$(document).ready(function(){
	

    $('#holidayWindow').jqm(); 
    $('#holidayWindow').jqm().jqDrag('#holidayWindowHandle');
    
    $("#holiday").datepicker(
        {
            showOn: "button",
            buttonImage: "/img/system/btn_icon_calendar.gif",
            buttonImageOnly: true,
            dateFormat: "yy-mm-dd",
            yearRange : "2015:<%=calendar.get(calendar.YEAR)+1%>"
        }
    );
    
    $("img.ui-datepicker-trigger").attr("style", "margin-left:5px; vertical-align:middle; cursor:pointer;"); // 입력창 옆의 이미지 속성 설정
    $('#holidayCloseButton').click(function(){ $("#holidayWindow").jqmHide();});	
    $('#holidaySaveButton').click(function(){ fnSaveHoliday(); });    
    
});

function fnHolidayDialog() {
	
	$('#holiday').val("");
	$('#holiday_nm').val("");
	$('#holidayWindow').jqmShow();
}

function fnSaveHoliday(){
	
	var holiday		= $('#holiday').val();
	var holiday_nm	= $('#holiday_nm').val();
	
	if( ! holiday ){
		alert("휴일일자를 입력하여 주시기 바랍니다.");
		return;
	}
	
	var format = /^(19[7-9][0-9]|20\d{2})-(0[0-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/;
	
	if( holiday.length != 10 || format.test(holiday)==false ){
		alert("날짜 형식이 올바르지 않습니다 \n ex) YYYY-MM-DD");
	}
	if( ! holiday_nm ){
		alert("휴일명을 입력하여 주시기 바랍니다.");
		return;
	}
	
	if( holiday_nm.length > 51){
		alert("휴일명은 최대 50자까지 입력 가능합니다.");
		return;
	}
	
	$.post(
		"/system/holiday/insertHolidayManage/save.sys",
		{
			holiday		: holiday,
			holiday_nm	: holiday_nm,
			oper		: 'add'
		},
		function(args){
			if ( fnAjaxTransResult(args)) {
				fnSearch();
				$('#holidayWindow').jqmHide();
			} 
			
		}
	);
}

</script>

</head>
<body>
<div class="holidayWindow" id="holidayWindow">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<div id="holidayWindowHandle">
					<table width="100%"  border="0" cellpadding="0" cellspacing="0" style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/popup_titlebar_mid.gif');">
		      			<tr>
		        			<td width="21" style="background-color: #ea002c; height: 47px;"></td>
		        			<td style="background-color: #ea002c; height: 47px;color: #fff;font-weight: 700;">
		        				<h2>휴일관리 등록</h2>
		        			</td>
		        			<td width="22" align="right" style="background-color: #ea002c; height: 47px;">
		        				<a href="#;" class="jqmClose">
		        				<img src="/img/contents/btn_close.png" class="jqmClose">
		        				</a>
		        			</td>
		        			<td width="10" style="background-color: #ea002c; height: 47px;"></td>
		      			</tr>
					</table>
				</div>
				<table width="100%"  border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_1.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_1.gif');">&nbsp;</td>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_2.gif" width="20" height="20" /></td>
					</tr>
					<tr>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_4.gif');">&nbsp;</td>
						<td bgcolor="#FFFFFF">
							
							<!-- 조회조건 -->
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td colspan="2" class="table_top_line"></td>
								</tr>
								<tr>
									<td class="table_td_subject" width="80">휴일일자</td>
									<td class="table_td_contents">
										<input id="holiday" name="holiday" type="text" maxlength="10" disabled="disabled" style="width: 100px;"/>
									</td>
								</tr>
                                <tr>
                                    <td colspan="2" height="1" bgcolor="eaeaea"></td>
                                </tr>
                                <tr>
                                    <td class="table_td_subject" width="80">휴일명</td>
                                    <td class="table_td_contents">
                                        <input  id="holiday_nm" name="holiday_nm" type="text" maxlength="50">
                                    </td>
                                </tr>
								<tr>
									<td colspan="2" class="table_top_line"></td>
								</tr>
								<tr>
									<td colspan="2" height='8'></td>
								</tr>
							</table>
							
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td align="center">
										<button id="holidaySaveButton" type="button" class="btn btn-primary btn-sm isWriter"><i class="fa fa-check"></i>등록</button>
										<button id="holidayCloseButton" type="button" class="btn btn-default btn-sm isWriter"><i class="fa fa-close"></i>닫기</button>
									</td>
								</tr>
							</table>
						</td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_2.gif');">&nbsp;</td>
					</tr>
					<tr>
						<td width="20" height="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_4.gif" width="20" height="20"/></td>
						<td style="background-image: url('<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_line_3.gif');">&nbsp;</td>
						<td width="20"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/system/box_corner_3.gif" width="20" height="20" /></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
