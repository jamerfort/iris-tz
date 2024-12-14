# `##class(tz.HL7).WithOffset()`

`WithOffset()` converts HL7-formatted dates/datetimes to the desired timezone with a format of `YYYYMMDDHHMMSS±zzzz`.

See `##class(tz.HL7).ConvertTz()` for more details on formats, timezones, etc.

### `##class(tz.HL7).WithOffset`(pDt, pTz, pDestTz As %String = "", Output pStatus = "", pErrOutput As %String = "{do not convert}", pStrict As %Boolean = 0) As %String


#### Arguments:

| Argument         | Description                                                            | Examples                                                |
|----------        |-------------                                                           |----------                                               |
| pDt              | The source date/datetime in HL7 format                                 | "20240102033045-0600"                                   |
| pTz              | The source timezone. If pDestTz is not provided, pTz will be targeted. | "America/New_York", "America/Los_Angeles"               |
| pDestTz=pTz      | The target timezone. If blank, use pTz.                                | "America/New_York", "America/Los_Angeles"               |
| *Output* pStatus | Reference to a new %Status variable                                    | .tSC                                                    |
| pErrOutput=pDt   | Value to return on error.  By default, do not convert and return pDt.  | "", "00000000000000"                                    |
| pStrict=0        | If 1 (strict), error if not HL7 format. If 0 (not strict), allow tz.Tz to attempt to parse.| 0, 1                             |

#### Result:
Return the converted HL7 date/datetime string.  If an error occurs, pErrOutput is used to determine result. (See below)

#### Examples:

```cls
USER>zw ##class(tz.HL7).WithOffset("20200102033045-0500", "America/Chicago")
"20200102023045-0600"

USER>zw ##class(tz.HL7).WithOffset("20200102033045", "America/Chicago")
"20200102033045-0600"

USER>zw ##class(tz.HL7).WithOffset("20200102033045", "America/Chicago", "America/Denver")
"20200102023045-0700"
```