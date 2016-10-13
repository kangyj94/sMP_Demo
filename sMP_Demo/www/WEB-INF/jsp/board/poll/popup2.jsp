<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="<%=Constances.SYSTEM_IMAGE_URL%>/css/popup.css" type="text/css" charset="utf-8" />

<title>${poll.SUBJECT}</title>
</head>
<body>  
<form>
<div id="M_wrap">
<input type="hidden" name="oper" value="${empty poll.POLLCOMMENTID ? "add":"edit"}"/>
<input type="hidden" name="idGenSvcNm" value="seqPollComment"/>
<input type="hidden" name="pollId" value="${poll.POLLID}"/>
<input type="hidden" name="pollCommentId" value="${poll.POLLCOMMENTID}"/>
<input type="hidden" name="commentType" value="${poll.COMMENTTYPE}"/>
<%-- 	<div class="CNT"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/search.jpg" /></div> --%>
	<div class="CNT">${poll.CONTENT}</div>
	<div id="box">
		<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/icon_comment.png" style="vertical-align:middle;float:left;margin-bottom:3px"/><span class="comment">${poll.RECENTCOMMENT}</span>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="*" />
				${empty poll.COMMENT?'<col class="colComment" width="70px" />':''}
				<col width="190px" />
			</colgroup>
<!-- 			<tr> -->
<!-- 				<td colspan="2"> -->
<%-- 					<img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/icon_comment.png" style="vertical-align:middle;margin-bottom:3px"/><span class="comment">${poll.RECENTCOMMENT}</span> --%>
<!-- 				</td> -->
<!-- 			</tr> -->
			<tr>
				<td>
					<textarea name="comment" required title="댓글" style="width:100%;height:50px;" maxlength="100" placeholder="최대 100글자" ${empty poll.COMMENT?'':'disabled'}>${poll.COMMENT}</textarea>
				</td>
				${empty poll.COMMENT?'<td class="tdComment" align="right" valign="middle"><a href="#" class="commentBtn"><img src="/img/btn_save.png" /></a></td>':''}
				<td align="right">
					<table border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td style="min-width:90px" valign="middle"><span class="goodCnt" style="font-size:24px; color:#F00;">${poll.GOODCNT}</span> <a href="#" class="goodBtn"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/good.png" style="vertical-align:middle;" /></a></td>
							<td style="min-width:90px" align="right" valign="middle"><a href="#" class="poorBtn"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/bad.png" style="vertical-align:middle;" /></a> <span class="poorCnt" style="font-size:24px; color:#333;">${poll.POORCNT}</span></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</div>
	<div class="pos_pop_control">
    	<table width="100%">
    		<tr>
    			<td>
			        <input onclick="notice_closeWin();" id="none_today" style="HEIGHT: 14px; VERTICAL-ALIGN: middle; PADDING-BOTTOM: 0px; PADDING-TOP: 0px; PADDING-LEFT: 0px; MARGIN: 0px; PADDING-RIGHT: 0px; WIDTH: 14px" type="checkbox">
			        <label style="HEIGHT: 23px; LINE-HEIGHT: 23px;color:#fff" for="none_today"> 오늘 하루 그만 보기</label>
        		</td>
        		<td align="right">
        			<a href="#" onclick="notice_closeWin()" class="close"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/btn_pos_close.gif" alt="창닫기"></a>
        		</td>
        	</tr>
        </table>
	</div>
</div>
</form>
<script src="<%=Constances.SYSTEM_CONTEXT_PATH%>/jq/js/jquery.min.js" type="text/javascript"></script>
<script src="<%=Constances.SYSTEM_CONTEXT_PATH%>/jq/js/custom.common.js" type="text/javascript"></script>

<script language="JavaScript">
$(function() {
    $('.closeBtn').click(function () {
        $(this).closest('.M_wrap').remove();
    });
    $('.commentBtn').click(function () {
        var obj = $(this);
        var f = obj.closest('form');
        if (!f.validate()) {
            return;
        }
        var sp = null;
        if (f.find('input[name=pollCommentId]').val() == '') {
            sp = 'insertPollComment';
        } else {
            sp = 'updatePollComment';
        }
        $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/board/'+sp+'/save.sys', f.serialize(),
            function(msg) {
              var m = eval('(' + msg + ')');
              if (m.customResponse.success) {
                  f.find('input[name=oper]').val('edit');
                  f.find('input[name=pollCommentId]').val(m.customResponse.newIdx);
                  alert('설문조사에 참여해주셔서 감사합니다.');
                  f.find('.comment').html(f.find('textarea').val());
                  f.find('textarea').attr('disabled', true);
                  f.find('.colComment').css('width', '190px');
                  f.find('.tdComment').remove();
              } else {
                  alert('저장 중 오류가 발생했습니다.');
              }
            }
        );  
    });
    $('.goodBtn').click(function () {
        var f = $(this).closest('form');
        updateCommentType(f, 'good');
    });
    $('.poorBtn').click(function () {
        var f = $(this).closest('form');
        updateCommentType(f, 'poor');
    });
});
function updateCommentType(f, sts) {
    var commentType = f.find('input[name=commentType]');
    if (commentType.val() != '') {
        alert('이미 참여하였습니다.');
        return;
    }
    commentType.val(sts);

    var sp = null;
    if (f.find('input[name=pollCommentId]').val() == '') {
        sp = 'insertPollCommentType';
    } else {
        sp = 'updatePollCommentType';
    }
    $.post('<%=Constances.SYSTEM_CONTEXT_PATH %>/board/'+sp+'/save.sys', f.serialize(),
        function(msg) {
          var m = eval('(' + msg + ')');
          if (m.customResponse.success) {
              f.find('input[name=oper]').val('edit');
              f.find('input[name=pollCommentId]').val(m.customResponse.newIdx);
              alert('설문조사에 참여해주셔서 감사합니다.');
          } else {
              alert('저장 중 오류가 발생했습니다.');
          }
        }
    );  
    
    var cnt = f.find('.' + sts + 'Cnt');
    cnt.html(parseInt(cnt.html(), 10) + 1);
}
function notice_setCookie( name, value, expiredays ) {
 var todayDate = new Date();
 todayDate.setDate( todayDate.getDate() + expiredays ); 
 document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";" 
}
    
function notice_closeWin() { 
 if ( document.getElementById("none_today").checked )
    SetNewCookie( "poll${poll.POLLID}", "no");
 self.close(); 
}
        
function SetNewCookie(sName, sValue) {
    var expDays = 1; // 쿠키 만료기간(일수)
    var todayDate = new Date(); 
    var cookiePath = "/";
    todayDate.setDate(todayDate.getDate() + expDays); 

    document.cookie = sName + "=" + escape(sValue) + ";" +
    "expires=" + todayDate.toGMTString() + ";" +
    "path=" + cookiePath + ";";
}
</script>
</body>
</html>
