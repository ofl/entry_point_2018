## POST /api/users/sessions
ログインできること.

### Example

#### Request
```
POST /api/users/sessions HTTP/1.1
Accept: application/json
Authorization: rouziiLRRZY8tRttyiG5
Content-Length: 49
Content-Type: application/json
Host: www.example.com
Username: user_3

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
ETag: W/"838d5b6ed34f08c0ea062092a989fe8d"
Set-Cookie: _entry_point2018_session=NEhvT3JlSW5qQjRjQjNvazc1b0JGWkRzUTBUdzJEY0ZMd3VZclVoYmhKb1pFUVYwSERxSzUyOFVKVlFxV2EzOXNOd3JrYXNNYmZUVEkxOENXUVJBL1lrVlhVakdQbkI2VS9RQmhpTnlNV3YrWjZZelZROFd1eEZ2MXRTZDBqNjdzRVFmMVJmNTl1d2JrTkwrRzRKL3RvWDNWT2p4SkxHUDViZHoxbzVoUUpBPS0td0pFN0ZkbjdXcjlVNitnZUhtSW1wUT09--2d7828483d63e16cffe3fef0bc89ea58c62ecca0; path=/; HttpOnly
X-Request-Id: c910f600-85e8-43c4-ae5a-424fea9b843c
X-Runtime: 0.029038

{
  "authentication_token": "2117:RsU2fjSkiUU3UxEn4Wnn"
}
```

## POST /api/users/sessions
ログインできること.

### Example

#### Request
```
POST /api/users/sessions HTTP/1.1
Accept: application/json
Authorization: JyvceskPyKzikEKnnPXs
Content-Length: 185
Content-Type: application/json
Host: www.example.com
Username: user_6

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
ETag: W/"25410e3c8b83f4105a8acd0a7216e425"
Set-Cookie: _entry_point2018_session=Z3Y4OFJQdGF1cGpRUTlYL0hzZk1FakJXTDU3TzBNRXBzYlZTR3lxZnNGZERrV1c3czZQSDV1U25xQ0JnUEJOOHhsWUExcWxqbE5UYkFUa1dXbXNMRVUvM1MrRjlkcVBsSmRwa1V2ODhVUFdEODhURGpWcXI0N2xtQ1l5em12YXdnRWFSU01kWFlNb0szSnJLRmdpd3ZkQmJQVDhoQnE3aGk1cVBKdGR2dm1vPS0tMHREbUdnc2t0anB1L2F2ME5DSUlRUT09--35d3bce107323d54924875da5f878857d0286f72; path=/; HttpOnly
X-Request-Id: 3d1047b8-6448-45ed-806a-3e6343e8f174
X-Runtime: 0.422150

{
  "authentication_token": "2119:hMdaxxeL8MsdqwGWJfqm"
}
```

## DELETE /api/users/sessions
ログアウトすること.

### Example

#### Request
```
DELETE /api/users/sessions HTTP/1.1
Accept: application/json
Authorization: uS7GyCR-tmgANqFcpy8s
Content-Length: 2
Content-Type: application/json
Host: www.example.com
Username: user_12

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
Set-Cookie: _entry_point2018_session=QzFzT3VIRzRCUjhaWnVoTTdFTWE1WDl4N0lZNm9veHVYeE9hZkdxSThFcERTd2s3eEJOUDJSelFyN1VhZHFPMmVoZm01MzhhWTFYdm4xaFh1bTNoUnc9PS0tOGM0NlRPS2h4UjV6Z0xaK1NUUlFUZz09--8440964322f456a5669433f05b7fa1b48ddf9063; path=/; HttpOnly
X-Request-Id: fc248d6e-b9f3-4a5c-82c6-2c4732773a8c
X-Runtime: 0.028196

{
  "head": 200
}
```
