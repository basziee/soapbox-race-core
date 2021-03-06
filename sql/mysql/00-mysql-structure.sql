CREATE DATABASE IF NOT EXISTS `SOAPBOX` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE UTF8_UNICODE_CI;
DROP USER IF EXISTS 'soapbox'@'localhost';
CREATE USER 'soapbox'@'localhost' IDENTIFIED BY 'soapbox';
GRANT ALL ON SOAPBOX.* TO 'soapbox'@'localhost' WITH GRANT OPTION;
CREATE TABLE IF NOT EXISTS
    SOAPBOX.BASKETDEFINITION
    (
        productId VARCHAR(255) COLLATE utf8_unicode_ci NOT NULL,
        ownedCarTrans longtext COLLATE utf8_unicode_ci,
        PRIMARY KEY (productId)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS
    SOAPBOX.CARSLOT
    (
        id bigint NOT NULL AUTO_INCREMENT,
        ownedCarTrans longtext COLLATE utf8_unicode_ci,
        PersonaId bigint,
        PRIMARY KEY (id),
        INDEX FK_CARSLOT_PERSONA (PersonaId)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS
    SOAPBOX.CATEGORY
    (
        idcategory bigint NOT NULL AUTO_INCREMENT,
        catalogVersion VARCHAR(255) COLLATE utf8_unicode_ci,
        categories VARCHAR(255) COLLATE utf8_unicode_ci,
        displayName VARCHAR(255) COLLATE utf8_unicode_ci,
        filterType INT,
        icon VARCHAR(255) COLLATE utf8_unicode_ci,
        id bigint,
        longDescription VARCHAR(255) COLLATE utf8_unicode_ci,
        name VARCHAR(255) COLLATE utf8_unicode_ci,
        priority SMALLINT,
        shortDescription VARCHAR(255) COLLATE utf8_unicode_ci,
        showInNavigationPane bit,
        showPromoPage bit,
        webIcon VARCHAR(255) COLLATE utf8_unicode_ci,
        PRIMARY KEY (idcategory)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS
    SOAPBOX.CHAT_ROOM
    (
        ID bigint NOT NULL AUTO_INCREMENT,
        amount INT,
        longName VARCHAR(255) COLLATE utf8_unicode_ci,
        shortName VARCHAR(255) COLLATE utf8_unicode_ci,
        PRIMARY KEY (ID)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS
    SOAPBOX.EVENT
    (
        ID INT NOT NULL AUTO_INCREMENT,
        eventModeId INT NOT NULL,
        isEnabled bit NOT NULL,
        isLocked bit NOT NULL,
        maxCarClassRating INT NOT NULL,
        maxLevel INT NOT NULL,
        minCarClassRating INT NOT NULL,
        minLevel INT NOT NULL,
        name VARCHAR(255) COLLATE utf8_unicode_ci,
        PRIMARY KEY (ID)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS
    SOAPBOX.EVENT_DATA
    (
        ID bigint NOT NULL AUTO_INCREMENT,
        alternateEventDurationInMilliseconds bigint NOT NULL,
        bestLapDurationInMilliseconds bigint NOT NULL,
        bustedCount INT NOT NULL,
        carId bigint NOT NULL,
        copsDeployed INT NOT NULL,
        copsDisabled INT NOT NULL,
        copsRammed INT NOT NULL,
        costToState INT NOT NULL,
        distanceToFinish FLOAT NOT NULL,
        eventDurationInMilliseconds bigint NOT NULL,
        eventModeId INT NOT NULL,
        eventSessionId bigint,
        finishReason INT NOT NULL,
        fractionCompleted FLOAT NOT NULL,
        hacksDetected bigint NOT NULL,
        heat FLOAT NOT NULL,
        infractions INT NOT NULL,
        longestJumpDurationInMilliseconds bigint NOT NULL,
        numberOfCollisions INT NOT NULL,
        perfectStart INT NOT NULL,
        personaId bigint,
        rank INT NOT NULL,
        roadBlocksDodged INT NOT NULL,
        spikeStripsDodged INT NOT NULL,
        sumOfJumpsDurationInMilliseconds bigint NOT NULL,
        topSpeed FLOAT NOT NULL,
        EVENTID INT,
        PRIMARY KEY (ID),
        INDEX FK_EVENTDATA_EVENT (EVENTID)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS
    SOAPBOX.EVENT_SESSION
    (
        ID bigint NOT NULL AUTO_INCREMENT,
        EVENTID INT,
        PRIMARY KEY (ID),
        INDEX FK_EVENTSESSION_EVENT (EVENTID)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS
    SOAPBOX.INVITE_TICKET
    (
        ID bigint NOT NULL AUTO_INCREMENT,
        DISCORD_NAME VARCHAR(255) COLLATE utf8_unicode_ci,
        TICKET VARCHAR(255) COLLATE utf8_unicode_ci,
        USERID bigint,
        PRIMARY KEY (ID),
        INDEX FK_INVITETICKET_USER (USERID)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS
    SOAPBOX.LEVEL_REP
    (
        level bigint NOT NULL AUTO_INCREMENT,
        expPoint bigint,
        PRIMARY KEY (level)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS
    SOAPBOX.LOBBY
    (
        ID bigint NOT NULL AUTO_INCREMENT,
        isPrivate bit,
        lobbyDateTimeStart DATETIME,
        personaId bigint,
        EVENTID INT,
        PRIMARY KEY (ID),
        INDEX FK_LOBBY_EVENT (EVENTID)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS
    SOAPBOX.LOBBY_ENTRANT
    (
        id bigint NOT NULL AUTO_INCREMENT,
        gridIndex INT NOT NULL,
        LOBBYID bigint,
        PERSONAID bigint,
        PRIMARY KEY (id),
        INDEX FK_LOBBYENTRANT_LOBBY (LOBBYID),
        INDEX FK_LOBBYENTRANT_PERSONA (PERSONAID)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS
    SOAPBOX.LOGIN_ANNOUCEMENT
    (
        id INT NOT NULL AUTO_INCREMENT,
        imageUrl VARCHAR(255) COLLATE utf8_unicode_ci,
        target VARCHAR(255) COLLATE utf8_unicode_ci,
        type VARCHAR(255) COLLATE utf8_unicode_ci,
        PRIMARY KEY (id)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS
    SOAPBOX.ONLINE_USERS
    (
        ID INT NOT NULL,
        numberOfUsers INT NOT NULL,
        PRIMARY KEY (ID)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS
    SOAPBOX.PERSONA
    (
        ID bigint NOT NULL AUTO_INCREMENT,
        boost DOUBLE NOT NULL,
        cash DOUBLE NOT NULL,
        curCarIndex INT NOT NULL,
        iconIndex INT NOT NULL,
        level INT NOT NULL,
        motto VARCHAR(255) COLLATE utf8_unicode_ci,
        name VARCHAR(255) COLLATE utf8_unicode_ci,
        percentToLevel FLOAT NOT NULL,
        rating DOUBLE NOT NULL,
        rep DOUBLE NOT NULL,
        repAtCurrentLevel INT NOT NULL,
        score INT NOT NULL,
        USERID bigint,
        PRIMARY KEY (ID),
        INDEX FK_PERSONA_USER (USERID)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS
    SOAPBOX.PRODUCT
    (
        id bigint NOT NULL AUTO_INCREMENT,
        bundleItems VARCHAR(255) COLLATE utf8_unicode_ci,
        categoryId VARCHAR(255) COLLATE utf8_unicode_ci,
        categoryName VARCHAR(255) COLLATE utf8_unicode_ci,
        currency VARCHAR(255) COLLATE utf8_unicode_ci,
        description VARCHAR(255) COLLATE utf8_unicode_ci,
        durationMinute INT NOT NULL,
        enabled bit NOT NULL,
        hash bigint,
        icon VARCHAR(255) COLLATE utf8_unicode_ci,
        level INT NOT NULL,
        longDescription VARCHAR(255) COLLATE utf8_unicode_ci,
        minLevel INT NOT NULL,
        premium bit NOT NULL DEFAULT FALSE,
        price FLOAT NOT NULL,
        priority INT NOT NULL,
        productId VARCHAR(255) COLLATE utf8_unicode_ci,
        productTitle VARCHAR(255) COLLATE utf8_unicode_ci,
        productType VARCHAR(255) COLLATE utf8_unicode_ci,
        secondaryIcon VARCHAR(255) COLLATE utf8_unicode_ci,
        useCount INT NOT NULL,
        visualStyle VARCHAR(255) COLLATE utf8_unicode_ci,
        webIcon VARCHAR(255) COLLATE utf8_unicode_ci,
        webLocation VARCHAR(255) COLLATE utf8_unicode_ci,
        isDropable bit NOT NULL DEFAULT TRUE,
        PRIMARY KEY (id)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS
    SOAPBOX.RECOVERY_PASSWORD
    (
        id bigint NOT NULL AUTO_INCREMENT,
        expirationDate DATETIME,
        isClose bit,
        randomKey VARCHAR(255) COLLATE utf8_unicode_ci,
        userId bigint,
        PRIMARY KEY (id)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS
    SOAPBOX.REPORT
    (
        id bigint NOT NULL AUTO_INCREMENT,
        abuserPersonaId bigint,
        chatMinutes INT,
        customCarID INT,
        description VARCHAR(255) COLLATE utf8_unicode_ci,
        hacksdetected bigint,
        personaId bigint,
        petitionType INT,
        PRIMARY KEY (id)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS
    SOAPBOX.SERVER_INFO
    (
        messageSrv VARCHAR(1000) COLLATE utf8_unicode_ci NOT NULL,
        country VARCHAR(255) COLLATE utf8_unicode_ci,
        adminList VARCHAR(255) COLLATE utf8_unicode_ci,
        bannerUrl VARCHAR(255) COLLATE utf8_unicode_ci,
        discordUrl VARCHAR(255) COLLATE utf8_unicode_ci,
        facebookUrl VARCHAR(255) COLLATE utf8_unicode_ci,
        homePageUrl VARCHAR(255) COLLATE utf8_unicode_ci,
        numberOfRegistered INT,
        ownerList VARCHAR(255) COLLATE utf8_unicode_ci,
        serverName VARCHAR(255) COLLATE utf8_unicode_ci,
        timezone INT,
        PRIMARY KEY (serverName)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS
    SOAPBOX.TOKEN_SESSION
    (
        ID VARCHAR(255) COLLATE utf8_unicode_ci NOT NULL,
        activeLobbyId bigint,
        activePersonaId bigint,
        expirationDate DATETIME,
        premium bit NOT NULL DEFAULT FALSE,
        relayCryptoTicket VARCHAR(255) COLLATE utf8_unicode_ci,
        userId bigint,
        PRIMARY KEY (ID)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS
    SOAPBOX.USER
    (
        ID bigint NOT NULL AUTO_INCREMENT,
        EMAIL VARCHAR(255) COLLATE utf8_unicode_ci,
        PASSWORD VARCHAR(50) COLLATE utf8_unicode_ci,
        premium bit NOT NULL DEFAULT FALSE,
        PRIMARY KEY (ID)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS
    SOAPBOX.VINYLPRODUCT
    (
        id bigint NOT NULL AUTO_INCREMENT,
        bundleItems VARCHAR(255) COLLATE utf8_unicode_ci,
        categoryId VARCHAR(255) COLLATE utf8_unicode_ci,
        categoryName VARCHAR(255) COLLATE utf8_unicode_ci,
        currency VARCHAR(255) COLLATE utf8_unicode_ci,
        description VARCHAR(255) COLLATE utf8_unicode_ci,
        durationMinute INT NOT NULL,
        enabled bit NOT NULL,
        hash bigint NOT NULL,
        icon VARCHAR(255) COLLATE utf8_unicode_ci,
        level INT NOT NULL,
        longDescription VARCHAR(255) COLLATE utf8_unicode_ci,
        minLevel INT NOT NULL,
        premium bit NOT NULL DEFAULT FALSE,
        price FLOAT NOT NULL,
        priority INT NOT NULL,
        productId VARCHAR(255) COLLATE utf8_unicode_ci,
        productTitle VARCHAR(255) COLLATE utf8_unicode_ci,
        productType VARCHAR(255) COLLATE utf8_unicode_ci,
        secondaryIcon VARCHAR(255) COLLATE utf8_unicode_ci,
        useCount INT NOT NULL,
        visualStyle VARCHAR(255) COLLATE utf8_unicode_ci,
        webIcon VARCHAR(255) COLLATE utf8_unicode_ci,
        webLocation VARCHAR(255) COLLATE utf8_unicode_ci,
        parentCategoryId bigint,
        PRIMARY KEY (id),
        INDEX FK_VINYLPRODUCT_CATEGORY (parentCategoryId)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE IF NOT EXISTS
    SOAPBOX.PROMO_CODE
    (
        id bigint NOT NULL AUTO_INCREMENT,
        isUsed bit,
        promoCode VARCHAR(255),
        USERID bigint,
        PRIMARY KEY (id),
        INDEX FK_PROMOCODE_USER (UserId)
    )
    ENGINE=InnoDB DEFAULT CHARSET=utf8;
ALTER TABLE
    SOAPBOX.CARSLOT ADD CONSTRAINT FK_CARSLOT_PERSONA FOREIGN KEY (PersonaId) REFERENCES
    SOAPBOX.PERSONA (ID);
ALTER TABLE
    SOAPBOX.EVENT_DATA ADD CONSTRAINT FK_EVENTDATA_EVENT FOREIGN KEY (EVENTID) REFERENCES
    SOAPBOX.EVENT (ID);
ALTER TABLE
    SOAPBOX.EVENT_SESSION ADD CONSTRAINT FK_EVENTSESSION_EVENT FOREIGN KEY (EVENTID) REFERENCES
    SOAPBOX.EVENT (ID);
ALTER TABLE
    SOAPBOX.INVITE_TICKET ADD CONSTRAINT FK_INVITETICKET_USER FOREIGN KEY (USERID) REFERENCES
    SOAPBOX.USER (ID);
ALTER TABLE
    SOAPBOX.LOBBY ADD CONSTRAINT FK_LOBBY_EVENT FOREIGN KEY (EVENTID) REFERENCES
    SOAPBOX.EVENT (ID);
ALTER TABLE
    SOAPBOX.LOBBY_ENTRANT ADD CONSTRAINT FK_LOBBYENTRANT_LOBBY FOREIGN KEY (LOBBYID) REFERENCES
    SOAPBOX.LOBBY (ID) ;
ALTER TABLE
    SOAPBOX.LOBBY_ENTRANT ADD CONSTRAINT FK_LOBBYENTRANT_PERSONA FOREIGN KEY (PERSONAID)
    REFERENCES SOAPBOX.PERSONA (ID);
ALTER TABLE
    SOAPBOX.PERSONA ADD CONSTRAINT FK_PERSONA_USER FOREIGN KEY (USERID) REFERENCES
    SOAPBOX.USER (ID);
ALTER TABLE
    SOAPBOX.VINYLPRODUCT ADD CONSTRAINT FK_VINYLPRODUCT_CATEGORY FOREIGN KEY (parentCategoryId)
    REFERENCES SOAPBOX.CATEGORY (idcategory);
ALTER TABLE
    SOAPBOX.PROMO_CODE ADD CONSTRAINT FK_PROMOCODE_USER FOREIGN KEY (USERID) REFERENCES SOAPBOX.USER (ID);
ALTER TABLE
    SOAPBOX.SERVER_INFO ADD COLUMN activatedHolidaySceneryGroups TEXT NOT NULL;
ALTER TABLE
    SOAPBOX.SERVER_INFO ADD COLUMN disactivatedHolidaySceneryGroups TEXT NOT NULL;
    
ALTER TABLE SOAPBOX.PERSONA AUTO_INCREMENT=100;