# QPon

This is my final year project at **Hong Kong Baptist University** for my computer science bachelor degree.
The idea behide the app is to give small to medium stores their own coupon system, allowing them to create, edit, delete and distrube their own coupons.
That being said, normal users can create an account to recieve coupons, as well as giving any coupon they own to another user.

The app's front end is written in Flutter, and using PocketBase, a Firebase like all in one backend program, as the backend.

## PocketBase Backend
The app would start fine without the backend, but it would be useless. 
The backend is a REST API that is used to store, retrieve and change data from the database.
To start the backend server, go into the pocketbase_backend directory and run the following command:
```.\pocketbase.exe serve --http="<ip_here>"```

If you want to set up your own server, set it up with the command above, but change the IP and port to your choice. You will have to change the details in the .env file.
