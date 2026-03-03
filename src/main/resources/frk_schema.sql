-- ============================================================
-- FRK Collectives — Enterprise E-Commerce Database Schema
-- MySQL 8.0+ | Normalized | Production-Ready
-- ============================================================

CREATE DATABASE IF NOT EXISTS frk_collectives
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE frk_collectives;

-- ============================================================
-- 1. USERS
-- ============================================================
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS wishlist;
DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS product_images;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100)    NOT NULL,
    email       VARCHAR(255)    NOT NULL UNIQUE,
    password_hash VARCHAR(255)  NOT NULL,
    phone       VARCHAR(20),
    role        ENUM('CUSTOMER','ADMIN') NOT NULL DEFAULT 'CUSTOMER',
    created_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_users_email (email)
) ENGINE=InnoDB;

-- ============================================================
-- 2. CATEGORIES
-- ============================================================
CREATE TABLE categories (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100)    NOT NULL UNIQUE,
    slug        VARCHAR(100)    NOT NULL UNIQUE,
    description TEXT,
    INDEX idx_categories_slug (slug)
) ENGINE=InnoDB;

-- ============================================================
-- 3. PRODUCTS
-- ============================================================
CREATE TABLE products (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    name                VARCHAR(255)    NOT NULL,
    category_id         INT             NOT NULL,
    price               DECIMAL(10,2)   NOT NULL,
    stock               INT             NOT NULL DEFAULT 0,
    brand               VARCHAR(100)    NOT NULL DEFAULT 'FRK',
    short_description   VARCHAR(500),
    detailed_description TEXT,
    rating              DECIMAL(2,1)    DEFAULT 0.0,
    review_count        INT             DEFAULT 0,
    size_options        VARCHAR(100)    DEFAULT 'S,M,L,XL',
    is_featured         BOOLEAN         DEFAULT FALSE,
    created_at          TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    INDEX idx_products_category (category_id),
    INDEX idx_products_price (price),
    INDEX idx_products_featured (is_featured),
    INDEX idx_products_rating (rating)
) ENGINE=InnoDB;

-- ============================================================
-- 4. PRODUCT IMAGES
-- ============================================================
CREATE TABLE product_images (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    product_id  INT             NOT NULL,
    image_url   VARCHAR(500)    NOT NULL,
    is_primary  BOOLEAN         DEFAULT FALSE,
    sort_order  INT             DEFAULT 0,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_images_product (product_id)
) ENGINE=InnoDB;

-- ============================================================
-- 5. ADDRESSES
-- ============================================================
CREATE TABLE addresses (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT             NOT NULL,
    name        VARCHAR(100)    NOT NULL,
    phone       VARCHAR(20)     NOT NULL,
    line1       VARCHAR(255)    NOT NULL,
    line2       VARCHAR(255),
    city        VARCHAR(100)    NOT NULL,
    state       VARCHAR(100)    NOT NULL,
    pincode     VARCHAR(10)     NOT NULL,
    is_default  BOOLEAN         DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_addresses_user (user_id)
) ENGINE=InnoDB;

-- ============================================================
-- 6. WISHLIST
-- ============================================================
CREATE TABLE wishlist (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT             NOT NULL,
    product_id  INT             NOT NULL,
    created_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    UNIQUE KEY uk_wishlist (user_id, product_id),
    INDEX idx_wishlist_user (user_id)
) ENGINE=InnoDB;

-- ============================================================
-- 7. ORDERS
-- ============================================================
CREATE TABLE orders (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT             NOT NULL,
    subtotal        DECIMAL(10,2)   NOT NULL,
    gst             DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    shipping        DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    grand_total     DECIMAL(10,2)   NOT NULL,
    status          ENUM('PENDING','CONFIRMED','SHIPPED','DELIVERED','CANCELLED')
                                    NOT NULL DEFAULT 'PENDING',
    shipping_name   VARCHAR(100),
    shipping_phone  VARCHAR(20),
    shipping_address TEXT,
    coupon_code     VARCHAR(50),
    discount        DECIMAL(10,2)   DEFAULT 0.00,
    created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_orders_user (user_id),
    INDEX idx_orders_status (status)
) ENGINE=InnoDB;

