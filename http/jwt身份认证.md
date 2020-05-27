jwt身份认证
### 1. 服务器在用户登录时生成token
jwt需要一个secret来生成， 这里创建时用的secret和检查时用的，必须是一个ecretd. :
```
func JwtHandler() *jwt.Middleware {
	var mySecret = []byte("HS2JDFKhu7Y1av7b")
	return jwt.New(jwt.Config{
		ValidationKeyGetter: func(token *jwt.Token) (interface{}, error) {
			return mySecret, nil
		},
		SigningMethod: jwt.SigningMethodHS256,
	})
}
```
使用 jwt ，在登录的时候， 会为用户生成tokenm 按指定的secret生成 token：
```
if ok := bcrypt.Match(password, user.Password); ok {
    token := jwt.NewTokenWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
        "exp": time.Now().Add(time.Hour * time.Duration(1)).Unix(),
        "iat": time.Now().Unix(),
    })
    tokenString, _ := token.SignedString([]byte("HS2JDFKhu7Y1av7b"))
    oauthToken := new(OauthToken)
    oauthToken.Token = tokenString
    oauthToken.UserId = user.ID
    oauthToken.Secret = "secret"
    oauthToken.Revoked = false
    oauthToken.ExpressIn = time.Now().Add(time.Hour * time.Duration(1)).Unix()
    oauthToken.CreatedAt = time.Now()
    response = oauthToken.OauthTokenCreate()
}
```
把这个token存放到数据库， 并返回给客户端 

### 2. 客户端每次请求，在header里带上token
不同于cookie, jwt身份认证方式， 需要javascripe每次请求时， 都要把jwt写在header里， 
这需要显示的写在js程序里， 不像cookie不需要写。 

### 3. 服务端对每次请求的token验证

