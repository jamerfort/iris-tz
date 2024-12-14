# `##class(tz.HL7).NowLocal()`

`NowLocal()` returns the current local time for the given timezone with a format of `YYYYMMDDHHMMSS`.

See `##class(tz.HL7).ConvertTz()` for more details on formats, timezones, etc.

### `##class(tz.HL7).NowLocal`(pTz As %String) As %String

#### Arguments:

| Argument         | Description                                                            | Examples                                                |
|----------        |-------------                                                           |----------                                               |
| pTz              | The source timezone.| "America/New_York", "America/Los_Angeles"               |

#### Result:
Return the current local time for the given timezone.

#### Examples:

```cls
USER>zw ##class(tz.HL7).NowLocal("America/Chicago")
"20200102023045"
```