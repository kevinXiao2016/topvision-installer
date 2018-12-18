/***********************************************************************
 * $Id: Version.java,v 1.1 2010-1-17 下午12:05:38 kelers Exp $
 * 
 * @author: kelers
 * 
 * (c)Copyright 2011-2010 kelers All rights reserved.
 ***********************************************************************/
package com.topvision.framework;

/**
 * @Create Date 2010-1-17 下午12:05:38
 * 
 * @author kelers
 * 
 */
@com.topvision.framework.annotation.Database(module = "framework", version = "1.0.1.0", date = "2012-11-12")
public class Version implements java.io.Serializable {
    private static final long serialVersionUID = -7803019126715257891L;
    private String buildTime = null;
    private String buildNumber = null;
    private String buildVersion = null;
    private String buildUser = null;

    public Version() {
        setBuildTime("@20110101-12:00:00@");
        setBuildVersion("@V100R001@");
        setBuildNumber("@B001@");
        setBuildUser("@Victor@");
    }

    /*
     * @see java.lang.Object#toString()
     */
    public String toString() {
        return new StringBuilder("V").append(getBuildVersion()).append("_B").append(getBuildNumber()).append("_D")
                .append(getBuildTime()).append(" by ").append(getBuildUser()).toString();
    }

    /**
     * @return the buildTime
     */
    public String getBuildTime() {
        return buildTime.replaceAll("@", "");
    }

    /**
     * @param buildTime
     *            the buildTime to set
     */
    public void setBuildTime(String buildTime) {
        this.buildTime = buildTime;
    }

    /**
     * @return the buildNumber
     */
    public String getBuildNumber() {
        return buildNumber.replaceAll("@", "");
    }

    /**
     * @param buildNumber
     *            the buildNumber to set
     */
    public void setBuildNumber(String buildNumber) {
        this.buildNumber = buildNumber;
    }

    /**
     * @return the buildVersion
     */
    public String getBuildVersion() {
        return buildVersion.replaceAll("@", "");
    }

    /**
     * @param buildVersion
     *            the buildVersion to set
     */
    public void setBuildVersion(String buildVersion) {
        this.buildVersion = buildVersion;
    }

    /**
     * @return the buildUser
     */
    public String getBuildUser() {
        return buildUser.replaceAll("@", "");
    }

    /**
     * @param buildUser
     *            the buildUser to set
     */
    public void setBuildUser(String buildUser) {
        this.buildUser = buildUser;
    }
}
