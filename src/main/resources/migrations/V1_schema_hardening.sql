-- ============================================================
-- FRK Collectives — Schema Hardening Migration V1
-- MySQL 8.0+ | Safe for live databases
-- ============================================================

-- --------------------------------------------------------
-- 1. USERS TABLE — Add updated_at tracking
-- --------------------------------------------------------
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA='frk_collectives' AND TABLE_NAME='users' AND COLUMN_NAME='updated_at');
SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE users ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_at',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- --------------------------------------------------------
-- 2. PRODUCTS TABLE — Indexes + FULLTEXT + soft delete
-- --------------------------------------------------------
CREATE INDEX idx_products_cat_price ON products (category_id, price);
CREATE INDEX idx_products_created ON products (created_at);

-- FULLTEXT for keyword search
SET @ft_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS 
    WHERE TABLE_SCHEMA='frk_collectives' AND TABLE_NAME='products' AND INDEX_NAME='ft_products_search');
SET @sql = IF(@ft_exists = 0, 
    'ALTER TABLE products ADD FULLTEXT INDEX ft_products_search (name, short_description)',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Add is_active for soft deletes
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA='frk_collectives' AND TABLE_NAME='products' AND COLUMN_NAME='is_active');
SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE products ADD COLUMN is_active BOOLEAN NOT NULL DEFAULT TRUE AFTER is_featured',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- --------------------------------------------------------
-- 3. ORDERS TABLE — Composite indexes
-- --------------------------------------------------------
CREATE INDEX idx_orders_user_date ON orders (user_id, created_at);
CREATE INDEX idx_orders_status_date ON orders (status, created_at);

SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA='frk_collectives' AND TABLE_NAME='orders' AND COLUMN_NAME='updated_at');
SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE orders ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_at',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- --------------------------------------------------------
-- 4. ORDER_ITEMS — Missing product_id index
-- --------------------------------------------------------
CREATE INDEX idx_order_items_product ON order_items (product_id);

-- --------------------------------------------------------
-- 5. REVIEWS — User index + composite
-- --------------------------------------------------------
CREATE INDEX idx_reviews_user ON reviews (user_id);
CREATE INDEX idx_reviews_product_date ON reviews (product_id, created_at);

-- --------------------------------------------------------
-- 6. WISHLIST — Product index
-- --------------------------------------------------------
CREATE INDEX idx_wishlist_product ON wishlist (product_id);

-- --------------------------------------------------------
-- 7. PRODUCT_IMAGES — Composite for primary lookups
-- --------------------------------------------------------
CREATE INDEX idx_images_product_primary ON product_images (product_id, is_primary);

-- --------------------------------------------------------
-- 8. ADDRESSES — Add created_at
-- --------------------------------------------------------
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA='frk_collectives' AND TABLE_NAME='addresses' AND COLUMN_NAME='created_at');
SET @sql = IF(@col_exists = 0, 
    'ALTER TABLE addresses ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER is_default',
    'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;


-- ============================================================
-- FUTURE-PROOFING TABLES
-- ============================================================

CREATE TABLE IF NOT EXISTS coupons (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    code            VARCHAR(50)     NOT NULL UNIQUE,
    description     VARCHAR(255),
    discount_type   ENUM('PERCENTAGE','FIXED') NOT NULL DEFAULT 'PERCENTAGE',
    discount_value  DECIMAL(10,2)   NOT NULL,
    min_order_value DECIMAL(10,2)   DEFAULT 0.00,
    max_uses        INT             DEFAULT NULL,
    used_count      INT             NOT NULL DEFAULT 0,
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE,
    valid_from      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valid_until     DATETIME        DEFAULT NULL,
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_coupons_code (code),
    INDEX idx_coupons_active (is_active, valid_from, valid_until)
) ENGINE=InnoDB;

INSERT IGNORE INTO coupons (code, description, discount_type, discount_value) VALUES
('FRK10', '10% off your order', 'PERCENTAGE', 10.00),
('FRK20', '20% off your order', 'PERCENTAGE', 20.00);

CREATE TABLE IF NOT EXISTS product_variants (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    product_id  INT             NOT NULL,
    size        VARCHAR(20)     NOT NULL,
    color       VARCHAR(50)     DEFAULT NULL,
    sku         VARCHAR(50)     UNIQUE,
    stock       INT             NOT NULL DEFAULT 0,
    price_adj   DECIMAL(10,2)   DEFAULT 0.00,
    is_active   BOOLEAN         NOT NULL DEFAULT TRUE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY uk_variant (product_id, size, color),
    INDEX idx_variants_product (product_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS inventory_log (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    product_id      INT             NOT NULL,
    variant_id      INT             DEFAULT NULL,
    change_qty      INT             NOT NULL,
    reason          ENUM('SALE','RESTOCK','ADJUSTMENT','RETURN') NOT NULL,
    reference_id    INT             DEFAULT NULL,
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_invlog_product (product_id),
    INDEX idx_invlog_date (created_at)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS notifications (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT             NOT NULL,
    title       VARCHAR(255)    NOT NULL,
    message     TEXT,
    type        ENUM('ORDER','PROMO','SYSTEM') NOT NULL DEFAULT 'ORDER',
    is_read     BOOLEAN         NOT NULL DEFAULT FALSE,
    reference_id INT            DEFAULT NULL,
    created_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_notif_user_read (user_id, is_read, created_at)
) ENGINE=InnoDB;

SELECT 'Migration V1 complete.' AS status;
