Class tz.Tests
{

/// Various Time/TZ Conversion Tests
ClassMethod Run() As %Status
{
  set ok = "" 
  set strict = 1
  set notStrict = 0

  set testCases = $LISTBUILD(
    // DST
    ..TestInternal("DST.1", "2020-07-01 12:30:10"      , "America/Chicago", "%Y-%m-%d %H:%M:%S"   , "%Y-%m-%d %H:%M:%S %z", "America/New_York", "2020-07-01 13:30:10 -0400"),
    ..TestInternal("DST.2", "2020-07-01 12:30:10 -0400", "America/Chicago", "%Y-%m-%d %H:%M:%S %z", "%Y-%m-%d %H:%M:%S %z", "America/New_York", "2020-07-01 12:30:10 -0400"),
    ..TestInternal("DST.3", "2020-07-01 12:30:10 -0500", "America/Chicago", "%Y-%m-%d %H:%M:%S %z", "%Y-%m-%d %H:%M:%S %z", "America/New_York", "2020-07-01 13:30:10 -0400"),
    
    // Standard
    ..TestInternal("STD.1", "2020-12-01 12:30:10"      , "America/Chicago", "%Y-%m-%d %H:%M:%S"   , "%Y-%m-%d %H:%M:%S %z", "America/New_York", "2020-12-01 13:30:10 -0500"),
    ..TestInternal("STD.2", "2020-12-01 12:30:10 -0400", "America/Chicago", "%Y-%m-%d %H:%M:%S %z", "%Y-%m-%d %H:%M:%S %z", "America/New_York", "2020-12-01 11:30:10 -0500"),
    ..TestInternal("STD.3", "2020-12-01 12:30:10 -0500", "America/Chicago", "%Y-%m-%d %H:%M:%S %z", "%Y-%m-%d %H:%M:%S %z", "America/New_York", "2020-12-01 12:30:10 -0500"),
    
    // Standard -> DST Transitions
    ..TestInternal("STD.DST.1", "2020-03-08 00:00:00", "America/New_York", "%Y-%m-%d %H:%M:%S", "%Y-%m-%d %H:%M:%S %z", "America/New_York", "2020-03-08 00:00:00 -0500"),
    ..TestInternal("STD.DST.2", "2020-03-08 01:00:00", "America/New_York", "%Y-%m-%d %H:%M:%S", "%Y-%m-%d %H:%M:%S %z", "America/New_York", "2020-03-08 01:00:00 -0500"),
    ..TestInternal("STD.DST.3", "2020-03-08 01:59:59", "America/New_York", "%Y-%m-%d %H:%M:%S", "%Y-%m-%d %H:%M:%S %z", "America/New_York", "2020-03-08 01:59:59 -0500"),
    ..TestInternal("STD.DST.4", "2020-03-08 02:00:00", "America/New_York", "%Y-%m-%d %H:%M:%S", "%Y-%m-%d %H:%M:%S %z", "America/New_York", "2020-03-08 03:00:00 -0400"),
    ..TestInternal("STD.DST.5", "2020-03-08 03:00:00", "America/New_York", "%Y-%m-%d %H:%M:%S", "%Y-%m-%d %H:%M:%S %z", "America/New_York", "2020-03-08 03:00:00 -0400"),
    
    // DST -> Standard Transitions (Ok)
    ..TestInternal("DST.STD.1", "2020-11-01 00:00:00", "America/New_York", "%Y-%m-%d %H:%M:%S", "%Y-%m-%d %H:%M:%S %z", "America/New_York", "2020-11-01 00:00:00 -0400"),
    // see "Ambiguous" tests below for the 1:00 am hours
    ..TestInternal("DST.STD.2", "2020-11-01 02:00:00", "America/New_York", "%Y-%m-%d %H:%M:%S", "%Y-%m-%d %H:%M:%S %z", "America/New_York", "2020-11-01 02:00:00 -0500"),
    ..TestInternal("DST.STD.3", "2020-11-01 03:00:00", "America/New_York", "%Y-%m-%d %H:%M:%S", "%Y-%m-%d %H:%M:%S %z", "America/New_York", "2020-11-01 03:00:00 -0500"),
    
    // DST -> Standard Transitions (Ambiguous)
    // Since there are two 1 AMs during the DST -> Standard transition, we don't really know which result we will receive.
    ..TestInternal("DST.STD.4", "2020-11-01 01:00:00", "America/New_York", "%Y-%m-%d %H:%M:%S", "%Y-%m-%d %H:%M:%S %z", "America/New_York", "2020-11-01 01:00:00 -0400", "2020-11-01 01:00:00 -0500"),

    ..TestConvert("Convert.1", "2020-01-02 03:30:45", "America/New_York", "%Y-%m-%d %H:%M:%S", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:45 -0600"),
    ..TestConvert("Convert.BlankDate", "", "America/New_York", "%Y-%m-%d %H:%M:%S", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, ""),


    ////*****************************************
    //// full date/time
    ////*****************************************

    //$LB("%Y%m%d%H%M%S%z"),
    ..TestConvert("Convert.Format.1", "20200102033045-0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:45 -0600"),

    //$LB("%Y%m%d%H%M%S"),
    ..TestConvert("Convert.Format.2", "20200102033045", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:45 -0600"),

    //$LB("%Y-%m-%dT%H:%M:%S"),
    ..TestConvert("Convert.Format.3a", "2020-01-02T03:30:45", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:45 -0600"),
    ..TestConvert("Convert.Format.3b", "2020-1-2T3:30:45", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:45 -0600"),

    //$LB("%Y-%m-%dT%H:%M:%SZ"),
    //This should be interpretted as UTC
    ..TestConvert("Convert.Format.4", "2020-01-02T03:30:45Z", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/01/2020 21:30:45 -0600"),

    //$LB("%Y-%m-%dT%H:%M:%S%z"),
    ..TestConvert("Convert.Format.5a", "2020-01-02T03:30:45-0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:45 -0600"),
    ..TestConvert("Convert.Format.5b", "2020-1-2T3:30:45-0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:45 -0600"),

    //$LB("%Y%m%dT%H%M%S"),
    ..TestConvert("Convert.Format.6", "20200102T033045", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:45 -0600"),

    //$LB("%Y%m%dT%H%M%SZ"),
    //This should be interpretted as UTC
    ..TestConvert("Convert.Format.7", "20200102T033045Z", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/01/2020 21:30:45 -0600"),

    //$LB("%Y%m%dT%H%M%S%z"),
    ..TestConvert("Convert.Format.8", "20200102T033045-0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:45 -0600"),


    //$LB("%Y-%m-%d %H:%M:%S %z"),
    ..TestConvert("Convert.Format.9a", "2020-01-02 03:30:45 -0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:45 -0600"),
    ..TestConvert("Convert.Format.9b", "2020-1-2 3:30:45 -0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:45 -0600"),

    //$LB("%Y-%m-%d %H:%M:%S %Z"),
    // NOT SUPPORTED BY PYTHON
    //..TestConvert("Convert.Format.2", "2020-01-02 03:30:45 EST", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:45 -0600"),
    //..TestConvert("Convert.Format.10", "2020-1-2 3:30:45 EST", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:45 -0600"),

    //$LB("%Y-%m-%d %H:%M:%S"),
    ..TestConvert("Convert.Format.10a", "2020-01-02 03:30:45", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:45 -0600"),
    ..TestConvert("Convert.Format.10b", "2020-1-2 3:30:45", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:45 -0600"),

    //$LB("%m/%d/%Y %H:%M:%S %z"),
    ..TestConvert("Convert.Format.11a", "01/02/2020 03:30:45 -0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:45 -0600"),
    ..TestConvert("Convert.Format.11b", "1/2/2020 3:30:45 -0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:45 -0600"),

    //$LB("%m/%d/%Y %H:%M:%S %Z"),
    // NOT SUPPORTED BY PYTHON
    //..TestConvert("Convert.Format.5", "01/02/2020 03:30:45 EST", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:45 -0600"),
    //..TestConvert("Convert.Format.7", "1/2/2020 3:30:45 EST", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:45 -0600"),

    //$LB("%m/%d/%Y %H:%M:%S"),
    ..TestConvert("Convert.Format.12a", "01/02/2020 03:30:45", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:45 -0600"),
    ..TestConvert("Convert.Format.12b", "1/2/2020 3:30:45", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:45 -0600"),

    //$LB("%Y-%m-%d %H:%M:%S %p %z"),
    ..TestConvert("Convert.Format.13a", "2020-01-02 03:30:45 PM -0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:45 -0600"),
    ..TestConvert("Convert.Format.13b", "2020-1-2 3:30:45 PM -0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:45 -0600"),

    //$LB("%Y-%m-%d %H:%M:%S %p %Z"),
    // NOT SUPPORTED BY PYTHON
    //..TestConvert("Convert.Format.11", "2020-01-02 03:30:45 PM EST", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:45 -0600"),
    //..TestConvert("Convert.Format.11", "2020-1-2 3:30:45 PM EST", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:45 -0600"),

    //$LB("%Y-%m-%d %H:%M:%S %p"),
    ..TestConvert("Convert.Format.14a", "2020-01-02 03:30:45 PM", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:45 -0600"),
    ..TestConvert("Convert.Format.14b", "2020-1-2 3:30:45 PM", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:45 -0600"),

    //$LB("%m/%d/%Y %H:%M:%S %p %z"),
    ..TestConvert("Convert.Format.15a", "01/02/2020 03:30:45 PM -0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:45 -0600"),
    ..TestConvert("Convert.Format.15b", "1/2/2020 3:30:45 PM -0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:45 -0600"),

    //$LB("%m/%d/%Y %H:%M:%S %p %Z"),
    // NOT SUPPORTED BY PYTHON
    //..TestConvert("Convert.Format.11", "01/02/2020 03:30:45 PM EST", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:45 -0600"),
    //..TestConvert("Convert.Format.11", "1/2/2020 3:30:45 PM EST", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:45 -0600"),

    //$LB("%m/%d/%Y %H:%M:%S %p"),
    ..TestConvert("Convert.Format.16a", "01/02/2020 03:30:45 PM", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:45 -0600"),
    ..TestConvert("Convert.Format.16b", "1/2/2020 3:30:45 PM", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:45 -0600"),


    ////*****************************************
    //// no seconds
    ////*****************************************

    //$LB("%Y-%m-%dT%H:%M"),
    ..TestConvert("Convert.Format.17a", "2020-01-02T03:30", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:00 -0600"),
    ..TestConvert("Convert.Format.17b", "2020-1-2T3:30", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:00 -0600"),

    //$LB("%Y-%m-%dT%H:%MZ"),
    //This should be interpretted as UTC
    ..TestConvert("Convert.Format.18", "2020-01-02T03:30Z", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/01/2020 21:30:00 -0600"),

    //$LB("%Y-%m-%dT%H:%M%z"),
    ..TestConvert("Convert.Format.19a", "2020-01-02T03:30-0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:00 -0600"),
    ..TestConvert("Convert.Format.19b", "2020-1-2T3:30-0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:00 -0600"),

    //$LB("%Y%m%dT%H%M"),
    ..TestConvert("Convert.Format.20", "20200102T0330", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:00 -0600"),

    //$LB("%Y%m%dT%H%MZ"),
    //This should be interpretted as UTC
    ..TestConvert("Convert.Format.21", "20200102T0330Z", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/01/2020 21:30:00 -0600"),

    //$LB("%Y%m%dT%H%M%z"),
    ..TestConvert("Convert.Format.22", "20200102T0330-0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:00 -0600"),

    //$LB("%Y-%m-%d %H:%M %z"),
    ..TestConvert("Convert.Format.23a", "2020-01-02 03:30 -0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:00 -0600"),
    ..TestConvert("Convert.Format.23b", "2020-1-2 3:30 -0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:00 -0600"),

    //$LB("%Y-%m-%d %H:%M %Z"),
    // NOT SUPPORTED BY PYTHON
    //..TestConvert("Convert.Format.5a", "2020-01-02 03:30 EST", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:00 -0600"),
    //..TestConvert("Convert.Format.5b", "2020-1-2 3:30 EST", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:00 -0600"),

    //$LB("%Y-%m-%d %H:%M"),
    ..TestConvert("Convert.Format.24a", "2020-01-02 03:30", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:00 -0600"),
    ..TestConvert("Convert.Format.24b", "2020-1-2 3:30", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:00 -0600"),

    //$LB("%m/%d/%Y %H:%M %z"),
    ..TestConvert("Convert.Format.25a", "01/02/2020 03:30 -0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:00 -0600"),
    ..TestConvert("Convert.Format.25b", "1/2/2020 3:30 -0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:00 -0600"),

    //$LB("%m/%d/%Y %H:%M %Z"),
    // NOT SUPPORTED BY PYTHON
    //..TestConvert("Convert.Format.5a", "01/02/2020 03:30 EST", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:00 -0600"),
    //..TestConvert("Convert.Format.5b", "1/2/2020 3:30 EST", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:00 -0600"),

    //$LB("%m/%d/%Y %H:%M"),
    ..TestConvert("Convert.Format.26a", "01/02/2020 03:30", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:00 -0600"),
    ..TestConvert("Convert.Format.26b", "1/2/2020 3:30", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 02:30:00 -0600"),

    //$LB("%Y-%m-%d %H:%M %p %z"),
    ..TestConvert("Convert.Format.27a", "2020-01-02 03:30 PM -0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:00 -0600"),
    ..TestConvert("Convert.Format.27b", "2020-1-2 3:30 PM -0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:00 -0600"),

    //$LB("%Y-%m-%d %H:%M %p %Z"),
    // NOT SUPPORTED BY PYTHON
    //..TestConvert("Convert.Format.5a", "2020-01-02 03:30 PM EST", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:00 -0600"),
    //..TestConvert("Convert.Format.5b", "2020-1-2 3:30 PM EST", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:00 -0600"),

    //$LB("%Y-%m-%d %H:%M %p"),
    ..TestConvert("Convert.Format.28a", "2020-01-02 03:30 PM", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:00 -0600"),
    ..TestConvert("Convert.Format.28b", "2020-1-2 3:30 PM", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:00 -0600"),

    //$LB("%m/%d/%Y %H:%M %p %z"),
    ..TestConvert("Convert.Format.29a", "01/02/2020 03:30 PM -0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:00 -0600"),
    ..TestConvert("Convert.Format.29b", "1/2/2020 3:30 PM -0500", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:00 -0600"),

    //$LB("%m/%d/%Y %H:%M %p %Z"),
    // NOT SUPPORTED BY PYTHON
    //..TestConvert("Convert.Format.5a", "01/02/2020 03:30 PM EST", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:00 -0600"),
    //..TestConvert("Convert.Format.5b", "1/2/2020 3:30 PM EST", "America/Los_Angeles", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:00 -0600"),

    //$LB("%m/%d/%Y %H:%M %p"),
    ..TestConvert("Convert.Format.30a", "01/02/2020 03:30 PM", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:00 -0600"),
    ..TestConvert("Convert.Format.30b", "1/2/2020 3:30 PM", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/02/2020 14:30:00 -0600"),


    ////*****************************************
    //// date-only
    ////*****************************************

    //$LB("%Y-%m-%d"),
    ..TestConvert("Convert.Format.31a", "2020-01-02", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/01/2020 23:00:00 -0600"),
    ..TestConvert("Convert.Format.31a", "2020-1-2", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/01/2020 23:00:00 -0600"),

    //$LB("%m/%d/%Y"),
    ..TestConvert("Convert.Format.32a", "01/02/2020", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/01/2020 23:00:00 -0600"),
    ..TestConvert("Convert.Format.32a", "1/2/2020", "America/New_York", "", "%m/%d/%Y %H:%M:%S %z", "America/Chicago", ok, "01/01/2020 23:00:00 -0600"),

    ////*****************************************
    //// ##class(tz.HL7).ConvertTZ()
    ////*****************************************

    ..TestHL7ConvertTz("HL7.1a", "20200102033045-0500", "America/Los_Angeles", "America/Chicago", "HL7WithOffset", "20200102023045-0600"),
    ..TestHL7ConvertTz("HL7.1b", "20200102033045-0500", "America/Los_Angeles", "America/Chicago", "HL7Local"     , "20200102023045"),
    ..TestHL7ConvertTz("HL7.1c", "20200102033045-0500", "America/Los_Angeles", "America/Chicago", ""             , "20200102023045-0600"),

    ..TestHL7ConvertTz("HL7.2a", "20200102033045"     , "America/New_York", "America/Chicago", "HL7WithOffset", "20200102023045-0600"),
    ..TestHL7ConvertTz("HL7.2b", "20200102033045"     , "America/New_York", "America/Chicago", "HL7Local"     , "20200102023045"),
    ..TestHL7ConvertTz("HL7.2c", "20200102033045"     , "America/New_York", "America/Chicago", ""             , "20200102023045"),

    ..TestHL7ConvertTz("HL7.3a", "202001020330"       , "America/New_York", "America/Chicago", "HL7WithOffset", "20200102023000-0600"),
    ..TestHL7ConvertTz("HL7.3b", "202001020330"       , "America/New_York", "America/Chicago", "HL7Local"     , "20200102023000"),
    ..TestHL7ConvertTz("HL7.3c", "202001020330"       , "America/New_York", "America/Chicago", ""             , "202001020230"),

    ..TestHL7ConvertTz("HL7.4a", "202001020330-0500"  , "America/Los_Angeles", "America/Chicago", "HL7WithOffset", "20200102023000-0600"),
    ..TestHL7ConvertTz("HL7.4b", "202001020330-0500"  , "America/Los_Angeles", "America/Chicago", "HL7Local"     , "20200102023000"),
    ..TestHL7ConvertTz("HL7.4c", "202001020330-0500"  , "America/Los_Angeles", "America/Chicago", ""             , "202001020230-0600"),

    ..TestHL7ConvertTz("HL7.5a", "20200102"           , "America/New_York", "America/Chicago", "HL7WithOffset", "20200102"),
    ..TestHL7ConvertTz("HL7.5b", "20200102"           , "America/New_York", "America/Chicago", "HL7Local"     , "20200102"),
    ..TestHL7ConvertTz("HL7.5c", "20200102"           , "America/New_York", "America/Chicago", ""             , "20200102"),

    ..TestHL7ConvertTz("HL7.6a", "202001"             , "America/New_York", "America/Chicago", "HL7WithOffset", "202001"),
    ..TestHL7ConvertTz("HL7.6b", "202001"             , "America/New_York", "America/Chicago", "HL7Local"     , "202001"),
    ..TestHL7ConvertTz("HL7.6c", "202001"             , "America/New_York", "America/Chicago", ""             , "202001"),

    ..TestHL7ConvertTz("HL7.7a", "2020"               , "America/New_York", "America/Chicago", "HL7WithOffset", "2020"),
    ..TestHL7ConvertTz("HL7.7b", "2020"               , "America/New_York", "America/Chicago", "HL7Local"     , "2020"),
    ..TestHL7ConvertTz("HL7.7c", "2020"               , "America/New_York", "America/Chicago", ""             , "2020"),

    ..TestHL7ConvertTz("HL7.8a", ""                   , "America/New_York", "America/Chicago", "HL7WithOffset", ""),
    ..TestHL7ConvertTz("HL7.8b", ""                   , "America/New_York", "America/Chicago", "HL7Local"     , ""),
    ..TestHL7ConvertTz("HL7.8c", ""                   , "America/New_York", "America/Chicago", ""             , ""),

    ..TestHL7ConvertTz("HL7.9a", "20200102033045Z"     , "America/New_York", "America/Chicago", "HL7WithOffset", "20200101213045-0600"),
    ..TestHL7ConvertTz("HL7.9b", "20200102033045Z"     , "America/New_York", "America/Chicago", "HL7Local"     , "20200101213045"),
    ..TestHL7ConvertTz("HL7.9c", "20200102033045Z"     , "America/New_York", "America/Chicago", ""             , "20200101213045-0600"),

    ..TestHL7ConvertTz("HL7.10a", "202001020330Z"      , "America/New_York", "America/Chicago", "HL7WithOffset", "20200101213000-0600"),
    ..TestHL7ConvertTz("HL7.10b", "202001020330Z"      , "America/New_York", "America/Chicago", "HL7Local"     , "20200101213000"),
    ..TestHL7ConvertTz("HL7.10c", "202001020330Z"      , "America/New_York", "America/Chicago", ""             , "202001012130-0600"),

    ..TestHL7ConvertTz("HL7.11a", "2020010203Z"        , "America/New_York", "America/Chicago", "HL7WithOffset", "20200101210000-0600"),
    ..TestHL7ConvertTz("HL7.11b", "2020010203Z"        , "America/New_York", "America/Chicago", "HL7Local"     , "20200101210000"),
    ..TestHL7ConvertTz("HL7.11c", "2020010203Z"        , "America/New_York", "America/Chicago", ""             , "2020010121-0600"),

    // 1a: Strict, return original value
    // 1b: Not strict, try parsing the datetime (HL7WithOffset)
    // 1c: Not strict, try parsing the datetime (source format)
    // 1d: Strict, return blank
    ..TestHL7ConvertTz("HL7.Strict.1a","2020-01-02 03:30:45 -0500","America/New_York", "America/Chicago", "HL7WithOffset", "2020-01-02 03:30:45 -0500",, strict),
    ..TestHL7ConvertTz("HL7.Strict.1b","2020-01-02 03:30:45 -0500","America/New_York", "America/Chicago", "HL7WithOffset", "20200102023045-0600",, notStrict),
    ..TestHL7ConvertTz("HL7.Strict.1c","2020-01-02 03:30:45 -0500","America/New_York", "America/Chicago", ""             , "2020-01-02 02:30:45 -0600",, notStrict),
    ..TestHL7ConvertTz("HL7.Strict.1d","2020-01-02 03:30:45 -0500","America/New_York", "America/Chicago", "HL7WithOffset", "{{Date Parse ERROR}}","{{Date Parse ERROR}}", strict),
    ..TestHL7ConvertTz("HL7.Strict.1e","BAD:2020-01-02 03:30:45 -0500","America/New_York", "America/Chicago", "HL7WithOffset", "{{Date Parse ERROR}}","{{Date Parse ERROR}}", notStrict),
  )


  set numCases = $LISTLENGTH(testCases)
  set errs = 0
  set successes = 0
  set testcount = 0

  for i=1:1:numCases {
    set rslt = $LISTGET(testCases, i)

    if (rslt = "") {
      continue
    }

    set testcount = testcount + 1
    
    if ($$$ISERR(rslt)) {
      set errs = errs + 1
    } else {
      set successes = successes + 1
    }
  }

  if successes '= 0 {
    write successes_" Tests Successful!",!
  }

  if errs '= 0 {
    write errs_" ERRORS",!
    return $$$ERROR($$$GeneralError, "Tests Failed: "_errs)
  }

  return $$$OK
}

ClassMethod TestInternal(testId, dt, inTz, inFmt, outFmt, outTz, expectedValue, altExpectedValue As %String = "") As %Status
{
  set rslt = ##class(tz.internal).convertTZ(dt, inTz, inFmt, outFmt, outTz)
  return ..expect(testId, rslt, expectedValue, altExpectedValue)
}

ClassMethod TestConvert(testId, dt, inTz, inFmt, outFmt, outTz, expectOK, expectedValue, altExpectedValue As %String = "") As %Status
{
  set rslt = ##class(tz.TZ).Convert(dt, inTz, inFmt, outFmt, outTz, .tSC)

  set scText = $System.Status.GetErrorText(tSC)
  set statusStatus = ..expect(testId_".Status", scText, expectOK)

  if $$$ISERR(statusStatus) {
    return statusStatus
  }

  return ..expect(testId, rslt, expectedValue, altExpectedValue)
}

ClassMethod TestHL7ConvertTz(testId, dt, inTz, outTz, outFmt = "", expectedValue = "", pErrOutput As %String = "{do not convert}", pStrict As %Boolean = 0) As %Status
{
  set rslt = ##class(tz.HL7).ConvertTz(dt, inTz, outTz, outFmt, .tSC, pErrOutput, pStrict)

  //set scText = $System.Status.GetErrorText(tSC)
  //set ok = ""
  //set statusStatus = ..expect(testId_".Status", scText, ok)

  if $$$ISERR(tSC) {
    //w "ERROR: ",scText,!
  }

  return ..expect(testId, rslt, expectedValue)
}

ClassMethod expect(testId, value, expectedValue, altExpectedValue As %String = "") As %Status [ Internal ]
{
  if (value = expectedValue) {
    return $$$OK
  }

  if (altExpectedValue '= "") && (value = altExpectedValue) {
    return $$$OK
  }

  set errLines = $LB(
    "Value does not match expected value (test="_testId_")",
    "  Value   : "_value,
    "  Expected: "_expectedValue,
    "  Expected: "_expectedValue_" (alternate)",
  )

  if altExpectedValue = "" {
    set errLines = $LB(
      "Value does not match expected value (test="_testId_")",
      "  Value   : "_value,
      "  Expected: "_expectedValue
    )
  } else {
    set errLines = $LB(
      "Value does not match any expected values (test="_testId_")",
      "  Value   : "_value,
      "  Expected: "_expectedValue_" (option 1)",
      "  Expected: "_altExpectedValue_" (option 2)"
    )
  }

  set NL = $CHAR(10)_$CHAR(13)
  write "ERROR: "_$LISTTOSTRING(errLines, NL),!!

  set errMsg = $LISTTOSTRING(errLines, "; ")
  return $$$ERROR($$$GeneralError, errMsg)
}

}

