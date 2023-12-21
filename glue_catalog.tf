# Create Glue catalog database for ingested data sources
resource "aws_glue_catalog_database" "database" {
  name = var.data_catalog_database_name
}

resource "aws_glue_catalog_table" "fbad_table" {
  name          = var.customer_table_name
  database_name = aws_glue_catalog_database.database.name
  table_type    = "EXTERNAL_TABLE"

  parameters = {
    "classification"        = "csv" # Set classification to "csv"
  }

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.projectx-firehose_s3_bucket.bucket}/"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"  # Use TextInputFormat for CSV
    output_format = "org.apache.hadoop.hive.ql.io.IgnoreKeyTextOutputFormat"  # Use IgnoreKeyTextOutputFormat for CSV

    ser_de_info {
      name                  = "fbad-csv"
      serialization_library = "org.apache.hadoop.hive.serde2.OpenCSVSerde"  # Use LazySimpleSerDe for CSV

      parameters = {
        "separatorChar"         = ","
        "quoteChar"             = "\"" # Remove the quotes when querying the data
        "serialization.format"  = ","
      }
    }

    columns {
      name = "_id"
      type = "string"
    }

    columns {
      name = "isActive"
      type = "string"
    }

    columns {
      name = "balance"
      type = "string"
    }

    columns {
      name = "picture"
      type = "string"
    }

    columns {
      name = "age"
      type = "string"
    }

    columns {
      name = "eyeColor"
      type = "string"
    }

    columns {
      name = "name"
      type = "string"
    }

    columns {
      name = "gender"
      type = "string"
    }

    columns {
      name = "company"
      type = "string"
    }

    columns {
      name = "email"
      type = "string"
    }

    columns {
      name = "phone"
      type = "string"
    }

    columns {
      name = "address"
      type = "string"
    }

    columns {
      name = "registered"
      type = "string"
    }

    columns {
      name = "latitude"
      type = "string"
    }

    columns {
      name = "longitude"
      type = "string"
    }

    columns {
      name = "favoriteFruit"
      type = "string"
    }
  }
}