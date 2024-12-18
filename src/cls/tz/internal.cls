/// This class provides the core timezone conversion code.  These methods should not be called directly.
/// 
/// Use one of the following classes instead:
/// 
/// <ul>
///   <li>tz.TZ</li>
///   <li>tz.HL7</li>
/// </ul>
Class tz.internal
{

/// This is the core method that converts timezones/datetimes.  This is implemented in python without using any
/// external packages.  Unfortunately, it only works for UNIX at the moment.
ClassMethod convertTZ(pDt, pSrcTz, pSrcFormat, pDestFormat, pDestTz) As %String [ Internal, Language = python ]
{
  # This uses time.tzset.  Unfortunately, this is not supported on Windows.
  import datetime
  import time
  import os

  origTz = os.environ.get('TZ', None)

  # parse the input datetime
  inDt = datetime.datetime.strptime(pDt, pSrcFormat)

  # if no tzinfo in the parsed date (i.e. this was a local datetime, without an offset/zone)
  # replace the tzinfo with the input timezone
  if inDt.tzinfo == None:
    os.environ['TZ'] = pSrcTz
    time.tzset()

  epoch_secs = inDt.timestamp()

  # convert to the desired timezone
  os.environ['TZ'] = pDestTz
  time.tzset()
  outDt = time.localtime(epoch_secs)
  
  # alternate method of converting timezones
  # outDt = inDt.astimezone(outTz)

  rslt = time.strftime(pDestFormat, outDt)

  if origTz:
    os.environ['TZ'] = origTz
  else:
    del(os.environ['TZ'])

  time.tzset()

  return rslt
}

/// Newer versions of python provide a zoneinfo module.  Eventually, we may be able to switch to this method/module.
ClassMethod convertTZwithZoneInfo(pDt, pSrcTz, pSrcFormat, pDestFormat, pDestTz) As %String [ Internal, Language = python ]
{
  # This really only works in more recent versions of python.
  # Until zoneinfo is more widely available, we will not use this.
  import datetime
  import zoneinfo

  # parse the timezones
  inTz = zoneinfo.ZoneInfo(pSrcTz)
  outTz = zoneinfo.ZoneInfo(pDestTz)

  # parse the input datetime
  inDt = datetime.datetime.strptime(pDt, pSrcFormat)

  # if no tzinfo in the parsed date (i.e. this was a local datetime, without an offset/zone)
  # replace the tzinfo with the input timezone
  if inDt.tzinfo == None:
    inDt = inDt.replace(tzinfo=inTz)

  # convert to the desired timezone
  outDt = datetime.datetime.fromtimestamp(inDt.timestamp(), tz=outTz)
  
  # alternate method of converting timezones
  # outDt = inDt.astimezone(outTz)

  return outDt.strftime(pDestFormat)
}

}

