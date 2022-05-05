# godo-backend

This is the backend used for the todo application I'm writing.

It uses `go-fiber` for the http server and does all the heavy-lifting for the application.

## Run

First, compile frontend application using

```bash
flutter build web
```

Then, copy contents of the `build/web` folder to `backend/web`

Finally use `run.bat` on Windows or just run the app using

```bash
go run main.go
```

You can also use docker compose to start the app

```bash
docker-compose up
```

## Configuration

This application requires several environment variables to be set.

They can be defined with a `.env` file.

### Variables that require definition

`HOST`: address of the host, such as `"127.0.0.1"`

`PORT`: port which will be used by the backend, such as `8080`

`APP_ENV`: application environment, either `prod` or `dev`

`MONGO_URI`: uri used to connect to mongodb

`JWT_SECRET_KEY`: secret key used for jwt authentification
