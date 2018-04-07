## POST /api/users/user_auths
ユーザー認証が作成されること.

### Example

#### Request
```
POST /api/users/user_auths HTTP/1.1
Accept: application/json
Authorization: 1g1ceYkyysejAaXz92XA
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
X-Request-Id: 54e1cc4d-cd0a-43d4-ab45-994b75974705
X-Runtime: 0.508882

{
  "message": "Sent confirmation mail"
}
```
