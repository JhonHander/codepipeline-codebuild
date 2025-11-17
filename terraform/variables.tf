variable "aws_region" {
  description = "The AWS region to create resources in."
  default     = "us-east-1"
}

variable "github_repository_id" {
  description = "The GitHub repository ID in format owner/repo."
}

variable "github_branch" {
  description = "The branch of the GitHub repository."
  default     = "main"
}

variable "aws_account_id" {
  description = "The AWS account ID"
}
