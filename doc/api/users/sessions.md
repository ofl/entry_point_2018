## POST /api/users/sessions
ログインできること.

### Example

#### Request
```
POST /api/users/sessions HTTP/1.1
Accept: application/json
Authorization: vZDAZY5RfHxP47JfVuyA
Content-Length: 49
Content-Type: application/json
Host: www.example.com
Username: user_94

{
  "user": {
    "username": "foo",
    "password": "password"
  }
}
```

#### Response
```
HTTP/1.1 200
Cache-Control: max-age=0, private, must-revalidate
Content-Length: 52
Content-Type: application/json; charset=utf-8
ETag: W/"6af19a6adf705dc07a69708923f30973"
Set-Cookie: _entry_point2018_session=MTRncVh5THlrNkwrK1lyVVJXMEdIZDVOQnRiekZUNk1yQUw2bG16aGlPQjZTaWxqVSt0OWV4U2F0RUVIRUh3VnBsQ2lmcDI0UGpkSWtDZnpSaTJIanpQR1dHLzJKQjlpeHdTZnc4YjBMUFpqNCtVU3UxZmR2QlJGNm9CbTBTUmlaQTRMYkJidDlIQ1EydUtvMHBOdWVPWVovTHUva3RTZ1dERTdTTFE1ZTM4PS0tUlFJNU4xNERhbzlWcmNRUURBT1hQQT09--b6cc303d6fc487661bb66df1d821ea233cc3d9d2; path=/; HttpOnly
X-Request-Id: 132bb211-e54d-4c58-9463-57f8fc63f83d
X-Runtime: 0.017063

{
  "authentication_token": "2548:thKgePFqtmMt5MfxrZaR"
}
```

## POST /api/users/sessions
ログインできること.

### Example

#### Request
```
POST /api/users/sessions HTTP/1.1
Accept: application/json
Authorization: JxeyoY643gypZTJrsizu
Content-Length: 185
Content-Type: application/json
Host: www.example.com
Username: user_97

{
  "user_auth": {
    "provider": "twitter",
    "uid": "14659669",
    "access_token": "14659669-IFC6BowZI4xJVbzYcBYEZRTVlCNxq9r4i2qt9aQ9l",
    "access_secret": "QemTEm4cPB0mUBL2aSECkcIHQmxtV24TTprAxsGWuhdmn"
  }
}
```

#### Response
```
HTTP/1.1 200
Cache-Control: max-age=0, private, must-revalidate
Content-Length: 52
Content-Type: application/json; charset=utf-8
ETag: W/"e318a78bfac1706b9853c84cfea61914"
Set-Cookie: _entry_point2018_session=cE5PK29GMGtjZDhRVWZMQUt4aG96K0FWVTJIeWNqWmVXd09qWkhUbkZLcnRSdldkWHpkWDRBSmtSWnVWeW82bXRIaUVKQ05KYmpSMzFoWGtOSjBmVUcyYVpjRnEyY3k1M3VmTGpVWms5dTM4ZTQ1aGVTTTdaYXp3WDMwdkp5OXFLWFVUWE9uVmJSQjR6bHd0bHVjZGhVVElEWHVJZmowTFdWNmxhV1RoaGRvPS0tQ3U1SXBwLzJFenc3eVBUNjhkakMxQT09--b199b76e8ea5ad31880333a0e5046782b2635c8a; path=/; HttpOnly
X-Request-Id: d955d70b-9d5b-4eb7-baba-476b9842303f
X-Runtime: 0.347998

{
  "authentication_token": "2550:zwGsoW7F2gqyzYVeEz83"
}
```

## DELETE /api/users/sessions
ログアウトすること.

### Example

#### Request
```
DELETE /api/users/sessions HTTP/1.1
Accept: application/json
Authorization: G5mvxJsmHtJuAtd9xKrH
Content-Length: 2
Content-Type: application/json
Host: www.example.com
Username: user_103

{
}
```

#### Response
```
HTTP/1.1 200
Cache-Control: max-age=0, private, must-revalidate
Content-Length: 12
Content-Type: application/json; charset=utf-8
ETag: W/"b83be4ac5f9f2c363ec50ba7369c3b2d"
Set-Cookie: _entry_point2018_session=RnN1K2JZOHpqbkM1OEtJTHhTSitEWWFTd0RRNmNxSDk3NlU5OFcwRStBc2xoTEN5NTljMEk2dDRUYktDQmlIN2RSU2c1K3AvNklMOHk2V2luQWFIV3c9PS0tYi9pQlpqditycjhqVGk1bnpRaG43UT09--b3d2d510354bedf811720178014fbc834bdcb2ee; path=/; HttpOnly
X-Request-Id: a76f2804-4e3c-4522-a88d-bb3e523e45e8
X-Runtime: 0.022379

{
  "head": 200
}
```
