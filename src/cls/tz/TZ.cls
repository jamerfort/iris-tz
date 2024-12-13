/// TODO: Document
Class tz.TZ
{

/// Description
ClassMethod Test() As %Status
{
  return ##class(tz.Tests).Run()
}

ClassMethod DetermineFormat(pDt, pTz As %String = "") As %String [ Internal ]
{
  // TODO: Handle m/d/y vs. y/d/m vs. d/m/y
  set formats = $LISTBUILD(
    // full date/time
    $LB("%Y%m%d%H%M%S%z"),
    $LB("%Y%m%d%H%M%S"),

    $LB("%Y-%m-%dT%H:%M:%S"),
    $LB("%Y-%m-%dT%H:%M:%SZ", "", "UTC"),
    $LB("%Y-%m-%dT%H:%M:%S%z"),
    $LB("%Y%m%dT%H%M%S"),
    $LB("%Y%m%dT%H%M%SZ", "", "UTC"),
    $LB("%Y%m%dT%H%M%S%z"),

    $LB("%Y-%m-%d %H:%M:%S %z"),
    //$LB("%Y-%m-%d %H:%M:%S %Z"),
    $LB("%Y-%m-%d %H:%M:%S"),

    $LB("%m/%d/%Y %H:%M:%S %z"),
    //$LB("%m/%d/%Y %H:%M:%S %Z"),
    $LB("%m/%d/%Y %H:%M:%S"),

    $LB("%Y-%m-%d %I:%M:%S %p %z"),
    //$LB("%Y-%m-%d %I:%M:%S %p %Z"),
    $LB("%Y-%m-%d %I:%M:%S %p"),

    $LB("%m/%d/%Y %I:%M:%S %p %z"),
    //$LB("%m/%d/%Y %I:%M:%S %p %Z"),
    $LB("%m/%d/%Y %I:%M:%S %p"),

    // no seconds
    $LB("%Y-%m-%dT%H:%M"),
    $LB("%Y-%m-%dT%H:%MZ", "", "UTC"),
    $LB("%Y-%m-%dT%H:%M%z"),
    $LB("%Y%m%dT%H%M"),
    $LB("%Y%m%dT%H%MZ", "", "UTC"),
    $LB("%Y%m%dT%H%M%z"),

    $LB("%Y-%m-%d %H:%M %z"),
    //$LB("%Y-%m-%d %H:%M %Z"),
    $LB("%Y-%m-%d %H:%M"),

    $LB("%m/%d/%Y %H:%M %z"),
    //$LB("%m/%d/%Y %H:%M %Z"),
    $LB("%m/%d/%Y %H:%M"),

    $LB("%Y-%m-%d %I:%M %p %z"),
    //$LB("%Y-%m-%d %I:%M %p %Z"),
    $LB("%Y-%m-%d %I:%M %p"),

    $LB("%m/%d/%Y %I:%M %p %z"),
    //$LB("%m/%d/%Y %I:%M %p %Z"),
    $LB("%m/%d/%Y %I:%M %p"),

    // date-only
    $LB("%Y-%m-%d", "", "", "<DATEONLY>"),
    $LB("%m/%d/%Y", "", "", "<DATEONLY>"),
  )

  set numFormats = $LISTLENGTH(formats)
  for i=1:1:numFormats {
    set patternAndFmt = $LISTGET(formats, i)

    if patternAndFmt = "" {
      continue
    }

    set fmt = $LISTGET(patternAndFmt, 1)
    set pattern = $LISTGET(patternAndFmt, 2)
    set tz = $LISTGET(patternAndFmt, 3)
    set dateOnly = $LISTGET(patternAndFmt, 4)

    if pattern = "" {
      set pattern = ..fmtToPattern(fmt)
    }

    if tz = "" {
      set tz = pTz
    }

    if $MATCH(pDt, pattern) {
      return $LB(fmt, tz, dateOnly)
    }
  }
  return ""
}

ClassMethod fmtToPattern(fmt As %String) As %String [ Internal ]
{
  set rslt = fmt

  // We only need the patterns used in DetermineFormat above...
  //    %d,%H %m,%M %p,%S %Y,%z

  //set rslt = $REPLACE(rslt, "%c", "%a %b %d %X %Y")
  //set rslt = $REPLACE(rslt, "%x", "%m/%d/%y")
  //set rslt = $REPLACE(rslt, "%X", "%H:%M:%S")

  //set rslt = $REPLACE(rslt, "%a", "[a-zA-Z]+")
  //set rslt = $REPLACE(rslt, "%A", "[a-zA-Z]+")
  //set rslt = $REPLACE(rslt, "%b", "[a-zA-Z]+")
  //set rslt = $REPLACE(rslt, "%B", "[a-zA-Z]+")
  set rslt = $REPLACE(rslt, "%d", "[0123]?[0-9]")
  //set rslt = $REPLACE(rslt, "%f", "[0-9]{6}")
  set rslt = $REPLACE(rslt, "%H", "[0123]?[0-9]")
  set rslt = $REPLACE(rslt, "%I", "[01]?[0-9]")
  //set rslt = $REPLACE(rslt, "%j", "[0-9]{1,3}")
  set rslt = $REPLACE(rslt, "%m", "[01]?[0-9]")
  set rslt = $REPLACE(rslt, "%M", "[0-5][0-9]")
  set rslt = $REPLACE(rslt, "%p", "(AM|PM|am|pm)")
  set rslt = $REPLACE(rslt, "%S", "[0-5][0-9]")
  //set rslt = $REPLACE(rslt, "%U", "[0-5][0-9]")
  //set rslt = $REPLACE(rslt, "%u", "[1-7]")
  //set rslt = $REPLACE(rslt, "%w", "[0-6]")
  //set rslt = $REPLACE(rslt, "%W", "[0-5][0-9]")
  //set rslt = $REPLACE(rslt, "%y", "[0-9]{2}")
  set rslt = $REPLACE(rslt, "%Y", "[0-9]{4}")
  set rslt = $REPLACE(rslt, "%z", "[+-][0-9]{2,4}")
  //set rslt = $REPLACE(rslt, "%Z", "[a-zA-Z]+")
  //set rslt = $REPLACE(rslt, "%G", "[0-9]{4}")
  //set rslt = $REPLACE(rslt, "%V", "[0-5][0-9]")
  set rslt = $REPLACE(rslt, "%%", "[%]")

  return "^"_rslt_"$"
}

ClassMethod Convert(pDt, pSrcTz, pSrcFormat = "", pDestFormat = "", pDestTz = "", Output pStatus As %Status) As %String
{
  set pStatus = $$$OK

  if (pDt = "") {
    return ""
  }

  // If source format is "", try to determine the matching format.
  // Error if unable to determine format.
  if (pSrcFormat = "") {
    set fmtRslt = ..DetermineFormat(pDt, pSrcTz)
    set pSrcFormat = $LISTGET(fmtRslt, 1)
    set pSrcTz = $LISTGET(fmtRslt, 2)
    set dateOnly = $LISTGET(fmtRslt, 3)

    // TODO: What if the input is only a date?

    if pSrcFormat = "" {
      set pStatus = $$$ERROR($$$GeneralError, "Unable to determine source format: "_pDt)
      return ""
    }
  }

  // If no dest format is provided, use the source format.
  if (pDestFormat = "") {
    set pDestFormat = pSrcFormat
  }

  // If no dest tz is provided, use the source tz.
  if (pDestTz = "") {
    set pDestTz = pSrcTz
  }

  try {
    set rslt = ##class(tz.internal).convertTZ(pDt, pSrcTz, pSrcFormat, pDestFormat, pDestTz)
  }
  catch ex {
    set pStatus = ex.AsStatus()
    set rslt = ""
  }

  quit rslt
}

}

