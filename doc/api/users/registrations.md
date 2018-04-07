## GET /api/users/registrations
ユーザー情報を取得できること.

### Example

#### Request
```
GET /api/users/registrations HTTP/1.1
Accept: application/json
Authorization: UF89C2xmeoVeQGoksjw_
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
ETag: W/"ec7838f37426ebb4f5be7d68a4928475"
X-Request-Id: a9a1be0a-0f0a-43c4-8c23-f65b486c611d
X-Runtime: 0.059269

{
  "id": 1961,
  "username": "user_76",
  "email": "user_76@example.com",
  "authentication_token": "UF89C2xmeoVeQGoksjw_",
  "created_at": "2018-04-07T10:26:06.522+09:00",
  "updated_at": "2018-04-07T10:26:06.538+09:00",
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
Accept: text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5
Content-Length: 73
Content-Type: application/x-www-form-urlencoded
Host: www.example.com

user[username]=foo&user[email]=foo%40example.com&user[password]=foobarbaz
```

#### Response
```
HTTP/1.1 200
Cache-Control: max-age=0, private, must-revalidate
Content-Length: 276
Content-Type: application/json; charset=utf-8
ETag: W/"e8b43d1af3a31e5915081624e61a76db"
Set-Cookie: _entry_point2018_session=My94ejZTU1p4emVyYjFQbjVaVmZYQjgzcHVxdUFqQjM5dFB1cHlmUGZlMkk4dEVxTXlzN09WNnZWVGFrWTBCSGtYYitvSHIyNGVmMnF5YXRXZms0eGNMalgxRjJueEVhRkQ4aGNkZExuam9pNTRVam9XVGtsbVdTNTFjLzNlazVvSVdlMVhrQVlURnNObmo2NlltbUhubmRrNEIxa1BSSkNBZTZBZi9teEtVPS0tb3Zhd3VqWmliRFYxcUsvWnVTaWQ1dz09--c5b03c75053aa6b7920081a304e23f5f8efda9e8; path=/; HttpOnly
X-Request-Id: 289862c6-8524-420e-886c-c7d594ef47f9
X-Runtime: 0.020014

{
  "id": 1962,
  "username": "foo",
  "email": "foo@example.com",
  "authentication_token": "Z5qse2Mw5b2gz5kn1Rf3",
  "created_at": "2018-04-07T10:26:06.638+09:00",
  "updated_at": "2018-04-07T10:26:06.642+09:00",
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
Authorization: EhWMNWSxzaHsUMCZLp2r
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
ETag: W/"4d36b80c0b49706938873c8af899d3ec"
X-Request-Id: fd6dce3e-e470-414d-84ea-2ee2125a136d
X-Runtime: 0.019833

{
  "id": 1968,
  "username": "foo",
  "email": "foo@example.com",
  "authentication_token": "EhWMNWSxzaHsUMCZLp2r",
  "created_at": "2018-04-07T10:26:06.787+09:00",
  "updated_at": "2018-04-07T10:26:06.809+09:00",
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
Authorization: zdmaTw4dEPHBxwQFsGMx
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
Set-Cookie: _entry_point2018_session=TFpodjl0WlRyLzNTa1hNeHJyOHNVdk4zZTdXZ3BJYVdIUEZHUkxtd01Hb2xWSWI5NXVTSXcxMXR6c2w1STdUZk52SlA2MFh6SGk5VUNETDV4eDVneWc9PS0tWnlweEZ1aFpBc1VVYUYybEwrek8vQT09--53170ccd800304d7ffaff3e60af90c6ccded70e0; path=/; HttpOnly
X-Request-Id: 79179349-cd06-407d-a04e-69b5b2daa7a1
X-Runtime: 0.025263

{
  "head": "ok"
}
```
