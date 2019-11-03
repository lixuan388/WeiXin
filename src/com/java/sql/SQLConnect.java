package com.java.sql;

import java.sql.Connection;
import java.sql.SQLException;

import org.apache.tomcat.jdbc.pool.DataSource;
import org.apache.tomcat.jdbc.pool.PoolProperties;

public class SQLConnect {
	

	static PoolProperties p = null;
	
	static DataSource datasource=null;
	
	
    static void InitConnectPoolSQL()
    {
        p = new PoolProperties();

      p.setDriverClassName("com.mysql.jdbc.Driver");
      p.setUrl("jdbc:mysql://127.0.0.1:53306/txdb?useUnicode=true&characterEncoding=utf8");
      p.setUsername("root");
      p.setPassword("root@17ecity.cc");   
        p.setJmxEnabled(true);
        p.setTestWhileIdle(false);
        p.setTestOnBorrow(true);
        p.setValidationQuery("SELECT 1");
        p.setTestOnReturn(false);
        p.setValidationInterval(30000);
        p.setTimeBetweenEvictionRunsMillis(30000);
        p.setMaxActive(100);
        p.setInitialSize(10);
        p.setMaxWait(10000);
        p.setRemoveAbandonedTimeout(60);
        p.setMinEvictableIdleTimeMillis(30000);
        p.setMinIdle(10);
        p.setLogAbandoned(false);
        p.setRemoveAbandoned(true);
        p.setJdbcInterceptors("org.apache.tomcat.jdbc.pool.interceptor.ConnectionState;org.apache.tomcat.jdbc.pool.interceptor.StatementFinalizer");
    
        datasource = new DataSource();
        datasource.setPoolProperties(p);
            
    }       
            
	static public Connection GetConnect()
	{
		if (datasource==null)
		{
//			InitConnectPool();
			InitConnectPoolSQL();
		}
		try {
			return datasource.getConnection();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
		    
	
	static {
//		InitConnectPool();
	}
		    

}
