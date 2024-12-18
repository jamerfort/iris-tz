# `##class(tz.TZ).Convert()`

`Convert()` transforms the given datetime string (in the given timezone) to a desired format/timezone.

### `##class(tz.TZ).Convert`(pDt, pTz, pFormat = "", pDestFormat = "", pDestTz = "", Output pStatus As %Status, pErrOutput As %String = "{do not convert}") As %String

#### Arguments:

| Argument         | Description                                                               | Examples                                                |
|----------        |-------------                                                              |----------                                               |
| pDt              | The source date/datetime                                    | "2024-01-02 03:30:45 -0600"                                   |
| pTz              | The source timezone. If pDestTz is not provided, pTz will be targeted.    | "America/New_York", "America/Los_Angeles"               |
| pFormat=""       | The source format. If blank, attempt to dynamically determine the format. | "", "%Y%m%d%H%M%S"                                      |
| pDestFormat=""   | The target format. If blank, match the source format.                     | "%Y-%m-%d %H:%M:%S %z"                                  |
| pDestTz=pTz      | The target timezone. If blank, use pTz.                                   | "America/New_York", "America/Los_Angeles"               |
| *Output* pStatus | Reference to a new %Status variable                                       | .tSC                                                    |
| pErrOutput=pDt   | Value to return on error.  By default, do not convert and return pDt.  | "", "00000000000000", "\<ERROR\>"                         |

#### Result:
Return the transformed date/datetime string.

#### Examples:

```cls
# Convert a datetime with offset to a desired time zone:
USER>zw ##class(tz.TZ).Convert("2020-07-01 12:30:10 -0400", "America/Chicago")
"2020-07-01 11:30:10 -0500"

USER>zw ##class(tz.TZ).Convert("2020-07-01 12:30:10 -0500", "America/Chicago")
"2020-07-01 12:30:10 -0500"

# Convert a local datetime from one time zone to another:
USER>zw ##class(tz.TZ).Convert("2020-07-01 12:30:10", "America/Chicago", "", "", "America/New_York")
"2020-07-01 13:30:10"

# Change the format of a datetime:
USER>zw ##class(tz.TZ).Convert("2020-07-01 12:30:10", "America/Chicago", "", "%m/%d/%Y %H:%M:%S %z")
"07/01/2020 12:30:10 -0500"

# Change the format and time zone of a datetime:
USER>zw ##class(tz.TZ).Convert("2020-07-01 12:30:10", "America/Chicago", "", "%m/%d/%Y %H:%M:%S %z", "America/New_York")
"07/01/2020 13:30:10 -0400"
```

#### Supported Input Formats:

If `Convert()` is not provided a value for the `pFormat` argument, it attempts to match the given date/datetime to several datetime formats:

__full date/times:__

| Format | Example |
| ------ | ------- |
| %Y%m%d%H%M%S%z | 20240102153045-0400 |
| %Y%m%d%H%M%S | 20240102153045 |
| %Y-%m-%dT%H:%M:%S | 2024-01-02T15:30:45 |
| %Y-%m-%dT%H:%M:%SZ | 2024-01-02T15:30:45Z |
| %Y-%m-%dT%H:%M:%S%z | 2024-01-02T15:30:45-0400 |
| %Y%m%dT%H%M%S | 20240102T153045 |
| %Y%m%dT%H%M%SZ | 20240102T153045Z |
| %Y%m%dT%H%M%S%z | 20240102T153045-0400 |
| %Y-%m-%d %H:%M:%S %z | 2024-01-02 15:30:45 -0400 |
| %Y-%m-%d %H:%M:%S | 2024-01-02 15:30:45 |
| %m/%d/%Y %H:%M:%S %z | 01/02/2024 15:30:45 -0400 |
| %m/%d/%Y %H:%M:%S | 01/02/2024 15:30:45 |
| %Y-%m-%d %I:%M:%S %p %z | 2024-01-02 03:30:45 PM -0400 |
| %Y-%m-%d %I:%M:%S %p | 2024-01-02 03:30:45 PM |
| %m/%d/%Y %I:%M:%S %p %z | 01/02/2024 03:30:45 PM -0400 |
| %m/%d/%Y %I:%M:%S %p | 01/02/2024 03:30:45 PM |


__date/times (no secconds):__
| Format | Example |
| ------ | ------- |
| %Y-%m-%dT%H:%M | 2024-01-02T15:30 |
| %Y-%m-%dT%H:%MZ | 2024-01-02T15:30Z |
| %Y-%m-%dT%H:%M%z | 2024-01-02T15:30-0400 |
| %Y%m%dT%H%M | 20240102T1530 |
| %Y%m%dT%H%MZ | 20240102T1530Z |
| %Y%m%dT%H%M%z | 20240102T1530-0400 |
| %Y-%m-%d %H:%M %z | 2024-01-02 15:30 -0400 |
| %Y-%m-%d %H:%M | 2024-01-02 15:30 |
| %m/%d/%Y %H:%M %z | 01/02/2024 15:30 -0400 |
| %m/%d/%Y %H:%M | 01/02/2024 15:30 |
| %Y-%m-%d %I:%M %p %z | 2024-01-02 03:30 PM -0400 |
| %Y-%m-%d %I:%M %p | 2024-01-02 03:30 PM |
| %m/%d/%Y %I:%M %p %z | 01/02/2024 03:30 PM -0400 |
| %m/%d/%Y %I:%M %p | 01/02/2024 03:30 PM |


__date-only:__
| Format | Example |
| ------ | ------- |
| %Y-%m-%d | 2024-01-02 |
| %m/%d/%Y | 01/02/2024 |


If an error occurs:
- set pStatus to the error
- return pErrOutput if populated
- If pErrOutput is not set, return pDt.

#### Output Formats:

If pDestFormat is blank, use the same format as the pDt input.