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

        // Try multiple locations for .env file
        java.io.File dotEnv = findEnvFile();
        if (dotEnv != null && dotEnv.exists()) {
            System.out.println("[DBConnection] Loading .env from: " + dotEnv.getAbsolutePath());
            try (java.io.BufferedReader reader = new java.io.BufferedReader(new java.io.FileReader(dotEnv))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    line = line.trim();
                    if (line.isEmpty() || line.startsWith("#"))
                        continue;
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
                System.err.println("[DBConnection] Failed to load .env: " + e.getMessage());
            }
        } else {
            System.out.println("[DBConnection] No .env file found, using default DB config.");
        }

        System.out.println("[DBConnection] Connecting to: " + dbUrl + " as user: " + dbUser);

        HikariDataSource ds = null;
        try {
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

            ds = new HikariDataSource(config);
            System.out.println("[DBConnection] HikariCP pool initialized successfully.");
        } catch (Exception e) {
            System.err.println("[DBConnection] FATAL: Failed to initialize connection pool: " + e.getMessage());
            e.printStackTrace();
            throw new ExceptionInInitializerError(e);
        }
        dataSource = ds;
    }

    /**
     * Searches for .env file in multiple possible locations.
     */
    private static java.io.File findEnvFile() {
        // 1. Current working directory
        java.io.File f = new java.io.File(".env");
        if (f.exists())
            return f;

        // 2. User directory / project root via system property
        String userDir = System.getProperty("user.dir");
        if (userDir != null) {
            f = new java.io.File(userDir, ".env");
            if (f.exists())
                return f;
        }

        // 3. Try to find via classpath — go up from WEB-INF/classes
        try {
            java.net.URL resource = DBConnection.class.getProtectionDomain().getCodeSource().getLocation();
            if (resource != null) {
                java.io.File classDir = new java.io.File(resource.toURI());
                // Navigate up from target/classes or WEB-INF/classes to project root
                java.io.File dir = classDir;
                for (int i = 0; i < 5; i++) {
                    dir = dir.getParentFile();
                    if (dir == null)
                        break;
                    f = new java.io.File(dir, ".env");
                    if (f.exists())
                        return f;
                }
            }
        } catch (Exception ignored) {
        }

        return null;
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
