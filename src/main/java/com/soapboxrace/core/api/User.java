package com.soapboxrace.core.api;

import com.soapboxrace.core.api.util.BanUtil;
import com.soapboxrace.core.api.util.LauncherChecks;
import com.soapboxrace.core.api.util.Secured;
import com.soapboxrace.core.bo.AuthenticationBO;
import com.soapboxrace.core.bo.TokenSessionBO;
import com.soapboxrace.core.bo.UserBO;
import com.soapboxrace.core.jpa.BanEntity;
import com.soapboxrace.core.jpa.UserEntity;
import com.soapboxrace.jaxb.http.UserInfo;
import com.soapboxrace.jaxb.login.LoginStatusVO;

import javax.ejb.EJB;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.*;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

@Path("User")
public class User {

	@Context
	private HttpServletRequest sr;
	
	@EJB
	private AuthenticationBO authenticationBO;
	
	@EJB
	private UserBO userBO;

	@EJB
	private TokenSessionBO tokenBO;

	@POST
	@Secured
	@Path("GetPermanentSession")
	@Produces(MediaType.APPLICATION_XML)
	public Response getPermanentSession(@HeaderParam("securityToken") String securityToken, @HeaderParam("userId") Long userId) {
		UserEntity userEntity = tokenBO.getUser(securityToken);
		BanEntity ban = authenticationBO.checkUserBan(userEntity);
		
		if (ban != null && ban.stillApplies())
		{
			return Response
					.status(Response.Status.UNAUTHORIZED)
					.entity(BanUtil.getLoginStatus(ban))
					.build();
		}
		
		tokenBO.deleteByUserId(userId);
		String randomUUID = tokenBO.createToken(userId);
		UserInfo userInfo = userBO.getUserById(userId);
		userInfo.getUser().setSecurityToken(randomUUID);
		userBO.createXmppUser(userInfo);
		return Response
				.ok(userInfo)
				.build();
	}

	@POST
	@Secured
	@Path("SecureLoginPersona")
	@Produces(MediaType.APPLICATION_XML)
	public String secureLoginPersona(@HeaderParam("securityToken") String securityToken, @HeaderParam("userId") Long userId, @QueryParam("personaId") Long personaId) {
		tokenBO.setActivePersonaId(securityToken, personaId, false);
		userBO.secureLoginPersona(userId, personaId);
		return "";
	}

	@POST
	@Secured
	@Path("SecureLogoutPersona")
	@Produces(MediaType.APPLICATION_XML)
	public String secureLogoutPersona(@HeaderParam("securityToken") String securityToken, @HeaderParam("userId") Long userId, @QueryParam("personaId") Long personaId) {
		tokenBO.setActivePersonaId(securityToken, 0L, true);
		return "";
	}

	@POST
	@Secured
	@Path("SecureLogout")
	@Produces(MediaType.APPLICATION_XML)
	public String secureLogout() {
		return "";
	}

	@GET
	@Path("authenticateUser")
	@Produces(MediaType.APPLICATION_XML)
	@LauncherChecks
	public Response authenticateUser(@QueryParam("email") String email, @QueryParam("password") String password) {
		LoginStatusVO loginStatusVO = tokenBO.login(email, password, sr);
		if (loginStatusVO.isLoginOk()) {
			return Response.ok(loginStatusVO).build();
		}
		return Response.serverError().entity(loginStatusVO).build();
	}

	@GET
	@Path("createUser")
	@Produces(MediaType.APPLICATION_XML)
	@LauncherChecks
	public Response createUser(@QueryParam("email") String email, @QueryParam("password") String password, @QueryParam("inviteTicket") String inviteTicket) {
		LoginStatusVO loginStatusVO = userBO.createUserWithTicket(email, password, inviteTicket);
		if (loginStatusVO != null && loginStatusVO.isLoginOk()) {
			loginStatusVO = tokenBO.login(email, password, sr);
			return Response.ok(loginStatusVO).build();
		}
		return Response.serverError().entity(loginStatusVO).build();
	}

}
