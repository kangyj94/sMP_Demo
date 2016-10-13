<%@ page language="java" import="java.io.*,java.util.*,crosscert.*" %>
<%@ page contentType = "text/html; charset=euc-kr" %>

<%  
	/*-------------------------시작----------------------------*/ 
	response.setDateHeader("Expires",0); 
	response.setHeader("Prama","no-cache"); 

	if(request.getProtocol().equals("HTTP/1.1")) 
	{ 
		response.setHeader("Cache-Control","no-cache"); 
	} 
	/*------------------------- 끝----------------------------*/ 


	
	String signeddata = request.getParameter("signed_data");		// 서명된 값
	//String signeddata = "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";

			
	int nPrilen=0, nCertlen=0, nRet;
	
	Base64 CBase64 = new Base64();  
	nRet = CBase64.Decode(signeddata.getBytes("KSC5601"), signeddata.getBytes("KSC5601").length);
	if(nRet==0) 
	{
		out.println("서명값 Base64 Decode 결과 : 성공<br>") ;
	}
	else
	{
		out.println("서명값 Base64 Decode 결과 : 실패<br>") ;
		out.println("에러내용 : " + CBase64.errmessage + "<br>");
		out.println("에러코드 : " + CBase64.errcode + "<br>");
	}
		
	Verifier CVerifier = new Verifier();
	
	nRet=CVerifier.VerSignedData(CBase64.contentbuf, CBase64.contentlen); 

	
	if(nRet==0) 
	{
		String sOrgData = new String(CVerifier.contentbuf, "KSC5601");
		out.println("전자서명 검증 결과 : 성공<br>") ;
		out.println("원문 : " + sOrgData + "<br>");
	}
	else
	{
		out.println("전자서명 검증 결과 : 실패<br>") ;
		out.println("에러내용 : " + CVerifier.errmessage + "<br>");
		out.println("에러코드 : " + CVerifier.errcode + "<br>");
		return;
	}

	//인증서 정보 추출 결과	
	Certificate CCertificate = new Certificate();
	nRet=CCertificate.ExtractCertInfo(CVerifier.certbuf, CVerifier.certlen);
	if (nRet ==0)
	{
	
		out.println("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" + "<br>");

		out.print("version;          "+  CCertificate.version               + "<br>");
		out.print("serial;           "+  CCertificate.serial                + "<br>");
		out.print("issuer;           "+  CCertificate.issuer                + "<br>");
		out.print("subject;          "+  CCertificate.subject               + "<br>");
		out.print("subjectAlgId;     "+  CCertificate.subjectAlgId          + "<br>");
		out.print("from;             "+  CCertificate.from                  + "<br>");
		out.print("to;               "+  CCertificate.to                    + "<br>");
		out.print("signatureAlgId;   "+  CCertificate.signatureAlgId        + "<br>");
		out.print("pubkey;           "+  CCertificate.pubkey                + "<br>");
		out.print("signature;        "+  CCertificate.signature             + "<br>");
		out.print("issuerAltName;    "+  CCertificate.issuerAltName         + "<br>");
		out.print("subjectAltName;   "+  CCertificate.subjectAltName        + "<br>");
		out.print("keyusage;         "+  CCertificate.keyusage              + "<br>");
		out.print("policy;           "+  CCertificate.policy                + "<br>");
		out.print("basicConstraint;  "+  CCertificate.basicConstraint       + "<br>");
		out.print("policyConstraint; "+  CCertificate.policyConstraint      + "<br>");
		out.print("distributionPoint;"+  CCertificate.distributionPoint     + "<br>");
		out.print("authorityKeyId;   "+  CCertificate.authorityKeyId        + "<br>");
		out.print("subjectKeyId;     "+  CCertificate.subjectKeyId          + "<br>");

	}
	else
	{
		out.println("인증서 검증 결과 : 실패<br>") ;
		out.println("에러내용 : " + CCertificate.errmessage + "<br>");
		out.println("에러코드 : " + CCertificate.errcode + "<br>");
	}
		
                 
																 

	
	// 인증서 검증
	
	String Policies = "1.2.410.200004.5.4.1.1|1.2.410.200004.5.4.1.2|1.2.410.200004.5.4.1.7|1.2.410.200004.5.4.1.3|1.2.410.200004.5.4.1.4|1.2.410.200004.5.4.1.5|1.2.410.200004.5.2.1.1|1.2.410.200005.1.1.1|1.2.410.200012.1.1.3|1.2.410.200005.1.1.4|1.2.410.200005.1.1.5|1.2.410.200004.5.4.1.200|1.2.410.200004.5.1.1.7|1.2.410.200004.5.4.2.26|1.2.410.200004.5.4.2.31|";
	

	CCertificate.errmessage = "";

	nRet=CCertificate.ValidateCert(CVerifier.certbuf, CVerifier.certlen, Policies, 1);
	if(nRet==0) 
	{
		out.println("인증서 검증 결과 : 성공<br>") ;
	}
	else
	{
		out.println("인증서 검증 결과 : 실패<br>") ;
		out.println("에러내용 : " + CCertificate.errmessage + "<br>");
		out.println("에러코드 : " + CCertificate.errcode + "<br>");
		out.println("에러코드 : " + Integer.toHexString(CCertificate.errcode) + "<br>");
		out.println("에러내용 : " + CCertificate.errdetailmessage + "<br>");
	}
	
%>

<script language="javascript" src="../cc.js"></script>


<pre>
<font color = red>

