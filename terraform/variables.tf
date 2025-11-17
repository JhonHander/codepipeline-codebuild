variable "aws_region" {
  description = "The AWS region to create resources in."
  default     = "us-east-1"
}

variable "github_owner" {
  description = "The owner of the GitHub repository."
}

variable "github_repo" {
  description = "The name of the GitHub repository."
}

variable "github_branch" {
  description = "The branch of the GitHub repository."
  default     = "main"
}

variable "github_token" {
  description = "The GitHub token to access the repository."
}

variable "aws_account_id" {
  description = "The AWS account ID"
}
