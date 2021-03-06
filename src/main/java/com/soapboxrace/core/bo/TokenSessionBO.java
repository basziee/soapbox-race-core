package com.soapboxrace.core.bo;

import com.soapboxrace.core.api.util.RequestUtil;
import com.soapboxrace.core.api.util.UUIDGen;
import com.soapboxrace.core.dao.TokenSessionDAO;
import com.soapboxrace.core.dao.UserDAO;
import com.soapboxrace.core.jpa.TokenSessionEntity;
import com.soapboxrace.core.jpa.UserEntity;
import com.soapboxrace.jaxb.login.LoginStatusVO;

import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.NotAuthorizedException;
import java.util.Date;

@Stateless
public class TokenSessionBO
{
    @EJB
    private TokenSessionDAO tokenDAO;

    @EJB
    private UserDAO userDAO;
    
    @EJB
    private ParameterBO parameterBO;

    public boolean verifyToken(Long userId, String securityToken)
    {
        TokenSessionEntity tokenSessionEntity = tokenDAO.findById(securityToken);
        if (tokenSessionEntity == null || !tokenSessionEntity.getUserId().equals(userId))
        {
            return false;
        }
        long time = new Date().getTime();
        long tokenTime = tokenSessionEntity.getExpirationDate().getTime();
        if (time > tokenTime)
        {
            return false;
        }
        tokenSessionEntity.setExpirationDate(getMinutes(3));
        tokenDAO.update(tokenSessionEntity);
        return true;
    }

    public void updateToken(String securityToken)
    {
        TokenSessionEntity tokenSessionEntity = tokenDAO.findById(securityToken);
        Date expirationDate = getMinutes(3);
        tokenSessionEntity.setExpirationDate(expirationDate);
        tokenDAO.update(tokenSessionEntity);
    }

    public String createToken(Long userId)
    {
        TokenSessionEntity tokenSessionEntity = new TokenSessionEntity();
        Date expirationDate = getMinutes(15);
        tokenSessionEntity.setExpirationDate(expirationDate);
        String randomUUID = UUIDGen.getRandomUUID();
        tokenSessionEntity.setSecurityToken(randomUUID);
        tokenSessionEntity.setUserId(userId);
        UserEntity userEntity = userDAO.findById(userId);
        tokenSessionEntity.setPremium(userEntity.isPremium());
        tokenDAO.insert(tokenSessionEntity);
        return randomUUID;
    }

    public boolean verifyPersona(String securityToken, Long personaId)
    {
        TokenSessionEntity tokenSession = tokenDAO.findById(securityToken);
        if (tokenSession == null)
        {
            throw new NotAuthorizedException("Invalid session...");
        }

        UserEntity user = userDAO.findById(tokenSession.getUserId());
        if (!user.ownsPersona(personaId))
        {
            throw new NotAuthorizedException("Persona is not owned by user");
        }
        return true;
    }

    public void deleteByUserId(Long userId)
    {
        tokenDAO.deleteByUserId(userId);
    }

    private Date getMinutes(int minutes)
    {
        long time = new Date().getTime();
        time = time + (minutes * 60000);
        return new Date(time);
    }

    public LoginStatusVO login(String email, String password, HttpServletRequest httpRequest)
    {
        LoginStatusVO loginStatusVO = new LoginStatusVO(0L, "", false);
        if (email != null && !email.isEmpty() && password != null && !password.isEmpty())
        {
            UserEntity userEntity = userDAO.findByEmail(email);
            if (userEntity != null)
            {
                if (password.equals(userEntity.getPassword()))
                {
                    if (userEntity.getIpAddress() == null || userEntity.getIpAddress().trim().isEmpty()) {
                        userEntity.setIpAddress(RequestUtil.getIp(httpRequest));
                        userDAO.update(userEntity);
                    }

                    Long userId = userEntity.getId();
                    deleteByUserId(userId);
                    String randomUUID = createToken(userId);
                    loginStatusVO = new LoginStatusVO(userId, randomUUID, true);
                    loginStatusVO.setDescription("");
                    
                    return loginStatusVO;
                }
            }
        }
        loginStatusVO.setDescription("LOGIN ERROR");
        return loginStatusVO;
    }

    public Long getActivePersonaId(String securityToken)
    {
        TokenSessionEntity tokenSessionEntity = tokenDAO.findById(securityToken);
        return tokenSessionEntity.getActivePersonaId();
    }

    public void setActivePersonaId(String securityToken, Long personaId, Boolean isLogout)
    {
        TokenSessionEntity tokenSessionEntity = tokenDAO.findById(securityToken);

        if (!isLogout)
        {
            if (!userDAO.findById(tokenSessionEntity.getUserId()).ownsPersona(personaId))
            {
                throw new NotAuthorizedException("Persona not owned by user");
            }
        }

        tokenSessionEntity.setActivePersonaId(personaId);
        tokenDAO.update(tokenSessionEntity);
    }

    public String getActiveRelayCryptoTicket(String securityToken)
    {
        TokenSessionEntity tokenSessionEntity = tokenDAO.findById(securityToken);
        return tokenSessionEntity.getRelayCryptoTicket();
    }

    public Long getActiveLobbyId(String securityToken)
    {
        TokenSessionEntity tokenSessionEntity = tokenDAO.findById(securityToken);
        return tokenSessionEntity.getActiveLobbyId();
    }

    public void setActiveLobbyId(String securityToken, Long lobbyId)
    {
        TokenSessionEntity tokenSessionEntity = tokenDAO.findById(securityToken);
        tokenSessionEntity.setActiveLobbyId(lobbyId);
        tokenDAO.update(tokenSessionEntity);
    }

    public boolean isPremium(String securityToken)
    {
        return tokenDAO.findById(securityToken).isPremium();
    }

    public boolean isAdmin(String securityToken)
    {
        return getUser(securityToken).isAdmin();
    }

    public UserEntity getUser(String securityToken)
    {
        return userDAO.findById(tokenDAO.findById(securityToken).getUserId());
    }
}
