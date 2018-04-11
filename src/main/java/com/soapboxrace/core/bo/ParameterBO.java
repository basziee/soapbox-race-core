package com.soapboxrace.core.bo;

import com.soapboxrace.core.dao.ParameterDAO;
import com.soapboxrace.core.dao.TokenSessionDAO;
import com.soapboxrace.core.jpa.ParameterEntity;
import com.soapboxrace.core.jpa.TokenSessionEntity;

import javax.ejb.EJB;
import javax.ejb.Stateless;

@Stateless
public class ParameterBO {

	@EJB
	private ParameterDAO parameterDao;

	@EJB
	private TokenSessionDAO tokenDAO;

	private String getParameter(String name) {
		try {
			ParameterEntity findById = parameterDao.findById(name);
			return findById.getValue();
		} catch (Exception e) {
		}
		return null;
	}

	public int getMaxCarSlotsFree() {
		String parameter = getParameter("MAX_CAR_SLOTS_FREE");
		if (parameter != null) {
			return Integer.valueOf(parameter);
		}
		return 6;
	}

	public int getMaxCarSlotsPremium() {
		String parameter = getParameter("MAX_CAR_SLOTS_PREMIUM");
		if (parameter != null) {
			return Integer.valueOf(parameter);
		}
		return 30;
	}

	public int getStartingCash() {
		String parameter = getParameter("STARTING_CASH_AMOUNT");
		if (parameter != null) {
			return Integer.valueOf(parameter);
		}
		return 350_000;
	}
	
	public boolean getPremiumCarChangerProtection() {
		String parameter = getParameter("PREMIUM_CARCHANGER_PROTECTION");
		if (parameter != null) {
			return Boolean.valueOf(parameter);
		}
		return false;
	}

	public int getCarLimit(String securityToken) {
		TokenSessionEntity tokenSession = tokenDAO.findById(securityToken);
		if (tokenSession.isPremium()) {
			return getMaxCarSlotsPremium();
		}
		return getMaxCarSlotsFree();
	}
}
