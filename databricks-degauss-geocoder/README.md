# About

Extensions of [databricksruntime/standard](https://github.com/databricks/containers/tree/master/ubuntu/standard) with the [DeGAUSS](https://degauss.org) [geocoder](https://degauss.org/geocoder)

# Images

These images are available on [Docker Hub](https://hub.docker.com/repository/docker/themadstatter/databricksruntime-standard-degauss-geocoder/general).

# Databricks Notebook Examples

<details>

<summary>Shell</summary>

## Geocode Single Address

```
%sh

ruby /app/geocode.rb "3333 Burnet Ave Cincinnati OH 45229"
```

## Use entrypoint.R

```
%sh

cd /Workspace/Users/schuelke@wustl.edu
wget https://raw.githubusercontent.com/degauss-org/geocoder/master/test/my_address_file.csv
Rscript /app/entrypoint.R my_address_file.csv 0.5
```

</details>

<details>

<summary>R</summary>

## Read and Write CSV

```
%r

setwd("/Workspace/Users/schuelke@wustl.edu")

csv_in <- "my_address_file_in.csv"
csv_out <- "my_address_file_out.csv"

download.file("https://raw.githubusercontent.com/degauss-org/geocoder/master/test/my_address_file.csv", csv_in)

readr::read_csv(csv_in) |>
  purrr::pmap_dfr(\(id, address, ...) {
    result <- system2("ruby", args = c("/app/geocode.rb", shQuote(address)), stdout = TRUE, stderr = FALSE) |>
      jsonlite::fromJSON()

    tibble::tibble(id = id, address = address) |>
      dplyr::bind_cols(result)
  }) |>
  readr::write_csv(csv_out)
```

## Read and Write Data Lake

```
%r

# download an example csv input file
download.file(
  "https://raw.githubusercontent.com/degauss-org/geocoder/master/test/my_address_file.csv", 
  "/Workspace/Users/schuelke@wustl.edu/my_address_file.csv"
)

# read the example csv input file and write to lake
SparkR::read.df("file:/Workspace/Users/schuelke@wustl.edu/my_address_file.csv", "csv", header = "true") |>
SparkR::saveAsTable("sandbox.wilcox_lab.degauss_geocoder_my_address_file", "delta", "overwrite")

# create user defined function (udf) version of geocode() so that it can be applied to a pyspark dataframe
geocode <- function(df) {
  df |> 
    purrr::pmap(\(id, address) {
      result <- system2("ruby", args = c("/app/geocode.rb", shQuote(address)), stdout = TRUE, stderr = FALSE) |>
      jsonlite::fromJSON()
    
      tibble::tibble(id, address) |>
        dplyr::bind_cols(result)
    }) |>
  purrr::list_rbind()
}

# resulting schema after dapply() geocode()
schema <- SparkR::structType(
  SparkR::structField("id", "string"), 
  SparkR::structField("address", "string"),
  SparkR::structField("street", "string"),
  SparkR::structField("zip", "string"),
  SparkR::structField("city", "string"),
  SparkR::structField("state", "string"),
  SparkR::structField("lat", "double"),
  SparkR::structField("lon", "double"),
  SparkR::structField("fips_county", "string"),
  SparkR::structField("score", "double"),
  SparkR::structField("prenum", "string"),
  SparkR::structField("number", "string"),
  SparkR::structField("precision", "string")
)

# process the data without ever leaving spark
SparkR::sql("SELECT * FROM sandbox.wilcox_lab.degauss_geocoder_my_address_file;") |>
SparkR::dapply(geocode, schema) |>
SparkR::saveAsTable("sandbox.wilcox_lab.degauss_geocoder_my_address_file_out", "delta", "overwrite")
```

</details>

<details>

<summary>Python</summary>

## Read and Write CSV

```
%python

import urllib.request
import json
import subprocess
import pandas as pd

csv_in = "/Workspace/Users/schuelke@wustl.edu/my_address_file.csv"
csv_out = "/Workspace/Users/schuelke@wustl.edu/my_address_file_out.csv"

# download an example csv input file
urllib.request.urlretrieve(
    "https://raw.githubusercontent.com/degauss-org/geocoder/master/test/my_address_file.csv", 
    csv_in
)

# read the example csv input file
df = pd.read_csv(csv_in)

# define a geocoding function
def geocode(address):
    """
    Geocode an address using DeGAUSS Geocoder.

    Parameters
    ----------
    address : string
        The address to code
    
    Returns
    -------
    a list [] of zero or more dictionaries {x:y}
        geocode information
    """

    try:
        result = json.loads(subprocess.run(["ruby", "/app/geocode.rb", address], capture_output=True).stdout.decode())
    except Exception as e:
        result = json.loads('[{"error":"' + str(e) + '"}]')

    return(result)

# apply the geocoding function to the address column
df['json'] = df['address'].apply(geocode)

# expand data longer (some addresses will return multiple geocode results)
df = df.drop(columns = ['json']).join(df['json'].explode().to_frame())

# expand data wider
df = df.drop(columns = ['json']).join(pd.json_normalize(df['json']))

# write data out
df.to_csv(csv_out)
```

## Read and Write Data Lake

```
%python

import urllib.request
import json
import subprocess
from pyspark.sql.functions import col, udf, explode
from pyspark.sql.types import ArrayType, MapType, StringType

# download an example csv input file
urllib.request.urlretrieve(
    "https://raw.githubusercontent.com/degauss-org/geocoder/master/test/my_address_file.csv", 
    "/Workspace/Users/schuelke@wustl.edu/my_address_file.csv"
)

# read the example csv input file and write to lake
(
    spark
    .read
    .format("csv")
    .option("header", True)
    .load("file:/Workspace/Users/schuelke@wustl.edu/my_address_file.csv") # path must be absolute
    .writeTo("sandbox.wilcox_lab.degauss_geocoder_my_address_file")
    .createOrReplace()
)

# define a geocoding function
def geocode(address):
    """
    Geocode an address using DeGAUSS Geocoder.

    Parameters
    ----------
    address : string
        The address to code
    
    Returns
    -------
    a list [] of zero or more dictionaries {x:y}
        geocode information
    """

    try:
        result = json.loads(subprocess.run(["ruby", "/app/geocode.rb", address], capture_output=True).stdout.decode())
    except Exception as e:
        result = json.loads('[{"error":"' + str(e) + '"}]')

    return(result)

# create user defined function (udf) version of geocode() so that it can be applied to a pyspark dataframe
geocodeUDF = udf(lambda x:geocode(x), ArrayType(MapType(StringType(), StringType())))

# process the data without ever leaving spark
(
    spark
    .sql("SELECT * FROM sandbox.wilcox_lab.degauss_geocoder_my_address_file")
    .withColumn("geocode_results", geocodeUDF(col("address")))
    # expand data longer (some addresses will return multiple geocode results)
    .withColumn("geocode_results", explode(col("geocode_results")))
    # expand data wider
    .withColumn("street", col("geocode_results")["street"])
    .withColumn("zip", col("geocode_results")["zip"])
    .withColumn("city", col("geocode_results")["city"])
    .withColumn("state", col("geocode_results")["state"])
    .withColumn("lat", col("geocode_results")["lat"])
    .withColumn("lon", col("geocode_results")["lon"])
    .withColumn("fips_county", col("geocode_results")["fips_county"])
    .withColumn("score", col("geocode_results")["score"])
    .withColumn("prenum", col("geocode_results")["prenum"])
    .withColumn("number", col("geocode_results")["number"])
    .withColumn("precision", col("geocode_results")["precision"])
    .withColumn("error", col("geocode_results")["error"])
    # geocode_results are no longer needed
    .drop("geocode_results")
    .writeTo("sandbox.wilcox_lab.degauss_geocoder_my_address_file_out")
    .createOrReplace()
)
```

</details>

<details>

<summary>Scala</summary>

## Read and Write CSV

```
%scala

/**
 * Cleans up the output files of Spark dataframe.coalesce(1).write()<...>.csv("path")
 *
 * <p>After a Spark dataframe.coalesce(1).write()<...>.csv("path") call, this function:
 *   <ol>
 *     <li>copies the single CSV file from the output directory to the parent directory with a name matching the original directory name</li>
 *     <li>removes the accompanying CRC file</li>
 *     <li>removes the directory</li>
 *   </ol>
 * </p>
 *
 * @param directory   absolute path to the directory where the dataframe was written
 * @return            Map of logicals indicating if the CSV file copy, CRC file removal, and directory removal succeeded
 *
 * {@snippet :
 * val d = "file:/Workspace/Users/schuelke@wustl.edu/df"
 * 
 * sc
 *   .parallelize(List( (1, "a"), (2, "b") ))
 *   .toDF("key", "value")
 *   .coalesce(1)
 *   .write
 *   .mode("overwrite")
 *   .option("header", "true")
 *   .csv(d)
 * 
 * cleanWriteCsv(d)
 * }
 */
def cleanWriteCsv(directory: String): Map[String, Boolean] = {
  var cpCsvResult = false
  var rmCrcResult = false
  var rmDirResult = false
  
  var nCsv = 0
  for(file <- dbutils.fs.ls(directory)) {
    if (file.name.endsWith(".csv")) {
      nCsv += 1
    }
  }

  if (nCsv == 0) {
    throw new Exception("No CSV file found in " + directory)
  } else if (nCsv > 1) {
    throw new Exception("Multiple CSV files found in " + directory)
  } else {
    val parentDirectory = java.nio.file.Paths.get(directory).getParent().toString()
    val csvFileNameSansExtension = java.nio.file.Paths.get(directory).getFileName().toString()
    val csvFilePath = java.nio.file.Paths.get(parentDirectory, csvFileNameSansExtension + ".csv").toString()
    val crcFilePath = java.nio.file.Paths.get(parentDirectory, "." + csvFileNameSansExtension + ".csv.crc").toString()
    
    for(file <- dbutils.fs.ls(directory)) {
      if (file.name.endsWith(".csv")) {
        cpCsvResult = dbutils.fs.cp(file.path, csvFilePath)
        rmCrcResult = dbutils.fs.rm(crcFilePath)
      }
    }
    
    rmDirResult = dbutils.fs.rm(directory, recurse = true)
    
    return(Map("cpCsvResult" -> cpCsvResult, "rmCrcResult" -> rmCrcResult, "rmDirResult" -> rmDirResult))
  }
}
```

```
%scala

import java.io.File
import java.net.URL
import org.apache.commons.io.FileUtils
import org.apache.spark.sql.functions.{col, explode, from_json, udf}
import org.apache.spark.sql.types.{ArrayType, MapType, StringType, StructType}
import scala.sys.process._

// download an example csv input file
FileUtils.copyURLToFile(
  new URL("https://raw.githubusercontent.com/degauss-org/geocoder/master/test/my_address_file.csv"), 
  new File("/Workspace/Users/schuelke@wustl.edu/my_address_file.csv")
)

// define a geocoding function
def geocode(x: String): String = {
  try {
    val command = Seq("ruby", "/app/geocode.rb", x)
    command.!!
  } catch {
    case e: Exception => "[{\"error\":\"" + e.getMessage() + "\"}]"
  }
}

// create user defined function (udf) version of geocode() so that it can be applied to a spark dataframe
val geocodeUDF = udf((x: String) => geocode(x))

// read the example csv input file
spark
  .read
  .format("csv")
  .option("header", "true")
  .load("file:/Workspace/Users/schuelke@wustl.edu/my_address_file.csv") // path must be absolute
  // apply the geocoding function to the address column
  .withColumn("geocode_results", geocodeUDF(col("address")))
  // cast the json string to an array of maps
  .withColumn("geocode_results", from_json(col("geocode_results"), ArrayType(MapType(StringType, StringType))))
  // expand data longer (some addresses will return multiple geocode results)
  .withColumn("geocode_results", explode(col("geocode_results")))
  // expand data wider
  .withColumn("street", col("geocode_results.street"))
  .withColumn("zip", col("geocode_results.zip"))
  .withColumn("city", col("geocode_results.city"))
  .withColumn("state", col("geocode_results.state"))
  .withColumn("lat", col("geocode_results.lat"))
  .withColumn("lon", col("geocode_results.lon"))
  .withColumn("fips_county", col("geocode_results.fips_county"))
  .withColumn("score", col("geocode_results.score"))
  .withColumn("prenum", col("geocode_results.prenum"))
  .withColumn("number", col("geocode_results.number"))
  .withColumn("precision", col("geocode_results.precision"))
  .withColumn("error", col("geocode_results.error"))
  // geocode_results is no longer needed
  .drop("geocode_results")
  // bring all partitions together to get one output csv
  .coalesce(1)
  // write partitions to a directory
  .write
  .mode("overwrite")
  .option("header", "true")
  .csv("file:/Workspace/Users/schuelke@wustl.edu/my_address_file_out")
```

```
%scala

cleanWriteCsv("file:/Workspace/Users/schuelke@wustl.edu/my_address_file_out")
```

## Read and Write Data Lake

```
%scala

import java.io.File
import java.net.URL
import org.apache.commons.io.FileUtils
import org.apache.spark.sql.functions.{col, explode, from_json, udf}
import org.apache.spark.sql.types.{ArrayType, MapType, StringType, StructType}
import scala.sys.process._

// download an example csv input file
FileUtils.copyURLToFile(
  new URL("https://raw.githubusercontent.com/degauss-org/geocoder/master/test/my_address_file.csv"), 
  new File("/Workspace/Users/schuelke@wustl.edu/my_address_file.csv")
)

// read the example csv input file and write to lake
spark
  .read
  .format("csv")
  .option("header", "true")
  .load("file:/Workspace/Users/schuelke@wustl.edu/my_address_file.csv") // path must be absolute
  .writeTo("sandbox.wilcox_lab.degauss_geocoder_my_address_file")
  .createOrReplace()

// define a geocoding function
def geocode(x: String): String = {
  try {
    val command = Seq("ruby", "/app/geocode.rb", x)
    command.!!
  } catch {
    case e: Exception => "[{\"error\":\"" + e.getMessage() + "\"}]"
  }
}

// create user defined function (udf) version of geocode() so that it can be applied to a spark dataframe
val geocodeUDF = udf((x: String) => geocode(x))

// process the data without ever leaving spark
spark.read.table("sandbox.wilcox_lab.degauss_geocoder_my_address_file")
  // apply the geocoding function to the address column
  .withColumn("geocode_results", geocodeUDF(col("address")))
  // cast the json string to an array of maps
  .withColumn("geocode_results", from_json(col("geocode_results"), ArrayType(MapType(StringType, StringType))))
  // expand data longer (some addresses will return multiple geocode results)
  .withColumn("geocode_results", explode(col("geocode_results")))
  // expand data wider
  .withColumn("street", col("geocode_results.street"))
  .withColumn("zip", col("geocode_results.zip"))
  .withColumn("city", col("geocode_results.city"))
  .withColumn("state", col("geocode_results.state"))
  .withColumn("lat", col("geocode_results.lat"))
  .withColumn("lon", col("geocode_results.lon"))
  .withColumn("fips_county", col("geocode_results.fips_county"))
  .withColumn("score", col("geocode_results.score"))
  .withColumn("prenum", col("geocode_results.prenum"))
  .withColumn("number", col("geocode_results.number"))
  .withColumn("precision", col("geocode_results.precision"))
  .withColumn("error", col("geocode_results.error"))
  // geocode_results is no longer needed
  .drop("geocode_results")
  .writeTo("sandbox.wilcox_lab.degauss_geocoder_my_address_file_out")
  .createOrReplace()
```

</details>