/***********************************************************************
 * $Id: ReadMemory.java,v1.0 2016年12月5日 下午2:12:09 $
 * 
 * @author: Victorli
 * 
 * (c)Copyright 2011 Topvision All rights reserved.
 ***********************************************************************/
package com.topvision.framework.common;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.lang.management.ManagementFactory;

import com.sun.management.OperatingSystemMXBean;

/**
 * @author Victorli
 * @created @2016年12月5日-下午2:12:09
 *
 */
public class ReadMemory {
    public static void main(String[] args) {
        OperatingSystemMXBean osmb = (OperatingSystemMXBean) ManagementFactory.getOperatingSystemMXBean();
        long mem = osmb.getTotalPhysicalMemorySize() / 1024 / 1024 / 1024;
        System.out.println("TotalPhysicalMemorySize:" + mem + "GB");
        if (args.length != 3) {
            return;
        }
        boolean isX64 = "x64".equals(args[0]);
        System.out.println("isX64(" + args[0] + "):" + isX64);
        boolean hasServer = "hasServer".equals(args[1]);
        System.out.println("hasServer(" + args[1] + "):" + hasServer);
        boolean hasMysql = "hasMysql".equals(args[2]);
        System.out.println("hasMysql(" + args[2] + "):" + hasMysql);

        String option = "--JvmMs 1024 --JvmMx 4096";
        String innodb_buffer_pool_size = "256M";
        // X86
        if (!isX64) {
            option = "--JvmMs 512 --JvmMx 1024";
        } else {
            if (mem >= 60) {
                // 64G -Xms20G -Xmx40G
                option = "--JvmMs 20480 --JvmMx 40960";
            } else if (mem >= 30) {
                // 32G -Xms12G -Xmx24G
                option = "--JvmMs 12288 --JvmMx 24576";
            } else if (mem >= 15) {
                // 16G -Xms5G -Xmx10G
                option = "--JvmMs 5120 --JvmMx 10240";
            } else if (mem >= 6) {
                // 8G -Xms2G -Xmx4G
                option = "--JvmMs 2048 --JvmMx 4096";
            }

            // Mysql ：修改my.cnf
            if (hasServer && hasMysql) {
                // Server＋Mysql
                if (mem >= 60) {
                    // 64G
                    innodb_buffer_pool_size = "20G";
                } else if (mem >= 30) {
                    // 32G
                    innodb_buffer_pool_size = "6G";
                } else if (mem >= 15) {
                    // 16G
                    innodb_buffer_pool_size = "4G";
                } else if (mem >= 6) {
                    // 8G
                    innodb_buffer_pool_size = "2G";
                }
            } else if (hasMysql) {
                // 单独安装Mysql
                if (mem >= 60) {
                    // 64G
                    innodb_buffer_pool_size = "40G";
                } else if (mem >= 30) {
                    // 32G
                    innodb_buffer_pool_size = "24G";
                } else if (mem >= 15) {
                    // 16G
                    innodb_buffer_pool_size = "10G";
                } else if (mem >= 6) {
                    // 8G
                    innodb_buffer_pool_size = "4G";
                }
            }
        }
        if (hasServer) {
            updateOptions(option);
        }
        if (hasMysql) {
            updateMysql(innodb_buffer_pool_size);
        }
    }

    private static void updateOptions(String option) {
        File file = new File("bin/nm3000Install.bat");
        File bak = new File("bin/nm3000Install.bak");
        BufferedWriter out = null;
        BufferedReader in = null;
        try {
            file.renameTo(bak);
            in = new BufferedReader(new InputStreamReader(new FileInputStream(bak)));
            file.createNewFile();
            out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file)));
            String line = null;
            while ((line = in.readLine()) != null) {
                if (line.startsWith("set OPTIONS")) {
                    out.write("set OPTIONS=");
                    out.write(option);
                } else {
                    out.write(line);
                }
                out.newLine();
            }
        } catch (Exception e) {
            e.printStackTrace(System.out);
        }
        try {
            in.close();
            out.close();
        } catch (Exception e) {
            e.printStackTrace(System.out);
        }
        bak.delete();
    }

    private static void updateMysql(String innodb_buffer_pool_size) {
        File file = new File("mysql/my.cnf");
        File bak = new File("mysql/my.bak");
        BufferedWriter out = null;
        BufferedReader in = null;
        try {
            file.renameTo(bak);
            in = new BufferedReader(new InputStreamReader(new FileInputStream(bak)));
            file.createNewFile();
            out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file)));
            String line = null;
            while ((line = in.readLine()) != null) {
                if (line.startsWith("innodb_buffer_pool_size")) {
                    out.write("innodb_buffer_pool_size = ");
                    out.write(innodb_buffer_pool_size);
                } else {
                    out.write(line);
                }
                out.newLine();
            }
        } catch (Exception e) {
            e.printStackTrace(System.out);
        }
        try {
            in.close();
            out.close();
        } catch (Exception e) {
            e.printStackTrace(System.out);
        }
        bak.delete();
    }
}
