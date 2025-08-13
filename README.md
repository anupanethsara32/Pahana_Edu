# Pahana Edu – Web Application

## 📌 Project Overview
Pahana Edu is a Java-based web application developed to provide a seamless platform for educational services and administrative tasks. It includes modules for **user registration**, **login authentication**, **admin management**, **item management**, **billing**, and **customer communication**. The system follows a **3-tier architecture** with the use of **design patterns** such as Singleton, Factory, and Strategy for maintainability and scalability.

---

## 🚀 Features
- **User Registration & Login** (Separate flows for Admin and Users)
- **Admin Dashboard** for managing customers, items, and billing
- **Item Selling Module** with image upload/display
- **Billing System** with bill saving and printing functionality
- **Help & Contact** modules for user assistance
- **Secure Authentication** with session management and access control filters

---

## 🛠️ Technologies Used
- **Frontend**: HTML5, CSS3, Bootstrap 5, JavaScript
- **Backend**: Java Servlets, JSP
- **Database**: MySQL
- **Server**: Apache Tomcat
- **Version Control**: Git & GitHub (with master & developer branches)
- **IDE**: NetBeans

---

## 📂 Project Structure
```
Pahana_Edu/
│── src/                   # Java source files (Servlets, Filters, etc.)
│── web/                   # JSP files, static assets
│── WEB-INF/               # Configurations & deployment descriptors
│── sql/                   # Database scripts
│── README.md              # Project documentation
```

---

## 🔄 Version Control & Branching Strategy
This project follows a **Sequential Versioning (Linear Workflow)** with two branches:
- **master** → Stable, production-ready code
- **developer** → Feature development and testing

Changes are committed in **NetBeans IDE** and pushed to GitHub using descriptive commit messages.

---

## 📦 Installation & Setup
1. **Clone the Repository**
   ```bash
   git clone https://github.com/anupanethsara32/Pahana_Edu.git
   ```
2. **Import into NetBeans** as a Java Web Project.
3. **Configure MySQL Database**:
   - Import the provided `.sql` file in the `sql/` folder.
   - Update database credentials in `DBConnection` class.
4. **Deploy on Apache Tomcat** (version 9+ recommended).
5. Access the application via:
   ```
   http://localhost:8080/Pahana_Edu
   ```

---


## 📜 License
This project is for educational purposes and is free to use with proper attribution.
