# Powershell

## Verarbeitung von JSON

Umwandeln von oder nach JSON

### Von json in ein ziel Formart Umwandeln

```powershell
ConvertFrom-Json
           [-InputObject] <String>
           [-AsHashtable]
           [<CommonParameters>]
```

### Example Json Konverter

```powershell
Get-Date | Select-Object -Property * | ConvertTo-Json | ConvertFrom-Json

DisplayHint : 2
...
```

#### Quellen zu Json

* [playing-with-json-and-powershell](https://devblogs.microsoft.com/scripting/playing-with-json-and-powershell/)

## Verarbeitung einer Request via URL

```powershell
$request = 'http://musicbrainz.org/ws/2/artist/5b11f4ce-a62d-471e-81fc-a69a8278c7da?inc=aliases&fmt=json'

Invoke-WebRequest $request | ConvertFrom-Json | Select name, disambiguation, country

```

### Umwandeln in json

```Powershell
ConvertTo-Json
         [-InputObject] <Object>
         [-Depth <Int32>]
         [-Compress]
         [-EnumsAsStrings]
         [-AsArray]
         [<CommonParameters>]
```

### Example Kalender

```powershell
(Get-UICulture).Calendar | ConvertTo-Json

{
  "MinSupportedDateTime": "0001-01-01T00:00:00",
  "MaxSupportedDateTime": "9999-12-31T23:59:59.9999999",
  "AlgorithmType": 1,
  "CalendarType": 1,
  "Eras": [
    1
  ],
  "TwoDigitYearMax": 2029,
  "IsReadOnly": true
}
```

### Example Kalender als Array

```Powershell
Get-Date | ConvertTo-Json; Get-Date | ConvertTo-Json -AsArray

{
  "value": "2018-10-12T23:07:18.8450248-05:00",
  "DisplayHint": 2,
  "DateTime": "October 12, 2018 11:07:18 PM"
}
[
  {
    "value": "2018-10-12T23:07:18.8480668-05:00",
    "DisplayHint": 2,
    "DateTime": "October 12, 2018 11:07:18 PM"
  }
]
```

### Example Domain mit Json

```Powershell
PS C:\> @{Account="User01";Domain="Domain01";Admin="True"} | ConvertTo-Json -Compress

{"Domain":"Domain01","Account":"User01","Admin":"True"}
```

### Example Datum Parameter Umwandeln in Json

```Powershell
PS C:\> Get-Date | Select-Object -Property * | ConvertTo-Json

{
  "DisplayHint": 2,
  "DateTime": "October 12, 2018 10:55:32 PM",
  "Date": "2018-10-12T00:00:00-05:00",
  "Day": 12,
  "DayOfWeek": 5,
  "DayOfYear": 285,
  "Hour": 22,
  "Kind": 2,
  "Millisecond": 639,
  "Minute": 55,
  "Month": 10,
  "Second": 32,
  "Ticks": 636749817326397744,
  "TimeOfDay": {
    "Ticks": 825326397744,
    "Days": 0,
    "Hours": 22,
    "Milliseconds": 639,
    "Minutes": 55,
    "Seconds": 32,
    "TotalDays": 0.95523888627777775,
    "TotalHours": 22.925733270666665,
    "TotalMilliseconds": 82532639.774400011,
    "TotalMinutes": 1375.54399624,
    "TotalSeconds": 82532.6397744
  },
  "Year": 2018
}
```

## Verarbeitung von YAML

### Quellen

* [powershell-password-resets](https://4sysops.com/archives/powershell-password-resets/)

* [Reset-password-for-all]https://gallery.technet.microsoft.com/scriptcenter/Reset-password-for-all-412fbc72)

* [resetting-local-administrator-password-computers](http://windowsitpro.com/powershell/resetting-local-administrator-password-computers)

* [scriptcenter](https://gallery.technet.microsoft.com/scriptcenter/66a5b38f-cdf1-4126-aa0c-be65e16dd650)

* [Repositorie für Linux](https://packages.microsoft.com/)