# Azure SQL Server High Availability Deployment with ARM Templates

This repository contains all the necessary **ARM templates** and **PowerShell scripts** to deploy a fully automated, highly available SQL Server 2022 Always On Availability Group on Microsoft Azure.

---

## 📖 Overview

The solution is designed to:

✅ Deploy a **Domain Controller VM** on Azure  
✅ Create a dedicated **SQL Server domain service account**  
✅ Deploy two SQL Server 2022 Enterprise VMs in an **Always On Availability Group (AG)**  
✅ Configure **Windows Server Failover Cluster (WSFC)**, AG Listener, and Cloud Witness

---

## 📂 Repository Structure

```
.
├── DC/
│   ├── parameters.json            # Parameters for DC deployment
│   ├── sqlserviceaccount.ps1      # PowerShell script to create SQL service account
│   └── template.json              # ARM template for DC VM
├── SQL/
│   ├── parameters.json            # Parameters for SQL cluster deployment
│   └── template.json              # ARM template for SQL cluster
└── README.md
```

---

## 📝 Prerequisites

- Azure subscription
- Administrative access to deploy resources and join domain

---

## 🚀 Deployment Steps

### 1️⃣ Deploy Domain Controller VM

Via Azure Portal > “Deploy a custom template” and upload `DC/template.json` and `DC/parameters.json`.
Create a new resource group "sql-ha" in Central India and select it for the deployment.

---

### 2️⃣ Create SQL Server Service Account

Log in to the Domain Controller VM and run:

```powershell
.\DC\sqlserviceaccount.ps1
```

This creates a domain account `sqladmin` for SQL services.

Tip: Change the default password in the script to a strong, unique one before running.

---

### 3️⃣ Deploy SQL Server Cluster

Via Azure Portal > “Deploy a custom template”.
Upload template and parameters files and proceed with the deployment in the "sql-ha" resource group.

---

## 🔎 Validation

✅ Open **Failover Cluster Manager** and check WSFC  
✅ Open **SQL Server Management Studio (SSMS)** and verify the Availability Group and Listener  
✅ Test failover between nodes

You can also check High Availability configuration from the SQL Virtual Machines blade in the Azure portal.

---

## 📄 Notes

- You can customize names, IP addresses, domain names, admin usernames/passwords, etc., in the template parameters.
- You need to update subscription ID in the template/parameters file with your subscription ID.
- Same NSG is being used for DC and SQL machines. NSG rules in the templates include ports needed for RDP and WSFC. You can also use separate NSGs for SQL and DC. 
- Cloud Witness storage account is created automatically if specified.

---

## 📬 Feedback

Feel free to open an issue or submit a pull request if you find any problems or improvements!

Happy deploying! 🚀
