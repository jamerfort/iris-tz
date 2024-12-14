# `##class(tz.HL7).ConvertTz()`

`ConvertTz()` converts HL7-formatted dates/datetimes to the desired timezone and/or format.

### `##class(tz.HL7).ConvertTz()`(pDt, pTz, pDestTz="", pDestFormat As %String = "", Output pStatus As %Status, pErrOutput As %String = "{do not convert}", pStrict As %Boolean = 0) as %String


#### Arguments:

| Argument         | Description                                                            | Examples                                                |
|----------        |-------------                                                           |----------                                               |
| pDt              | The source date/datetime in HL7 format                                 | "20240102033045-0600"                                   |
| pTz              | The source timezone. If pDestTz is not provided, pTz will be targeted. | "America/New_York", "America/Los_Angeles"               |
| pDestTz=pTz      | The target timezone. If blank, use pTz.                                | "America/New_York", "America/Los_Angeles"               |
| pDestFormat=""   | The target format. If blank, try to match the source format.           | "HL7Local", "HL7withOffset", "", "%Y-%m-%d %H:%M:%S %z" |
| *Output* pStatus | Reference to a new %Status variable                                    | .tSC                                                    |
| pErrOutput=pDt   | Value to return on error.  By default, do not convert and return pDt.  | "", "00000000000000"                                    |
| pStrict=0        | If 1 (strict), error if not HL7 format. If 0 (not strict), allow tz.Tz to attempt to parse.| 0, 1                             |

#### Result:
Return the converted HL7 date/datetime string.  If an error occurs, pErrOutput is used to determine result. (See below)

#### Examples:

```cls
USER>zw ##class(tz.HL7).ConvertTz("20200102033045-0500", "America/Chicago")
"20200102023045-0600"

USER>zw ##class(tz.HL7).ConvertTz("20200102033045", "America/New_York", "America/Chicago")
20200102023045

USER>zw ##class(tz.HL7).ConvertTz("20200102033045", "America/New_York", "America/Chicago", "HL7WithOffset")
"20200102023045-0600"

USER>zw ##class(tz.HL7).ConvertTz("20200102033045-0500", "America/Chicago", "", "HL7Local")
20200102023045

USER>zw ##class(tz.HL7).ConvertTz("20200102033045-0500", "America/Chicago", "", "%Y-%m-%d %H:%M:%S %z")
"2020-01-02 02:30:45 -0600"

USER>zw ##class(tz.HL7).ConvertTz("", "America/Chicago")
""

USER>zw ##class(tz.HL7).ConvertTz("20240102", "America/Chicago")
20240102

USER>zw ##class(tz.HL7).ConvertTz("20240102", "America/Chicago", "America/New_York")
20240102
```

#### Supported Input Formats:

`ConvertTz()` attempts to match the given date/datetime to several HL7 formats.

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
- If pStrict is 0, allow `##class(tz.Tz).Convert()` to attempt to parse the input.
- If pStrict is 1, set pStatus to an error, and process pErrOutput, as mentioned next.

If an error occurs:
- set pStatus to the error
- return pErrOutput if populated
- If pErrOutput is not set, return pDt.

#### Output Formats:

If pDestFormat is blank, use the same format as the pDt input.

If pDestFormat is "HL7Local", use the "%Y%m%d%H%M%S" format.

If pDestFormat is "HL7WithOffset", use the "%Y%m%d%H%M%S%z" format.