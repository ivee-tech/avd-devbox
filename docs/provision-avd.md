# Provision Azure Virtual Desktop (AVD)

Below is a **step-by-step guide to set up a new Azure Virtual Desktop (AVD) environment** using the Azure portal:

---

### ✅ **Prerequisites**
- **Azure subscription** with appropriate permissions:
  - *Desktop Virtualization Contributor* for host pool, workspace, and app group.
  - *Virtual Machine Contributor* for session hosts.
- **Active Directory**: Azure AD or hybrid AD for user authentication.
- **Networking**: Virtual network with connectivity to domain controllers.
- **Licenses**: Windows 10/11 Enterprise multi-session or Windows Server + RDS CALs.
- **FSLogix** (optional): For profile management.
- **Azure AD permissions**: Contributor or equivalent.

---

### **Step 1: Create a Host Pool**
1. In the **Azure portal**, search for **Azure Virtual Desktop**.
2. Select **Host pools → Create**.
3. Fill in:
   - **Subscription** and **Resource Group**.
   - **Host pool name** (e.g., `hp01`).
   - **Location**: Choose an Azure region.
   - **Preferred app group type**: *Desktop* or *RemoteApp*.
   - **Host pool type**: *Pooled* or *Personal*.
4. Click **Next: Session hosts**.

---

### **Step 2: Add Session Hosts**
1. **Number of VMs**: Specify how many session hosts to create (can be 0 initially).
2. **VM details**:
   - **Name prefix** (e.g., `hp01-sh`).
   - **VM size** (e.g., `Standard_D4s_v3`).
   - **Image**: Windows 11 Enterprise multi-session (or custom image).
3. **Domain join**:
   - Provide **AD domain** and credentials.
4. **Networking**:
   - Select **Virtual Network** and **Subnet**.
5. **Administrator account** for VMs.
6. Click **Next: Workspace**.

---

### **Step 3: Create a Workspace**
1. **Workspace name** (e.g., `ws01`).
2. Link the **host pool** to this workspace.
3. Click **Review + Create** → **Create**.

---

### **Step 4: Assign Users**
- Go to **Application groups** in the host pool.
- Assign **Azure AD users or groups** to the Desktop or RemoteApp group.

---

### **Step 5: (Optional) Enable FSLogix**
- Deploy FSLogix on session hosts.
- Configure profile container storage (Azure Files or Azure NetApp Files).

---

### **Step 6: Test Access**
- Users connect via **Remote Desktop client** or **AVD web client**.

