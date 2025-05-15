# Inception - Cloud Deployment

This project is inspired by the **Inception** subject at 42.  
It demonstrates how to deploy a full WordPress stack (WordPress + MariaDB + NGINX + phpMyAdmin) in **Docker containers** on a **cloud VM** using **automation scripts** and **TLS (HTTPS)**.

---

## Services Included

- **NGINX** (reverse proxy, TLS support)
- **WordPress** (PHP-FPM backend)
- **MariaDB** (MySQL-compatible database)
- **phpMyAdmin** (web interface to manage the DB)

Each service runs in its **own container**, communicating via a custom Docker network (`inception`).

---

## Requirements

- A remote VM (Ubuntu 20.04 LTS recommended)
- Docker & docker compose (installed automatically by the script)
- SSH access to the VM
- [Optional] Free GCP credits, or your own cloud provider
- **No domain name required** (uses `https://<your-vm-ip>` with a self-signed certificate)

---

## Installation

### 1. Clone the repository

```bash
git clone <your-repo>
cd <your-repo>
```

### 2. Create the `.env` file

Create a file named `.env` in the root directory with the following content:

```env
DB_NAME=wordpress
DB_USER=wp
DB_PASS=supersecret
DB_ROOT=rootpass
```

> You can change the values as needed.

---

### 3. Configure your remote VM access

Edit `project-config.sh`:

```bash
REMOTE_USER=your_vm_user
REMOTE_HOST=your_vm_ip
```

---

### 4. Deploy to the VM

Run the deployment script:

```bash
./deploy.sh
```

This will:
- Upload your `docker-compose.yml`, config files, and requirements
- Install Docker, docker compose, and UFW
- Open ports 80/443
- Launch the services in the background (`docker compose up -d`)

---

## HTTPS Support

- A **self-signed certificate** is automatically generated during NGINX build
- Access your site using:
  ```
  https://<your-vm-ip>
  ```
- phpMyAdmin is available at:
  ```
  https://<your-vm-ip>/phpmyadmin/
  ```

> Browsers will show a warning (because the cert is self-signed). You can safely ignore it for the project.

---

## Re-deployment

To rebuild or restart everything:

```bash
./deploy.sh
```

To remove everything :

```bash
./clean-vm.sh
```

---

## Architecture

```
+------------+       +------------+        +--------------+
|            |       |            |        |              |
|  NGINX     +-------> WordPress  +-------> MariaDB       |
|  (443 SSL) |       |  (php-fpm) |        |              |
|            |       |            |        |              |
+------+-----+       +-----+------+        +------+-------+
       |                   |                      |
       |                   v                      |
       +--------------> phpMyAdmin <--------------+
```

---

## Project Requirements Covered

- [x] 1 process = 1 container
- [x] Docker Compose used
- [x] HTTPS support (self-signed)
- [x] Wordpress + MariaDB + phpMyAdmin setup
- [x] Volumes for data persistence
- [x] Automatic deployment (no Ansible needed)
- [x] Firewall (UFW) configured
- [x] Service auto-restart after VM reboot
- [x] Web access only, no DB exposed publicly

---

## Notes

- This project avoids Ansible for simplicity.  
  You are free to extend it if required.

- No domain name is used. If you wish, you can configure one with DuckDNS.

---

## 🧼 To Do (optional)

- Add certbot support if a real domain is used
- Harden security with fail2ban, NGINX rate limits, etc.
