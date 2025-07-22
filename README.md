# 🚀 Azure SQL Server High Availability Deployment with ARM Templates

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
- Azure CLI installed
- Administrative access to deploy resources and join domain

---

## 🚀 Deployment Steps

### 1️⃣ Deploy Domain Controller VM

```bash
az deployment group create   --resource-group dc-rg   --template-file DC/template.json   --parameters @DC/parameters.json
```

Or via Azure Portal > “Deploy a custom template” and upload `DC/template.json` and `DC/parameters.json`.

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

```bash
az deployment group create   --resource-group sql-ha   --template-file SQL/template.json   --parameters @SQL/parameters.json
```

Or via Azure Portal > “Deploy a custom template”.

---

## 🔎 Validation

✅ Open **Failover Cluster Manager** and check WSFC  
✅ Open **SQL Server Management Studio (SSMS)** and verify the Availability Group and Listener  
✅ Test failover between nodes

You can also check High Availability configuration from the SQL Virtual Machines blade in the Azure portal.

---

## 📄 Notes

- The NSG rules in the templates include ports needed for RDP, DNS, WSFC, and SQL.
- Change any hardcoded passwords in the `sqlserviceaccount.ps1` script before use.
- Cloud Witness storage account is created automatically if specified.

---

## 📬 Feedback

Feel free to open an issue or submit a pull request if you find any problems or improvements!

Happy deploying! 🚀
