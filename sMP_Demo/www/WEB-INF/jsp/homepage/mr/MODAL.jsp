<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.co.bitcube.common.utils.Constances" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>OK Plaza에 오신것을 환영합니다.</title>
<link href="<%=Constances.SYSTEM_JSCSS_URL%>/css/homepage_style.css" rel="stylesheet" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
</head>
<body>
<table width="1014" border="0" cellspacing="3" cellpadding="0" bgcolor="#f18833">
  <tr>
    <td bgcolor="#FFFFFF"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/pop_Dsearch_img_01.gif" width="1008" height="47" /></td>
      </tr>
      <tr>
        <td height="30" style="background-image:url(<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/pop_Dsearch_img_02.gif)"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="106"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/pop_Dsearch_img_03.gif" width="106" height="30" /></td>
            <td><label for="select"></label>
              <select name="select" id="select">
                <option>전체</option>
                <option>사급</option>
                <option>지정</option>
                <option>일반</option>
                <option>SKT</option>
              </select></td>
            <td width="50"><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/pop_Dsearch_btn.gif" width="41" height="19" /></td>
          </tr>
        </table></td>
      </tr>
      <tr>
        <td><img src="<%=Constances.SYSTEM_IMAGE_URL%>/img/homepage/pop_Dsearch_img_04.gif" width="1008" height="450" /></td>
      </tr>
    </table></td>
  </tr>
</table>
</body>
</html>