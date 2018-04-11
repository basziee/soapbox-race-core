package com.soapboxrace.core.bo;

import javax.ejb.EJB;
import javax.ejb.Stateless;

import com.soapboxrace.core.dao.BanDAO;
import com.soapboxrace.core.jpa.BanEntity;
import com.soapboxrace.core.jpa.UserEntity;

@Stateless
public class AuthenticationBO
{
    @EJB
    private BanDAO banDAO;

    public BanEntity checkUserBan(UserEntity userEntity)
    {
        return banDAO.findByUser(userEntity);
    }

    public BanEntity checkNonUserBan(String ip, String email)
    {
        BanEntity banEntity;
        if ((banEntity = banDAO.findByIp(ip)) != null)
            return banEntity;
        else if ((banEntity = banDAO.findByEmail(email)) != null)
            return banEntity;
        return null;
    }
}
