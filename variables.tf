variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"  # Change the default value as needed
}

variable "api_name" {
  description = "Name of the API Gateway"
  type        = string
  default     = "projectx-api-endpoint"  # Change the default value as needed
}

variable "payload_validator_schema" {
  description = "JSON schema for payload validation"
  type        = string
  default = <<EOF
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "type": "object",
  "required": ["id", "docs"],
  "properties": {
    "id": {"type": "string"},
    "docs": {
      "minItems": 1,
      "type": "array",
      "items": {"type": "object"}
    }
  }
}
EOF
}

variable "payload_validator_schema_v2" {
  description = "JSON schema for payload validation"
  type        = string
  default = <<EOF
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "type": "object",
  "properties": {
    "_id": {
      "type": "string"
    },
    "index": {
      "type": "integer"
    },
    "guid": {
      "type": "string",
      "pattern": "^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$"
    },
    "isActive": {
      "type": "boolean"
    },
    "balance": {
      "type": "string",
      "pattern": "^\\$\\d+(\\.\\d{1,2})?$"
    },
    "picture": {
      "type": "string",
      "format": "uri"
    },
    "age": {
      "type": "integer"
    },
    "eyeColor": {
      "type": "string"
    },
    "name": {
      "type": "string"
    },
    "gender": {
      "type": "string"
    },
    "company": {
      "type": "string"
    },
    "email": {
      "type": "string",
      "format": "email"
    },
    "phone": {
      "type": "string"
    },
    "address": {
      "type": "string"
    },
    "about": {
      "type": "string"
    },
    "registered": {
      "type": "string"
    },
    "latitude": {
      "type": "number"
    },
    "longitude": {
      "type": "number"
    },
    "friends": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "id": {
            "type": "integer"
          },
          "name": {
            "type": "string"
          }
        },
        "required": ["id", "name"]
      }
    },
    "greeting": {
      "type": "string"
    },
    "favoriteFruit": {
      "type": "string"
    }
  },
  "required": [
    "_id",
    "index",
    "guid",
    "isActive",
    "balance",
    "picture",
    "age",
    "eyeColor",
    "name",
    "gender",
    "company",
    "email",
    "phone",
    "address",
    "about",
    "registered",
    "latitude",
    "longitude",
    "friends",
    "greeting",
    "favoriteFruit"
  ]
}
EOF
}


variable "environment" {
  description = "The Deployment environment"
  default = "dev"
}

variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
  default = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  type        = list
  description = "The CIDR block for the public subnet"
  default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  type        = list
  description = "The CIDR block for the private subnet"
  default = ["10.0.10.0/24","10.0.20.0/24"]
}

variable "availability_zones" {
  type        = list
  description = "The az that the resources will be launched"
  default = ["eu-west-1a", "eu-west-1b"]
}

variable "global_prefix" {
  type    = string
  default = "demo-msk"
}

variable "data_catalog_database_name" {
  type = string
  default = "projectx-customers"
}

variable "customer_table_name" {
  type = string
  default = "customer_details"
}