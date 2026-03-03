package com.frk.dao;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;

/**
 * Database Connection Manager using HikariCP Connection Pool.
 * Provides high-performance, production-ready connection management.
 */
public class DBConnection {

    private static final HikariDataSource dataSource;

    static {
        // Load credentials from .env
        String dbUrl = "jdbc:mysql://localhost:3306/frk_collectives?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
        String dbUser = "root";
        String dbPass = "";

        java.io.File dotEnv = new java.io.File(".env");
        if (dotEnv.exists()) {
            try (java.io.BufferedReader reader = new java.io.BufferedReader(new java.io.FileReader(dotEnv))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    if (line.contains("=")) {
                        String[] parts = line.split("=", 2);
                        String key = parts[0].trim();
                        String value = parts[1].trim();
                        if ("DB_URL".equals(key))
                            dbUrl = value;
                        if ("DB_USER".equals(key))
                            dbUser = value;
                        if ("DB_PASSWORD".equals(key))
                            dbPass = value;
                    }
                }
            } catch (java.io.IOException e) {
                System.err.println("Failed to load .env: " + e.getMessage());
            }
        }

        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(dbUrl);
        config.setUsername(dbUser);
        config.setPassword(dbPass);
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");

        // Pool configuration
        config.setMaximumPoolSize(20);
        config.setMinimumIdle(5);
        config.setIdleTimeout(300000); // 5 minutes
        config.setConnectionTimeout(20000); // 20 seconds
        config.setMaxLifetime(1200000); // 20 minutes

        // Performance optimizations
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
        config.addDataSourceProperty("useServerPrepStmts", "true");

        config.setPoolName("FRK-HikariPool");

        dataSource = new HikariDataSource(config);
    }

    /**
     * Gets a connection from the HikariCP pool.
     *
     * @return Connection object from the pool
     * @throws SQLException if unable to obtain connection
     */
    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    /**
     * Shuts down the connection pool gracefully.
     * Should be called during application shutdown.
     */
    public static void shutdown() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
}
