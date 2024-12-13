Class tz.internal
{

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