=====================================================================================
 ** 소스 **
=====================================================================================

< % @ page language="java" import="java.io.*,java.util.*,<b><font size = 4>crosscert.*</font></b>" % >
< % @ page contentType = "text/html; charset=euc-kr" % >

< %  
	/*-------------------------시작----------------------------*/ 
	response.setDateHeader("Expires",0); 
	response.setHeader("Prama","no-cache"); 

	if(request.getProtocol().equals("HTTP/1.1")) 
	{ 
		response.setHeader("Cache-Control","no-cache"); 
	} 
	/*------------------------- 끝----------------------------*/ 


	
	String signeddata = request.getParameter("signed_data");		// 서명된 값
	String src = request.getParameter("src");		// 원문
		
	int nPrilen=0, nCertlen=0, nRet;
	
	Base64 CBase64 = new Base64();  
	nRet = CBase64.Decode(signeddata.getBytes("KSC5601"), signeddata.getBytes("KSC5601").length);
	
	//byte ccc[] = new byte[10];
	//nRet = CBase64.Decode(ccc, ccc.length);
	if(nRet==0) 
	{
		out.println("서명값 Base64 Decode 결과 : 성공< br>") ;
	}
	else
	{
		out.println("서명값 Base64 Decode 결과 : 실패< br>") ;
		out.println("에러내용 : " + CBase64.errmessage + "< br>");
		out.println("에러코드 : " + CBase64.errcode + "< br>");
	}
		
	Verifier CVerifier = new Verifier();
	
	nRet=CVerifier.VerSignedData(CBase64.contentbuf, CBase64.contentlen); 

	
	if(nRet==0) 
	{
		String sOrgData = new String(CVerifier.contentbuf, "KSC5601");
		out.println("전자서명 검증 결과 : 성공< br>") ;
		out.println("원문 : " + sOrgData + "< br>");
	}
	else
	{
		out.println("전자서명 검증 결과 : 실패< br>") ;
		out.println("에러내용 : " + CVerifier.errmessage + "< br>");
		out.println("에러코드 : " + CVerifier.errcode + "< br>");
		return;
	}

	//인증서 정보 추출 결과	
	Certificate CCertificate = new Certificate();
	//byte uuu[] = new byte[100];
	nRet=CCertificate.ExtractCertInfo(CVerifier.certbuf, CVerifier.certlen);
	//nRet=CCertificate.ExtractCertInfo(uuu, CVerifier.certlen);
	if (nRet ==0)
	{
	
		out.println("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++" + "< br>");

		out.print("version;          "+  CCertificate.version               + "< br>");
		out.print("serial;           "+  CCertificate.serial                + "< br>");
		out.print("issuer;           "+  CCertificate.issuer                + "< br>");
		out.print("subject;          "+  CCertificate.subject               + "< br>");
		out.print("subjectAlgId;     "+  CCertificate.subjectAlgId          + "< br>");
		out.print("from;             "+  CCertificate.from                  + "< br>");
		out.print("to;               "+  CCertificate.to                    + "< br>");
		out.print("signatureAlgId;   "+  CCertificate.signatureAlgId        + "< br>");
		out.print("pubkey;           "+  CCertificate.pubkey                + "< br>");
		out.print("signature;        "+  CCertificate.signature             + "< br>");
		out.print("issuerAltName;    "+  CCertificate.issuerAltName         + "< br>");
		out.print("subjectAltName;   "+  CCertificate.subjectAltName        + "< br>");
		out.print("keyusage;         "+  CCertificate.keyusage              + "< br>");
		out.print("policy;           "+  CCertificate.policy                + "< br>");
		out.print("basicConstraint;  "+  CCertificate.basicConstraint       + "< br>");
		out.print("policyConstraint; "+  CCertificate.policyConstraint      + "< br>");
		out.print("distributionPoint;"+  CCertificate.distributionPoint     + "< br>");
		out.print("authorityKeyId;   "+  CCertificate.authorityKeyId        + "< br>");
		out.print("subjectKeyId;     "+  CCertificate.subjectKeyId          + "< br>");

	}
	else
	{
		out.println("인증서 검증 결과 : 실패< br>") ;
		out.println("에러내용 : " + CCertificate.errmessage + "< br>");
		out.println("에러코드 : " + CCertificate.errcode + "< br>");
	}
		
                 
																 

	
	// 인증서 검증
	
	String Policies = "1.2.410.200004.5.4.1.1|1.2.410.200004.5.4.1.2|1.2.410.200004.5.4.1.7|1.2.410.200004.5.4.1.3|1.2.410.200004.5.4.1.4|1.2.410.200004.5.4.1.5|1.2.410.200004.5.2.1.1|1.2.410.200005.1.1.1|1.2.410.200012.1.1.3|1.2.410.200005.1.1.4|1.2.410.200005.1.1.5";
	

	CCertificate.errmessage = "";

	nRet=CCertificate.ValidateCert(CVerifier.certbuf, CVerifier.certlen, Policies, 1);


	
	if(nRet==0) 
	{
		out.println("인증서 검증 결과 : 성공< br>") ;
	}
	else
	{
		out.println("인증서 검증 결과 : 실패< br>") ;
		out.println("에러내용 : " + CCertificate.errmessage + "< br>");
		out.println("에러코드 : " + CCertificate.errcode + "< br>");
		out.println("에러코드 : " + Integer.toHexString(CCertificate.errcode) + "< br>");
	}
% >

</font>
</pre>