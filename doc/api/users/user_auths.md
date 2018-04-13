## POST /api/users/user_auths
ユーザー認証が作成されること.

### Example

#### Request
```
POST /api/users/user_auths HTTP/1.1
Accept: application/json
Authorization: D_Qh8qWiUHsyLYSgxXV-
Content-Length: 91
Content-Type: application/json
Host: www.example.com
Username: user_113

{
  "user_auth": {
    "provider": "email",
    "uid": "foobarbaz@example.com",
    "user_password": "password"
  }
}
```

#### Response
```
HTTP/1.1 200
Cache-Control: max-age=0, private, must-revalidate
Content-Length: 36
Content-Type: application/json; charset=utf-8
ETag: W/"ab9be7c96ccbc5495cb099741e208ea9"
X-Request-Id: d4824147-7f58-46ba-9223-8aa565ce93fd
X-Runtime: 0.453424

{
  "message": "Sent confirmation mail"
}
```
