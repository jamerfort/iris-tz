[![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community__iris-tz&metric=alert_status&token=sqb_34e9ceb4b4645334eed851ad51f06b5e46bf27a0)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community__iris-tz)
[![Reliability Rating](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community__iris-tz&metric=reliability_rating&token=sqb_34e9ceb4b4645334eed851ad51f06b5e46bf27a0)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community__iris-tz)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat&logo=AdGuard)](LICENSE)

# tz
An ObjectScript library for handling/converting time zones and timestamps in InterSystems IRIS.

> Time zones are HARD!  Let's make them easy!!!

To learn more about time zones, Daylight Savings Time, offsets and more, check out [Time Zones and Offsets and ObjectScript, Oh My!](./docs/Timezones_and_Offsets.md).

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

## tz.Ens (for Interoperability Rules/DTLs) Basic Usage 
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

## tz.HL7 Basic Usage
```cls
// ConvertTz() Examples
set dt = ##class(tz.HL7).ConvertTz("20200102033045-0500", "America/Chicago")
set dt = ##class(tz.HL7).ConvertTz("20200102033045", "America/New_York", "America/Chicago")
set dt = ##class(tz.HL7).ConvertTz("20200102033045", "America/New_York", "America/Chicago", "HL7Local")
set dt = ##class(tz.HL7).ConvertTz("20200102033045", "America/New_York", "America/Chicago", "HL7WithOffset")
set dt = ##class(tz.HL7).ConvertTz("20200102033045", "America/New_York", "America/Chicago", "%Y-%m-%d %H:%M:%S")

// ToLocal() Examples
set dt = ##class(tz.HL7).ToLocal("20200102033045-0500", "America/Chicago")
set dt = ##class(tz.HL7).ToLocal("20200102033045", "America/Chicago", "America/Denver")

// WithOffset() Examples
set dt = ##class(tz.HL7).WithOffset("20200102033045-0500", "America/Chicago")
set dt = ##class(tz.HL7).WithOffset("20200102033045", "America/Chicago")
set dt = ##class(tz.HL7).WithOffset("20200102033045", "America/Chicago", "America/Denver")

// NowLocal() Example
set dt = ##class(tz.HL7).NowLocal("America/Chicago")

// NowWithOffset() Example
set dt = ##class(tz.HL7).NowWithOffset("America/Chicago")
```

## Prerequisites
- IRIS 2022.1+ (for Embedded Python support)
- Python 3 installed on the system
- Currently only works on UNIX systems

## Installation

There are several methods for installing this library:
1. Import classes directly into IRIS
2. Install the IPM/ZPM package 
3. Docker

### Option 1: Import Classes Directly into IRIS

Download the most recent `exports/tz.Export.xml` from the repository.

Import `tz.Export.xml` into your IRIS instance using the **Import** button found on the **System Operation > Classes** page in your Management Portal.

If you prefer loading `tz.Export.xml` from an IRIS terminal:

```cls
USER>do $system.OBJ.Load("/path/to/tz.Export.xml", "cuk")
```
### Option 2: Install the IPM/ZPM package 

Once package is approved, use `zpm` install the `tz` package:
```cls
USER>zpm

=============================================================================
|| Welcome to the Package Manager Shell (ZPM). version 0.7.4               ||
|| Enter q/quit to exit the shell. Enter ?/help to view available commands ||
|| Current registry https://pm.community.intersystems.com                  ||
=============================================================================
zpm:USER>install tz
```
### Option 3: Docker

If you prefer, you can load the library with docker, run the built-in tests, and experiment with the `tz` classes.

First, download/clone the repo to your local computer:

```bash
git clone git@github.com:jamerfort/iris-tz.git
```
Build and connect to your instance:

```bash
cd ./iris-tz

# Rebuild/start the image
docker compose up --build -d

# Connect to your instance
docker exec -it iris-tz iris terminal IRIS

# Stop your containers
docker compose down 
```
## Verify/Test Installation

