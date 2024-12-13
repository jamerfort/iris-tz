[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat&logo=AdGuard)](LICENSE)

# tz
An ObjectScript library for handling/converting time zones and timestamps in InterSystems IRIS.

> Time zones are HARD!  Let's make them easy!!!

### InterSystems "Bringing Ideas to Reality" Contest
This library was originally created/published for the [InterSystems "Bringing Ideas to Reality" Contest](https://community.intersystems.com/post/intersystems-bringing-ideas-reality-contest).

See ["Time zone conversion"](https://ideas.intersystems.com/ideas/DPI-I-601) on the [InterSystems Ideas Portal](https://ideas.intersystems.com/). 

## Description

This ObjectScript library was created to easily handle the formatting and conversion of timestamps from one time zone to another using standard timezones and formatting directives found on most POSIX-based systems.

In general, when working with datetimes, there are two types of datetimes:

1. Absolute Time - i.e. Coordinated Universal Time (UTC)
    - Contains either a timezone specification or offset.
    - All UTC times are relative to time a the Royal Observatory in Greenwich, London (see [Greenwich Mean Time](https://en.wikipedia.org/wiki/Greenwich_Mean_Time)).
    - UTC-0000 is the time at Greenwich
    - UTC-0100 is one hour west of Greenwich
    - UTC+0100 is one hour east of Greenwich

2. Local Time
    - No timezone or offset information is available.

If you know the `Local Time` and a `timezone (or offset)`, you can determine an `Absolute Time`.

You can convert any `Absolute Time` to a `Local Time` for any `timezone` you desire.

This library will help you perform the conversions between various local times and absolute times.

## tz.HL7 Basic Usage
```cls
set dt = ##class(tz.HL7).ConvertTz("20200102033045-0500", "America/Chicago")
set dt = ##class(tz.HL7).ConvertTz("20200102033045", "America/New_York", "America/Chicago")
set dt = ##class(tz.HL7).ConvertTz("20200102033045", "America/New_York", "America/Chicago", "HL7Local")
set dt = ##class(tz.HL7).ConvertTz("20200102033045", "America/New_York", "America/Chicago", "HL7WithOffset")
set dt = ##class(tz.HL7).ConvertTz("20200102033045", "America/New_York", "America/Chicago", "%Y-%m-%d %H:%M:%S")
```

## Prerequisites
- IRIS 2022.1+ (for Embedded Python support)
- Python 3 installed on the system
- Currently only works on UNIX systems

## Installation

Download the most recent `exports/tz.Export.xml` from the repository.

Import `tz.Export.xml` into your IRIS instance using the **Import** button found on the **System Operation > Classes** page in your Management Portal.

If you prefer loading `tz.Export.xml` from an IRIS terminal:

```cls
NAMESPACE>do $system.OBJ.Load("/path/to/tz.Export.xml", "cuk")
```

### Verify/Test Installation

Once you have installed the library as mentioned above, verify your installation using the following commands from IRIS terminal:

```cls
NAMESPACE>do ##class(tz.TZ).Test()
40 Tests Successful!
0 ERRORS
```
## Supported Timezones

This library uses the [IANA timezone database/information](https://www.iana.org/time-zones) installed on your system to perform the necessary timezone conversions.  This database is typically updated whenever you apply operating system patches.

For more information, check out this [Wikipedia page](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).

Examples of valid timezones:

- America/New_York
- US/Eastern
- America/Chicago
- US/Central
- America/Denver
- US/Mountain
- America/Los_Angeles
- US/Pacific
- Europe/Brussels
- CET
- Europe/Athens
- EET

## Supported Datetime Format Codes

This library uses a mixture of python and POSIX/libc calls to parse and format datetimes.  The following format codes should work in most cases:

| Format Code | Description | Examples |
| ----------- | ----------- | -------- |
| %Y | The year, including century | 1999, 2024 |
| %y | The year, without century | 99, 24 |
| %m | The month, zero-padded | 01, 02, ..., 12 |
| %d | The day of the month, zero-padded | 01, 02, ..., 31 |
| %H | The hour, 24-hour clock, zero-padded | 00, 01, ..., 23 |
| %M | The minute, zero-padded | 00, 01, ..., 59 |
| %S | The second, zero-padded | 00, 01, ..., 59 |
| %p | AM or PM | AM, PM |
| %z | The UTC offset, ±HHMM[SS[.ffffff]] | (empty), -0400, -0500, +0000, +0300 |

Though the above format codes likely cover most of your formatting needs, you may find that codes from the following resources may work as well:
- [Python datetime module](https://docs.python.org/3/library/datetime.html#strftime-and-strptime-format-codes)
- [C strptime manpage](https://man7.org/linux/man-pages/man3/strptime.3.html)

## Flexible Datetime Parsing

If an input format is blank or not provided to the `##class(tz.TZ).Convert()` method, the library attempts to determine if the provided datetime string matches one of the following formats (in this order):

- `%Y%m%d%H%M%S%z`
- `%Y%m%d%H%M%S`
- `%Y-%m-%dT%H:%M:%S`
- `%Y-%m-%dT%H:%M:%SZ`
- `%Y-%m-%dT%H:%M:%S%z`
- `%Y%m%dT%H%M%S`
- `%Y%m%dT%H%M%SZ`
- `%Y%m%dT%H%M%S%z`
- `%Y-%m-%d %H:%M:%S %z`
- `%Y-%m-%d %H:%M:%S`
- `%m/%d/%Y %H:%M:%S %z`
- `%m/%d/%Y %H:%M:%S`
- `%Y-%m-%d %I:%M:%S %p %z`
- `%Y-%m-%d %I:%M:%S %p`
- `%m/%d/%Y %I:%M:%S %p %z`
- `%m/%d/%Y %I:%M:%S %p`
- `%Y-%m-%dT%H:%M`
- `%Y-%m-%dT%H:%MZ`
- `%Y-%m-%dT%H:%M%z`
- `%Y%m%dT%H%M`
- `%Y%m%dT%H%MZ`
- `%Y%m%dT%H%M%z`
- `%Y-%m-%d %H:%M %z`
- `%Y-%m-%d %H:%M`
- `%m/%d/%Y %H:%M %z`
- `%m/%d/%Y %H:%M`
- `%Y-%m-%d %I:%M %p %z`
- `%Y-%m-%d %I:%M %p`
- `%m/%d/%Y %I:%M %p %z`
- `%m/%d/%Y %I:%M %p`
- `%Y-%m-%d`
- `%m/%d/%Y`

## HL7 Date/Datetime Conversion - `##class(tz.HL7)`

The `tz.HL7` class provides several methods for converting HL7-formatted dates/datetimes to the desired timezone and/or format:

1. `ConvertTz()` converts HL7-formatted dates/datetimes to the desired timezone and/or format.
    - See [docs/tz.HL7.ConvertTz.md](./docs/tz.HL7.ConvertTz.md)

