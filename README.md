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
// Callbacks
//   get theme
//   get path
//   copy files (templates)
//   generate
//   build

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
