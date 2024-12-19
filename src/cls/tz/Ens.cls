/// <p><code>TZ()</code> converts HL7-formatted dates/datetimes to the desired timezone and/or format.</p>
/// <p><code>TZLocal()</code> converts HL7-formatted dates/datetimes to the desired local time.</p>
/// <p><code>TZOffset()</code> converts HL7-formatted dates/datetimes to the desired datetime with timezone offset.</p>
/// <p>The <code>tz.Ens</code> class extends <code>Ens.Rule.FunctionSet</code> to make <code>TZ()</code>, <code>TZLocal()</code>, and <code>TZOffset</code> available in Rules and DTLs.</p>
/// <p>These methods call <code>##class(tz.HL7).ConvertTz()</code>.  See <code>tz.HL7</code> docs for more details.</p>
/// <h2>Examples:</h2>
/// <pre><code class="language-cls">// Convert local time from one timezone to another 	 
/// set datetime = &quot;20240102033045&quot;
/// set newDatetime = ##class(tz.Ens).TZ(datetime,&quot;America/New_York&quot;,&quot;America/Chicago&quot;)
/// 
/// // Convert local time to offset 	 
/// set datetime = &quot;20240102033045&quot;
/// set newDatetime = ##class(tz.Ens).TZOffset(datetime,&quot;America/Chicago&quot;,&quot;America/New_York&quot;)
/// 
/// // Convert offset to local time 	 
/// set datetime = &quot;20240102033045-0500&quot;
/// set newDatetime = ##class(tz.Ens).TZLocal(datetime,&quot;America/Chicago&quot;)
/// 
/// // Convert to a non-HL7 format 	 
/// set datetime = &quot;20240102033045-0500&quot;
/// set newDatetime = ##class(tz.Ens).TZ(datetime,&quot;America/Chicago&quot;,,&quot;%m/%d/%Y %H:%M:%S %z&quot;)
/// </code></pre>
/// <h2>Supported Input Formats:</h2>
/// <p>The <code>tz.Ens</code> methods use the date/datetime input formats supported by <code>##class(tz.HL7).ConvertTz()</code>.</p>
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
/// <li>If <code>strict</code> is 0, allow <code>##class(tz.Tz).Convert()</code> to attempt to parse the input.</li>
/// <li>If <code>strict</code> is 1, process errorValue, as mentioned next.</li>
/// </ul>
/// <p>If an error occurs:</p>
/// <ul>
/// <li>return <code>errorValue</code> if populated</li>
/// <li>If <code>errorValue</code> is not set, return <code>datetime</code>.</li>
/// </ul>
Class tz.Ens Extends Ens.Rule.FunctionSet
{
  /// <p><code>TZ()</code> converts HL7-formatted dates/datetimes to the desired timezone and/or format.  By default, the output is formatted with the same format as the input.</p>
  /// <table>
  /// <thead>
  /// <tr>
  /// <th>Argument</th>
  /// <th>Description</th>
  /// <th>Examples</th>
  /// </tr>
  /// </thead>
  /// <tbody><tr>
  /// <td>datetime</td>
  /// <td>The source date/datetime in HL7 format<br/>(See &quot;Supported Input Formats&quot; above)</td>
  /// <td>&quot;20240102033045-0600&quot;</td>
  /// </tr>
  /// <tr>
  /// <td>tz</td>
  /// <td>The source timezone. If desiredTz is not provided, tz will be targeted.</td>
  /// <td>&quot;America/New_York&quot;, &quot;America/Los_Angeles&quot;</td>
  /// </tr>
  /// <tr>
  /// <td>desiredTz=tz</td>
  /// <td>The target timezone. If blank, use tz.</td>
  /// <td>&quot;America/New_York&quot;, &quot;America/Los_Angeles&quot;</td>
  /// </tr>
  /// <tr>
  /// <td>desiredFormat=&quot;&quot;</td>
  /// <td>The target format. If blank, try to match the source format.</td>
  /// <td>&quot;HL7Local&quot;, &quot;HL7withOffset&quot;, &quot;&quot;, &quot;%Y-%m-%d %H:%M:%S %z&quot;</td>
  /// </tr>
  /// <tr>
  /// <td>errorValue</td>
  /// <td>Value to return on error.  By default, return original datetime value.</td>
  /// <td>&quot;&quot;, &quot;00000000000000&quot;</td>
  /// </tr>
  /// <tr>
  /// <td>strict=0</td>
  /// <td>If 1 (strict), error if not HL7 format. If 0 (not strict), allow tz.Tz to attempt to parse.</td>
  /// <td>0, 1</td>
  /// </tr>
  /// </tbody></table>
  /// <h4>Result:</h4>
  /// <p>Return the converted HL7 date/datetime string. If an error occurs, <code>errorValue</code> is used to determine result. (See below)</p>
  /// <p>If <code>desiredFormat</code> is blank, use the same format as the <code>datetime</code> input.</p>
  /// <p>If <code>desiredFormat</code> is &quot;HL7Local&quot;, use the &quot;%Y%m%d%H%M%S&quot; format.</p>
  /// <p>If <code>desiredFormat</code> is &quot;HL7WithOffset&quot;, use the &quot;%Y%m%d%H%M%S%z&quot; format.</p>
  ClassMethod TZ(datetime, tz, desiredTz = "", desiredFormat = "", errorValue As %String, strict As %Boolean = 0) As %String
  {
    set errorValue = $GET(errorValue, "{do not convert}")
    return ##class(tz.HL7).ConvertTz(datetime, tz, desiredTz, desiredFormat, .tSC, errorValue, strict)
  }

  /// <p><code>TZLocal()</code> converts HL7-formatted dates/datetimes to the desired local time. Output format: <code>YYYYMMDDHHMMSS</code></p>
  /// <table>
  /// <thead>
  /// <tr>
  /// <th>Argument</th>
  /// <th>Description</th>
  /// <th>Examples</th>
  /// </tr>
  /// </thead>
  /// <tbody><tr>
  /// <td>datetime</td>
  /// <td>The source date/datetime in HL7 format<br/>(See &quot;Supported Input Formats&quot; above)</td>
  /// <td>&quot;20240102033045-0600&quot;</td>
  /// </tr>
  /// <tr>
  /// <td>tz</td>
  /// <td>The source timezone. If desiredTz is not provided, tz will be targeted.</td>
  /// <td>&quot;America/New_York&quot;, &quot;America/Los_Angeles&quot;</td>
  /// </tr>
  /// <tr>
  /// <td>desiredTz=tz</td>
  /// <td>The target timezone. If blank, use tz.</td>
  /// <td>&quot;America/New_York&quot;, &quot;America/Los_Angeles&quot;</td>
  /// </tr>
  /// <tr>
  /// <td>errorValue</td>
  /// <td>Value to return on error.  By default, return original datetime value.</td>
  /// <td>&quot;&quot;, &quot;00000000000000&quot;</td>
  /// </tr>
  /// <tr>
  /// <td>strict=0</td>
  /// <td>If 1 (strict), error if not HL7 format. If 0 (not strict), allow tz.Tz to attempt to parse.</td>
  /// <td>0, 1</td>
  /// </tr>
  /// </tbody></table>
  /// <h4>Result:</h4>
  /// <p>Return the converted HL7 date/datetime string (<code>YYYYMMDDHHMMSS</code>). If an error occurs, <code>errorValue</code> is used to determine result. (See below)</p>
  ClassMethod TZLocal(datetime, tz, desiredTz = "", errorValue As %String, strict As %Boolean = 0) As %String
  {
    set desiredFormat = "HL7Local"
    set errorValue = $GET(errorValue, "{do not convert}")
    return ##class(tz.HL7).ConvertTz(datetime, tz, desiredTz, desiredFormat, .tSC, errorValue, strict)
  }

  /// <p><code>TZOffset()</code> converts HL7-formatted dates/datetimes to the desired datetime with timezone offset.  Output format: <code>YYYYMMDDHHMMSS±zzzz</code>.</p>
  /// <table>
  /// <thead>
  /// <tr>
  /// <th>Argument</th>
  /// <th>Description</th>
  /// <th>Examples</th>
  /// </tr>
  /// </thead>
  /// <tbody><tr>
  /// <td>datetime</td>
  /// <td>The source date/datetime in HL7 format<br/>(See &quot;Supported Input Formats&quot; above)</td>
  /// <td>&quot;20240102033045-0600&quot;</td>
  /// </tr>
  /// <tr>
  /// <td>tz</td>
  /// <td>The source timezone. If desiredTz is not provided, tz will be targeted.</td>
  /// <td>&quot;America/New_York&quot;, &quot;America/Los_Angeles&quot;</td>
  /// </tr>
  /// <tr>
  /// <td>desiredTz=tz</td>
  /// <td>The target timezone. If blank, use tz.</td>
  /// <td>&quot;America/New_York&quot;, &quot;America/Los_Angeles&quot;</td>
  /// </tr>
  /// <tr>
  /// <td>errorValue</td>
  /// <td>Value to return on error.  By default, return original datetime value.</td>
  /// <td>&quot;&quot;, &quot;00000000000000&quot;</td>
  /// </tr>
  /// <tr>
  /// <td>strict=0</td>
  /// <td>If 1 (strict), error if not HL7 format. If 0 (not strict), allow tz.Tz to attempt to parse.</td>
  /// <td>0, 1</td>
  /// </tr>
  /// </tbody></table>
  /// <h4>Result:</h4>
  /// <p>Return the converted HL7 date/datetime string (<code>YYYYMMDDHHMMSS±zzzz</code>). If an error occurs, <code>errorValue</code> is used to determine result. (See below)</p>
  ClassMethod TZOffset(datetime, tz, desiredTz = "", errorValue As %String, strict As %Boolean = 0) As %String
  {
    set desiredFormat = "HL7WithOffset"
    set errorValue = $GET(errorValue, "{do not convert}")
    return ##class(tz.HL7).ConvertTz(datetime, tz, desiredTz, desiredFormat, .tSC, errorValue, strict)
  }
}