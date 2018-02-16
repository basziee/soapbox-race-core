package com.soapboxrace.core.api;

import javax.ejb.EJB;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import com.soapboxrace.core.api.util.Secured;
import com.soapboxrace.core.bo.ParameterBO;
import com.soapboxrace.core.bo.SessionBO;
import com.soapboxrace.jaxb.http.ChatServer;

@Path("/Session")
public class Session {

	@EJB
	private SessionBO bo;

	@EJB
	private ParameterBO parameterBO;

	@GET
	@Secured
	@Path("/GetChatInfo")
	@Produces(MediaType.APPLICATION_XML)
	public ChatServer getChatInfo() {
		ChatServer chatServer = new ChatServer();
		chatServer.setIp(parameterBO.getStrParam("XMPP_IP"));
		chatServer.setPort(parameterBO.getIntParam("XMPP_PORT"));
		chatServer.setPrefix("sbrw");
		chatServer.setRooms(bo.getAllChatRoom());
		return chatServer;
	}
}
