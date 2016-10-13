<%@ page language="java" contentType="text/html; charset=utf-8" %>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=7" />
<!-- <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/> -->
<title>rexpreview</title>
<!-- script type="text/javascript" src="./rexscript/rexpert.js"></script>
<script type="text/javascript" src="./rexscript/rexpert_properties.js"></script -->

<script type="text/javascript" src="./rexscript/getscript.jsp?f=rexpert"></script>
<script type="text/javascript" src="./rexscript/getscript.jsp?f=rexpert_properties"></script>

<script type="text/javascript">

var goAgent = new rex_Agent();
var goOOF = null;
var goParamSet;
var gid = "";

var gaReports = new Array();
var gaReportsIndex = 0;
var gaReportsIndexTmp = 0;

var giTimerCnt = 0;
function init() {
	if ( goAgent.isWin ) {
		try {
			var sVer = RexCtl.GetVersion();

			OnLoad();
		} catch(ex) {
			if (goAgent.isSF) {
				giTimerCnt++;

				if (giTimerCnt < 50 )
				{
					setTimeout(init, 600);
				} else {
					alert("initial timeout.(safari plug-in bug)");
					return;
				}
			}

			return;
		}
	} else {
		setTimeout(OnLoad, 600);
	}
}

function OnLoad()
{
	gid = "";

	var sParam = window.location.search;
	sParam = sParam.substr(1);
	var aParam = sParam.split("=");

	gid = aParam[1];

	var oOOF;

	if ( opener != undefined )	{
		oOOF = opener.rex_goParamSet[gid];
		goParamSet = opener.rex_goParamSet;
	} else if(parent.rex_goParamSet[gid] != undefined)	{
		oOOF = parent.rex_goParamSet[gid];
		goParamSet = parent.rex_goParamSet;
	} else if(window.dialogArguments != undefined) {
		oOOF = window.dialogArguments.rex_goParamSet[gid];
		goParamSet = window.dialogArguments.rex_goParamSet;
	}

	if (oOOF == null) return;
	if (goParamSet == null) return;

	for(var vParam in goParamSet)
	{
		gaReports.push(goParamSet[vParam]);
	}

	goOOF = oOOF;

	if (oOOF.opentype == "export") {
		ExportServer();
	} else {
		if ( (goAgent.isWin || goAgent.isIE) ) {
			var printoption = oOOF.printoption;
			var exportoption = oOOF.exportoption;
			var toolbarbuttonoption = oOOF.toolbarbuttonoption;

			if(printoption != null) {
				rex_fnPrintSetting(RexCtl,printoption);
			} 

			if(exportoption != null) {
				rex_fnExportVisible(RexCtl, exportoption);
			}

			if(toolbarbuttonoption != null) {
				rex_fnToolBarButtonEnableTrue(RexCtl,toolbarbuttonoption);
			}

			if (gid == "rex_toc") {
				fnOpenToc();
			} else {
				fnOpen(oOOF);
			}
		} else {
			// Mac, Linux, Others
			rex_ifrmRexPreview.location.href = "./hero/client/rexpreview_html5.jsp";
			return;
		}
	} //end if
}

function fnOpen(oOOF)
{
	try {
		//var sVer = RexCtl.GetVersion();

		if(typeof(rex_gsCss) != "undefined") {
			for(var i = 0; i < rex_gsCss.length; i++) {
				alert(rex_gsCss[i]);
				RexCtl.SetCSS(rex_gsCss[i]);
			}

			//RexCtl.UpdateCSS();
		}

		RexCtl.SetCSS("license.server.path=" + rex_gsRexServiceRootURL + "license.jsp");
		RexCtl.UpdateCSS();
	} catch(ex) {
		return;
	}

	if (goOOF.event.init != undefined) {
		goOOF.event.init(RexCtl, "init", null);
	}

	if (oOOF.opentype == "open" || oOOF.opentype == "openmodal") {
		RexCtl.OpenOOF(oOOF.toString());
	} else if (oOOF.opentype == "iframe") {
		RexCtl.OpenOOF(oOOF.toString());
	} else if (oOOF.opentype == "print") {
		RexCtl.OpenOOF(oOOF.toString());
		//RexCtl.Print(false, 1,-1,1,"");
	} else if (oOOF.opentype == "printdirect") {
		RexCtl.OpenOOF(oOOF.toString());
		//RexCtl.PrintDirect("HP LaserJet 3050" , 260, 1, -1, 1, "");
	} else if (oOOF.opentype == "save") {
		RexCtl.OpenOOF(oOOF.toString());
		//RexCtl.Export(false, "pdf", "c:\\test.pdf", 1,-1,"");
	}
}

