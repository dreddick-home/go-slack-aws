variable aws_region {
  type        = string
  default     = "eu-west-1"
  description = "The region for the aws provider"
}


variable "environments" {
  description = "Map, holding configuration of all environments."
  type        = map(map(string))
}

variable "token" {
  description = "Token for access to Slack API"
  type        = string
}
variable "channel_id" {
  description = "ChannelId for posting"
  type        = string
}



