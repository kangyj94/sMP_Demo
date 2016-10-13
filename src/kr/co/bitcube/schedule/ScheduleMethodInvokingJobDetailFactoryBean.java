package kr.co.bitcube.schedule;

import javax.annotation.PostConstruct;

import org.apache.commons.beanutils.MethodUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Component;
import org.springframework.web.context.WebApplicationContext;

//@Component
public class ScheduleMethodInvokingJobDetailFactoryBean {

	@Autowired private WebApplicationContext context;
	private Logger logger = Logger.getLogger(this.getClass());

	@PostConstruct
	public void init() {
		try {
			logger.info("=================ScheduleMethodInvokingJobDetailFactoryBean Start===================");
			Object obj = context.getBean("scheduleController");
			MethodUtils.invokeMethod(obj, "pdtAutoComplete", null);
			MethodUtils.invokeMethod(obj, "admMainInfoSetup", null);
			logger.info("=================ScheduleMethodInvokingJobDetailFactoryBean End===================");
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
}