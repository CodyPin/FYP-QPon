# QPon

## PocketBase Backend
The app would start fine without the backend, but it would be useless. 
The backend is a REST API that is used to store, retrieve and change data from the database.
To start the backend server, go into the pocketbase_backend directory and run the following command:
```.\pocketbase.exe serve --http="192.168.0.100:80"```
The IP is actually my PC IP, which is port forwarded from my home router to the 8000 port. After the project is complete, I will close the server and the app will not be able to log in.

If you want to set up your own server, set it up with the command above, but change the IP and port to your choice. You will have to change the details in the .env file.