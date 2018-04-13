## GET /api/users/registrations
ユーザー情報を取得できること.

### Example

#### Request
```
GET /api/users/registrations HTTP/1.1
Accept: application/json
Authorization: 2dgk-P7yLEiRuJgfpqFo
Content-Length: 0
Content-Type: application/json
Host: www.example.com
Username: user_76
```

#### Response
```
HTTP/1.1 200
Cache-Control: max-age=0, private, must-revalidate
Content-Length: 283
Content-Type: application/json; charset=utf-8
ETag: W/"629663f74dbdabf40aa919232558b11b"
X-Request-Id: fe257e0a-9b0f-4876-9009-bec9fa28b203
X-Runtime: 0.062482

{
  "id": 2532,
  "username": "user_76",
  "email": "user_76@example.com",
  "authentication_token": "2dgk-P7yLEiRuJgfpqFo",
  "created_at": "2018-04-07T11:08:25.522+09:00",
  "updated_at": "2018-04-07T11:08:25.542+09:00",
  "confirmed_by_email": false,
  "confirmed_by_twitter": true,
  "confirmed_by_facebook": false
}
```

## POST /api/users/registrations
ユーザーが登録されること.

### Example

#### Request
```
POST /api/users/registrations HTTP/1.1
Accept: application/json
Content-Length: 76
Content-Type: application/json
Host: www.example.com

{
  "user": {
    "username": "foo",
    "email": "foo@example.com",
    "password": "foobarbaz"
  }
}
```

#### Response
```
HTTP/1.1 200
Cache-Control: max-age=0, private, must-revalidate
Content-Length: 276
Content-Type: application/json; charset=utf-8
ETag: W/"10eb82e7fca9baa0ffb25dedc253ac68"
Set-Cookie: _entry_point2018_session=SmhCLzYrcE9yQ2hZRk5NaDRWbHNuclRTQk02Z0krQWIyeWdlOG9IWUhCd29WMXdPTHhYSStXOG5nVEdsMFNHcTdYNExxd2VTUThsQ2FWR0g4NjE2dHRHTzZydkozVkpiMWdZN3luSnNTTFV3OWRKdjg1eTlRNUo4TGlsYldYdXgwN2NmMTY2RkJBMlYwZ2xJZHAwN0pkdVVPeDQwVmg3b3ZqVHF4K0NuZXJnPS0tRVc3TVVmaUVIeWNmVURzV2QybmgrUT09--9d213a7a44a4648a9a6e9dfa0df38c254ef70bda; path=/; HttpOnly
X-Request-Id: 5decd290-f97e-4a8b-b7a5-bd9ebe681b53
X-Runtime: 0.025668

{
  "id": 2533,
  "username": "foo",
  "email": "foo@example.com",
  "authentication_token": "tfR5729jpceuabnMcbBq",
  "created_at": "2018-04-07T11:08:25.631+09:00",
  "updated_at": "2018-04-07T11:08:25.637+09:00",
  "confirmed_by_email": false,
  "confirmed_by_twitter": false,
  "confirmed_by_facebook": false
}
```

## PUT /api/users/registrations
ユーザー情報が修正されること.

### Example

#### Request
```
PUT /api/users/registrations HTTP/1.1
Accept: application/json
Authorization: mmjJhT6LqiMma13xdi-k
Content-Length: 76
Content-Type: application/json
Host: www.example.com
Username: user_82

{
  "user": {
    "username": "foo",
    "email": "foo@example.com",
    "password": "foobarbaz"
  }
}
```

#### Response
```
HTTP/1.1 200
Cache-Control: max-age=0, private, must-revalidate
Content-Length: 275
Content-Type: application/json; charset=utf-8
ETag: W/"1d8e6e8a2a90e4304414a3d4c81862a0"
X-Request-Id: bcdb99ab-d88a-422f-990c-df14467dbed6
X-Runtime: 0.021192

{
  "id": 2539,
  "username": "foo",
  "email": "foo@example.com",
  "authentication_token": "mmjJhT6LqiMma13xdi-k",
  "created_at": "2018-04-07T11:08:25.814+09:00",
  "updated_at": "2018-04-07T11:08:25.838+09:00",
  "confirmed_by_email": false,
  "confirmed_by_twitter": true,
  "confirmed_by_facebook": false
}
```

## DELETE /api/users/registrations
ユーザーが削除されること.

### Example

#### Request
```
DELETE /api/users/registrations HTTP/1.1
Accept: application/json
Authorization: eKZwsZnpeTMAiH9iof6i
Content-Length: 0
Content-Type: application/json
Host: www.example.com
Username: user_88
```

#### Response
```
HTTP/1.1 200
Cache-Control: max-age=0, private, must-revalidate
Content-Length: 13
Content-Type: application/json; charset=utf-8
ETag: W/"b3930ec395ac5e1738ab6d02f69ed9e9"
Set-Cookie: _entry_point2018_session=aGdVVXp0d3hUMGZKVkJFdzNHcDc1dW1WVm9PQ2dTRXZHL0JEbnpjaUE2czdlZUNvaUJ0U3VwcGRKSXJlaTVmcDFSc3FTc0FjMHhpY3pRQXpIQjN6TVE9PS0tSmR6YTBUd0ZlTUlmSjZjOEE5Vm13UT09--04dd652fdd63800242ee7c16f4ec4c4e47e6f2c9; path=/; HttpOnly
X-Request-Id: 502f99cd-acd9-4375-942b-145be141ffe8
X-Runtime: 0.029201

{
  "head": "ok"
}
```