Run tests from your iris terminal:
```cls
// Built-in Tests
USER>do ##class(tz.TZ).Test()
116 Tests Successful!

// Experiment with the API
USER>zw ##class(tz.HL7).ConvertTz("20240102033045-0500", "America/New_York")
"20240102033045-0500"
```

If you are using Docker or have a copy of the repo, you can reload changes to the `tz` source code from your iris terminal:

```cls
USER>do $system.OBJ.LoadDir("/home/irisowner/dev/src", "cuk",,1)

Load of directory started on 12/14/2024 00:40:14
Loading file /home/irisowner/dev/src/cls/tz/HL7.cls as cls
Imported class: tz.HL7
Loading file /home/irisowner/dev/src/cls/tz/TZ.cls as cls
Imported class: tz.TZ
Loading file /home/irisowner/dev/src/cls/tz/internal.cls as cls
Imported class: tz.internal
Loading file /home/irisowner/dev/src/cls/tz/Tests.cls as cls
Imported class: tz.Tests
Class tz.HL7 is up-to-date.
Class tz.TZ is up-to-date.
Class tz.Tests is up-to-date.
Class tz.internal is up-to-date.
Load finished successfully.
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

## Ens (for Interoperability Rules/DTLs) Date/Datetime Conversion - `##class(tz.Ens)`

The `tz.Ens` class provides several methods for converting HL7-formatted dates/datetimes to the desired timezone and/or format.  These methods are exposed to Interoperability Rules/DTLs:

1. `TZ()` converts HL7-formatted dates/datetimes to the desired timezone and/or format.
    - See [docs/tz.Ens.md](./docs/tz.Ens.md)

2. `TZLocal()` converts HL7-formatted dates/datetimes to the desired local time.
    - See [docs/tz.Ens.md](./docs/tz.Ens.md)

3. `TZOffset()` converts HL7-formatted dates/datetimes to the desired datetime with timezone offset.
    - See [docs/tz.Ens.md](./docs/tz.Ens.md)


## HL7 Date/Datetime Conversion - `##class(tz.HL7)`

The `tz.HL7` class provides several methods for converting HL7-formatted dates/datetimes to the desired timezone and/or format:

1. `ConvertTz()` converts HL7-formatted dates/datetimes to the desired timezone and/or format.
    - See [docs/tz.HL7.ConvertTz.md](./docs/tz.HL7.ConvertTz.md)

2. `ToLocal()` converts HL7-formatted dates/datetimes to the desired timezone with a format of `YYYYMMDDHHMMSS`.
    - See [docs/tz.HL7.ToLocal.md](./docs/tz.HL7.ToLocal.md)

3. `WithOffset()` converts HL7-formatted dates/datetimes to the desired timezone with a format of `YYYYMMDDHHMMSS±zzzz`.
    - See [docs/tz.HL7.WithOffset.md](./docs/tz.HL7.WithOffset.md)

4. `NowLocal()` returns the current local time for the given timezone with a format of `YYYYMMDDHHMMSS`.
    - See [docs/tz.HL7.NowLocal.md](./docs/tz.HL7.NowLocal.md)

5. `NowWithOffset()` returns the current time with an offset for the given timezone with a format of `YYYYMMDDHHMMSS±zzzz`.
    - See [docs/tz.HL7.NowWithOffset.md](./docs/tz.HL7.NowWithOffset.md)

## Base TZ Date/Datetime Conversion - `##class(tz.TZ)`

The `tz.TZ` class provides the base `Convert()` method used by the other classes (such as `tz.HL7` and `tz.Ens`).  If the `tz.HL7` and `tz.Ens` classes do not provide the needed functionality, most likely, `##class(tz.TZ).Convert()` can be used to accomplish your goals.

See [docs/tz.TZ.Convert.md](./docs/tz.TZ.Convert.md)


