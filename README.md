# Application Generator

Application Generator

## Usage

```go
Application := app.New("Qor Example")

webEC := Application.Use(web_theme.EC)

androidEC := Application.Use(android_theme.EC)

Application.Create()
```

```go
type EC struct {
  Requires: {{"importpath", "name"}, {"importpath", "name"}}
}
```

```go
RegisterWidget(Widget{
  Template: "product_list",
  Context: func() {
  }
})
```

```go
web.App{
  Name  string
  Path string
  Theme app.Theme
}

android.App{
  Name  string
  Theme app.Theme
}

ios.App{
  Name  string
  Theme app.Theme
}
```