-- ============================================================
-- 8. ORDER ITEMS
-- ============================================================
CREATE TABLE order_items (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    order_id    INT             NOT NULL,
    product_id  INT             NOT NULL,
    product_name VARCHAR(255)   NOT NULL,
    quantity    INT             NOT NULL DEFAULT 1,
    size        VARCHAR(10),
    price       DECIMAL(10,2)   NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_order_items_order (order_id)
) ENGINE=InnoDB;

-- ============================================================
-- 9. REVIEWS
-- ============================================================
CREATE TABLE reviews (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    product_id  INT             NOT NULL,
    user_id     INT             NOT NULL,
    rating      INT             NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment     TEXT,
    created_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uk_review (product_id, user_id),
    INDEX idx_reviews_product (product_id)
) ENGINE=InnoDB;


-- ============================================================
-- SEED DATA
-- ============================================================

-- Categories
INSERT INTO categories (name, slug, description) VALUES
('Hoodies',      'hoodies',      'Premium heavyweight hoodies crafted for the urban minimalist.'),
('Shoes',        'shoes',        'Architectural footwear designed with precision and purpose.'),
('Bags',         'bags',         'Functional luxury bags built for the modern metropolitan.'),
('Accessories',  'accessories',  'Refined details that complete the FRK vision.'),
('T-Shirts',     't-shirts',     'Essential everyday wear with premium construction.');

-- Admin User (password: Admin@123)
INSERT INTO users (name, email, password_hash, phone, role) VALUES
('FRK Admin', 'admin@frkcollectives.com',
 '$2a$10$M1xBMV9lOw7c/QrybxzZn.7RZa3nw0Tc6uTO5bBtLRvWJYo01co3q',
 '9876543210', 'ADMIN');

-- Test Customer (password: Customer@123)
INSERT INTO users (name, email, password_hash, phone, role) VALUES
('Farhan Khan', 'farhan@example.com',
 '$2a$10$mohvOY9nPhsA4uK9SoCW3uIYUAMiJjJJM7v9sl9M6sLIC/vr72Fl6',
 '9123456789', 'CUSTOMER');

-- Products (INR Pricing)
INSERT INTO products (name, category_id, price, stock, brand, short_description, detailed_description, rating, review_count, size_options, is_featured) VALUES
('Onyx Heavyweight Hoodie',     1, 4999.00, 50, 'FRK', 'Premium 500gsm cotton fleece. Drop shoulder, cropped fit.',
 'The Onyx Heavyweight Hoodie is the cornerstone of the FRK wardrobe. Constructed from 500gsm premium cotton fleece, it features a relaxed drop-shoulder silhouette with a cropped modern fit. The interior is brushed for unmatched softness, while the exterior maintains a structured, architectural drape. Finished with tonal FRK branding and matte black hardware. True minimalist luxury, redefined.',
 4.8, 24, 'S,M,L,XL', TRUE),

('Graphite Essentials Hoodie',  1, 3499.00, 75, 'FRK', 'Everyday comfort meets high-end street style.',
 'The Graphite Essentials Hoodie delivers effortless luxury for everyday wear. Cut from 400gsm brushed cotton with a relaxed fit, it features a kangaroo pocket, ribbed cuffs, and a premium drawcord hood. The soft brushed interior makes it your go-to layering piece. Subtle FRK embroidery on the chest completes the minimalist aesthetic.',
 4.5, 18, 'S,M,L,XL', FALSE),

('Phantom Oversized Hoodie',    1, 5499.00, 30, 'FRK', 'Oversized silhouette. Statement piece for the bold.',
 'The Phantom Oversized Hoodie pushes boundaries with its exaggerated proportions and architectural cut. Crafted from heavyweight 520gsm terry fabric with raw-edge details and an elongated hem. Features a deep hood, dropped shoulders, and hidden side pockets. This is not just a hoodie — it is a statement. Limited production run ensures exclusivity.',
 4.9, 31, 'M,L,XL,XXL', TRUE),

