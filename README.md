# QPon

## PocketBase Backend
The app would start fine without the backend, but it would be useless. 
The backend is a REST API that is used to store, retrieve and change data from the database.
To start the backend server, go into the pocketbase_backend directory and run the following command:
```.\pocketbase.exe serve --http="61.244.58.244:8000"```
The IP is actually my home IP address, I have port forwarded the port 8000 to the server. After the project grading is complete, I will close the server and the app will not be able to log in.

If you change the IP in the http of the command, you would need to change the IP in the .env too.