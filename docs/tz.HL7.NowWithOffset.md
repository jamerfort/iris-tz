# `##class(tz.HL7).NowWithOffset()`

`NowWithOffset()` returns the current time with an offset for the given timezone with a format of `YYYYMMDDHHMMSS±zzzz` .

See `##class(tz.HL7).ConvertTz()` for more details on formats, timezones, etc.

### `##class(tz.HL7).NowWithOffset`(pTz As %String) As %String

#### Arguments:

| Argument         | Description                                                            | Examples                                                |
|----------        |-------------                                                           |----------                                               |
| pTz              | The source timezone.| "America/New_York", "America/Los_Angeles"               |

#### Result:
Return the current time with an offset for the given timezone.

#### Examples:

```cls
USER>zw ##class(tz.HL7).NowWithOffset("America/Chicago")
"20200102023045-0600"
```