function fnOpenToc()
{
	try {
		//var sVer = RexCtl.GetVersion();

		if(typeof(rex_gsCss) != "undefined") {
			for(var i = 0; i < rex_gsCss.length; i++) {
				RexCtl.SetCSS(rex_gsCss[i]);
			}

			//RexCtl.UpdateCSS();
		}

		RexCtl.SetCSS("license.server.path=" + rex_gsRexServiceRootURL + "license.jsp");
		RexCtl.UpdateCSS();
	} catch(ex) {
		return;
	}

	if (goOOF.event.init != undefined) {
		goOOF.event.init(RexCtl, "init", null);
	}

	gaReportsIndexTmp = gaReports.length;

	fnOpenTocSub("", "", "");
}

function fnOpenTocSub(oRexCtl, sEvent, oArgs) {
	var oReport;

	if(gaReports.length > 0 && gaReports.length > gaReportsIndex)
	{
		oReport = gaReports[gaReportsIndex];

		oReport.event.finishdocument = fnOpenTocSub;

		RexCtl.OpenOOF(oReport.toString());

		gaReportsIndex++;
	} else {
		//
	}
}

function OnFinishDocument()
{
	try {
		if(typeof(rex_gsMethod) != "undefined") {
			for(var i = 0; i < rex_gsMethod.length; i++) {
				eval("RexCtl." + rex_gsMethod[i]);
			}
		}
	} catch(ex) { }

	gaReportsIndexTmp = gaReportsIndexTmp - 1;

	if (gid == "rex_toc") {
		if (goOOF.event.finishdocument != undefined) {

			goOOF.event.finishdocument(RexCtl, "finishdocument", null);
		}

		if (gaReports.length <= gaReportsIndex && gaReportsIndexTmp == 0) {

			if (goOOF.opentype == "save") {
				//RexCtl.Export(goOOF.save.dialog, goOOF.save.filetype,  goOOF.save.fileName, 
				//			goOOF.save.startpage, goOOF.save.endpage, goOOF.save.Option);

				setTimeout(fnTimerExport, 100);
				
				if (!goAgent.isIE) {
					//window.close();	
				}
			} else if (goOOF.opentype == "print") {
				//RexCtl.Print(goOOF.print.dialog, goOOF.print.startpage, goOOF.print.endpage, 
				//			goOOF.print.copycount, goOOF.print.Option);
				
				setTimeout(fnTimerPrint, 100);

				if (!goAgent.isIE) {
					//window.close();	
				}
			} else if (goOOF.opentype == "printdirect") {
				//RexCtl.PrintDirect(goOOF.print.printname, goOOF.print.trayid, goOOF.print.startpage, goOOF.print.endpage, 
				//			goOOF.print.copycount, goOOF.print.Option);

				setTimeout(fnTimerPrintDirect, 100);
				
				if (!goAgent.isIE) {
					//window.close();	
				}
			} else if (goOOF.opentype == "export") {
				if (!goAgent.isIE) {
					window.close();	
				}
			}
			
			if (goOOF.autorefeshtime != undefined) {
				window.setTimeout("RexCtl.Refresh();", goOOF.autorefeshtime * 1000);
			}
		}
	} else {
		if (goOOF.event.finishdocument != undefined) {
			goOOF.event.finishdocument(RexCtl, "finishdocument", null);
		}

		if (goOOF.opentype == "save") {
			//RexCtl.Export(goOOF.save.dialog, goOOF.save.filetype,  goOOF.save.fileName, 
			//			goOOF.save.startpage, goOOF.save.endpage, goOOF.save.Option);

			setTimeout(fnTimerExport, 100);

			if (!goAgent.isIE) {
				//window.close();	
			}
		} else if (goOOF.opentype == "print") {
			//RexCtl.Print(goOOF.print.dialog, goOOF.print.startpage, goOOF.print.endpage, 
			//			goOOF.print.copycount, goOOF.print.Option);

			setTimeout(fnTimerPrint, 100);

			if (!goAgent.isIE) {
				//window.close();	
			}
		} else if (goOOF.opentype == "printdirect") {
			//RexCtl.PrintDirect(goOOF.print.printname, goOOF.print.trayid, goOOF.print.startpage, goOOF.print.endpage, 
			//			goOOF.print.copycount, goOOF.print.Option);

			setTimeout(fnTimerPrintDirect, 100);

			if (!goAgent.isIE) {
				//window.close();	
			}
		} else if (goOOF.opentype == "export") {
			if (!goAgent.isIE) {
				window.close();	
			}
		}

		if (goOOF.autorefeshtime != undefined) {
			window.setTimeout("RexCtl.Refresh();", goOOF.autorefeshtime * 1000);
		}
	}
}

