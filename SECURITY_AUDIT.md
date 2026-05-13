# Security Audit: What NOT to Commit

Based on the Java/JSP, Maven, and MySQL stack of FRK Collectives, this document details specific files and patterns that represent severe security risks if committed to the public Git history.

---

### 1. Local Environment Variables (`.env`)

- **What to check for:** Any file named `.env`, `.env.local`, or `.env.production`.
- **The damage:** Your `.env` file contains `DB_PASSWORD` and `SESSION_SECRET_KEY`. If committed publicly, automated bots will scrape your database credentials within seconds, leading to data theft, ransomware, or complete database deletion. Session keys allow attackers to forge user cookies and hijack accounts.
- **How to check:**
  ```bash
  git log --all --stat | grep -i "\.env"
  ```
- **How to remove:**
  ```bash
  git filter-repo --path .env --invert-paths
  ```

### 2. Hardcoded Database Credentials in Code

- **What to check for:** Hardcoded JDBC URLs, usernames, or passwords in Java Servlets, DAOs (e.g., `ProductDAO.java`), or `context.xml`.
  Example pattern: `DriverManager.getConnection("jdbc:mysql://...", "root", "my_real_password")`
- **The damage:** Same as committing a `.env` file. Attackers will decompile or read the source code to extract the hardcoded database credentials.
- **How to check:**
  ```bash
  git grep -i "password="
  git grep -i "jdbc:mysql"
  ```
- **How to remove:** 
  You must replace the hardcoded values with `System.getenv("DB_PASSWORD")` in the current commit. Then, you must rotate the compromised password immediately on your MySQL server, as cleaning git history of a specific line of code across many commits is complex and error-prone.

### 3. Payment Gateway API Keys

- **What to check for:** Any string resembling `sk_live_...` or `sk_test_...` (Stripe/Payment keys) hardcoded in Java controllers or JSP frontend files.
- **The damage:** If a live secret key is committed, attackers can process fraudulent refunds, steal customer payment data, or hijack your merchant account.
- **How to check:**
  ```bash
  git grep "sk_live_"
  git grep "sk_test_"
  ```
- **How to remove:**
  ```bash
  # It is faster and safer to immediately revoke the key in your payment provider's dashboard.
  # Once revoked, the leaked key is useless.
  ```

### 4. Compiled Application Archives (`.war`, `.jar`)

- **What to check for:** Any files ending in `.war` or `.jar` in the `target/` directory.
- **The damage:** While not strictly a security vulnerability, committing compiled binaries massively bloats the repository size, slowing down clones and pulls for all future developers. It can also accidentally include compiled `.properties` files that might contain secrets that were ignored in the source directory.
- **How to check:**
  ```bash
  git log --all --stat | grep -E "\.war$|\.jar$"
  ```
- **How to remove:**
  ```bash
  git filter-repo --path-glob '*.war' --path-glob '*.jar' --invert-paths
  ```

### 5. IDE Workspaces and Keychains

- **What to check for:** IntelliJ `.idea/` folder contents, specifically `workspace.xml` or `tasks.xml`, or Eclipse `.settings/`.
- **The damage:** These files can inadvertently leak local absolute file paths (exposing your OS username), internal server IP addresses, or locally cached database access tokens used by your IDE's database GUI.
- **How to check:**
  ```bash
  git log --all --stat | grep "\.idea/"
  ```
- **How to remove:**
  ```bash
  git filter-repo --path .idea/ --invert-paths
  ```

---

### Emergency Response: "I accidentally committed a secret!"

If you realize you have pushed a secret to GitHub:
1. **DO NOT JUST DELETE IT IN A NEW COMMIT.** The secret will still exist in the Git history.
2. **Rotate the secret immediately.** Change the database password, revoke the API key, or generate a new session secret. Assume it is already compromised.
3. Use a tool like [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/) or `git filter-repo` to scrub the history.
4. Force push the rewritten history: `git push origin --force --all`.
