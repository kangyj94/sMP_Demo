document.write('<OBJECT ID="XecureWeb" CLASSID="CLSID:7E9FDB80-5316-11D4-B02C-00C04F0CD404"  width=0 height=0><param name="lang" value="korean">No XecureWeb PlugIn</OBJECT>');
//CODEBASE="/XecureObject/xw_install.cab#Version=7,2,1,3"

function gfEncrypt(plain_text)
{
	///////////////////////////////////////////////////////////////////////////////////
	// xgate ���� ��:��Ʈ ���� , ��Ʈ ������ ����Ʈ�� 443 ��Ʈ ���
	var s_xgate_addr	= window.location.hostname + ":443:8080";
	//var xgate_addr	= "210.124.178.206" + ":8443:8001,8002,8003,8004,8005,8006,8007,8008,8009,8010,8011";

	//s_auth_type = location.pathname;
	//s_auth_type =  "/XecureDemo/jsp/test_response_a.jsp";
	s_auth_type =  "";

	var cipher = "";

	if (plain_text == "") return "";

	//cipher =  XecureUnescape(document.XecureWeb.BlockEnc(s_xgate_addr,s_auth_type,plain_text,"GET"));
	cipher = document.XecureWeb.BlockEnc(s_xgate_addr, s_auth_type, plain_text,"POST");

	/*
	cipher_begin_index = cipher.indexOf(';');
	
	if (cipher_begin_index < 0)
		cipher = "";
	else	
		cipher = cipher.substring(cipher_begin_index + 1, cipher.length );
	*/

	//alert(cipher);

	//alert(document.XecureWeb.GetSID());

	//if( cipher == "" ) alert("XecureWeb.BlockEnc error !!"); // XecureWebError() ;

	return cipher;
}

function gfDecrypt(cipher)
{
	///////////////////////////////////////////////////////////////////////////////////
	// xgate ���� ��:��Ʈ ���� , ��Ʈ ������ ����Ʈ�� 443 ��Ʈ ���
	var s_xgate_addr	= window.location.hostname + ":443:8080";
	//var xgate_addr	= "210.124.178.206" + ":8443:8001,8002,8003,8004,8005,8006,8007,8008,8009,8010,8011";

	var plain = "";

	if (cipher == "") return "";

	plain = document.XecureWeb.BlockDec( s_xgate_addr, cipher);

	//if( plain == "" ) alert("XecureWeb.BlockDec error !!");   //XecureWebError() ;

	return plain;
}

function gfGetSID()
{
	var s_xgate_addr	= window.location.hostname + ":443:8080";

	var sid =  document.XecureWeb.GetSID();

	if (sid == "") {
		sid = document.XecureWeb.BlockEnc( s_xgate_addr, "", "", "GET" );
	}

	return sid;
}