function OnFinishPrint()
{
	if (goOOF.event.finishprint != undefined) {
		goOOF.event.finishprint(RexCtl, "finishprint", null);
	}
}

function OnFinishExport(filename)
{
	if (goOOF.event.finishexport != undefined) {
		goOOF.event.finishexport(RexCtl, "finishexport", {"filename": filename});
	}
}

function MakeHyperLinkClickedArg(sPath) {
	return {"Path": sPath};
}



function OnButtonPrintClickBefore(Cancel)
{
	if (goOOF.event.buttonprintclickbefore != undefined) {
		goOOF.event.buttonprintclickbefore(RexCtl, "buttonprintclickbefore", null);
	}	
}

function OnButtonPrintClickAfter()
{
	if (goOOF.event.buttonprintclickafter != undefined) {
		goOOF.event.buttonprintclickafter(RexCtl, "buttonprintclickafter", null);
	}		
}

function OnButtonExportClickBefore(Cancel)
{
	if (goOOF.event.buttonexportclickbefore != undefined) {
		goOOF.event.buttonexportclickbefore(RexCtl, "buttonexportclickbefore", null);
	}	
}

function OnButtonExportClickAfter()
{
	if (goOOF.event.buttonexportclickafter != undefined) {
		goOOF.event.buttonexportclickafter(RexCtl, "buttonexportclickafter", null);
	}	
}

function OnButtonRefreshClickBefore(Cancel)
{
	if (goOOF.event.buttonrefreshclickbefore != undefined) {
		goOOF.event.buttonrefreshclickbefore(RexCtl, "buttonrefreshclickbefore", null);
	}		
}

function OnButtonRefreshClickAfter()
{
	if (goOOF.event.buttonrefreshclickafter != undefined) {
		goOOF.event.buttonrefreshclickafter(RexCtl, "buttonrefreshclickafter", null);
	}	
}

function OnButtonExportXLSClickBefore(Cancel)
{
	if (goOOF.event.buttonexportxlsclickbefore != undefined) {
		goOOF.event.buttonexportxlsclickbefore(RexCtl, "buttonexportxlsclickbefore", null);
	}	
}

function OnButtonExportXLSClickAfter()
{
	if (goOOF.event.buttonexportxlsclickafter != undefined) {
		goOOF.event.buttonexportxlsclickafter(RexCtl, "buttonexportxlsclickafter", null);
	}	
}

function OnButtonExportPDFClickBefore(Cancel)
{
	if (goOOF.event.buttonexportpdfclickbefore != undefined) {
		goOOF.event.buttonexportpdfclickbefore(RexCtl, "buttonexportpdfclickbefore", null);
	}	
}

function OnButtonExportPDFClickAfter()
{
	if (goOOF.event.buttonexportpdfclickafter != undefined) {
		goOOF.event.buttonexportpdfclickafter(RexCtl, "buttonexportpdfclickafter", null);
	}	
}

function OnButtonExportHWPClickBefore(Cancel)
{
	if (goOOF.event.buttonexporthwpclickbefore != undefined) {
		goOOF.event.buttonexporthwpclickbefore(RexCtl, "buttonexporthwpclickbefore", null);
	}		
}

