# App

Application Generator

## Usage

```go
Application := app.New()

Application.Generate()
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