('Cloudwalker Low Tech',        2, 7999.00, 40, 'FRK', 'Monochrome chunky sneakers. Breathable mesh upper.',
 'The Cloudwalker Low Tech combines engineering precision with street-ready aesthetics. Built on a proprietary cushioned sole unit with 40mm height, the upper features breathable mesh panels with premium suede overlays. The all-white colorway maintains the FRK monochrome philosophy. EVA midsole provides all-day comfort. Each pair is individually numbered.',
 4.7, 42, '7,8,9,10,11', TRUE),

('Phantom High-Top Corsa',      2, 9499.00, 25, 'FRK', 'Sleek black high-tops. Premium leather construction.',
 'The Phantom High-Top Corsa is the pinnacle of FRK footwear. Premium full-grain leather upper in matte black, sitting on a custom-molded rubber outsole with micro-tread pattern. Features padded ankle collar, tonal lacing system, and embossed FRK insignia on the heel tab. The silhouette draws inspiration from motorsport heritage, reimagined for the urban landscape.',
 4.6, 15, '7,8,9,10,11', TRUE),

('Obsidian Tactical Backpack',  3, 6499.00, 35, 'FRK', 'Matte black cordura. Waterproof zippers, 25L capacity.',
 'The Obsidian Tactical Backpack is engineered for the daily commute and weekend escape. Constructed from 1000D Cordura nylon with DWR coating, it features YKK AquaGuard zippers, an ergonomic back panel with airflow channels, and 25L capacity. Internal organization includes a padded 15" laptop sleeve, quick-access front pocket, and hidden security pocket. All hardware is matte black PVD-coated.',
 4.8, 28, 'ONE SIZE', FALSE),

('Void Leather Weekend Bag',    3, 12999.00, 15, 'FRK', 'Full-grain Italian leather duffel. Matte black hardware.',
 'The Void Weekend Bag is the ultimate travel companion. Handcrafted from full-grain Italian vegetable-tanned leather in deep black, it ages beautifully with use. Spacious main compartment fits 2-3 days of essentials, with interior zip pocket and shoe compartment. Detachable shoulder strap with premium padding. All hardware is custom-cast in matte black zinc alloy. Each bag includes a dust cover and authenticity card.',
 4.9, 12, 'ONE SIZE', TRUE),

('Midnight Canvas Tote',        3, 2999.00, 60, 'FRK', 'Waxed canvas tote. Minimalist carryall for daily life.',
 'The Midnight Canvas Tote strips away the unnecessary to deliver pure function. Made from waxed 18oz canvas with leather handle wraps, it features a magnetic top closure, interior zip pocket, and reinforced base. Dimensions are generous enough for a laptop, gym gear, or groceries. The waxed finish develops a unique patina over time, making each bag truly one-of-a-kind.',
 4.4, 9, 'ONE SIZE', FALSE),

('Essential Black Tee',         5, 1999.00, 100, 'FRK', 'Premium 220gsm cotton. Perfect weight, perfect fit.',
 'The Essential Black Tee is the foundation of the FRK wardrobe. Cut from 220gsm combed cotton with a pre-shrunk finish, it features a modern regular fit with slightly elongated body. Ribbed crew neck holds its shape wash after wash. Small FRK logo heat-pressed on the lower back hem. Available in true black only — because perfection does not need variation.',
 4.6, 56, 'S,M,L,XL,XXL', TRUE),

('Stealth Crossbody Sling',     4, 3499.00, 45, 'FRK', 'Compact crossbody with hidden compartments.',
 'The Stealth Crossbody Sling keeps your essentials secure and accessible. Constructed from ballistic nylon with a water-resistant coating, it features a main compartment, hidden back pocket, and internal card slots. Adjustable strap with quick-release buckle allows for crossbody or shoulder carry. Reflective FRK logo adds subtle visibility in low light. Compact enough for essentials — phone, wallet, keys, earbuds.',
 4.3, 14, 'ONE SIZE', FALSE),