function OnButtonExportHWPClickAfter()
{
	if (goOOF.event.buttonexporthwpclickafter != undefined) {
		goOOF.event.buttonexporthwpclickafter(RexCtl, "buttonexporthwpclickafter", null);
	}	
}

function OnCancelPrint(Cancel)
{
	if (goOOF.event.cancelprint != undefined) {
		goOOF.event.cancelprint(RexCtl, "cancelprint", null);
	}	
}

function OnButtonCloseWindowClickBefore(Cancel)
{
	if (goOOF.event.buttonclosewindowclickbefore != undefined) {
		goOOF.event.buttonclosewindowclickbefore(RexCtl, "buttonclosewindowclickbefore", null);
	}	
}

function OnButtonCloseWindowClickAfter()
{
	if (goOOF.event.buttonclosewindowclickafter != undefined) {
		goOOF.event.buttonclosewindowclickafter(RexCtl, "buttonclosewindowclickafter", null);
	}		
}

function OnPrintPage(totalpage, page)
{
	//alert("--OnPrintPage" + "  totalpage:" + totalpage + "   page:" + page);
	if (goOOF.event.printpage != undefined) {
		goOOF.event.printpage(RexCtl, "printpage", {"totalpage": totalpage, "page" : page});
	}	
}

function OnRexpertError(name, description)
{
	//alert("--OnRexpertError" + "  name:" + name + "   description:" + description);
	if (goOOF.event.rexperterror != undefined) {
		goOOF.event.rexperterror(RexCtl, "rexperterror", {"name": name, "description" : description});
	}
}

function OnCancelExport()
{
	if (goOOF.event.cancelexport != undefined) {
		goOOF.event.cancelexport(RexCtl, "cancelexport", null);
	}	
}

function OnFinishPrintResult(resultcode)
{
	if (goOOF.event.finishprintresult != undefined) {
		goOOF.event.finishprintresult(RexCtl, "finishprintresult", {"resultcode": resultcode });
	}	
}



function ExportServer() {
	var oAjax = rex_GetgoAjax();

	oAjax.Path = rex_gsRptExportURL;
	oAjax.Open();

	oAjax.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");		

	oAjax.AddParameter("oof", goOOF.toString());
	oAjax.AddParameter("filename", goOOF.exportservice.filename);
	oAjax.AddParameter("filetype", goOOF.exportservice.filetype);
	oAjax.AddParameter("afterjob", goOOF.exportservice.afterjob);

	oAjax.Send();

	var sRtn = oAjax.Response();

	if (goOOF.event.finishexportserver != undefined) {
		goOOF.event.finishexportserver(RexCtl, "finishexportserver", {"returnval": sRtn});
	}
}

function OnFinishPrintResult(ResultCode)
{
	if (goOOF.event.finishprintresult != undefined) {
		goOOF.event.finishprintresult(RexCtl, "finishprintresult", {"resultcode": ResultCode});
	}
}

function fnTimerExport()
{
	RexCtl.Export(goOOF.save.dialog, goOOF.save.filetype,  goOOF.save.fileName, 
			goOOF.save.startpage, goOOF.save.endpage, goOOF.save.Option);
}

function fnTimerPrint()
{
	RexCtl.Print(goOOF.print.dialog, goOOF.print.startpage, goOOF.print.endpage, 
			goOOF.print.copycount, goOOF.print.Option);
}

function fnTimerPrintDirect()
{
	RexCtl.PrintDirect(goOOF.print.printname, goOOF.print.trayid, goOOF.print.startpage, goOOF.print.endpage, 
			goOOF.print.copycount, goOOF.print.Option);
}

</script>

</head>
<body onload="init();"  style="margin:0 0 0 0;width:100%;height:100%" scroll="no">
<form id="frmExportService"  name="frmExportService" method="post" style="display:none" action="">
	<input type="hidden" name="oof"/>
	<input type="hidden" name="filename"/>
	<input type="hidden" name="filetype"/>
</form>
<script type="text/javascript">
	rex_writeRexCtl("RexCtl");
</script>
</body>
</html>