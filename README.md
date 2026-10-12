# 🛡️ Secure Multi-Tier Cloud Network Architecture on AWS

[![AWS](https://img.shields.io/badge/AWS-VPC%20%7C%20EC2-orange?logo=amazon-aws)](https://aws.amazon.com/)
[![Terraform](https://img.shields.io/badge/IaC-Terraform-blueviolet?logo=terraform)](https://www.terraform.io/)
[![Region](https://img.shields.io/badge/Region-us--east--1-blue)]()
[![Free Tier](https://img.shields.io/badge/Cost-100%25%20Free%20Tier-success)]()

> Triển khai mô hình mạng cô lập bảo mật nhiều tầng trên AWS (Multi-Tier VPC) theo chuẩn **AWS Well-Architected Framework (Security Pillar)**. Quản trị máy chủ nội bộ qua **Bastion Host**, **Security Group Chaining** và **SSH Agent Forwarding**.

---

##  Tổng quan kiến trúc mạng (Architecture Overview)

* **VPC:** `Project-vpc` (CIDR: `10.0.0.0/16`)
* **Public Subnet:** `Project-subnet-public1-us-east-1a` (`10.0.0.0/20` - 4,090 IP)
  * Nằm sau Internet Gateway (`Project-igw`).
  * Chứa **Bastion-Host** có Public IP tiếp nhận truy cập quản trị.
* **Private Subnet:** `Project-subnet-private1-us-east-1a` (`10.0.128.0/20` - 4,090 IP)
  * Cô lập hoàn toàn với Internet (không có Public IP, bảng định tuyến chỉ có tuyến `local`).
  * Chứa **Private-Server** (mô phỏng Database/Internal Backend).

---

##  Hướng dẫn trải nghiệm dự án (2 Lựa chọn)

###  LỰA CHỌN 1: Xem tài liệu kiến trúc & Bằng chứng kiểm thử (PoC)

Dành cho nhà tuyển dụng / kỹ sư muốn kiểm tra nhanh kết quả thực tế:

1. **Kiểm tra thông mạng nội bộ (Internal Connectivity):**
   * Đứng từ Bastion Host ping sang Private Server (`10.0.128.x`).
   * **Kết quả:** Phản hồi liên tục, 0% packet loss.
   *(Bằng chứng: Xem ảnh `images/test-ping.png`)*

2. **Quản trị an toàn bằng SSH Agent Forwarding (`ssh -A`):**
   * Quản trị viên SSH xuyên từ laptop cá nhân qua Bastion vào Private Server mà **không lưu bất kỳ private key (`.pem`) nào trên máy trung gian**.
   *(Bằng chứng: Xem ảnh `images/test-ssh-agent.png`)*

3. **Xác thực cách ly hoàn toàn (Zero-Trust Isolation):**
   * Đứng tại Private Server gọi `curl https://www.google.com` $\rightarrow$ **Connection timed out**.
   * Từ Internet bên ngoài kết nối thẳng tới Private IP $\rightarrow$ **Bị chặn hoàn toàn**.

---

###  LỰA CHỌN 2: Tự động triển khai 1-Click bằng Terraform (IaC)

Dành cho kỹ sư muốn tự động tạo ra toàn bộ hệ thống này trên tài khoản AWS của mình chỉ với 1 câu lệnh:

#### Yêu cầu:
* Đã cài đặt [Terraform](https://www.terraform.io/) và [AWS CLI](https://aws.amazon.com/cli/).
* Đã có 1 Key Pair trên AWS tên là `lab-key` (tại vùng `us-east-1`).

#### Cách chạy:
```bash
# 1. Chuyển vào thư mục terraform
cd terraform

# 2. Khởi tạo và tải AWS Provider
terraform init

# 3. Triển khai toàn bộ hạ tầng 
terraform apply -auto-approve

# 4. Đăng nhập vào Bastion Host:
ssh -A ec2-user@<bastion_public_ip>

# 5. Từ Bastion Host đăng nhập sang Private Server:
ssh ec2-user@<private_server_ip>

#6. Xóa hạ tầng tránh lãng phí tài nguyên:
terraform destroy -auto-approve