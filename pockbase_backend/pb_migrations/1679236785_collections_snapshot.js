migrate((db) => {
  const snapshot = [
    {
      "id": "_pb_users_auth_",
      "created": "2022-11-22 16:30:21.426Z",
      "updated": "2023-03-19 14:39:45.599Z",
      "name": "users",
      "type": "auth",
      "system": false,
      "schema": [
        {
          "system": false,
          "id": "pesxnujl",
          "name": "is_store",
          "type": "bool",
          "required": false,
          "unique": false,
          "options": {}
        }
      ],
      "listRule": "id = @request.auth.id",
      "viewRule": "id = @request.auth.id",
      "createRule": "",
      "updateRule": "id = @request.auth.id",
      "deleteRule": "id = @request.auth.id",
      "options": {
        "allowEmailAuth": true,
        "allowOAuth2Auth": true,
        "allowUsernameAuth": true,
        "exceptEmailDomains": null,
        "manageRule": null,
        "minPasswordLength": 8,
        "onlyEmailDomains": null,
        "requireEmail": false
      }
    },
    {
      "id": "kszh7oje22y6l4d",
      "created": "2022-11-22 16:49:40.465Z",
      "updated": "2023-03-19 14:39:45.600Z",
      "name": "stores",
      "type": "base",
      "system": false,
      "schema": [
        {
          "system": false,
          "id": "ddzehm3k",
          "name": "name",
          "type": "text",
          "required": true,
          "unique": false,
          "options": {
            "min": null,
            "max": null,
            "pattern": ""
          }
        },
        {
          "system": false,
          "id": "7k3mnqpv",
          "name": "phone_no",
          "type": "number",
          "required": false,
          "unique": false,
          "options": {
            "min": null,
            "max": null
          }
        },
        {
          "system": false,
          "id": "hqlao5mt",
          "name": "owner",
          "type": "relation",
          "required": false,
          "unique": false,
          "options": {
            "collectionId": "_pb_users_auth_",
            "cascadeDelete": false,
            "minSelect": null,
            "maxSelect": 1,
            "displayFields": null
          }
        },
        {
          "system": false,
          "id": "ghhweci3",
          "name": "icon",
          "type": "file",
          "required": false,
          "unique": false,
          "options": {
            "maxSelect": 1,
            "maxSize": 5242880,
            "mimeTypes": [],
            "thumbs": []
          }
        }
      ],
      "listRule": "",
      "viewRule": "",
      "createRule": null,
      "updateRule": "",
      "deleteRule": null,
      "options": {}
    },
    {
      "id": "1z9rx49vuw712hl",
      "created": "2022-11-22 16:53:54.146Z",
      "updated": "2023-03-19 14:39:45.600Z",
      "name": "coupons",
      "type": "base",
      "system": false,
      "schema": [
        {
          "system": false,
          "id": "bbv6kqs5",
          "name": "name",
          "type": "text",
          "required": true,
          "unique": false,
          "options": {
            "min": null,
            "max": null,
            "pattern": ""
          }
        },
        {
          "system": false,
          "id": "nyt2hnsm",
          "name": "description",
          "type": "text",
          "required": false,
          "unique": false,
          "options": {
            "min": null,
            "max": null,
            "pattern": ""
          }
        },
        {
          "system": false,
          "id": "yneiho6o",
          "name": "discount_type",
          "type": "select",
          "required": true,
          "unique": false,
          "options": {
            "maxSelect": 1,
            "values": [
              "percentage",
              "cash"
            ]
          }
        },
        {
          "system": false,
          "id": "zb3lnsfi",
          "name": "amount",
          "type": "number",
          "required": true,
          "unique": false,
          "options": {
            "min": null,
            "max": null
          }
        },
        {
          "system": false,
          "id": "fzzyqdad",
          "name": "expire_date",
          "type": "date",
          "required": false,
          "unique": false,
          "options": {
            "min": "",
            "max": ""
          }
        },
        {
          "system": false,
          "id": "6sdtt7h5",
          "name": "is_active",
          "type": "bool",
          "required": false,
          "unique": false,
          "options": {}
        },
        {
          "system": false,
          "id": "ppijzkew",
          "name": "store",
          "type": "relation",
          "required": true,
          "unique": false,
          "options": {
            "collectionId": "kszh7oje22y6l4d",
            "cascadeDelete": false,
            "minSelect": null,
            "maxSelect": 1,
            "displayFields": null
          }
        },
        {
          "system": false,
          "id": "rny0smul",
          "name": "use_count",
          "type": "number",
          "required": false,
          "unique": false,
          "options": {
            "min": 0,
            "max": null
          }
        },
        {
          "system": false,
          "id": "in8npngo",
          "name": "image",
          "type": "file",
          "required": false,
          "unique": false,
          "options": {
            "maxSelect": 1,
            "maxSize": 5242880,
            "mimeTypes": [],
            "thumbs": []
          }
        }
      ],
      "listRule": "",
      "viewRule": "",
      "createRule": "",
      "updateRule": "",
      "deleteRule": "",
      "options": {}
    },
    {
      "id": "hpdbfkioo4axtwa",
      "created": "2022-11-22 16:55:01.188Z",
      "updated": "2023-03-19 14:39:45.600Z",
      "name": "user_coupons",
      "type": "base",
      "system": false,
      "schema": [
        {
          "system": false,
          "id": "akykcjnz",
          "name": "user",
          "type": "relation",
          "required": true,
          "unique": false,
          "options": {
            "collectionId": "_pb_users_auth_",
            "cascadeDelete": true,
            "minSelect": null,
            "maxSelect": 1,
            "displayFields": null
          }
        },
        {
          "system": false,
          "id": "uyqxii1w",
          "name": "coupon",
          "type": "relation",
          "required": true,
          "unique": false,
          "options": {
            "collectionId": "1z9rx49vuw712hl",
            "cascadeDelete": false,
            "minSelect": null,
            "maxSelect": 1,
            "displayFields": null
          }
        },
        {
          "system": false,
          "id": "lonntggh",
          "name": "amount",
          "type": "number",
          "required": true,
          "unique": false,
          "options": {
            "min": 1,
            "max": null
          }
        }
      ],
      "listRule": "",
      "viewRule": "",
      "createRule": "",
      "updateRule": "",
      "deleteRule": "",
      "options": {}
    }
  ];

  const collections = snapshot.map((item) => new Collection(item));

  return Dao(db).importCollections(collections, true, null);
}, (db) => {
  return null;
})
