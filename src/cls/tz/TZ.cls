/// This class provides the Convert() method, which wraps the tz.internal.convertTZ() method
/// with user-friendly arguments and handling.<br/><br/>
/// 
/// For HL7-specific datetime/timezone handling, see the tz.HL7 class.<br/><br/>
/// 
/// You can call ##class(tz.TZ).Test() to call the various unit tests provided by this package.
Class tz.TZ
{

/// Run all of the unit tests provided with this package.
ClassMethod Test() As %Status
{
  return ##class(tz.Tests).Run()
}

/// Given a datetime and timezone (optional), try to determine the
/// datetime format.
///   
/// If able to determine format, return the following tuple:
///   $LB(fmt, tz, dateOnly)
/// - fmt: the format determined for the datetime
/// - tz: either the original pTz, or a tz determined by the format
/// - dateOnly: is pDt only a date (not a datetime)?  1 or 0
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

/// Given a datetime format (with %Y, %m, etc.), return a
/// regular expression that matches.  Only a subset of
/// patterns are supported.
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

/// <p><code>Convert()</code> transforms the given datetime string (in the given timezone) to a desired format/timezone.</p>
/// <table>
/// <thead>
/// <tr>
/// <th>Argument</th>
/// <th>Description</th>
/// <th>Examples</th>
/// </tr>
/// </thead>
/// <tbody><tr>
/// <td>pDt</td>
/// <td>The source date/datetime</td>
/// <td>&quot;2024-01-02 03:30:45 -0600&quot;</td>
/// </tr>
/// <tr>
/// <td>pTz</td>
/// <td>The source timezone. If pDestTz is not provided, pTz will be targeted.</td>
/// <td>&quot;America/New_York&quot;, &quot;America/Los_Angeles&quot;</td>
/// </tr>
/// <tr>
/// <td>pFormat=&quot;&quot;</td>
/// <td>The source format. If blank, attempt to dynamically determine the format.</td>
/// <td>&quot;&quot;, &quot;%Y%m%d%H%M%S&quot;</td>
/// </tr>
/// <tr>
/// <td>pDestFormat=&quot;&quot;</td>
/// <td>The target format. If blank, match the source format.</td>
/// <td>&quot;%Y-%m-%d %H:%M:%S %z&quot;</td>
/// </tr>
/// <tr>
/// <td>pDestTz=pTz</td>
/// <td>The target timezone. If blank, use pTz.</td>
/// <td>&quot;America/New_York&quot;, &quot;America/Los_Angeles&quot;</td>
/// </tr>
/// <tr>
/// <td><em>Output</em> pStatus</td>
/// <td>Reference to a new %Status variable</td>
/// <td>.tSC</td>
/// </tr>
/// <tr>
/// <td>pErrOutput=pDt</td>
/// <td>Value to return on error.  By default, do not convert and return pDt.</td>
/// <td>&quot;&quot;, &quot;00000000000000&quot;, &quot;&lt;ERROR&gt;&quot;</td>
/// </tr>
/// </tbody></table>
/// <h4>Result:</h4>
/// <p>Return the transformed date/datetime string.</p>
/// <h4>Examples:</h4>
/// <pre><code class="language-cls"># Convert a datetime with offset to a desired time zone:
/// USER&gt;zw ##class(tz.TZ).Convert(&quot;2020-07-01 12:30:10 -0400&quot;, &quot;America/Chicago&quot;)
/// &quot;2020-07-01 11:30:10 -0500&quot;
/// 
/// USER&gt;zw ##class(tz.TZ).Convert(&quot;2020-07-01 12:30:10 -0500&quot;, &quot;America/Chicago&quot;)
/// &quot;2020-07-01 12:30:10 -0500&quot;
/// 
/// # Convert a local datetime from one time zone to another:
/// USER&gt;zw ##class(tz.TZ).Convert(&quot;2020-07-01 12:30:10&quot;, &quot;America/Chicago&quot;, &quot;&quot;, &quot;&quot;, &quot;America/New_York&quot;)
/// &quot;2020-07-01 13:30:10&quot;
/// 
/// # Change the format of a datetime:
/// USER&gt;zw ##class(tz.TZ).Convert(&quot;2020-07-01 12:30:10&quot;, &quot;America/Chicago&quot;, &quot;&quot;, &quot;%m/%d/%Y %H:%M:%S %z&quot;)
/// &quot;07/01/2020 12:30:10 -0500&quot;
/// 
/// # Change the format and time zone of a datetime:
/// USER&gt;zw ##class(tz.TZ).Convert(&quot;2020-07-01 12:30:10&quot;, &quot;America/Chicago&quot;, &quot;&quot;, &quot;%m/%d/%Y %H:%M:%S %z&quot;, &quot;America/New_York&quot;)
/// &quot;07/01/2020 13:30:10 -0400&quot;
/// </code></pre>
/// <h4>Supported Input Formats:</h4>
/// <p>If <code>Convert()</code> is not provided a value for the <code>pFormat</code> argument, it attempts to match the given date/datetime to several datetime formats:</p>
/// <p><strong>full date/times:</strong></p>
/// <table>
/// <thead>
/// <tr>
/// <th>Format</th>
/// <th>Example</th>
/// </tr>
/// </thead>
/// <tbody><tr>
/// <td>%Y%m%d%H%M%S%z</td>
/// <td>20240102153045-0400</td>
/// </tr>
/// <tr>
/// <td>%Y%m%d%H%M%S</td>
/// <td>20240102153045</td>
/// </tr>
/// <tr>
/// <td>%Y-%m-%dT%H:%M:%S</td>
/// <td>2024-01-02T15:30:45</td>
/// </tr>
/// <tr>
/// <td>%Y-%m-%dT%H:%M:%SZ</td>
/// <td>2024-01-02T15:30:45Z</td>
/// </tr>
/// <tr>
/// <td>%Y-%m-%dT%H:%M:%S%z</td>
/// <td>2024-01-02T15:30:45-0400</td>
/// </tr>
/// <tr>
/// <td>%Y%m%dT%H%M%S</td>
/// <td>20240102T153045</td>
/// </tr>
/// <tr>
/// <td>%Y%m%dT%H%M%SZ</td>
/// <td>20240102T153045Z</td>
/// </tr>
/// <tr>
/// <td>%Y%m%dT%H%M%S%z</td>
/// <td>20240102T153045-0400</td>
/// </tr>
/// <tr>
/// <td>%Y-%m-%d %H:%M:%S %z</td>
/// <td>2024-01-02 15:30:45 -0400</td>
/// </tr>
/// <tr>
/// <td>%Y-%m-%d %H:%M:%S</td>
/// <td>2024-01-02 15:30:45</td>
/// </tr>
/// <tr>
/// <td>%m/%d/%Y %H:%M:%S %z</td>
/// <td>01/02/2024 15:30:45 -0400</td>
/// </tr>
/// <tr>
/// <td>%m/%d/%Y %H:%M:%S</td>
/// <td>01/02/2024 15:30:45</td>
/// </tr>
/// <tr>
/// <td>%Y-%m-%d %I:%M:%S %p %z</td>
/// <td>2024-01-02 03:30:45 PM -0400</td>
/// </tr>
/// <tr>
/// <td>%Y-%m-%d %I:%M:%S %p</td>
/// <td>2024-01-02 03:30:45 PM</td>
/// </tr>
/// <tr>
/// <td>%m/%d/%Y %I:%M:%S %p %z</td>
/// <td>01/02/2024 03:30:45 PM -0400</td>
/// </tr>
/// <tr>
/// <td>%m/%d/%Y %I:%M:%S %p</td>
/// <td>01/02/2024 03:30:45 PM</td>
/// </tr>
/// </tbody></table>
/// <p><strong>date/times (no secconds):</strong></p>
/// <table>
/// <thead>
/// <tr>
/// <th>Format</th>
/// <th>Example</th>
/// </tr>
/// </thead>
/// <tbody><tr>
/// <td>%Y-%m-%dT%H:%M</td>
/// <td>2024-01-02T15:30</td>
/// </tr>
/// <tr>
/// <td>%Y-%m-%dT%H:%MZ</td>
/// <td>2024-01-02T15:30Z</td>
/// </tr>
/// <tr>
/// <td>%Y-%m-%dT%H:%M%z</td>
/// <td>2024-01-02T15:30-0400</td>
/// </tr>
/// <tr>
/// <td>%Y%m%dT%H%M</td>
/// <td>20240102T1530</td>
/// </tr>
/// <tr>
/// <td>%Y%m%dT%H%MZ</td>
/// <td>20240102T1530Z</td>
/// </tr>
/// <tr>
/// <td>%Y%m%dT%H%M%z</td>
/// <td>20240102T1530-0400</td>
/// </tr>
/// <tr>
/// <td>%Y-%m-%d %H:%M %z</td>
/// <td>2024-01-02 15:30 -0400</td>
/// </tr>
/// <tr>
/// <td>%Y-%m-%d %H:%M</td>
/// <td>2024-01-02 15:30</td>
/// </tr>
/// <tr>
/// <td>%m/%d/%Y %H:%M %z</td>
/// <td>01/02/2024 15:30 -0400</td>
/// </tr>
/// <tr>
/// <td>%m/%d/%Y %H:%M</td>
/// <td>01/02/2024 15:30</td>
/// </tr>
/// <tr>
/// <td>%Y-%m-%d %I:%M %p %z</td>
/// <td>2024-01-02 03:30 PM -0400</td>
/// </tr>
/// <tr>
/// <td>%Y-%m-%d %I:%M %p</td>
/// <td>2024-01-02 03:30 PM</td>
/// </tr>
/// <tr>
/// <td>%m/%d/%Y %I:%M %p %z</td>
/// <td>01/02/2024 03:30 PM -0400</td>
/// </tr>
/// <tr>
/// <td>%m/%d/%Y %I:%M %p</td>
/// <td>01/02/2024 03:30 PM</td>
/// </tr>
/// </tbody></table>
/// <p><strong>date-only:</strong></p>
/// <table>
/// <thead>
/// <tr>
/// <th>Format</th>
/// <th>Example</th>
/// </tr>
/// </thead>
/// <tbody><tr>
/// <td>%Y-%m-%d</td>
/// <td>2024-01-02</td>
/// </tr>
/// <tr>
/// <td>%m/%d/%Y</td>
/// <td>01/02/2024</td>
/// </tr>
/// </tbody></table>
/// <p>If an error occurs:</p>
/// <ul>
/// <li>set pStatus to the error</li>
/// <li>return pErrOutput if populated</li>
/// <li>If pErrOutput is not set, return pDt.</li>
/// </ul>
/// <h4>Output Formats:</h4>
/// <p>If pDestFormat is blank, use the same format as the pDt input.</p>
ClassMethod Convert(pDt, pTz, pFormat = "", pDestFormat = "", pDestTz = "", Output pStatus As %Status, pErrOutput As %String = "{do not convert}") As %String
{
  set pStatus = $$$OK

  if (pDt = "") {
    return ""
  }

  // If source format is "", try to determine the matching format.
  // Error if unable to determine format.
  if (pFormat = "") {
    set fmtRslt = ..DetermineFormat(pDt, pTz)
    set pFormat = $LISTGET(fmtRslt, 1)
    set pTz = $LISTGET(fmtRslt, 2)
    //set dateOnly = $LISTGET(fmtRslt, 3)

    // TODO: What if the input is only a date?

    if pFormat = "" {
      set pStatus = $$$ERROR($$$GeneralError, "Unable to determine source format: "_pDt)

      if pErrOutput = "{do not convert}" {
        set pErrOutput = pDt
      }

      return pErrOutput
    }
  }

  // If no dest format is provided, use the source format.
  if (pDestFormat = "") {
    set pDestFormat = pFormat
  }

  // If no dest tz is provided, use the source tz.
  if (pDestTz = "") {
    set pDestTz = pTz
  }

  try {
    set rslt = ##class(tz.internal).convertTZ(pDt, pTz, pFormat, pDestFormat, pDestTz)
  }
  catch ex {
    set pStatus = ex.AsStatus()

    if pErrOutput = "{do not convert}" {
      set pErrOutput = pDt
    }

    return pErrOutput
  }

  return rslt
}

}

