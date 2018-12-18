/***********************************************************************
 * $Id: Setting.java,v 1.1 2010-1-17 下午03:23:11 kelers Exp $
 * 
 * @author: kelers
 * 
 * (c)Copyright 2011 Topoview All rights reserved.
 ***********************************************************************/
package com.topvision.framework.annotation;

import java.lang.annotation.Inherited;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

/**
 * @Create Date 2010-1-17 下午03:23:11
 * 
 * @author kelers
 * 
 */
@Retention(RetentionPolicy.RUNTIME)
@Inherited
public @interface Database {
    String date();

    String module() default "ems";

    String version();
}
