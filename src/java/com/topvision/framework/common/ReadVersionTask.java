/***********************************************************************
 * $Id: ReadVersionTask.java,v1.0 2012-11-12 下午3:59:04 $
 * 
 * @author: Victor
 * 
 * (c)Copyright 2011 Topvision All rights reserved.
 ***********************************************************************/
package com.topvision.framework.common;

import java.io.File;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLClassLoader;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.types.Path;

/**
 * @author Victor
 * @created @2012-11-12-下午3:59:04
 * 
 */
public class ReadVersionTask extends Task {
    private String name;
    private String clazz;
    private Path classpath;

    /*
     * (non-Javadoc)
     * 
     * @see org.apache.tools.ant.Task#execute()
     */
    @Override
    public void execute() throws BuildException {
        try {
            ClassLoader loader = getClass().getClassLoader();
            if (classpath != null) {
                URL[] urls = new URL[] { new File(classpath.toString()).toURI().toURL() };
                loader = new URLClassLoader(urls, loader);
            }
            clazz = clazz.replaceAll("/", ".");
            Class<?> c = loader.loadClass(clazz);
            Method m = c.getMethod("getBuildVersion");
            String version = (String) m.invoke(c.newInstance());
            getProject().setProperty(name, version);
            System.out.println("Read version:" + version);
        } catch (ClassNotFoundException e) {
            e.printStackTrace(System.out);
        } catch (MalformedURLException e) {
            e.printStackTrace(System.out);
        } catch (SecurityException e) {
            e.printStackTrace(System.out);
        } catch (NoSuchMethodException e) {
            e.printStackTrace(System.out);
        } catch (IllegalArgumentException e) {
            e.printStackTrace(System.out);
        } catch (IllegalAccessException e) {
            e.printStackTrace(System.out);
        } catch (InvocationTargetException e) {
            e.printStackTrace(System.out);
        } catch (InstantiationException e) {
            e.printStackTrace(System.out);
        }
        super.execute();
    }

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @param name
     *            the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * @return the clazz
     */
    public String getClazz() {
        return clazz;
    }

    /**
     * @param clazz
     *            the clazz to set
     */
    public void setClazz(String clazz) {
        this.clazz = clazz;
    }

    /**
     * @return the classpath
     */
    public Path getClasspath() {
        return classpath;
    }

    /**
     * @param classpath
     *            the classpath to set
     */
    public void setClasspath(Path classpath) {
        this.classpath = classpath;
    }
}