('Monolith Leather Belt',       4, 2499.00, 55, 'FRK', 'Full-grain leather. Matte black pin buckle.',
 'The Monolith Belt is minimalism at its finest. Cut from 3.5mm full-grain leather with burnished edges, it features a custom-designed matte black pin buckle with subtle FRK engraving. Width is 35mm — versatile enough for both casual and smart-casual styling. The leather develops a rich patina with wear, telling your story over time.',
 4.7, 22, '28,30,32,34,36', FALSE),

('Noir Structured Cap',         4, 1499.00, 80, 'FRK', 'Six-panel structured cap. Embroidered FRK logo.',
 'The Noir Structured Cap is the finishing touch for the FRK look. Six-panel construction with an internal structured crown holds its shape throughout the day. Made from brushed cotton twill with a pre-curved brim. Features tonal FRK embroidery on the front and an adjustable metal clasp with engraved logo on the back. One size fits most with adjustable closure.',
 4.5, 33, 'ONE SIZE', FALSE);

-- Product Images
INSERT INTO product_images (product_id, image_url, is_primary, sort_order) VALUES
(1,  'https://images.unsplash.com/photo-1556821840-3a63f95609a7?auto=format&fit=crop&q=80&w=800', TRUE, 1),
(1,  'https://images.unsplash.com/photo-1578587018452-892bace9ee45?auto=format&fit=crop&q=80&w=800', FALSE, 2),
(2,  'https://images.unsplash.com/photo-1578587018452-892bace9ee45?auto=format&fit=crop&q=80&w=800', TRUE, 1),
(2,  'https://images.unsplash.com/photo-1556821840-3a63f95609a7?auto=format&fit=crop&q=80&w=800', FALSE, 2),
(3,  'https://images.unsplash.com/photo-1542327897-d73f4005b533?auto=format&fit=crop&q=80&w=800', TRUE, 1),
(4,  'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?auto=format&fit=crop&q=80&w=800', TRUE, 1),
(4,  'https://images.unsplash.com/photo-1549298916-b41d501d3772?auto=format&fit=crop&q=80&w=800', FALSE, 2),
(5,  'https://images.unsplash.com/photo-1549298916-b41d501d3772?auto=format&fit=crop&q=80&w=800', TRUE, 1),
(5,  'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?auto=format&fit=crop&q=80&w=800', FALSE, 2),
(6,  'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&q=80&w=800', TRUE, 1),
(7,  'https://images.unsplash.com/photo-1552504620-1e5b2addf45a?auto=format&fit=crop&q=80&w=800', TRUE, 1),
(8,  'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&q=80&w=800', TRUE, 1),
(9,  'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&q=80&w=800', TRUE, 1),
(10, 'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?auto=format&fit=crop&q=80&w=800', TRUE, 1),
(11, 'https://images.unsplash.com/photo-1624222247344-550fb60583dc?auto=format&fit=crop&q=80&w=800', TRUE, 1),
(12, 'https://images.unsplash.com/photo-1588850561407-ed78c334e67a?auto=format&fit=crop&q=80&w=800', TRUE, 1);

-- Sample Reviews
INSERT INTO reviews (product_id, user_id, rating, comment) VALUES
(1, 2, 5, 'Absolutely premium quality. The weight of the fabric is perfect and the fit is exactly as described. Worth every rupee.'),
(4, 2, 5, 'These sneakers are incredibly comfortable. The cushioning is next level and they look amazing with everything.'),
(9, 2, 4, 'Great basic tee. The cotton quality is noticeably better than other brands in this price range.');

-- Sample Address
INSERT INTO addresses (user_id, name, phone, line1, line2, city, state, pincode, is_default) VALUES
(2, 'Farhan Khan', '9123456789', '42 Park Avenue', 'Near City Mall', 'Mumbai', 'Maharashtra', '400001', TRUE);
