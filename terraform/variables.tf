variable "aws_region" {
  description = "Region triển khai"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "Tên Key Pair đã tạo trên AWS"
  type        = string
  default     = "lab-key"
}