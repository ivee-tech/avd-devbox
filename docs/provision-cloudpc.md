# Provision CloudPC

Here's a **step-by-step guide** to help you **provision a Cloud PC** in Microsoft 365 using **Windows 365 Enterprise** and **Intune**:

---

## 🧭 Step-by-Step: Provisioning a Cloud PC

### 🔹 1. **Purchase a Windows 365 License**
- Go to the https://admin.microsoft.com or https://windows365.microsoft.com.
- Choose **Windows 365 Enterprise** or **Business**.
- Assign the license to the user(s) who will receive a Cloud PC.

---

### 🔹 2. **Create a Provisioning Policy in Intune**
1. Go to **Microsoft Intune Admin Center**.
2. Navigate to:  
   `Devices > Windows 365 > Provisioning Policies`
3. Click **Create Policy**:
   - **Name & Description**: Give it a clear name.
   - **License Type**: Choose Enterprise or Business.
   - **Join Type**: Select **Microsoft-hosted network** or **Azure Network Connection**.
   - **Image Type**: Choose a default image (Windows 10/11 with or without Microsoft 365 Apps) or upload a custom image.
   - **Device Name Template**: Use something like `CloudPC-%USERNAME%-%RAND:5%`.

---

### 🔹 3. **Create a User Settings Policy**
1. Go to:  
   `Devices > Windows 365 > User Settings`
2. Click **Create Policy**:
   - Define optional settings (e.g., local admin rights).
   - Assign the policy to a group containing Cloud PC users.

---

### 🔹 4. **Assign Policies to Users**
- Ensure the user is:
  - Licensed for Windows 365.
  - Included in the **Azure AD group** targeted by both the provisioning and user settings policies.

---

### 🔹 5. **Provisioning Begins Automatically**
- Once policies and licenses are assigned, provisioning starts.
- You can monitor status under:  
  `Devices > Windows 365 > All Cloud PCs`

---

### 🔹 6. **Accessing the Cloud PC**
Users can access their Cloud PC via:

- **Web**: https://windows365.microsoft.com
- **Windows App**: Modern app for Windows 10/11
- **Remote Desktop App**: Using the feed URL from the portal

---

### 🔹 7. **Optional Configurations**
- **Azure Network Connection**: For hybrid join or internal resource access.
- **Windows Update Rings**: Manage updates via Intune.
- **Application Deployment**: Push apps like any other Intune-managed device.
- **Conditional Access & Security Policies**: Apply standard M365 security controls.

---
