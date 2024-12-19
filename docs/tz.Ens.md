# `##class(tz.Ens)`

`TZ()` converts HL7-formatted dates/datetimes to the desired timezone and/or format.

`TZLocal()` converts HL7-formatted dates/datetimes to the desired local time.

`TZOffset()` converts HL7-formatted dates/datetimes to the desired datetime with timezone offset.

The `tz.Ens` class extends `Ens.Rule.FunctionSet` to make `TZ()`, `TZLocal()`, and `TZOffset` available in Rules and DTLs.

These methods call `##class(tz.HL7).ConvertTz()`.  See `tz.HL7` docs for more details.

## Examples:

```cls
// Convert local time from one timezone to another 	 
set datetime = "20240102033045"
set newDatetime = ##class(tz.Ens).TZ(datetime,"America/New_York","America/Chicago")

// Convert local time to offset 	 
set datetime = "20240102033045"
set newDatetime = ##class(tz.Ens).TZOffset(datetime,"America/Chicago","America/New_York")

// Convert offset to local time 	 
set datetime = "20240102033045-0500"
set newDatetime = ##class(tz.Ens).TZLocal(datetime,"America/Chicago")

// Convert to a non-HL7 format 	 
set datetime = "20240102033045-0500"
set newDatetime = ##class(tz.Ens).TZ(datetime,"America/Chicago",,"%m/%d/%Y %H:%M:%S %z")
```

## Supported Input Formats:

The `tz.Ens` methods use the date/datetime input formats supported by `##class(tz.HL7).ConvertTz()`.

In general, this library defines valid HL7 dates/datetimes with the following formats:

- YYYYmmddHHMMSS±zzzz
- YYYYmmddHHMM±zzzz
- YYYYmmddHH±zzzz
- YYYYmmddHHMMSSZ
- YYYYmmddHHMMZ
- YYYYmmddHHZ
- YYYYmmddHHMMSS
- YYYYmmddHHMM
- YYYYmmddHH
- YYYYmmdd
- YYYYmm
- YYYY
- [BLANK]

Since the following values/formats do not have time-parts (i.e. hour, minute, etc.), they are returned as-is from `ConvertTz()`:
- Blank values
- YYYYMMDD
- YYYYMM
- YYYY

If the input is not a valid HL7 date/datetime:
- If `strict` is 0, allow `##class(tz.Tz).Convert()` to attempt to parse the input.
- If `strict` is 1, process errorValue, as mentioned next.

If an error occurs:
- return `errorValue` if populated
- If `errorValue` is not set, return `datetime`.

## `##class(tz.Ens).TZ`(datetime, tz, desiredTz="", desiredFormat="", errorValue As %String, strict As %Boolean = 0) as %String

`TZ()` converts HL7-formatted dates/datetimes to the desired timezone and/or format.  By default, the output is formatted with the same format as the input.

#### Arguments:

| Argument         | Description                                                            | Examples                                                |
|----------        |-------------                                                           |----------                                               |
| datetime         | The source date/datetime in HL7 format (see "Supported Input Formats" above)   | "20240102033045-0600"                                   |
| tz               | The source timezone. If desiredTz is not provided, tz will be targeted.| "America/New_York", "America/Los_Angeles"               |
| desiredTz=tz     | The target timezone. If blank, use tz.                                 | "America/New_York", "America/Los_Angeles"               |
| desiredFormat="" | The target format. If blank, try to match the source format.           | "HL7Local", "HL7withOffset", "", "%Y-%m-%d %H:%M:%S %z" |
| errorValue       | Value to return on error.  By default, return original datetime value. | "", "00000000000000"                                    |
| strict=0         | If 1 (strict), error if not HL7 format. If 0 (not strict), allow tz.Tz to attempt to parse.| 0, 1                             |

#### Result:
Return the converted HL7 date/datetime string. If an error occurs, `errorValue` is used to determine result. (See below)

If `desiredFormat` is blank, use the same format as the `datetime` input.

If `desiredFormat` is "HL7Local", use the "%Y%m%d%H%M%S" format.

If `desiredFormat` is "HL7WithOffset", use the "%Y%m%d%H%M%S%z" format.


## `##class(tz.Ens).TZLocal`(datetime, tz, desiredTz="", errorValue As %String, strict As %Boolean = 0) as %String

`TZLocal()` converts HL7-formatted dates/datetimes to the desired local time. Output format: `YYYYMMDDHHMMSS`

#### Arguments:

| Argument         | Description                                                            | Examples                                                |
|----------        |-------------                                                           |----------                                               |
| datetime         | The source date/datetime in HL7 format (see "Supported Input Formats" above)   | "20240102033045-0600"                                   |
| tz               | The source timezone. If desiredTz is not provided, tz will be targeted.| "America/New_York", "America/Los_Angeles"               |
| desiredTz=tz     | The target timezone. If blank, use tz.                                 | "America/New_York", "America/Los_Angeles"               |
| errorValue       | Value to return on error.  By default, return original datetime value. | "", "00000000000000"                                    |
| strict=0         | If 1 (strict), error if not HL7 format. If 0 (not strict), allow tz.Tz to attempt to parse.| 0, 1                             |

#### Result:
Return the converted HL7 date/datetime string (`YYYYMMDDHHMMSS`). If an error occurs, `errorValue` is used to determine result. (See below)

## `##class(tz.Ens).TZOffset`(datetime, tz, desiredTz="", errorValue As %String, strict As %Boolean = 0) as %String

`TZOffset()` converts HL7-formatted dates/datetimes to the desired datetime with timezone offset.  Output format: `YYYYMMDDHHMMSS±zzzz`.

#### Arguments:

| Argument         | Description                                                            | Examples                                                |
|----------        |-------------                                                           |----------                                               |
| datetime         | The source date/datetime in HL7 format (see "Supported Input Formats" above)   | "20240102033045-0600"                                   |
| tz               | The source timezone. If desiredTz is not provided, tz will be targeted.| "America/New_York", "America/Los_Angeles"               |
| desiredTz=tz     | The target timezone. If blank, use tz.                                 | "America/New_York", "America/Los_Angeles"               |
| errorValue       | Value to return on error.  By default, return original datetime value. | "", "00000000000000"                                    |
| strict=0         | If 1 (strict), error if not HL7 format. If 0 (not strict), allow tz.Tz to attempt to parse.| 0, 1                             |

#### Result:
Return the converted HL7 date/datetime string (`YYYYMMDDHHMMSS±zzzz`). If an error occurs, `errorValue` is used to determine result. (See below)