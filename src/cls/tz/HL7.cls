/// A class that converts datetimes (formatted as HL7 dates/datetimes) to the desired timezone or format.
/// 
/// See the tz.TZ class for details on timezones and datetime formats.
Class tz.HL7
{

// <p><code>ConvertTz()</code> converts HL7-formatted dates/datetimes to the desired timezone and/or format.</p>

/// <h4>Arguments:</h4>
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
/// <td>The source date/datetime in HL7 format</td>
/// <td>&quot;20240102033045-0600&quot;</td>
/// </tr>
/// <tr>
/// <td>pTz</td>
/// <td>The source timezone. If pDestTz is not provided, pTz will be targeted.</td>
/// <td>&quot;America/New_York&quot;, &quot;America/Los_Angeles&quot;</td>
/// </tr>
/// <tr>
/// <td>pDestTz=pTz</td>
/// <td>The target timezone. If blank, use pTz.</td>
/// <td>&quot;America/New_York&quot;, &quot;America/Los_Angeles&quot;</td>
/// </tr>
/// <tr>
/// <td>pDestFormat=&quot;&quot;</td>
/// <td>The target format. If blank, try to match the source format.</td>
/// <td>&quot;HL7Local&quot;, &quot;HL7withOffset&quot;, &quot;&quot;, &quot;%Y-%m-%d %H:%M:%S %z&quot;</td>
/// </tr>
/// <tr>
/// <td><em>Output</em> pStatus</td>
/// <td>Reference to a new %Status variable</td>
/// <td>.tSC</td>
/// </tr>
/// <tr>
/// <td>pErrOutput=pDt</td>
/// <td>Value to return on error.  By default, do not convert and return pDt.</td>
/// <td>&quot;&quot;, &quot;00000000000000&quot;</td>
/// </tr>
/// <tr>
/// <td>pStrict=0</td>
/// <td>If 1 (strict), error if not HL7 format. If 0 (not strict), allow tz.Tz to attempt to parse.</td>
/// <td>0, 1</td>
/// </tr>
/// </tbody></table>
/// <h4>Result:</h4>
/// <p>Return the converted HL7 date/datetime string.  If an error occurs, pErrOutput is used to determine result. (See below)</p>
/// <h4>Examples:</h4>
/// <pre><code class="language-cls">USER&gt;zw ##class(tz.HL7).ConvertTz(&quot;20200102033045-0500&quot;, &quot;America/Chicago&quot;)
/// &quot;20200102023045-0600&quot;
/// 
/// USER&gt;zw ##class(tz.HL7).ConvertTz(&quot;20200102033045&quot;, &quot;America/New_York&quot;, &quot;America/Chicago&quot;)
/// 20200102023045
/// 
/// USER&gt;zw ##class(tz.HL7).ConvertTz(&quot;20200102033045&quot;, &quot;America/New_York&quot;, &quot;America/Chicago&quot;, &quot;HL7WithOffset&quot;)
/// &quot;20200102023045-0600&quot;
/// 
/// USER&gt;zw ##class(tz.HL7).ConvertTz(&quot;20200102033045-0500&quot;, &quot;America/Chicago&quot;, &quot;&quot;, &quot;HL7Local&quot;)
/// 20200102023045
/// 
/// USER&gt;zw ##class(tz.HL7).ConvertTz(&quot;20200102033045-0500&quot;, &quot;America/Chicago&quot;, &quot;&quot;, &quot;%Y-%m-%d %H:%M:%S %z&quot;)
/// &quot;2020-01-02 02:30:45 -0600&quot;
/// 
/// USER&gt;zw ##class(tz.HL7).ConvertTz(&quot;&quot;, &quot;America/Chicago&quot;)
/// &quot;&quot;
/// 
/// USER&gt;zw ##class(tz.HL7).ConvertTz(&quot;20240102&quot;, &quot;America/Chicago&quot;)
/// 20240102
/// 
/// USER&gt;zw ##class(tz.HL7).ConvertTz(&quot;20240102&quot;, &quot;America/Chicago&quot;, &quot;America/New_York&quot;)
/// 20240102
/// </code></pre>
/// <h4>Supported Input Formats:</h4>
/// <p><code>ConvertTz()</code> attempts to match the given date/datetime to several HL7 formats.</p>
/// <p>In general, this library defines valid HL7 dates/datetimes with the following formats:</p>
/// <ul>
/// <li>YYYYmmddHHMMSS±zzzz</li>
/// <li>YYYYmmddHHMM±zzzz</li>
/// <li>YYYYmmddHH±zzzz</li>
/// <li>YYYYmmddHHMMSSZ</li>
/// <li>YYYYmmddHHMMZ</li>
/// <li>YYYYmmddHHZ</li>
/// <li>YYYYmmddHHMMSS</li>
/// <li>YYYYmmddHHMM</li>
/// <li>YYYYmmddHH</li>
/// <li>YYYYmmdd</li>
/// <li>YYYYmm</li>
/// <li>YYYY</li>
/// <li>[BLANK]</li>
/// </ul>
/// <p>Since the following values/formats do not have time-parts (i.e. hour, minute, etc.), they are returned as-is from <code>ConvertTz()</code>:</p>
/// <ul>
/// <li>Blank values</li>
/// <li>YYYYMMDD</li>
/// <li>YYYYMM</li>
/// <li>YYYY</li>
/// </ul>
/// <p>If the input is not a valid HL7 date/datetime:</p>
/// <ul>
/// <li>If pStrict is 0, allow <code>##class(tz.Tz).Convert()</code> to attempt to parse the input.</li>
/// <li>If pStrict is 1, set pStatus to an error, and process pErrOutput, as mentioned next.</li>
/// </ul>
/// <p>If an error occurs:</p>
/// <ul>
/// <li>set pStatus to the error</li>
/// <li>return pErrOutput if populated</li>
/// <li>If pErrOutput is not set, return pDt.</li>
/// </ul>
/// <h4>Output Formats:</h4>
/// <p>If pDestFormat is blank, use the same format as the pDt input.</p>
/// <p>If pDestFormat is &quot;HL7Local&quot;, use the &quot;%Y%m%d%H%M%S&quot; format.</p>
/// <p>If pDestFormat is &quot;HL7WithOffset&quot;, use the &quot;%Y%m%d%H%M%S%z&quot; format.</p>
ClassMethod ConvertTz(pDt, pTz, pDestTz = "", pDestFormat As %String = "", Output pStatus As %Status, pErrOutput As %String = "{do not convert}", pStrict As %Boolean = 0) As %String
{
  set pStatus = $$$OK

  if pDt = "" {
    return ""
  }

  // split the datetime and offset
  set hasOffset = ..SplitOffset(pDt, .datepart, .offset)

  // Does it end with Z, indicating UTC?
  if (hasOffset = 0) && ($EXTRACT(datepart, *) = "Z") {
    set datepart = $EXTRACT(datepart, 1, *-1)
    set offset = "+0000"
    set hasOffset = 1
  }

  // Is this a valid HL7 datetime?
  if pStrict && ('$MATCH(datepart, "^[0-9]{4}[0-9]*$")) {
    set pStatus = $$$ERROR($$$GeneralError, "Not an HL7 Datetime value")

    if pErrOutput = "{do not convert}" {
      set pErrOutput = pDt
    }

    return pErrOutput
  }

  set srcFmt = ""
  set dtLen = $LENGTH(datepart)

  if dtLen = 14 {
    set srcFmt = "%Y%m%d%H%M%S"

  } elseif dtLen = 12 {
    set srcFmt = "%Y%m%d%H%M"

  } elseif dtLen = 10 {
    set srcFmt = "%Y%m%d%H"

  } elseif dtLen = 8 {
    // This is a date-only, so return original value
    //set srcFmt = "%Y%m%d"
    return datepart

  } elseif dtLen = 6 {
    // This is a year+month, so return original value
    //set srcFmt = "%Y%m"
    return datepart

  } elseif dtLen = 4 {
    // This is a year, so return original value
    //set srcFmt = "%Y"
    return datepart
  }

  if hasOffset && (srcFmt '= "") {
    set srcFmt = srcFmt_"%z"
  }

  // Determine the destination format, if necessary
  set upperDestFormat = $ZCONVERT(pDestFormat, "U")
  if upperDestFormat = "HL7WITHOFFSET" {
    set pDestFormat = "%Y%m%d%H%M%S%z"

  } elseif upperDestFormat = "HL7LOCAL" {
    set pDestFormat = "%Y%m%d%H%M%S"

  } elseif pDestFormat = ""  {
    set pDestFormat = srcFmt
  }

  if pDestTz = "" {
    set pDestTz = pTz
  }

  set rslt = ##class(tz.TZ).Convert(datepart_offset, pTz, srcFmt, pDestFormat, pDestTz, .pStatus)

  if $$$ISERR(pStatus) {
    if pErrOutput = "{do not convert}" {
      set pErrOutput = pDt
    }

    return pErrOutput
  }

  return rslt
}

/// Returns 0 if an offset (i.e. -0400, +0400) was not found.
/// Returns an integer specifying its start position in the string.
/// See $LOCATE.
ClassMethod FindOffset(pInWithOffset As %String) As %Integer [ Private ]
{
  //set idx = $FIND(pInWithOffset, "-")

  //if (idx = 0) {
  //  // "-" not found, try "+"
  //  set idx = $FIND(pInWithOffset, "+")
  //}
  //quit idx

  set idx = $LOCATE(pInWithOffset, "[+-][0-9]{2}[0-9]*$")
  quit idx
}

/// Returns 1 if an offset (i.e. -0400, +0400) was found. Returns 0 otherwise.
ClassMethod HasOffset(pInWithOffset As %String) As %Integer [ Private ]
{
  if (..FindOffset(pInWithOffset) = 0) {
    quit 0
  } else {
    quit 1
  }
}

/// Split an HL7 Datetime into a datetime and offset (i.e. -0400, +0400).
/// 
/// Returns 1 if an offset was found; 0 otherwise;
ClassMethod SplitOffset(pInWithOffset, Output pDatetime, Output pOffset As %String) As %Integer [ Private ]
{
  set idx = ..FindOffset(pInWithOffset)

  if (idx = 0) {
    // no offset found
    set pDatetime = pInWithOffset
    set pOffset = ""
    quit 0
  }

  //set pDatetime = $EXTRACT(pInWithOffset, 1, idx-2)
  //set pOffset = $EXTRACT(pInWithOffset, idx-1,*)

  set pDatetime = $EXTRACT(pInWithOffset, 1, idx-1)
  set pOffset = $EXTRACT(pInWithOffset, idx,*)

  quit 1
}

/// <p><code>WithOffset()</code> converts HL7-formatted dates/datetimes to the desired timezone with a format of <code>YYYYMMDDHHMMSS±zzzz</code>.</p>
/// <p>See <code>##class(tz.HL7).ConvertTz()</code> for more details on arguments, return values, formats, timezones, etc.</p>
/// <h4>Examples:</h4>
/// <pre><code class="language-cls">USER&gt;zw ##class(tz.HL7).WithOffset(&quot;20200102033045-0500&quot;, &quot;America/Chicago&quot;)
/// &quot;20200102023045-0600&quot;
/// 
/// USER&gt;zw ##class(tz.HL7).WithOffset(&quot;20200102033045&quot;, &quot;America/Chicago&quot;)
/// &quot;20200102033045-0600&quot;
/// 
/// USER&gt;zw ##class(tz.HL7).WithOffset(&quot;20200102033045&quot;, &quot;America/Chicago&quot;, &quot;America/Denver&quot;)
/// &quot;20200102023045-0700&quot;
/// </code></pre>
ClassMethod WithOffset(pDt, pTz, pDestTz As %String = "", Output pStatus = "", pErrOutput As %String = "{do not convert}", pStrict As %Boolean = 0) As %String
{
  quit ..ConvertTz(pDt, pTz, pDestTz, "HL7WithOffset", .pStatus, pErrOutput, pStrict)
}

/// <p><code>ToLocal()</code> converts HL7-formatted dates/datetimes to the desired timezone with a format of <code>YYYYMMDDHHMMSS</code>.</p>
/// <p>See <code>##class(tz.HL7).ConvertTz()</code> for more details on arguments, return values, formats, timezones, etc.</p>
/// <h4>Examples:</h4>
/// <pre><code class="language-cls">USER&gt; zw ##class(tz.HL7).ToLocal(&quot;20200102033045-0500&quot;, &quot;America/Chicago&quot;)
/// 20200102023045
/// 
/// USER&gt;zw ##class(tz.HL7).ToLocal(&quot;20200102033045&quot;, &quot;America/Chicago&quot;)
/// 20200102033045
/// 
/// USER&gt;zw ##class(tz.HL7).ToLocal(&quot;20200102033045&quot;, &quot;America/Chicago&quot;, &quot;America/Denver&quot;)
/// 20200102023045
/// </code></pre>
ClassMethod ToLocal(pDt, pTz, pDestTz As %String = "", Output pStatus = "", pErrOutput As %String = "{do not convert}", pStrict As %Boolean = 0) As %String
{
  quit ..ConvertTz(pDt, pTz, pDestTz, "HL7Local", .pStatus, pErrOutput, pStrict)
}

/// <p><code>NowLocal()</code> returns the current local time for the given timezone with a format of <code>YYYYMMDDHHMMSS</code>.</p>
/// <p>See <code>##class(tz.HL7).ConvertTz()</code> for more details on formats, timezones, etc.</p>
/// <table>
/// <thead>
/// <tr>
/// <th>Argument</th>
/// <th>Description</th>
/// <th>Examples</th>
/// </tr>
/// </thead>
/// <tbody><tr>
/// <td>pTz</td>
/// <td>The source timezone.</td>
/// <td>&quot;America/New_York&quot;, &quot;America/Los_Angeles&quot;</td>
/// </tr>
/// </tbody></table>
/// <h4>Examples:</h4>
/// <pre><code class="language-cls">USER&gt;zw ##class(tz.HL7).NowLocal(&quot;America/Chicago&quot;)
/// &quot;20200102023045&quot;
/// </code></pre>
ClassMethod NowLocal(pTz) As %String
{
  set now = $ZDATETIME($HOROLOG, 3, 5)
  set srcFmt = "%Y-%m-%dT%H:%M:%S%z"
  quit ##class(tz.TZ).Convert(now, pTz, srcFmt, "%Y%m%d%H%M%S")
}

/// <p><code>NowWithOffset()</code> returns the current time with an offset for the given timezone with a format of <code>YYYYMMDDHHMMSS±zzzz</code> .</p>
/// <p>See <code>##class(tz.HL7).ConvertTz()</code> for more details on formats, timezones, etc.</p>
/// <table>
/// <thead>
/// <tr>
/// <th>Argument</th>
/// <th>Description</th>
/// <th>Examples</th>
/// </tr>
/// </thead>
/// <tbody><tr>
/// <td>pTz</td>
/// <td>The source timezone.</td>
/// <td>&quot;America/New_York&quot;, &quot;America/Los_Angeles&quot;</td>
/// </tr>
/// </tbody></table>
/// <h4>Examples:</h4>
/// <pre><code class="language-cls">USER&gt;zw ##class(tz.HL7).NowWithOffset(&quot;America/Chicago&quot;)
/// &quot;20200102023045-0600&quot;
/// </code></pre>
ClassMethod NowWithOffset(pTz) As %String
{
  set now = $ZDATETIME($HOROLOG, 3, 5)
  set srcFmt = "%Y-%m-%dT%H:%M:%S%z"
  quit ##class(tz.TZ).Convert(now, pTz, srcFmt, "%Y%m%d%H%M%S%z")
}

}

