package com.agileai.hr.module.system.exteral;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebService;

@WebService(serviceName="HelloWorld",portName="HelloWorldPort")
public interface HelloWorld {
	@WebMethod
	public String sayHi(@WebParam(name="theGirlName") String theGirlName);
}
